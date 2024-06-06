import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late SharedPreferences prefs;
  List<String> likedBuildings = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  _loadFavorites() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      likedBuildings = prefs.getStringList('likedBuildings') ?? [];
    });
  }

  _removeFromFavorites(String address) async {
    likedBuildings.remove(address);
    await prefs.setStringList('likedBuildings', likedBuildings);
    setState(() {});
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
                final address = likedBuildings[index];
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
                        address,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever,
                            color: Colors.redAccent),
                        onPressed: () => _removeFromFavorites(address),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
