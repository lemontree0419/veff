import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:vestfriend_123_a3/PlacesApiGoogle/places_api_google.dart';

class GetUserLocation extends StatefulWidget {
  final LatLng? initialPosition;

  GetUserLocation({this.initialPosition});

  @override
  State<GetUserLocation> createState() => _GetUserLocationState();
}

class _GetUserLocationState extends State<GetUserLocation> {
  final Completer<GoogleMapController> _controller = Completer();

  List<Marker> myMarker = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      // 특정 위치로 초기 카메라 위치 설정
      packData(widget.initialPosition!);
    } else {
      // 사용자의 현재 위치를 기반으로 초기 카메라 위치 설정
      getUserLocation().then((position) {
        packData(LatLng(position.latitude, position.longitude));
      });
    }
  }

  Future<void> packData(LatLng position) async {
    CameraPosition cameraPosition = CameraPosition(
      // 사용자의 현재 위치로 카메라 위치 설정
      target: position,
      zoom: 14,
    );

    // 사용자의 현재 위치에 마커 추가
    myMarker.add(
      Marker(
        markerId: MarkerId('First'),
        position: position,
        infoWindow: InfoWindow(
          title: 'Selected Position',
        ),
      ),
    );

    final GoogleMapController controller = await _controller.future;
    // 카메라 이동 애니메이션 및 마커 업데이트
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) {
      print('error$error');
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Location'),
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // 1. 검색화면으로 이동합니다.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlacesApiGoogleMapSearch()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 1), // 초기 위치는 임시 값으로 설정
          mapType: MapType.normal,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: (LatLng latLng) {
            // 지도를 탭하면 마커를 추가합니다.
            addMarker(latLng);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 사용자의 현재 위치를 기반으로 초기 카메라 위치 설정
          getUserLocation().then((position) {
            packData(LatLng(position.latitude, position.longitude));
          });
        },
        child: const Icon(Icons.radio_button_off),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // floatingActionButton 위치 설정
    );
  }

  void addMarker(LatLng latLng) async {
    // 사용자가 클릭한 위치에 마커를 추가합니다.
    final GoogleMapController controller = await _controller.future;
    setState(() {
      myMarker.clear();
      myMarker.add(
        Marker(
          markerId: MarkerId('Selected'),
          position: latLng,
          infoWindow: InfoWindow(
            title: 'Selected Position',
          ),
        ),
      );
    });

    // 마커를 추가한 위치로 카메라를 이동시킵니다.
    controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }
}


