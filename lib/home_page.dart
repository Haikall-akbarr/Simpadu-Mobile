import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/absen_page.dart';
import 'pages/matakuliah_page.dart';
import 'pages/profil_page.dart';
import 'pages/scan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    AbsenPage(),
    MataKuliahPage(),
    ProfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _pages[_currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanPage()),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.qr_code_scanner),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: Colors.white,
          elevation: 10,
          child: Container(
            height: 70, // Tinggi cukup agar tidak overflow
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildNavIcon(Icons.home, 0, 'Beranda'),
                    _buildNavIcon(Icons.assignment, 1, 'Absen'),
                  ],
                ),
                Row(
                  children: [
                    _buildNavIcon(Icons.book, 2, 'Mata Kuliah'),
                    _buildNavIcon(Icons.person, 3, 'Profil'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, String label) {
    final isSelected = _currentIndex == index;
    return MaterialButton(
      minWidth: 40,
      onPressed: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
