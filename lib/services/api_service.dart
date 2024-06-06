import 'dart:convert';
import 'package:FSSP_cilent/models/building_model.dart';
import 'package:FSSP_cilent/models/review_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl = dotenv.get("BASE_URL");
  static final String serviceKey = dotenv.get("SERVICE_KEY");
  static final String clientId = dotenv.get("CLIENT_ID");
  static final String clientSecret = dotenv.get("CLIENT_SECRET");

  // 메인페이지에서의 최신 리뷰 조회
  static Future<List<ReviewModel>> getLatestReviews() async {
    final url = Uri.parse('$baseUrl/api/latest-reviews');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> reviewsJson =
          jsonDecode(response.body) as List<dynamic>;
      List<ReviewModel> reviews =
          reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
      return reviews;
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  // 지도에서 리뷰 조회
  static Future<List<ReviewModel>> fetchReviews(double northEastLat,
      double northEastLng, double southWestLat, double southWestLng) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/map-reviews/?northEastLat=$northEastLat&northEastLng=$northEastLng&southWestLat=$southWestLat&southWestLng=$southWestLng'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> reviewsJson = responseData['reviews'];
      return reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch reviews');
    }
  }

  // 건물 정보 조회
  static Future<BuildingModel> getBuildingInfo(
    String address,
    String bcode,
    String jibunAddress,
  ) async {
    //건물 조회에 필요한 시군구코드, 법정동코드, 번, 지 구하기
    final String sigunguCd = bcode.substring(0, 5);
    final String bjdongCd = bcode.substring(5, 10);

    // 공백으로 분리
    List<String> parts = jibunAddress.split(' ');

    // 마지막 부분을 숫자로 인식하여 번과 지 추출
    String lastPart = parts.last;
    String bun = '';
    String ji = '';

    if (lastPart.contains('-')) {
      // '-'로 분리하여 번과 지 추출
      List<String> bunJi = lastPart.split('-');
      bun = bunJi[0].padLeft(4, '0');
      ji = bunJi[1].padLeft(4, '0');
    } else {
      // '-'가 없는 경우, 숫자 부분만 번으로 설정
      bun = lastPart.padLeft(4, '0');
    }

    final response = await http.get(
      Uri.parse(
          'http://apis.data.go.kr/1613000/BldRgstService_v2/getBrTitleInfo?sigunguCd=$sigunguCd&bjdongCd=$bjdongCd&bun=$bun&ji=$ji&_type=json&ServiceKey=$serviceKey'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final buildingData = jsonResponse['response']['body']['items']['item'];
      return BuildingModel.fromJson(buildingData);
    } else {
      throw Exception('Failed to load building information');
    }
  }

  // 리뷰 작성
  static Future<bool> submitReview(Map<String, dynamic> reviewData) async {
    final url = Uri.parse('$baseUrl/api/reviews');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reviewData),
    );

    return response.statusCode == 201;
  }

  // 주소로 위도, 경도 찾기
  Future<Map<String, dynamic>> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
        'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$address');

    final headers = {
      'X-NCP-APIGW-API-KEY-ID': clientId,
      'X-NCP-APIGW-API-KEY': clientSecret,
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['addresses'].isEmpty) {
        return {'latitude': null, 'longitude': null};
      }

      double latitude = double.parse(data['addresses'][0]['y']);
      double longitude = double.parse(data['addresses'][0]['x']);
      return {'latitude': latitude, 'longitude': longitude};
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }

  // 주소로 리뷰 조회
  static Future<List<ReviewModel>> getReviewsByAddress(String address) async {
    final url = Uri.parse('$baseUrl/api/reviews-by-address?address=$address');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> reviewsJson =
          jsonDecode(response.body) as List<dynamic>;
      return reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch reviews');
    }
  }
}
