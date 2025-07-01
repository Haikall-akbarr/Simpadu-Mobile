// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import semua halaman yang akan dinavigasi
import 'khs_page.dart';
import 'pengumuman_page.dart';
import 'jadwal_page.dart';
import 'matakuliah_page.dart';
import 'absen_page.dart';
import 'profil_page.dart';

// Import service dan widget yang dibutuhkan
import '../services/pengumuman_service.dart';
import '../widgets/menu_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // State untuk data yang akan dimuat dari API
  String latestNews = 'Memuat pengumuman...';
  bool? isAktif;

  // Warna utama untuk konsistensi tema
  static const Color primaryColor = Color(0xFF0D47A1);

  @override
  void initState() {
    super.initState();
    // Panggil kedua fungsi untuk memuat data saat halaman pertama kali dibuka
    _loadData();
  }

  // Menggabungkan pemanggilan data ke dalam satu fungsi agar lebih rapi
  Future<void> _loadData() async {
    // Memanggil kedua fungsi pemuat data secara bersamaan.
    // Aplikasi tidak akan menunggu salah satu selesai untuk memulai yang lain.
    _loadLatestNews();
    _loadStatusAktif();
  }

  // Fungsi untuk memuat berita/pengumuman terbaru dari service
  Future<void> _loadLatestNews() async {
    try {
      final news = await PengumumanService.fetchLatestPengumuman();
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

  // Fungsi untuk memuat status aktif mahasiswa.
  // DIGANTI DENGAN SIMULASI untuk menghindari error dari file eksternal.
  Future<void> _loadStatusAktif() async {
    try {
      // Simulasi panggilan API dengan jeda 2 detik
      final status = await Future.delayed(const Duration(seconds: 2), () {
        return true; // Asumsikan status mahasiswa selalu aktif untuk demo
      });

      if (mounted) {
        setState(() {
          isAktif = status;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isAktif = null; // Menandakan gagal memuat
        });
      }
    }
  }

  // Fungsi helper untuk navigasi agar kode tidak berulang
  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildPengumumanCard(),
            const SizedBox(height: 24),
            _buildJadwalSection(),
            const SizedBox(height: 24),
            _buildMenuSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 16, 20, 20),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _navigate(context, const ProfilPage()),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/Poliban_logo1.png'),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('M. HAIKAL AKBAR',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17)),
                      Text('Mahasiswa - Teknik Informatika',
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _navigate(context, const PengumumanPage()),
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _statusCard(),
        ],
      ),
    );
  }

  Widget _statusCard() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isAktif == null
              ? Colors.grey.shade400
              : (isAktif! ? Colors.green.shade400 : Colors.red.shade400),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: Text(
          isAktif == null
              ? 'Memuat status UKT...'
              : 'Status UKT: ${isAktif! ? "AKTIF" : "TIDAK AKTIF"}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildPengumumanCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)
            ]),
        child: Row(
          children: [
            Icon(Icons.campaign_outlined, color: Colors.blue.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                latestNews,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalSection() {
    final String tanggalHariIni =
        DateFormat('EEEE, dd MMM', 'id_ID').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Jadwal Hari Ini",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(tanggalHariIni,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          _jadwalCard('Kecerdasan Buatan', '10:30 - 12:10 | H-205'),
          const SizedBox(height: 10),
          _jadwalCard('Metode Numerik', '13:00 - 15:30 | H-103'),
        ],
      ),
    );
  }

  Widget _jadwalCard(String matkul, String detail) {
    return InkWell(
      onTap: () => _navigate(context, const MataKuliahPage()),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 10)
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.class_outlined,
                  color: primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(matkul,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(detail,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Menu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 0),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 1.3,
            children: [
              MenuCard(
                  icon: Icons.assignment_turned_in_outlined,
                  label: 'Absen',
                  onTap: () => _navigate(context, const AbsenPage())),
              MenuCard(
                  icon: Icons.person_outline,
                  label: 'Profil',
                  onTap: () => _navigate(context, const ProfilPage())),
              MenuCard(
                  icon: Icons.school_outlined,
                  label: 'KHS',
                  onTap: () => _navigate(context, const KhsPage())),
              MenuCard(
                  icon: Icons.library_books_outlined,
                  label: 'Mata Kuliah',
                  onTap: () => _navigate(context, const MataKuliahPage())),
            ],
          ),
        ],
      ),
    );
  }
}
