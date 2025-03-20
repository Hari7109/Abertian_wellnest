import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_list_page.dart';
import 'publisharticlepage.dart';
import 'uploadhealthpage.dart';
import 'doctornotificationpage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor App',
      theme: ThemeData(
        primaryColor: const Color(0xFF4A6FFF),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4A6FFF),
          secondary: Color(0xFF00D8C9),
        ),
        fontFamily: GoogleFonts.poppins().fontFamily,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const DoctorHomePage(),
    );
  }
}

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _selectedIndex = 0;
  String doctorName = "Doctor";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctorData();
  }

  Future<void> _fetchDoctorData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          // Check if user has doctor role
          if (userData['role'] == 'doctor') {
            setState(() {
              doctorName = userData['name'] ?? "Doctor";
              isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 30),

          // Feature Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildFeatureCard(Icons.chat_bubble_rounded, "Students\nChats", 1,
                  const Color(0xFFEDF4FF), const Color(0xFF4A6FFF)),
              _buildFeatureCard(Icons.folder_rounded, "Medical\nRecords", 2,
                  const Color(0xFFE6F9F1), const Color(0xFF00C48C)),
              _buildFeatureCard(Icons.article_rounded, "Publish\nArticles", 3,
                  const Color(0xFFFFF6E9), const Color(0xFFFF9F43)),
              _buildFeatureCard(
                  Icons.notifications_rounded,
                  "Alerts &\nNotifications",
                  4,
                  const Color(0xFFFFEEF0),
                  const Color(0xFFFF5C75)),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              image: const DecorationImage(
                image: AssetImage("assets/doctor_avatar.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back,",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
            color: Colors.grey[700],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String label, int pageIndex,
      Color bgColor, Color iconColor) {
    return GestureDetector(
      onTap: () => _onItemTapped(pageIndex),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Widget> _pages = [
    // Home page content is built dynamically
    const ChatListPage(),
    const UploadHealthPage(),
    const PublishArticlePage(),
    NotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
              title: Text(
                _selectedIndex == 1
                    ? "Chats"
                    : _selectedIndex == 2
                        ? "Records"
                        : _selectedIndex == 3
                            ? "Publish"
                            : "Notifications",
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
      body: _selectedIndex == 0 ? _buildHomePage() : _pages[_selectedIndex - 1],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey[400],
          showUnselectedLabels: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_rounded),
              label: "Records",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_rounded),
              label: "Publish",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: "Alerts",
            ),
          ],
        ),
      ),
    );
  }
}
