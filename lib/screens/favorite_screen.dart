import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'building_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late SharedPreferences prefs;
  List<Map<String, String>> likedBuildings = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  _loadFavorites() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String>? savedList = prefs.getStringList('likedBuildings');
      likedBuildings = savedList != null
          ? savedList
              .map((e) => Map<String, String>.from(json.decode(e)))
              .toList()
          : [];
    });
  }

  _removeFromFavorites(String address) async {
    likedBuildings.removeWhere((element) => element['address'] == address);
    await prefs.setStringList(
        'likedBuildings', likedBuildings.map((e) => json.encode(e)).toList());
    setState(() {});
  }

  void _navigateToBuildingScreen(Map<String, String> building) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuildingScreen(
          address: building['address']!,
          bcode: building['bcode']!,
          jibunAddress: building['jibunAddress']!,
          buildingName: building['buildingName']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('찜한 건물들'),
        backgroundColor: Colors.blueAccent,
      ),
      body: likedBuildings.isEmpty
          ? const Center(child: Text('찜한 건물이 없습니다.'))
          : ListView.builder(
              itemCount: likedBuildings.length,
              itemBuilder: (context, index) {
                final building = likedBuildings[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.location_city,
                          color: Colors.blueAccent),
                      title: Text(
                        building['address']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(building['buildingName']!),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever,
                            color: Colors.redAccent),
                        onPressed: () =>
                            _removeFromFavorites(building['address']!),
                      ),
                      onTap: () => _navigateToBuildingScreen(building),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: FavoriteScreen()));
}
