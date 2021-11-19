import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final bool sendByMe;
  final int time;
  MessageTile({@required this.message, @required this.sendByMe, this.time});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool isemoji() {
    final RegExp regexEmoji = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    for (int i = 0; i < widget.message.length; i++) {
      if (!regexEmoji.hasMatch(widget.message.substring(i, i + 1))) {
        return false;
      }
    }
    return true;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: widget.sendByMe ? 40 : 20,
            right: widget.sendByMe ? 20 : 40,
          ),
          alignment:
              widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: widget.sendByMe
                ? EdgeInsets.only(left: 30)
                : EdgeInsets.only(right: 30),
            padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isemoji()
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.primary),
              color: Colors.transparent,
              borderRadius: widget.sendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23),
                    ),
            ),
            child: GestureDetector(
              onTap: () {
                if (widget.message.contains('http') ||
                    widget.message.contains("https"))
                  _launchURL(widget.message);
              },
              child: Text(
                widget.message,
                textAlign: TextAlign.start,
                style: GoogleFonts.workSans(
                  color: widget.sendByMe
                      ? Theme.of(context).primaryColorDark
                      : Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  decoration: widget.message.contains('http')
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
