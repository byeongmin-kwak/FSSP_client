import 'package:FSSP_cilent/screens/building_screen.dart';
import 'package:FSSP_cilent/screens/review_write_screen.dart';
import 'package:flutter/material.dart';
import 'package:FSSP_cilent/models/review_model.dart';
import 'package:FSSP_cilent/services/api_service.dart';
import 'package:FSSP_cilent/widgets/review_widget.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<ReviewModel>> reviews = ApiService.getLatestReviews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade200,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.house_rounded,
              color: Colors.blue,
              size: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              "집사",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'lib/assets/image.png',
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "주소를 검색해주세요.",
                      hintStyle: TextStyle(color: Colors.grey.shade800),
                      suffixIcon:
                          Icon(Icons.search, color: Colors.grey.shade800),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onTap: () async {
                      KopoModel? model = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RemediKopo(),
                        ),
                      );
                      if (model != null) {
                        String? address = model.address;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuildingScreen(
                              address: address!,
                              bcode: model.bcode!,
                              jibunAddress: model.jibunAddress!,
                              buildingName: model.buildingName!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle(context, "#원룸 #오피스텔 #아파트", "최신 리뷰"),
                    reviewSection(context, reviews),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle(context, "#수원시 #영통구", "관심 지역 리뷰"),
                    reviewSection(context, reviews),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReviewWriteScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget sectionTitle(BuildContext context, String hashtag, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hashtag,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade300,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewSection(
      BuildContext context, Future<List<ReviewModel>> reviews) {
    return SizedBox(
      height: 270,
      child: FutureBuilder<List<ReviewModel>>(
        future: reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.black)),
            );
          } else if (snapshot.hasData) {
            return CarouselSlider(
              options: CarouselOptions(
                height: 290,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: snapshot.data!.map((review) {
                return Builder(
                  builder: (BuildContext context) {
                    return ReviewWidget(
                      review: review,
                    );
                  },
                );
              }).toList(),
            );
          } else {
            return const Center(
              child: Text('No reviews available',
                  style: TextStyle(color: Colors.black)),
            );
          }
        },
      ),
    );
  }
}
