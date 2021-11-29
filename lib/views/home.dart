import 'package:chatapp/views/settings.dart';
import 'package:chatapp/views/wall.dart';
import 'package:chatapp/widget/chatRoomTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts.dart';
import '../helper/sharedPrefFuncitons.dart';
import '../helper/firebase_helper.dart';
import 'chat.dart';
import 'search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Chat(
                            chatRoomId: snapshot
                                .data.documents[index].data['chatRoomId'],
                          ),
                        ),
                      );
                    },
                    child: ChatRoomsTile(
                      userName: snapshot
                          .data.documents[index].data['chatRoomId']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      chatRoomId:
                          snapshot.data.documents[index].data["chatRoomId"],
                    ),
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await SharedPrefFunctions.getUserNameSharedPreference();
    Constants.uid = await SharedPrefFunctions.getUidSharedPreference();
    Constants.decryptKey =
        await SharedPrefFunctions.getDecryptKeySharedPreference();
    FirebaseMethods().getUserChats(Constants.myName).then(
      (snapshots) {
        setState(
          () {
            chatRooms = snapshots;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats.",
          style: GoogleFonts.workSans(
            fontSize: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        leading: null,
        actions: [
          Row(
            children: <Widget>[
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Search()));
                },
                child: Image.asset('assets/icons/search.png', height: 30),
              ),
              SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Settings()));
                },
                child: Image.asset('assets/icons/gear.png', height: 30),
              ),
              SizedBox(width: 15),
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Wall(
                            title: Constants.myName,
                          ),
                        ),
                      ),
                  icon: Icon(Icons.person_outline_rounded, color: Colors.black))
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            chatRoomsList(),
          ],
        ),
      ),
    );
  }
}
