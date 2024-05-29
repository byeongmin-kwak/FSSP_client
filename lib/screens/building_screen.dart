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

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedBuildings = prefs.getStringList('likedBuildings');
    if (likedBuildings != null) {
      if (likedBuildings.contains(widget.address)) {
        setState(() {});
      }
    } else {
      await prefs.setStringList('likedBuildings', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
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
    );
  }
}
