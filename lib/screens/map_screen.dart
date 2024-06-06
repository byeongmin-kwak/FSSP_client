import 'package:FSSP_cilent/screens/building_screen.dart';
import 'package:FSSP_cilent/widgets/info_window_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:FSSP_cilent/services/api_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with RouteAware {
  late NaverMapController _mapController;
  OverlayEntry? _infoWindowOverlay;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteObserver().subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    RouteObserver().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // 다른 화면에서 돌아왔을 때
    _removeInfoWindow();
  }

  @override
  void didPushNext() {
    // 다른 화면으로 이동했을 때
    _removeInfoWindow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(37.247949112203, 127.07700000000),
                zoom: 15,
                bearing: 0,
                tilt: 0,
              ),
            ),
            onMapReady: (controller) {
              _mapController = controller;
              _fetchReviews(); // 지도가 준비되었을 때 리뷰를 가져옵니다.
            },
            onCameraChange: (reason, isAnimated) {
              _fetchReviews(); // 카메라가 이동할 때마다 리뷰를 가져옵니다.
            },
            onMapTapped: (point, latLng) {
              if (_infoWindowOverlay != null) {
                _infoWindowOverlay!.remove();
                _infoWindowOverlay = null;
              }
            },
          ),
        ],
      ),
    );
  }

  void _fetchReviews() async {
    // 현재 카메라 위치를 가져옵니다.
    final position = await _mapController.getCameraPosition();
    final target = position.target;
    final zoom = position.zoom;

    // 줌 레벨에 따른 대략적인 범위를 계산합니다.
    final double latRange = _getLatRangeFromZoom(zoom);
    final double lngRange = _getLngRangeFromZoom(zoom);

    final bounds = NLatLngBounds(
      southWest:
          NLatLng(target.latitude - latRange, target.longitude - lngRange),
      northEast:
          NLatLng(target.latitude + latRange, target.longitude + lngRange),
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

  double _getLatRangeFromZoom(double zoom) {
    // 줌 레벨에 따라 위도 범위를 계산합니다.
    // 이 값은 대략적인 값으로 필요에 따라 조정 가능합니다.
    return 0.01 * (20 - zoom);
  }

  double _getLngRangeFromZoom(double zoom) {
    // 줌 레벨에 따라 경도 범위를 계산합니다.
    // 이 값은 대략적인 값으로 필요에 따라 조정 가능합니다.
    return 0.01 * (20 - zoom);
  }

  void _updateMarkers(List reviews) {
    List<NMarker> markers = [];

    for (var review in reviews) {
      if (review.latitude != null && review.longitude != null) {
        NLatLng position = NLatLng(review.latitude, review.longitude);
        NMarker marker = NMarker(
          id: review.id.toString(),
          position: position,
        );

        marker.setOnTapListener((overlay) {
          _showCustomInfoWindow(
            review.address,
            review.overallRating,
            review.bcode,
            review.jibunAddress,
            review.buildingName,
            position,
          );
        });

        markers.add(marker);
      }
    }

    setState(() {
      _mapController.clearOverlays();
      _mapController.addOverlayAll(Set.from(markers));
    });
  }

  void _showCustomInfoWindow(
    String address,
    double rating,
    String bcode,
    String jibunAddress,
    String buildingName,
    NLatLng position,
  ) {
    if (_infoWindowOverlay != null) {
      _infoWindowOverlay!.remove();
    }

    final overlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 30,
        left: MediaQuery.of(context).size.width / 2 - 100,
        child: GestureDetector(
          onTap: () {
            _removeInfoWindow();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BuildingScreen(
                        address: address,
                        bcode: bcode,
                        jibunAddress: jibunAddress,
                        buildingName: buildingName,
                      )),
            );
          },
          child: InfoWindowWidget(
            address: address,
            rating: rating,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);
    _infoWindowOverlay = overlay;
  }

  void _removeInfoWindow() {
    if (_infoWindowOverlay != null) {
      _infoWindowOverlay!.remove();
      _infoWindowOverlay = null;
    }
  }
}
