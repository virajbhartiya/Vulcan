import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../consts.dart';
import '../home.dart';

class ChooseProPic extends StatefulWidget {
  const ChooseProPic({Key key}) : super(key: key);

  @override
  _ChooseProPicState createState() => _ChooseProPicState();
}

class _ChooseProPicState extends State<ChooseProPic> {
  File _imageFile;
  String imageUrl;
  bool uploading = false;
  final picker = ImagePicker();

  Future uploadImageToFirebase(BuildContext context) async {
    // do your stuff
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
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

      uploadImageToFirebase(context);
    });
  }

  changeProPic() {
    setState(() {
      uploading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ProPic.",
          style: GoogleFonts.workSans(
            fontSize: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: uploading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: new Text('Camera Photo'),
                      onPressed: () async {
                        await pickFile(context, "cameraPhoto");
                      },
                    ),
                    TextButton(
                      child: new Text('Gallery Photo'),
                      onPressed: () async {
                        await pickFile(context, "galleryPhoto");
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
