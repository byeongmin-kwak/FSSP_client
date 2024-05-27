import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:FSSP_cilent/services/api_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late NaverMapController _mapController;

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
        onMapReady: (controller) {
          _mapController = controller;
          _fetchReviews(); // 지도가 준비되었을 때 리뷰를 가져옵니다.
        },
      ),
    );
  }

  void _fetchReviews() async {
    // 현재 카메라 위치를 가져옵니다.
    final position = await _mapController.getCameraPosition();
    final target = position.target;

    // 여기서는 임의로 경계 범위를 설정합니다.
    final bounds = NLatLngBounds(
      southWest: NLatLng(target.latitude - 0.01, target.longitude - 0.01),
      northEast: NLatLng(target.latitude + 0.01, target.longitude + 0.01),
    );

    try {
      final reviews = await ApiService.fetchReviews(
        bounds.northEast.latitude,
        bounds.northEast.longitude,
        bounds.southWest.latitude,
        bounds.southWest.longitude,
      );
      _updateMarkers(reviews);
    } catch (e) {
      print('Error fetching reviews: $e');
      // 오류 처리
    }
  }

  void _updateMarkers(List reviews) {
    List<NMarker> markers = [];

    for (var review in reviews) {
      NLatLng position = NLatLng(review['latitude'], review['longitude']);
      markers.add(NMarker(
        id: "id",
        position: position,
        caption: NOverlayCaption(
          text: review['reviewText'],
        ),
        icon: const NOverlayImage.fromAssetImage('assets/marker_icon.png'),
      ));
    }

    setState(() {
      _mapController.clearOverlays();
      _mapController.addOverlayAll(Set.from(markers));
    });
  }
}
