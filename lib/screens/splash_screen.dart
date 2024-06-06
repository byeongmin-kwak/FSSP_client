import 'package:flutter/material.dart';
import 'package:FSSP_cilent/widgets/bottom_nav_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        const Duration(milliseconds: 3000), () {}); // 3초 동안 스플래시 화면을 보여줍니다.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const BottomNavWidget(initialIndex: 0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue, // 스플래시 화면의 배경색
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.house_rounded, // 스플래시 화면에 보여줄 아이콘
              color: Colors.white,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              '집사',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
