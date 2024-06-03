import 'package:flutter/material.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReviewWriteScreen(),
    );
  }
}

class ReviewWriteScreen extends StatefulWidget {
  const ReviewWriteScreen({super.key});

  @override
  _ReviewWriteScreenState createState() => _ReviewWriteScreenState();
}

class _ReviewWriteScreenState extends State<ReviewWriteScreen> {
  String? _selectedAddress;
  String? _selectedResidenceType;
  String? _selectedResidenceYear;
  String? _selectedResidenceFloor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 작성'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "주소",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (_selectedAddress == null)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: GestureDetector(
                    onTap: () async {
                      KopoModel? model = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RemediKopo(),
                        ),
                      );
                      if (model != null) {
                        setState(() {
                          _selectedAddress = model.address;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 8.0),
                          Text("살아본 집의 주소를 입력해 주세요."),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Card(
                  child: ListTile(
                    title: Text(_selectedAddress!),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        KopoModel? model = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RemediKopo(),
                          ),
                        );
                        if (model != null) {
                          setState(() {
                            _selectedAddress = model.address;
                          });
                        }
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "거주 년도",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DropdownButtonFormField<String>(
                hint: const Text("거주 년도를 선택해 주세요"),
                items: const [
                  DropdownMenuItem(
                    value: "2024년까지",
                    child: Text("2024년까지"),
                  ),
                  DropdownMenuItem(
                    value: "2023년까지",
                    child: Text("2023년까지"),
                  ),
                  DropdownMenuItem(
                    value: "2022년까지",
                    child: Text("2022년까지"),
                  ),
                  DropdownMenuItem(
                    value: "2021년이전",
                    child: Text("2021년이전"),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _selectedResidenceYear = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "거주 층",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DropdownButtonFormField<String>(
                hint: const Text("거주 층수를 선택해 주세요"),
                items: const [
                  DropdownMenuItem(
                    value: "저층",
                    child: Text("저층"),
                  ),
                  DropdownMenuItem(
                    value: "중층",
                    child: Text("중층"),
                  ),
                  DropdownMenuItem(
                    value: "고층",
                    child: Text("고층"),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _selectedResidenceFloor = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "만족도를 평가해 주세요",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              buildRatingRow("집 내부"),
              buildRatingRow("건물/단지"),
              buildRatingRow("교통"),
              buildRatingRow("치안"),
              buildRatingRow("생활/입지"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // 리뷰 제출 로직
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('다음'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRatingRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label),
          ),
          Expanded(
            flex: 7,
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ),
        ],
      ),
    );
  }
}
