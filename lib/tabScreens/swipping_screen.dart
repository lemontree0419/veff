import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vestfriend_123_a3/GetUserLocation/get_user_location.dart';
import 'package:vestfriend_123_a3/controllers/profile-controller.dart';
import 'package:vestfriend_123_a3/global.dart';
import 'package:vestfriend_123_a3/tabScreens/user_details_screen.dart';

class SwippingScreen extends StatefulWidget {
  const SwippingScreen({super.key});

  @override
  State<SwippingScreen> createState() => _SwippingScreenState();
}

class _SwippingScreenState extends State<SwippingScreen> {
  ProfileController profileController = Get.put(ProfileController());
  String senderName = "";
  RangeValues _currentAgeRange = const RangeValues(20, 55);
  RangeValues _currentKmRange = const RangeValues(0, 50);

  String currentCountry = ''; // 현재 사용자의 국가
  String currentCity = '';    // 현재 사용자의 도시


  applyFilter() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Matching Filter",
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text("I am looking for a:"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButton<String>(
                        hint: const Text('Select gender'),
                        value: chosenGender,
                        underline: Container(),
                        items: ['Male', 'female', 'Others'].map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            chosenGender = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("who lives in:"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButton<String>(
                        hint: const Text('Select country'),
                        value: chosenCountry,
                        underline: Container(),
                        items: [
                          'korea',
                          'Vietnam',
                          'Japan',
                          'China',
                          'USA',
                          'Philippines',
                        ].map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            chosenCountry = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // 나중에 global.dart 페이지에 city추가한거 연결문제없는지 확인할 것.
                    const Text("which city:"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButton<String>(
                        hint: const Text('Select city'),
                        value: chosenCity,
                        underline: Container(),
                        items: [
                          'Hanoi',
                          'Danang',
                          'HochiMinh',
                          'seoul',
                          'Busan',
                          'Others',
                        ].map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            chosenCity = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("상대의 나이범위를 선택하여주세요"),
                    const SizedBox(height: 10),
                    Text(
                      '나이 범위: ${_currentAgeRange.start.round()} - ${_currentAgeRange.end.round()}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    RangeSlider(
                      values: _currentAgeRange,
                      min: 20,
                      max: 55, // 최대 나이
                      divisions: 35, // 나이 구간
                      labels: RangeLabels(
                        _currentAgeRange.start.round().toString(),
                        _currentAgeRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentAgeRange = values;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        LatLng? userLocation = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GetUserLocation(),
                            ),
                        );
                        if (userLocation != null) {
                          // 여기서 userLocation을 기반으로 선택된 거리 내의 유저를 필터링하는 로직 추가
                          // 예를 들어, userLocation과 선택된 거리를 기반으로 필터링할 수 있는 함수를 호출하고 그 결과를 저장한다.
                          /// 아래 코드를 활성화 시켜 놓으면 깃발기능이 무의미 하게됨. 즉, 현재 나의 위치에서만 유저들이 보여짐.
                          //  filteredUsers = filterUsersWithinRange(userLocation, _currentKmRange);
                        }

                      },
                      icon: const Icon(
                        Icons.location_on_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      label:
                      const Text('당신의 현재 위치'
                      ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("km(범위, 나의 위치기준)"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '거리 Km : ${_currentKmRange.start.round()} - ${_currentKmRange.end.round()} km',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    RangeSlider(
                      values: _currentKmRange,
                      min: 0,
                      max: 100, // 최대 km
                      divisions: 20, // km 구간
                      labels: RangeLabels(
                        _currentKmRange.start.round().toString(),
                        _currentKmRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentKmRange = values;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          profileController.setAgeRange(_currentAgeRange);
                          Get.back();
                          profileController.getResults();
                        },
                        child: const Text("OK"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back(); // 이전 화면으로 돌아가는 코드
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],

              );
            },
          );
        });
  }

  readCurrentUserData() async {
    await FirebaseFirestore.instance.collection("users").doc(currentUserID).get().then((dataSnapshot) {
      setState(() {
        senderName = dataSnapshot.data()!["name"].toString();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: profileController.allUsersProfileList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final eachProfileInfo = profileController.allUsersProfileList[index];
            return DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    eachProfileInfo.imageProfile.toString(),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    //Filter and Map Icon Buttons
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                applyFilter();
                              },
                              icon: const Icon(
                                Icons.filter_list,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => GetUserLocation()
                                    )
                                );
                              },
                              icon: const Icon(
                                Icons.map_outlined,
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    //User Data
                    GestureDetector(
                      onTap: () {
                        profileController.viewSentAndViewRecevied(
                          eachProfileInfo.uid.toString(),
                          senderName,
                        );
                        //send user to profile person userDetailScreen
                        Get.to(UserDetailsScreen(
                          userID: eachProfileInfo.uid.toString(),
                        ));
                      },
                      child: Column(
                        children: [
                          //name
                          Text(
                            eachProfileInfo.name.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //age - city
                          Text(
                            eachProfileInfo.age.toString() + " ⦾ " + eachProfileInfo.city.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          //profession and religion
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text(
                                  eachProfileInfo.profession.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text(
                                  eachProfileInfo.religion.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //country and ethnicity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text(
                                  eachProfileInfo.country.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text(
                                  eachProfileInfo.ethnicity.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    //Image Buttons -favorite - chat - like
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //favorite button
                        GestureDetector(
                          onTap: () {
                            profileController.favoriteSentAndFavoriteRecevied(
                              eachProfileInfo.uid.toString(),
                              senderName,
                            );
                          },
                          child: Image.asset(
                            "images/heart.png",
                            width: 60,
                          ),
                        ),
                        //chat button
                        GestureDetector(
                          onTap: () {

                          },
                          child: Image.asset(
                            "images/mobile.png",
                            width: 90,
                          ),
                        ),
                        //like button
                        GestureDetector(
                          onTap: () {
                            profileController.likeSentAndLikeRecevied(
                              eachProfileInfo.uid.toString(),
                              senderName,
                            );
                          },
                          child: Image.asset(
                            "images/super.png",
                            width: 60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
