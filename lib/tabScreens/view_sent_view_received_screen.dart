import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vestfriend_123_a3/chatScreen/chat_screen.dart';
import 'package:vestfriend_123_a3/global.dart';
import 'package:vestfriend_123_a3/homeScreen/home_screen.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key, required this.userID});
  final String userID;

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  String name = "";
  List<Map<dynamic, dynamic>> _chatRooms = [];
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref('rooms');
  bool isLikeSentClicked = true;
  List<String> likeSentList = [];
  List<String> likeReceivedList = [];
  List likeList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLikedListKeys();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> retrieveUserInfo() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userID)
        .get();
    if (snapshot.exists) {
      setState(() {
        name = snapshot.data()!["name"];
      });
    }
  }

  Future<void> _loadChatRooms() async {
    final value = await _messagesRef.once();
    final rooms = value.snapshot.value as Map<dynamic, dynamic>;
    final chatRooms = rooms.entries
        .where((entry) => (entry.key as String).split('_').contains(name))
        .map((entry) => {entry.key: entry.value})
        .toList();
    setState(() {
      _chatRooms = chatRooms;
    });
  }

  Future<void> getLikedListKeys() async {
    await retrieveUserInfo();
    final collection = isLikeSentClicked ? 'likeSent' : 'likeReceived';
    final document = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID.toString())
        .collection(collection)
        .get();
    final list = document.docs.map((doc) => doc.id).toList();
    setState(() {
      if (isLikeSentClicked) {
        likeSentList = list;
      } else {
        likeReceivedList = list;
      }
    });
    await getKeysDataFromUsersCollection(list);
    await _loadChatRooms();
  }

  Future<void> getKeysDataFromUsersCollection(List<String> keysList) async {
    final allUsersDocument =
        await FirebaseFirestore.instance.collection("users").get();
    final filteredList = allUsersDocument.docs
        .where((doc) => keysList.contains(doc['uid']))
        .map((doc) => doc.data())
        .toList();
    setState(() {
      likeList = filteredList;
    });
  }

  String loadLastMessage(int index) {
    final data = _chatRooms[index][_chatRooms[index].keys.first]['messages']
        as Map<dynamic, dynamic>;
    final chatData = data.values.toList()
      ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    return chatData.first['message'];
  }

  String loadImageProfile(int index) {
    final data = _chatRooms[index][_chatRooms[index].keys.first]['messages']
        as Map<dynamic, dynamic>;
    final chatData = data.values.toList();
    return chatData.first['imageProfile'];
  }

  String loadLastTime(int index) {
    final data = _chatRooms[index][_chatRooms[index].keys.first]['messages']
        as Map<dynamic, dynamic>;
    final chatData = data.values.toList()
      ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    final date =
        DateTime.fromMillisecondsSinceEpoch(chatData.first['timestamp']);
    final now = DateTime.now();
    return now.day == date.day
        ? 'Today'
        : '${date.day} ${DateFormat.MMMM().format(DateTime(date.year, date.month))}';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure AutomaticKeepAliveClientMixin works
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                )),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ],
        title: const Text(
          'Conversations',
          style: TextStyle(),
        ),
      ),
      body: FutureBuilder(
        future: getLikedListKeys(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else if (_chatRooms.isEmpty) {
            return const Center(child: Text('No chat rooms available.'));
          } else {
            return Column(
              children: [
                // 채팅 검색 위젯
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 49, 49, 49),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                width: 50,
                                height: 50,
                                child: const Icon(Icons.search)),
                            const SizedBox(
                                height: 35,
                                child: VerticalDivider(
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // 채팅 기록 화면
                Expanded(
                  child: ListView.builder(
                    itemCount: _chatRooms.length,
                    itemBuilder: (context, index) {
                      final user = likeList[index];
                      final key =
                          (_chatRooms[index].keys.first as String).split('_');
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  uid: user["uid"],
                                  otherName:
                                      key.first == name ? key.last : key.first,
                                  name: name,
                                  age: user["age"] as int,
                                  profileImage: user["imageProfile"],
                                ),
                              ));
                        },
                        title: Text(key.first == name ? key.last : key.first),
                        leading: Container(
                          width: 50,
                          height: 50,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          child: Image.network(
                            user["imageProfile"],
                            fit: BoxFit.cover,
                          ),
                        ),
                        subtitle: Text(loadLastMessage(index)),
                        trailing: Text(loadLastTime(index)),
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
