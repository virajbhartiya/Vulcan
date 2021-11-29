import 'dart:io';

import 'package:chatapp/funcitons.dart';
import 'package:chatapp/helper/authenticate.dart';

import 'package:chatapp/helper/sharedPrefFuncitons.dart';
// import 'package:chatapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../consts.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool enabled = false;
  TextEditingController pinController = new TextEditingController();
  String currentPin;
  File _imageFile;
  String imageUrl;
  bool uploading = false;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getValues();
  }

  getValues() async {
    bool val =
        (await SharedPrefFunctions.getPinEnabledSharedPreference()) ?? false;
    currentPin = await SharedPrefFunctions.getPin();
    setState(() {
      currentPin = currentPin;
      enabled = val;
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = _imageFile.path.split('/').last;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) async {
      setState(() {
        imageUrl = value;
      });
      await updateproPicLink();
      setState(() {
        uploading = false;
      });
    });
  }

  updateproPicLink() async {
    await Firestore.instance
        .collection('users')
        .document(Constants.myName)
        .updateData({
      'profilePic': imageUrl,
    });
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

  changeProPic() {
    setState(() {
      uploading = true;
    });
  }

  changeValues() async {
    await SharedPrefFunctions.savePinEnabledSharedPreference(!enabled)
        .then((value) {
      setState(() {
        enabled = !enabled;
        pinController.text = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          "Settings.",
          style: GoogleFonts.workSans(
            fontSize: 50,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: uploading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                dense: true,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Sign Out"),
                                        content: Text(
                                            "Are you sure you want to Sign Out?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No"),
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              textStyle: MaterialStateProperty
                                                  .all<TextStyle>(TextStyle(
                                                      color: Colors.black)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .backgroundColor),
                                            ),
                                            onPressed: () {
                                              SharedPrefFunctions
                                                  .savePinEnabledSharedPreference(
                                                      false);
                                              // AuthService().signOut();
                                              SharedPrefFunctions
                                                  .saveUserLoggedInSharedPreference(
                                                      false);
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Authenticate(),
                                                ),
                                              );
                                            },
                                            child: Text("Sign Out"),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                leading: Image.asset(
                                    'assets/icons/sign-out.png',
                                    height: 30),
                                title: Text(
                                  "SignOut",
                                  style: GoogleFonts.workSans(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Divider(indent: 70, color: Colors.grey),
                              ListTile(
                                dense: true,
                                onTap: () {
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
                                              await pickFile(
                                                  context, "cameraPhoto");
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: new Icon(Icons.photo),
                                            title: new Text('Gallery Photo'),
                                            onTap: () async {
                                              await pickFile(
                                                  context, "galleryPhoto");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  changeProPic();
                                },
                                leading: Icon(FeatherIcons.user),
                                title: Text(
                                  "Choose Pro pic",
                                  style: GoogleFonts.workSans(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Divider(indent: 70, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
