import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts.dart';
import '../helper/firebase_helper.dart';
import '../views/chat.dart';
import '../widget/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch({value}) async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(value == null ? searchEditingController.text : value)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        if (searchResultSnapshot.documents.length == 0 && value == null) {
          initiateSearch(value: capitalize(searchEditingController.text));
        }
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              if (searchResultSnapshot.documents[index].data["username"] ==
                  Constants.myName) return Container();
              return InkWell(
                onTap: () {
                  sendMessage(
                      searchResultSnapshot.documents[index].data["username"]);
                },
                child: userTile(
                  searchResultSnapshot.documents[index].data["username"],
                  searchResultSnapshot.documents[index].data["email"],
                ),
              );
            })
        : Container();
  }

  sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
          first: true,
        ),
      ),
    );
  }

  Widget userTile(String userName, String email) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: GoogleFonts.workSans(
                    color: Theme.of(context).colorScheme.primary, fontSize: 16),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search.",
          style: GoogleFonts.workSans(fontSize: 50),
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
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (String value) {
                            initiateSearch();
                          },
                          controller: searchEditingController,
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
                              icon: isLoading
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.search,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () => initiateSearch(),
                            ),
                            border: InputBorder.none,
                            hintText: "Search...",
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
                        ),
                      ),
                    ],
                  ),
                ),
                userList()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
