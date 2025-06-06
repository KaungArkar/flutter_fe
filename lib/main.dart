import 'dart:async'; // For Future.delayed
import 'package:flutter/material.dart';

// Import necessary screens.
// If you move ExamTypeScreen and MenuScreen to their own files,
// you'll need to uncomment/add their imports here:
// import 'package:fequiz/examTypeScreen.dart';
// import 'package:fequiz/menuScreen.dart';
import 'package:fequiz/profileScreen.dart'; // Make sure this file exists
import 'package:fequiz/quiz.dart';         // Now imports the unified QuizScreen

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainTabScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0033A0),
      body: Center(
        child: Image.asset(
          'assets/images/quize.png', // Ensure this asset is correctly declared in pubspec.yaml
          width: 240,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  _MainTabScreenState createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  
  // Note: ExamTypeScreen, ProfileScreen, and MenuScreen must exist and be valid widgets.
  // ProfileScreen is imported. ExamTypeScreen and MenuScreen are defined below in this file.
  final List<Widget> _pages = [
    ExamTypeScreen(),
    ProfileScreen(),
    MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ""),
        ],
      ),
    );
  }
}

// --- IMPORTANT: For better project structure, move the following classes
//     into their own separate files (e.g., examTypeScreen.dart, menuScreen.dart,
//     and potentially a utils/clippers.dart for BottomWaveClipper).
//     Then import them at the top of this main.dart file. ---

class ExamTypeScreen extends StatelessWidget {
  const ExamTypeScreen({super.key});

  final List<Map<String, String>> examTypes = const [ // Added const for efficiency
    {'year': '2024', 'month': 'October', 'image': 'assets/images/2024.png'},
    {'year': '2024', 'month': 'April', 'image': 'assets/images/20242.png'},
    {'year': '2023', 'month': 'October', 'image': 'assets/images/2023.png'},
    {'year': '2023', 'month': 'April', 'image': 'assets/images/20232.png'},
    {'year': '2022', 'month': 'October', 'image': 'assets/images/2022.png'},
    {'year': '2022', 'month': 'April', 'image': 'assets/images/20222.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              height: height * 0.35,
              color: Colors.cyan,
            ),
          ),
          const Positioned(
            top: 120,
            left: 24,
            child: Text(
              '試験タイプ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 33,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/images/people.png'), // Ensure asset
              radius: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.27),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: examTypes.map((exam) {
                  return GestureDetector(
                    onTap: () {
                      String title = "${exam['month']} ${exam['year']}";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Using the corrected QuizScreen from quiz.dart
                          builder: (context) => QuizScreen(examTitle: title),
                        ),
                      );
                    },
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      shadowColor: Colors.black26,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              exam['image']!, // Ensure assets
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              exam['month']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              exam['year']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Menu Page", style: TextStyle(fontSize: 24)),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}