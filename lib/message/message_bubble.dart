import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vestfriend_123_a3/message/google_translate.dart';

class MessageBubble extends StatefulWidget {
  String message;
  String langCode;
  final int timestamp;
  final bool isMe;
  final String profileImage;

   MessageBubble({
    Key? key,
    required this.message,
     required this.langCode,
    required this.timestamp,
    required this.isMe,
    required this.profileImage,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {


  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(widget.timestamp);
    final realDate = '${date.year}-${date.month}-${date.day}';
    final realTime = '${date.hour}:${date.minute}';

    if (widget.isMe) {
      return _buildMyMessage(context, realDate, realTime);
    } else {
      return _buildOtherMessage(context, realDate, realTime);
    }
  }

  Widget _buildMyMessage(BuildContext context, String realDate, String realTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          textAlign: TextAlign.start,
          '$realDate $realTime',
          style: const TextStyle(color: Colors.grey),
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5, // 화면 너비의 50%로 설정
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.blue, // 말풍선 색상 지정
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
          ),
          child: Text(
            widget.message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherMessage(BuildContext context, String realDate, String realTime) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.profileImage),
              ),
            ),
          ),
          InkWell(
            onTap: () async{
              widget.message = await google_translate(text: widget.message,
                languageIsoCode: widget.langCode,
              );

setState(() {

});
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              padding: const EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5, // 화면 너비의 50%로 설정
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300], // 말풍선 색상 지정
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Text(
                widget.message,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          Text(
            textAlign: TextAlign.start,
            '$realDate $realTime',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
