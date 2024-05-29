import 'dart:convert';
import 'package:FSSP_cilent/models/review_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl = dotenv.get("BASE_URL");

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
}
