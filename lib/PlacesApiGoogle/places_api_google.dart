import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:vestfriend_123_a3/GetUserLocation/get_user_location.dart';

/// 검색화면 페이지 제작 Screen
class PlacesApiGoogleMapSearch extends StatefulWidget {
  @override
  State<PlacesApiGoogleMapSearch> createState() => _PlacesApiGoogleMapSearchState();
}

class _PlacesApiGoogleMapSearchState extends State<PlacesApiGoogleMapSearch> {
  String tokenForSession = '12345';
  var uuid = Uuid();
  List<dynamic> listForPlaces = [];
  final TextEditingController _controller = TextEditingController();

  void makeSuggestion(String input) async {
    String googlePlacesApiKey = '';
    String groundURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    var responseResult = await http.get(Uri.parse(request));
    var Resultdata = responseResult.body.toString();

    print('Result Data');
    print(Resultdata);

    if (responseResult.statusCode == 200) {
      setState(() {
        listForPlaces = jsonDecode(responseResult.body.toString())['predictions'];
      });
    } else {
      throw Exception('Showing data failed, try again');
    }
  }

  void onModify() {
    if (tokenForSession == null) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }

    makeSuggestion(_controller.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onModify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.teal],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('국가, 도시 찾기'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.orange],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search Here',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listForPlaces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        List<Location> locations = await locationFromAddress(listForPlaces[index]['description']);
                        // 클릭한 항목의 위치 정보를 얻습니다.
                        if (locations.isNotEmpty) {
                          LatLng selectedPosition = LatLng(locations[0].latitude, locations[0].longitude);
                          // 위치 정보를 기반으로 지도 화면으로 전환합니다.
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GetUserLocation(initialPosition: selectedPosition),
                          ));
                        }
                      },
                      title: Text(listForPlaces[index]['description']),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



