import 'package:FSSP_cilent/models/building_model.dart';
import 'package:FSSP_cilent/models/review_model.dart';
import 'package:FSSP_cilent/screens/map_screen.dart';
import 'package:FSSP_cilent/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BuildingScreen extends StatefulWidget {
  final String address, bcode, jibunAddress, buildingName;

  const BuildingScreen({
    super.key,
    required this.address,
    required this.bcode,
    required this.jibunAddress,
    required this.buildingName,
  });

  @override
  State<BuildingScreen> createState() => _BuildingScreenState();
}

class _BuildingScreenState extends State<BuildingScreen> {
  late SharedPreferences prefs;
  bool isLiked = false;
  late Future<BuildingModel> buildingInfo;
  late Future<List<ReviewModel>> reviews;
  final ScrollController _scrollController = ScrollController();
  bool _isBuildingInfoSelected = true;

  final GlobalKey _buildingInfoKey = GlobalKey();
  final GlobalKey _reviewKey = GlobalKey();

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedBuildings = prefs.getStringList('likedBuildings');
    if (likedBuildings != null) {
      if (likedBuildings.any(
          (element) => json.decode(element)['address'] == widget.address)) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedBuildings', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    buildingInfo = ApiService.getBuildingInfo(
        widget.address, widget.bcode, widget.jibunAddress);
    reviews = ApiService.getReviewsByAddress(widget.address);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final buildingInfoPosition =
        _getPositionOfWidget(_buildingInfoKey.currentContext);
    final reviewPosition = _getPositionOfWidget(_reviewKey.currentContext);

    if (_scrollController.offset >= reviewPosition - 200) {
      setState(() {
        _isBuildingInfoSelected = false;
      });
    } else {
      setState(() {
        _isBuildingInfoSelected = true;
      });
    }
  }

  double _getPositionOfWidget(BuildContext? context) {
    if (context == null) return 0;
    final box = context.findRenderObject() as RenderBox?;
    return box?.localToGlobal(Offset.zero).dy ?? 0;
  }

  void _scrollToSection(bool isBuildingInfo) {
    double offset = isBuildingInfo
        ? _getPositionOfWidget(_buildingInfoKey.currentContext)
        : _getPositionOfWidget(_reviewKey.currentContext);
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  onHeartTap() async {
    final likedBuildings = prefs.getStringList('likedBuildings');
    final buildingData = {
      'address': widget.address,
      'bcode': widget.bcode,
      'jibunAddress': widget.jibunAddress,
      'buildingName': widget.buildingName,
    };
    if (likedBuildings != null) {
      if (isLiked) {
        likedBuildings.removeWhere(
            (element) => json.decode(element)['address'] == widget.address);
      } else {
        likedBuildings.add(json.encode(buildingData));
      }
      await prefs.setStringList('likedBuildings', likedBuildings);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  void navigateToMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );
  }

  double getAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0;
    double sum = 0;
    for (var review in reviews) {
      sum += review.overallRating;
    }
    return sum / reviews.length;
  }

  Widget _buildKeywords(List<String> keywords, Color color) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 4.0,
      children: keywords.map((keyword) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 3),
                blurRadius: 5,
              ),
            ],
          ),
          child: Text(
            keyword,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade400,
        actions: [
          IconButton(
              onPressed: onHeartTap,
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_outline,
                size: 30,
              ))
        ],
        title: Text(
          widget.address,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.address,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.jibunAddress,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<ReviewModel>>(
                      future: reviews,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          double averageRating =
                              getAverageRating(snapshot.data!);
                          return Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 30),
                              const SizedBox(width: 5),
                              Text(
                                averageRating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 28),
                              ),
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: navigateToMapScreen,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.shade50,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, color: Colors.blue, size: 28),
                        SizedBox(width: 10),
                        Text(
                          '지도에서 위치 확인',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _scrollToSection(true),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: _isBuildingInfoSelected
                          ? const LinearGradient(
                              colors: [Colors.blue, Colors.lightBlueAccent],
                            )
                          : LinearGradient(
                              colors: [Colors.grey, Colors.grey.shade300],
                            ),
                    ),
                    child: Center(
                      child: Text(
                        '건물 정보',
                        style: TextStyle(
                          color: _isBuildingInfoSelected
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _scrollToSection(false),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: !_isBuildingInfoSelected
                          ? const LinearGradient(
                              colors: [Colors.blue, Colors.lightBlueAccent],
                            )
                          : LinearGradient(
                              colors: [Colors.grey, Colors.grey.shade300],
                            ),
                    ),
                    child: Center(
                      child: Text(
                        '리뷰',
                        style: TextStyle(
                          color: !_isBuildingInfoSelected
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    key: _buildingInfoKey,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: FutureBuilder<BuildingModel>(
                      future: buildingInfo,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(fontSize: 18),
                          );
                        } else if (snapshot.hasData) {
                          final building = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Table(
                              border: TableBorder.all(color: Colors.black),
                              columnWidths: const <int, TableColumnWidth>{
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(3),
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                _buildTableRow(
                                    '지상 층수', '${building.grndFlrCnt}층'),
                                _buildTableRow(
                                    '지하 층수', '${building.ugrndFlrCnt}층'),
                                _buildTableRow(
                                    '승강기 수', '${building.rideUseElvtCnt}대'),
                                _buildTableRow('허가일', building.pmsDay),
                                _buildTableRow('착공일', building.stcnsDay),
                                _buildTableRow('사용승인일', building.useAprDay),
                                _buildTableRow(
                                    '대지면적(㎡)', '${building.platArea}m²'),
                              ],
                            ),
                          );
                        } else {
                          return const Text('No building information available',
                              style: TextStyle(fontSize: 18));
                        }
                      },
                    ),
                  ),
                  Container(
                    key: _reviewKey,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: FutureBuilder<List<ReviewModel>>(
                      future: reviews,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(fontSize: 18),
                          );
                        } else if (snapshot.hasData) {
                          final reviews = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              final review = reviews[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '거주년도: ${review.residenceYear}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '거주층수: ${review.residenceFloor}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              ...List.generate(
                                                review.overallRating.round(),
                                                (index) => const Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 24,
                                                ),
                                              ),
                                              ...List.generate(
                                                5 -
                                                    review.overallRating
                                                        .round(),
                                                (index) => const Icon(
                                                  Icons.star_border,
                                                  color: Colors.yellow,
                                                  size: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            review.overallRating
                                                .toStringAsFixed(1),
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: '장점: ',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text: review.advantage,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildKeywords(review.advantageKeywords,
                                          Colors.green),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: '단점: ',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text: review.disadvantage,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildKeywords(
                                          review.disadvantageKeywords,
                                          Colors.red),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Text('No reviews available',
                              style: TextStyle(fontSize: 18));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String key, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
