import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vestfriend_123_a3/message/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.name,
    required this.otherName,
    required this.uid,
    required this.age,
    required this.profileImage,
  }) : super(key: key);

  final String name;
  final String otherName;
  final String uid;
  final int age;
  final String profileImage;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> chatDatas = [];
  late DatabaseReference roomRef;

  @override
  void initState() {
    super.initState();
    // Firebase Realtime Database의 채팅방 Reference 설정
    String roomId = generateRoomId(widget.name, widget.otherName);
    roomRef =
        FirebaseDatabase.instance.ref('rooms').child(roomId).child('messages');

    // Firebase Realtime Database의 메시지 추가 이벤트 리스너 등록
    roomRef.onChildAdded.listen((event) {
      Map<dynamic, dynamic> messageData =
      event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        chatDatas.add({
          'key': event.snapshot.key,
          'senderId': messageData["senderId"],
          'receiverId': messageData["receiverId"],
          'message': messageData["message"],
          'timestamp': messageData["timestamp"],
        });
      });
      // 새로운 메시지가 추가될 때 스크롤을 맨 아래로 이동
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  /// room key 제네레이터
  String generateRoomId(String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String roomId = ids.join("_");
    return roomId;
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      String message = messageController.text.trim();
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      String senderId = widget.name;
      String receiverId = widget.otherName;

      // 메시지 전송
      roomRef.push().set({
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "timestamp": timestamp,
      }).onError((error, stackTrace) => throw stackTrace);

      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      messageController.clear();
    }
  }
  String langCode = 'ko';

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.profileImage);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        profileImage: widget.profileImage,
        name: widget.otherName,
        age: widget.age.toString(),
      ),
      body: Column(
        children: [
          /// lang code
          Container(
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.blue),
                  child: DropdownButton<String>(
                    isDense: false,
                    iconSize: 12.0,
                    value: langCode,
                    onChanged: (String? newValue) async {
                      setState(() {
                        langCode = newValue ?? 'ko';
                      });

                    },
                    items: <String>['ko', 'en', 'vi', 'zh-CN']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              ],
            ),
          ),

          /// chat list
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: chatDatas.length,
                  itemBuilder: (context, index) {
                    final data = chatDatas.reversed.toList()[index];
                    return MessageBubble(
                      langCode: langCode,
                      message: data['message'],
                      timestamp: data['timestamp'],
                      isMe: data['senderId'] == widget.name,
                      profileImage: widget.profileImage,
                    );
                  },
                ),
              ),
            ),
          ),

          /// message input
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    dragStartBehavior: DragStartBehavior.down,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 50),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: messageController,
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                        textAlign: TextAlign.start,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '메시지 입력',
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => sendMessage(),
                  icon: Icon(
                    Icons.send,
                    color: messageController.text.isEmpty
                        ? Colors.grey
                        : Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SimpleAppBar({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.age,
  }) : super(key: key);

  final String profileImage;
  final String name;
  final String age;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(profileImage),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$name',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          height: 55,
          child: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '나가기',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


