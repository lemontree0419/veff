import 'package:flutter/material.dart';
import 'package:vestfriend_123_a3/authenbadge/car100_screen.dart';
import 'package:vestfriend_123_a3/authenbadge/car200_screen.dart';
import 'package:vestfriend_123_a3/authenbadge/car50_screen.dart';
import 'package:vestfriend_123_a3/authenbadge/money100_screen.dart';
import 'package:vestfriend_123_a3/authenbadge/money30_screen.dart';
import 'package:vestfriend_123_a3/authenbadge/money50_screen.dart';
import 'package:vestfriend_123_a3/authenbadge/money70_screen.dart';

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('인증 뱃지'),
        backgroundColor: Colors.red,
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '☞ 회원님에게 해당되는 항목을 선택하여 '
                  '          프로필을 꾸며보세요',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const Text(
              '☞ 카테고리별 해당하는 항목을 선택한 후에 '
                  '      인증을 준비해주세요',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              endIndent: 10,
            ),
            Text(
              '    수입(단위:천원)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Wrap(
                    // 가로 세로 배열 조절 spacing 값 조절하면됨.
                    spacing: 0.0,
                    runSpacing: 20.0,
                    children: [
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        //아래 빨간불 괄호 부분 기억할것.113행.
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Money30Screen()
                                )
                            );
                          },

                        child: Card(
                          color: const Color.fromARGB(255, 21, 21, 21),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset("images/dollar.png",width: 64.0),
                                  SizedBox(height: 10.0),
                                  Text("30,000+",style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                  )),
                                  SizedBox(height: 5.0),
                                  Text("연봉 3천만원 이상", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Money50Screen()
                                )
                            );
                          },
                        child: Card(
                          color: const Color.fromARGB(255, 21, 21, 21),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset("images/dollar.png",width: 64.0),
                                  SizedBox(height: 10.0),
                                  Text("50,000+",style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  )),
                                  SizedBox(height: 5.0),
                                  Text("연봉 5천만원 이상", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Money70Screen()
                                )
                            );
                          },
                        child: Card(
                          color: const Color.fromARGB(255, 21, 21, 21),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset("images/dollar.png",width: 64.0),
                                  SizedBox(height: 10.0),
                                  Text("70,000+",style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  )),
                                  SizedBox(height: 5.0),
                                  Text("연봉 7천만원 이상", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Money100Screen()
                                )
                            );
                          },
                        child: Card(
                          color: const Color.fromARGB(255, 21, 21, 21),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset("images/dollar.png",width: 64.0),
                                  SizedBox(height: 10.0),
                                  Text("100,000+",style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  )),
                                  SizedBox(height: 5.0),
                                  Text("연봉 1억원 이상", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        ),
                      ),
                      Text(
                        '   차량(단위:천원)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Row(
                        children: [
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Car50Screen()
                                )
                            );
                          },
                        child: Card(
                          color: const Color.fromARGB(255, 21, 21, 21),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset("images/car.png",width: 64.0),
                                  SizedBox(height: 10.0),
                                  Text("~50,000",style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  )),
                                  SizedBox(height: 5.0),
                                  Text("5천만원 미만", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Car100Screen()
                                )
                            );
                          },
                        child: Card(
                          color: const Color.fromARGB(255, 21, 21, 21),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset("images/car.png",width: 64.0),
                                  SizedBox(height: 10.0),
                                  Text("50,000~100,000",style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0
                                  )),
                                  SizedBox(height: 5.0),
                                  Text("5천만원~1억원", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 160.0,
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Car200Screen()
                                )
                            );
                          },
                        child: Card(
                          color: const Color.fromARGB(255, 21, 21, 21),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset("images/car.png",width: 64.0),
                                  SizedBox(height: 10.0),
                                  Text("100,000+",style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  )),
                                  SizedBox(height: 5.0),
                                  Text("1억원 이상", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
