import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _initialPosition = CameraPosition(
    // 집위치 구글맵에서 위도경도 값 넣은것.
    target: LatLng(37.51068, 127.0536),
    zoom: 14,
  );

  // 지도 깃발표시 코드
  final List<Marker> myMarker = [];
  final List<Marker> markerList = const [
     Marker(markerId: MarkerId('First'),
    position: LatLng(37.51068, 127.0536),
      infoWindow: InfoWindow(
        title: 'My Position',
      ),
    ),
    //2번재 마커 추가할때 코드, 나중에 지워도 됨.
    Marker(markerId: MarkerId('Second'),
      position: LatLng(37.511774, 127.057728),
      infoWindow: InfoWindow(
        title: 'Coex',
      ),
    )

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myMarker.addAll(markerList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          //지도 타입 변경 코드
          mapType: MapType.normal,
          markers: Set<Marker>.of(myMarker),
          onMapCreated: (GoogleMapController controller)
          {
            _controller.complete(controller);
          },
        ),
      ),
      // camera animation code(chap.6)
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: ()
        async
        {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: LatLng(37.51068, 127.0536),
              zoom: 14,
            )
          ));
          setState(() {

          });
        },
      ),
    );
  }
}
