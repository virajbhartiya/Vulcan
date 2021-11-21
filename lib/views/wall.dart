import 'package:chatapp/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Wall extends StatefulWidget {
  final String title;
  const Wall({Key key, this.title}) : super(key: key);

  @override
  _WallState createState() => _WallState();
}

class _WallState extends State<Wall> {
  TextEditingController commentController = TextEditingController();
  Stream<QuerySnapshot> comments;

  @override
  void initState() {
    super.initState();
    getComments().then((value) {
      setState(() {
        comments = value;
      });
    });
  }

  Future getComments() async {
    return Firestore.instance
        .collection("users")
        .document(widget.title)
        .collection("comments")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future addComment() async {
    String value = commentController.text;
    commentController.clear();
    await Firestore.instance
        .collection("users")
        .document(widget.title)
        .collection("comments")
        .add({
      "comment": value,
      "time": DateTime.now().microsecondsSinceEpoch,
      "user": Constants.myName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title + '\s Wall.',
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
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.png'),
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
            ),
            Container(
                height: 200,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: StreamBuilder(
                      stream: comments,
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        return snapshot.hasData
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  print(snapshot
                                      .data.documents[index].data["comment"]);
                                  return Container(
                                    height: 40,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
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
                                        Divider(
                                          endIndent: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                        )
                                      ],
                                    ),
                                  );
                                })
                            : Container();
                      },
                    )
                    // Column(
                    // children: [
                    // Container(
                    //   height: 40,
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 12.0),
                    //         child: Align(
                    //           alignment: Alignment.centerLeft,
                    //           child: Text(
                    //             comment,
                    //             style: GoogleFonts.workSans(
                    //               fontSize: 20,
                    //               color: Colors.black,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Divider(
                    //         endIndent:
                    //             MediaQuery.of(context).size.width * 0.2,
                    //       )
                    //     ],
                    //   ),
                    // )
                    //   ],
                    // ),
                    )),
          ],
        ),
      ),
    );
  }
}
