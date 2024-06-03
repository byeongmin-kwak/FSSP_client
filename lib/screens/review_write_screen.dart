import 'package:flutter/material.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:FSSP_cilent/widgets/keyword_selector.dart';
import 'package:FSSP_cilent/widgets/rating_row.dart';

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
  final TextEditingController _strengthsController = TextEditingController();
  final TextEditingController _weaknessesController = TextEditingController();

  final List<String> _strengthKeywords = [
    '없음',
    '주차',
    '대중교통',
    '공원산책',
    '치안',
    '경비실',
    '건물관리',
    '분리수거',
    '환기',
    '방음',
    '단열',
    '반려동물 키우기',
    '방충',
    '엘리베이터',
    '조용한 동네',
    '평지',
    '마트 · 편의점',
  ];

  final List<String> _weaknessKeywords = [
    '없음',
    '주차',
    '대중교통',
    '공원산책',
    '치안',
    '경비실',
    '건물관리',
    '분리수거',
    '환기',
    '결로',
    '단열',
    '반려동물 키우기',
    '벌레',
    '층간소음',
    '엘리베이터',
    '동네소음',
    '언덕',
    '마트 · 편의점',
  ];

  final Set<String> _selectedStrengthKeywords = {};
  final Set<String> _selectedWeaknessKeywords = {};

  double _overallRating = 0;
  String _ratingFeedback = '';

  void _onKeywordSelected(
      String keyword, bool selected, Set<String> selectedKeywords) {
    setState(() {
      if (selected) {
        selectedKeywords.add(keyword);
      } else {
        selectedKeywords.remove(keyword);
      }
    });
  }

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
              RatingRow(
                label: "집 내부",
                onRatingUpdate: (rating) {
                  // Handle rating update
                },
              ),
              RatingRow(
                label: "건물/단지",
                onRatingUpdate: (rating) {
                  // Handle rating update
                },
              ),
              RatingRow(
                label: "교통",
                onRatingUpdate: (rating) {
                  // Handle rating update
                },
              ),
              RatingRow(
                label: "치안",
                onRatingUpdate: (rating) {
                  // Handle rating update
                },
              ),
              RatingRow(
                label: "생활/입지",
                onRatingUpdate: (rating) {
                  // Handle rating update
                },
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "장점 (10자 이상)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _strengthsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: '예시) 층간소음 한 번도 겪은 적 없어요! 방음이 좋아요',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              KeywordSelector(
                title: "장점 키워드를 선택해 주세요",
                keywords: _strengthKeywords,
                selectedKeywords: _selectedStrengthKeywords,
                onSelected: (keyword, selected) {
                  _onKeywordSelected(
                      keyword, selected, _selectedStrengthKeywords);
                },
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "단점 (10자 이상)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _weaknessesController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: '예시) 층간소음이 심해요. 대화부터 발소리까지 들려요',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              KeywordSelector(
                title: "단점 키워드를 선택해 주세요",
                keywords: _weaknessKeywords,
                selectedKeywords: _selectedWeaknessKeywords,
                onSelected: (keyword, selected) {
                  _onKeywordSelected(
                      keyword, selected, _selectedWeaknessKeywords);
                },
              ),
              const SizedBox(height: 16),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "이 집의 총 별점은?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: RatingBar.builder(
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _overallRating = rating;
                      if (rating == 5) {
                        _ratingFeedback = "최고에요! 😍";
                      } else if (rating >= 4) {
                        _ratingFeedback = "좋아요 😊";
                      } else if (rating >= 3) {
                        _ratingFeedback = "괜찮아요 🙂";
                      } else if (rating >= 2) {
                        _ratingFeedback = "별로에요 😕";
                      } else {
                        _ratingFeedback = "최악이에요 😡";
                      }
                    });
                  },
                ),
              ),
              Center(
                child: Text(
                  _ratingFeedback,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  '제출하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
