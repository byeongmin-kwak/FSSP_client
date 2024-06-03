import 'dart:convert';
import 'package:FSSP_cilent/models/building_model.dart';
import 'package:FSSP_cilent/models/review_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class ApiService {
  static final String baseUrl = dotenv.get("BASE_URL");
  static final String serviceKey = dotenv.get("SERVICE_KEY");

  // 메인페이지에서의 최신 리뷰 조회
  static Future<List<ReviewModel>> getLatestReviews() async {
    List<ReviewModel> reviewInstances = [];
    final url = Uri.parse('$baseUrl/api/latest-reviews');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final reviews = jsonDecode(response.body);
      for (var review in reviews) {
        final instance = ReviewModel.fromJson(review);
        reviewInstances.add(instance);
      }
      return reviewInstances;
    } else {
      throw Error();
    }
  }

  // 지도에서 리뷰 조회
  static Future<List> fetchReviews(double northEastLat, double northEastLng,
      double southWestLat, double southWestLng) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/map-reviews/?northEastLat=$northEastLat&northEastLng=$northEastLng&southWestLat=$southWestLat&southWestLng=$southWestLng'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch reviews');
    }
  }

  // 건물 정보 조회
  static Future<BuildingModel> getBuildingInfo(String address) async {
    final jsonString = await rootBundle.loadString('lib/경기도 수원시 영통구.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> data = jsonMap['Data'];

    // 주소로 데이터 찾기
    final buildingData = data.firstWhere(
      (element) => element['NEW_PLAT_PLC'] == address,
      orElse: () => null,
    );

    if (buildingData == null) {
      throw Exception('Address not found');
    }

    final String sigunguCd = buildingData['SIGUNGU_CD'];
    final String bjdongCd = buildingData['BJDONG_CD'];
    final String bun = buildingData['BUN'];
    final String ji = buildingData['JI'];

    final response = await http.get(
      Uri.parse(
          'http://apis.data.go.kr/1613000/BldRgstService_v2/getBrTitleInfo?sigunguCd=$sigunguCd&bjdongCd=$bjdongCd&bun=$bun&ji=$ji&_type=json&ServiceKey=$serviceKey'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final buildingData = jsonResponse['response']['body']['items']['item'];
      return BuildingModel.fromJson(buildingData);
    } else {
      throw Error();
    }
  }
}
