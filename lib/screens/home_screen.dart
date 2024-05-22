import 'package:FSSP_cilent/models/review_model.dart';
import 'package:FSSP_cilent/services/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<ReviewModel>> reviews = ApiService.getLatestRevies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.house_rounded,
              color: Colors.blue.shade300,
              size: 40,
            ),
            const Text(
              "집사",
            ),
          ],
        ),
      ),
      body: const Column(
        children: [
          SearchBar(
            trailing: [Icon(Icons.search)],
            hintText: "주소를 검색해주세요.",
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "#원룸 #오피스텔 #아파트",
          ),
          Text(
            "최신 후기",
          ),
          Row(
            children: [],
          ),
          SizedBox(
            height: 30,
          ),
          Text("#수원시 #영통구"),
          Text("관심 지역 후기"),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}
