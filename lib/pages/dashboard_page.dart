// lib/pages/dashboard_page.dart

import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import 'khs_page.dart';
import 'cetak_krs_page.dart';
import 'pengumuman_page.dart';
import 'jadwal_page.dart';
import 'absen_page.dart';         // PASTIKAN FILE INI ADA DI lib/pages/
import 'matakuliah_page.dart';   // PASTIKAN FILE INI ADA DI lib/pages/
import 'profil_page.dart';       // PASTIKAN FILE INI ADA DI lib/pages/
import '../services/pengumuman_service.dart' as pengumumanService;
import '../services/dummy_api.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String latestNews = 'Memuat pengumuman...';
  bool? isAktif;
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadLatestNews();
    _loadStatusAktif();

    _pages = [
      _buildBerandaContent(),
      const AbsenPage(),        // Pastikan AbsenPage() bisa dipanggil dengan const
      const MataKuliahPage(),   // Pastikan MatakuliahPage() bisa dipanggil dengan const
      const ProfilPage(),       // Pastikan ProfilPage() bisa dipanggil dengan const
    ];
  }

  void _loadLatestNews() async {
    try {
      final news =
          await pengumumanService.PengumumanService.fetchLatestPengumuman();
      if (mounted) {
        setState(() {
          latestNews = news;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          latestNews = 'Gagal memuat pengumuman.';
        });
      }
    }
  }

  void _loadStatusAktif() async {
    try {
      final status = await fetchStatusAktif();
      if (mounted) {
        setState(() {
          isAktif = status;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isAktif = null;
        });
      }
    }
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _jadwalCard(
    BuildContext context,
    String matkul,
    String jam,
    String ruangan,
  ) {
    return InkWell(
      onTap: () => _navigate(context, const JadwalPage()),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF0F2F5),
        ),
        child: Row(
          children: [
            Icon(Icons.class_outlined, color: Colors.blue.shade700),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    matkul,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$jam  |  $ruangan',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCard() {
    if (isAktif == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          "Memuat status UKT...",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAktif! ? Colors.green.shade600 : Colors.red.shade600,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Status UKT: ${isAktif! ? "AKTIF" : "TIDAK AKTIF"}',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _buildBerandaContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.jpg'),
                      radius: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'M. HAIKAL AKBAR',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            'Mahasiswa - Teknik Informatika',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                         _navigate(context, const PengumumanPage());
                      },
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _statusCard(),
                const SizedBox(height: 4),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => _navigate(context, const PengumumanPage()),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDEEFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.campaign_outlined, color: Colors.blue.shade800),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        latestNews,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade900),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Jadwal Hari Ini",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text("Senin, 02 Jun",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _jadwalCard(context, 'Kecerdasan Buatan', '10:30 - 12:10', 'H-205'),
                const SizedBox(height: 8),
                _jadwalCard(context, 'Metode Numerik', '13:00 - 15:30', 'H-103'),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Menu",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.25,
              children: [
                MenuCard(
                  icon: Icons.how_to_reg_outlined,
                  label: 'Absen',
                  onTap: () => _navigate(context, const AbsenPage()), // Pastikan AbsenPage() bisa di-const
                ),
                MenuCard(
                  icon: Icons.school_outlined,
                  label: 'KHS',
                  onTap: () => _navigate(context, const KhsPage()), // Pastikan KhsPage() bisa di-const
                ),
                MenuCard(
                  icon: Icons.print_outlined,
                  label: 'Cetak KRS',
                  onTap: () => _navigate(context, const CetakKrsPage()), // Pastikan CetakKrsPage() bisa di-const
                ),
                // PENYESUAIAN DI SINI:
                MenuCard(
                  icon: Icons.library_books, // Menggunakan ikon alternatif
                  label: 'Mata Kuliah',
                  // Hapus 'const' jika MatakuliahPage tidak memiliki constructor const
                  onTap: () => _navigate(context, MataKuliahPage()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey.shade600,
        selectedFontSize: 12,
        unselectedFontSize: 12,
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