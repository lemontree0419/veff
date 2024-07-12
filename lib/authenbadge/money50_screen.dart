import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Money50Screen(),
    );
  }
}

class Money50Screen extends StatefulWidget {
  const Money50Screen({Key? key}) : super(key: key);

  @override
  _Money50ScreenState createState() => _Money50ScreenState();
}

class _Money50ScreenState extends State<Money50Screen> {
  List<File> _pickedImages = [];
  bool _isLoading = false;

  void _showImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // 여백 제거
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4, // 화면 너비의 80%
            height: MediaQuery.of(context).size.height * 0.4, // 화면 높이의 80%
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    if (_pickedImages.length >= 3) {
      // 이미 3장의 이미지를 선택한 경우 경고 메시지 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('최대 이미지 개수 초과'),
            content: const Text('이미지는 최대 3장까지만 업로드할 수 있습니다.'),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _uploadImages() async {
    setState(() {
      _isLoading = true;
    });

    for (var image in _pickedImages) {
      final ref = FirebaseStorage.instance.ref("money_50/${image.path.split('/').last}");
      await ref.putFile(image);

      final imageUrl = await ref.getDownloadURL();
      print('imageUrl = $imageUrl');
    }

    setState(() {
      _isLoading = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('업로드 완료'),
          content: const Text('이미지 업로드가 완료되었습니다!'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _clearImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 등록화면'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo_library_outlined),
              label: const Text('이미지 선택'),
            ),
          ),
          const SizedBox(height: 20), // 버튼과 사진 간의 간격을 줄이기 위해 수정
          if (_pickedImages.isNotEmpty)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _pickedImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showImageDialog(_pickedImages[index]);
                    },
                    child: GridTile(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.file(
                              _pickedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () => _clearImage(index),
                            child: const Text('취소'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (_pickedImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0), // 버튼 위 아래의 간격을 조절
              child: ElevatedButton.icon(
                onPressed: _uploadImages,
                icon: Icon(Icons.upload),
                label: const Text('업로드 하기'),
              ),
            ),
          if (_isLoading)
            Column(
              children: const [
                SizedBox(height: 25),
                CircularProgressIndicator(),
                SizedBox(height: 25),
              ],
            ),
          const Row(
            children: [
              Expanded(
                child: Text(
                  '※ 이미지 사진은 업로드는 최대 3장까지 가능합니다.',
                  style: TextStyle(fontSize: 18),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: Text(
                  '※ 회원님의 소득을 증빙할 수 있는 자료를 업로드 해주세요.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          const Row(
            children: [
              Expanded(
                child: Text(
                  '※ 회원님의 소득자료를 심사 후, 해당되는 Badge를 발급해드릴 예정입니다.(소요기간은 약 2~3일)',
                  style: TextStyle(fontSize: 18),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
