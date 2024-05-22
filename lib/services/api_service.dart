import 'dart:convert';
import 'package:FSSP_cilent/models/review_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl = dotenv.get("BASE_URL");

  static Future<List<ReviewModel>> getLatestRevies() async {
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
}
