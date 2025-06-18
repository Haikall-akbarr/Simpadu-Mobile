// lib/home_page.dart
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

  final List<Widget> _pages = [
    const DashboardPage(),
    const AbsenPage(),
    const MataKuliahPage(), // Nama kelas sudah benar
    const ProfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  Future<bool> _onWillPop() {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope( // Menggunakan PopScope yang baru
      canPop: _currentIndex == 0,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _onWillPop();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanPage()),
            );
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.qr_code_scanner),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: Colors.white,
          elevation: 10.0,
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavIcon(icon: Icons.home_filled, index: 0, label: 'Beranda'),
                  _buildNavIcon(icon: Icons.assignment_turned_in, index: 1, label: 'Absen'),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavIcon(icon: Icons.menu_book, index: 2, label: 'Mata Kuliah'),
                  _buildNavIcon(icon: Icons.person, index: 3, label: 'Profil'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon({required IconData icon, required int index, required String label}) {
    final bool isSelected = (_currentIndex == index);
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey[600],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}