import 'dart:io';
import 'package:chatapp/funcitons.dart';
import 'package:chatapp/views/wall.dart';
import 'package:chatapp/widget/messageTile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp/database/database.dart';
import 'package:chatapp/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/views/drawing screen/drawing_screen.dart';
import '../consts.dart';
import '../helper/firebase_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart' as p;
import 'package:encrypt/encrypt.dart' as encrypt;

class Chat extends StatefulWidget {
  final String chatRoomId;
  final bool first;

  Chat({this.chatRoomId, this.first});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  bool first;
  ScrollController _scrollController;
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  String sender = '';
  DatabaseSQL db;
  List<Message> messagesList = [];
  File _imageFile;
  String imageUrl;
  bool uploading = false;
  final picker = ImagePicker();
  String decryptKey = "";

  @override
  void initState() {
    setState(() {
      first = widget.first;
      sender = Constants.myName ==
              widget.chatRoomId.substring(0, widget.chatRoomId.indexOf('_'))
          ? widget.chatRoomId.substring(widget.chatRoomId.indexOf('_') + 1)
          : widget.chatRoomId.substring(0, widget.chatRoomId.indexOf('_'));
    });
    db = new DatabaseSQL(sender);
    fetchMessages().then((value) {
      setState(() {
        messagesList = value;
      });
    });

    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    FirebaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    getDecryptKey();
    super.initState();
  }

  Future getDecryptKey() async {
    await Firestore.instance
        .collection('users')
        .document(sender)
        .get()
        .then((value) {
      setState(() {
        decryptKey = value.data['decryptKey'];
      });
    });
  }

  String encryptMessage(value) {
    final key = encrypt.Key.fromUtf8(Constants.decryptKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter
        .encrypt(value == null ? messageEditingController.text : value, iv: iv);
    return encrypted.base64;
  }

  String decryptMessage(value) {
    final key = encrypt.Key.fromUtf8(decryptKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(value, iv: iv);
    return decrypted;
  }

  Future pickFile(context, type) async {
    var pickedFile;
    switch (type) {
      case 'cameraPhoto':
        pickedFile = await picker.getImage(source: ImageSource.camera);
        break;
      case 'galleryPhoto':
        pickedFile = await picker.getImage(source: ImageSource.gallery);
        break;
    }
    setState(() {
      uploading = true;
      _imageFile = File(pickedFile.path);
    });
    _imageFile = await compressImage(_imageFile);
    setState(() {});
    uploadImageToFirebase(context);
  }

  void draw() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => DrawingScreen()))
        .then((value) {
      setState(() {
        uploading = true;
        _imageFile = value;
      });
      uploadImageToFirebase(context);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile.path.split('/').last;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
      addMessage(value);
      setState(() {
        uploading = false;
      });
    });
  }

  Future fetchMessages() async {
    if (db != null) {
      await db.getMessages(sender).then((value) {
        setState(() {
          messagesList = value;
        });
        return value;
      });
    }
  }

  Future updateList(msg, docID) async {
    int count = 0;
    try {
      if (!(Constants.myName == msg["sendBy"]) && count == 0) {
        count++;
        Message message = new Message(
            username:
                Constants.myName == msg["sendBy"] ? sender : msg["sendBy"],
            sender: msg["sendBy"],
            time: msg["time"],
            message: msg["message"],
            mediaType: msg["mediaType"],
            mediaUrl: msg["mediaUrl"]);
        if (!messagesList.contains(message)) {
          await db.insertMessage(message).then((_) {
            setState(() {
              messagesList.add(message);
            });
          });
        }
        await Firestore.instance
            .collection("chatRoom")
            .document(widget.chatRoomId)
            .collection("chats")
            .document(docID)
            .delete();
      }
    } catch (e) {
      print(e);
    }
  }

  Widget chatMessages() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder(
            stream: chats,
            builder: (context, snapshot) {
              // fetchMessages();
              return snapshot.hasData
                  ? ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        fetchMessages();
                        try {
                          if (!(Constants.myName ==
                              snapshot.data.documents[index].data["sendBy"])) {
                            Message messg = new Message(
                                username: Constants.myName ==
                                        snapshot.data.documents[index]
                                            .data["sendBy"]
                                    ? sender
                                    : snapshot
                                        .data.documents[index].data["sendBy"],
                                sender: snapshot
                                    .data.documents[index].data["sendBy"],
                                time:
                                    snapshot.data.documents[index].data["time"],
                                message: snapshot
                                    .data.documents[index].data["message"],
                                mediaType: snapshot
                                    .data.documents[index].data["mediaType"],
                                mediaUrl: snapshot
                                    .data.documents[index].data["mediaUrl"]);
                            if (!messagesList.contains(messg)) {
                              updateList(snapshot.data.documents[index].data,
                                  snapshot.data.documents[index].documentID);
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                        return Container();
                      },
                    )
                  : Container();
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView.builder(
              reverse: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              itemCount: messagesList.length ?? 0,
              itemBuilder: (context, index) {
                if ((messagesList[index].mediaType ?? "none") == "none") {
                  return MessageTile(
                      message: decryptMessage(messagesList[index].message),
                      sendByMe: Constants.myName == messagesList[index].sender);
                } else {
                  return Container(
                    height: 201,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                          height: 200,
                          width: 200,
                          imageUrl:
                              decryptMessage(messagesList[index].mediaUrl),
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            return Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            );
                          }),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future addMessage(value) async {
    if (value.length > 0) {
      final extension = p.extension(value);
      Message message = new Message(
        message: "",
        username: sender,
        sender: Constants.myName,
        time: DateTime.now().millisecondsSinceEpoch,
        mediaType: extension,
        mediaUrl: encryptMessage(value),
      );
      await db.insertMessage(message);
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": "",
        'time': DateTime.now().millisecondsSinceEpoch,
        "mediaType": "photo",
        "mediaUrl": encryptMessage(imageUrl),
      };
      FirebaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        imageUrl = null;
        first = false;
      });
    } else if ((messageEditingController.text.isNotEmpty &&
        messageEditingController.text.trim().length >= 1)) {
      String msg = encryptMessage(null);

      setState(() {
        msg = encryptMessage(null);
        messageEditingController.text = "";
      });
      Message message = new Message(
        message: msg,
        username: sender,
        sender: Constants.myName,
        time: DateTime.now().millisecondsSinceEpoch,
        mediaType: "none",
        mediaUrl: "",
      );
      await db.insertMessage(message);
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": msg ?? "",
        'time': DateTime.now().millisecondsSinceEpoch,
        "mediaType": "none",
        "mediaUrl": "",
      };
      FirebaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
        first = false;
      });
    }
  }

  Future deleteMedia(url) async {
    await FirebaseStorage.instance
        .ref()
        .child(url)
        .delete()
        .then((_) => print('Successfully deleted $url storage item'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Wall(
                  title: Constants.myName ==
                          widget.chatRoomId
                              .substring(0, widget.chatRoomId.indexOf('_'))
                      ? widget.chatRoomId
                          .substring(widget.chatRoomId.indexOf('_') + 1)
                      : widget.chatRoomId.substring(
                          0,
                          widget.chatRoomId.indexOf('_'),
                        ),
                ),
              ),
            );
          },
          child: Text(
            Constants.myName ==
                    widget.chatRoomId
                        .substring(0, widget.chatRoomId.indexOf('_'))
                ? widget.chatRoomId
                    .substring(widget.chatRoomId.indexOf('_') + 1)
                : widget.chatRoomId
                    .substring(0, widget.chatRoomId.indexOf('_')),
            style: GoogleFonts.workSans(
              fontSize: 22,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              height: MediaQuery.of(context).size.height - 150,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, child: chatMessages()),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageEditingController,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            cursorColor: Colors.green[50],
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).backgroundColor,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xff06d6a7),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(FeatherIcons.chevronRight,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: () => addMessage(""),
                              ),
                              border: InputBorder.none,
                              hintText: "Type...",
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 18,
                                right: 20,
                                top: 14,
                                bottom: 14,
                              ),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            minLines: 1,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: new Icon(Icons.camera),
                                      title: new Text('Camera Photo'),
                                      onTap: () async {
                                        await pickFile(context, "cameraPhoto");
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.photo),
                                      title: new Text('Gallery Photo'),
                                      onTap: () async {
                                        await pickFile(context, "galleryPhoto");
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.all_inclusive),
                                      title: new Text('Draw'),
                                      onTap: () async {
                                        draw();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: uploading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
