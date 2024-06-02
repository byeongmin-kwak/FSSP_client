import 'package:FSSP_cilent/models/building_model.dart';
import 'package:FSSP_cilent/screens/map_screen.dart';
import 'package:FSSP_cilent/services/api_service.dart';
import 'package:FSSP_cilent/widgets/bottom_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuildingScreen extends StatefulWidget {
  final String address;

  const BuildingScreen({super.key, required this.address});

  @override
  State<BuildingScreen> createState() => _BuildingScreenState();
}

class _BuildingScreenState extends State<BuildingScreen> {
  late SharedPreferences prefs;
  bool isLiked = false;
  late Future<BuildingModel> buildingInfo;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedBuildings = prefs.getStringList('likedBuildings');
    if (likedBuildings != null) {
      if (likedBuildings.contains(widget.address)) {
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
    buildingInfo = ApiService.getBuildingInfo(widget.address);
  }

  onHeartTap() async {
    final likedBuildings = prefs.getStringList('likedBuildings');
    if (likedBuildings != null) {
      if (isLiked) {
        likedBuildings.remove(widget.address);
      } else {
        likedBuildings.add(widget.address);
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
              ))
        ],
        title: Text(
          widget.address,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          Text(
            widget.address,
          ),
          ElevatedButton(
            onPressed: () {
              // map_screen으로 이동하기 위해 BottomNavWidget에서 지정된 index 1로 이동하도록 설정
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const BottomNavWidget(initialIndex: 1)),
              );
            },
            child: const Text('리뷰 지도 보기'),
          ),
          FutureBuilder<BuildingModel>(
            future: buildingInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final building = snapshot.data!;
                return Expanded(
                  child: Padding(
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
                        _buildTableRow('지상 층수', '${building.grndFlrCnt}층'),
                        _buildTableRow('지하 층수', '${building.ugrndFlrCnt}층'),
                        _buildTableRow('승강기 수', '${building.rideUseElvtCnt}대'),
                        _buildTableRow('허가일	', building.pmsDay),
                        _buildTableRow('착공일', building.stcnsDay),
                        _buildTableRow('사용승인일', building.useAprDay),
                        _buildTableRow('대지면적(㎡)', '${building.platArea}m²'),
                      ],
                    ),
                  ),
                );
              } else {
                return const Text('No building information available');
              }
            },
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
