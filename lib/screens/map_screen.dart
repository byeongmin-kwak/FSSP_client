import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
              target: NLatLng(37.247949112203, 127.07700000000),
              zoom: 15,
              bearing: 0,
              tilt: 0),
        ),
        onMapReady: (controller) {},
      ),
    );
  }
}
