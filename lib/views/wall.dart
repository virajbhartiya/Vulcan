import 'package:chatapp/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Wall extends StatefulWidget {
  final String title;
  const Wall({Key key, this.title}) : super(key: key);

  @override
  _WallState createState() => _WallState();
}

class _WallState extends State<Wall> {
  TextEditingController commentController = TextEditingController();
  Stream<QuerySnapshot> comments;
  String proPic;

  @override
  void initState() {
    super.initState();
    getComments().then((value) {
      setState(() {
        comments = value;
      });
    });
    getProPic().then((value) {
      setState(() {
        proPic = value.data["profilePic"];
      });
    });
  }

  Future getComments() async {
    await getProPic();
    return Firestore.instance
        .collection("users")
        .document(widget.title)
        .collection("comments")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future deleteComment(String id) async {
    await Firestore.instance
        .collection("users")
        .document(widget.title)
        .collection("comments")
        .document(id)
        .delete();
  }

  Future getProPic() async {
    return Firestore.instance.collection("users").document(widget.title).get();
  }

  Future updateLikes(id, likedBy) async {
    await Firestore.instance
        .collection("users")
        .document(widget.title)
        .collection("comments")
        .document(id)
        .updateData({
      "likes": FieldValue.increment(1),
      "likedBy": FieldValue.arrayUnion(likedBy)
    });
  }

  Future decreaseLikes(id) async {
    await Firestore.instance
        .collection("users")
        .document(widget.title)
        .collection("comments")
        .document(id)
        .updateData({
      "likes": FieldValue.increment(-1),
      "likedBy": FieldValue.arrayRemove([Constants.myName])
    });
  }

  Future addComment() async {
    String value = commentController.text;
    commentController.clear();
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    await Firestore.instance
        .collection("users")
        .document(widget.title)
        .collection("comments")
        .document()
        .setData({
      "comment": value,
      "time": time,
      "user": Constants.myName,
      "likes": 0,
      "likedBy": FieldValue.arrayUnion([])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title + '\'\s Wall.',
          style: GoogleFonts.workSans(
            fontSize: 30,
            color: Theme.of(context).colorScheme.primary,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: CachedNetworkImage(
                    height: 70,
                    width: 70,
                    imageUrl: proPic,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What me friends say",
                  style: GoogleFonts.workSans(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: commentController,
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
                        Radius.circular(100),
                      ),
                      borderSide: BorderSide(
                        color: Color(0xff06d6a7),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(FeatherIcons.chevronRight,
                            color: Theme.of(context).colorScheme.primary),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () async {
                          await addComment();
                        }),
                    border: InputBorder.none,
                    hintText: "Add comment",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 18,
                      right: 20,
                      top: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 250,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: StreamBuilder(
                    stream: comments,
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                bool liked = false;
                                int ind = 0;
                                if (snapshot.data.documents[index]
                                        .data["likedBy"] !=
                                    null) {
                                  for (var val in snapshot
                                      .data.documents[index].data["likedBy"]) {
                                    if (val == Constants.myName) {
                                      liked = true;
                                      break;
                                    } else {
                                      liked = false;
                                    }
                                    ind++;
                                  }
                                }
                                print(liked);
                                return Container(
                                  height: 55,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshot.data.documents[index]
                                                    .data["comment"],
                                                style: GoogleFonts.workSans(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            snapshot.data.documents[index]
                                                .data["likes"]
                                                .toString(),
                                            style: GoogleFonts.workSans(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (!liked) {
                                                List<dynamic> likedBy = snapshot
                                                    .data
                                                    .documents[index]
                                                    .data["likedBy"]
                                                    .toList();
                                                likedBy.add(Constants.myName);
                                                updateLikes(
                                                    snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID,
                                                    likedBy);
                                              } else {
                                                decreaseLikes(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID);
                                              }
                                              setState(() {
                                                liked = !liked;
                                              });
                                            },
                                            icon: Icon(
                                              liked
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_up_alt_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Constants.myName == widget.title
                                              ? IconButton(
                                                  onPressed: () =>
                                                      deleteComment(snapshot
                                                          .data
                                                          .documents[index]
                                                          .documentID),
                                                  icon: Icon(
                                                    FeatherIcons.trash,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      Divider(
                                        endIndent:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container();
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
