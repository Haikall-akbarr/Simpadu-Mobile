// lib/home_page.dart
import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/absen_page.dart';
import 'pages/matakuliah_page.dart';
import 'pages/profil_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai urutan menu
  final List<Widget> _pages = [
    const DashboardPage(),
    const AbsenPage(),
    const MataKuliahPage(),
    const ProfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan berganti sesuai tab yang dipilih
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Menggunakan BottomNavigationBar standar sesuai screenshot
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Agar semua item terlihat
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0D47A1), // Warna item aktif
        unselectedItemColor: Colors.grey[600],    // Warna item tidak aktif
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_outlined),
            activeIcon: Icon(Icons.assignment_turned_in),
            label: 'Absen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Mata Kuliah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}