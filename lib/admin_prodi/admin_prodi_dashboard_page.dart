// lib/admin_prodi/admin_prodi_dashboard_page.dart
import 'package:flutter/material.dart';
import 'tambah_mahasiswa_page.dart';
import 'kelola_mahasiswa_page.dart';

class AdminProdiDashboardPage extends StatefulWidget {
  const AdminProdiDashboardPage({super.key});

  @override
  State<AdminProdiDashboardPage> createState() => _AdminProdiDashboardPageState();
}

class _AdminProdiDashboardPageState extends State<AdminProdiDashboardPage> {
  // Data dummy
  int totalMahasiswa = 1240;
  int totalProgramStudi = 20;
  int mahasiswaBaru = 156;

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background umum yang lebih lembut
      appBar: AppBar(
        title: const Text('Admin Prodi SIMAK',
            style: TextStyle(
                fontSize: 20, // Sedikit lebih besar untuk AppBar
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1), // Biru tua konsisten
        elevation: 1, // Sedikit shadow
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 26), // Icon sedikit lebih besar
              onPressed: () {
                // TODO: Aksi notifikasi admin
              }),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18, // Sedikit lebih kecil agar pas
                child: Text('AD',
                    style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Efek scroll mobile
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Header Selamat Datang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1), // Warna biru tua
                // borderRadius: const BorderRadius.vertical(
                //   bottom: Radius.circular(24), // Rounded bottom
                // ),
                 boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2)
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang, Admin!', // Lebih personal
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Panel administrasi akademik program studi Anda.',
                    style: TextStyle(
                        fontSize: 15, color: Colors.white.withOpacity(0.85)),
                  ),
                ],
              ),
            ),

            // Bagian Tugas Utama (Menu Aksi)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Text(
                'Tugas Utama',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0), // Memberi sedikit ruang di sisi
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'Tambah Mahasiswa',
                      color: Colors.blue.shade600,
                      onTap: () => _navigateToPage(const TambahMahasiswaPage()),
                    ),
                  ),
                  const SizedBox(width: 12), // Spasi antar kartu
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.people_alt_outlined, // Icon yang lebih umum untuk 'kelola'
                      label: 'Kelola Mahasiswa',
                      color: Colors.green.shade600,
                      onTap: () => _navigateToPage(const KelolaMahasiswaPage()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12), // Spasi sebelum section berikutnya

             // Kartu aksi tambahan jika ada (contoh)
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: _buildActionCard(
            //           context: context,
            //           icon: Icons.settings_outlined,
            //           label: 'Pengaturan Prodi',
            //           color: Colors.orange.shade600,
            //           onTap: () { /* TODO */ },
            //         ),
            //       ),
            //       const SizedBox(width: 12),
            //       Expanded(
            //         child: _buildActionCard( // Kartu kosong atau fitur lain
            //           context: context,
            //           icon: Icons.bar_chart_outlined,
            //           label: 'Laporan',
            //           color: Colors.purple.shade500,
            //           onTap: () { /* TODO */ },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),


            // Bagian Statistik
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
              child: Text(
                'Statistik Akademik',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              ),
            ),
            _buildStatCard(
              title: 'Total Mahasiswa',
              value: totalMahasiswa.toString(),
              change: '+12%',
              changePeriod: 'Dari bulan lalu',
              icon: Icons.groups_outlined,
              iconColor: Colors.blue.shade700,
              context: context,
            ),
            _buildStatCard(
              title: 'Total Program Studi',
              value: totalProgramStudi.toString(),
              change: '+2',
              changePeriod: 'Program studi aktif',
              icon: Icons.school_outlined,
              iconColor: Colors.teal.shade600, // Warna disesuaikan
              context: context,
            ),
            _buildStatCard(
              title: 'Mahasiswa Baru',
              value: mahasiswaBaru.toString(),
              change: '+8%',
              changePeriod: 'Tahun ajaran ini',
              icon: Icons.person_add_outlined,
              iconColor: Colors.amber.shade700, // Warna disesuaikan
              context: context,
            ),
            const SizedBox(height: 24), // Spasi di akhir
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu aksi (mirip MenuCard di dashboard mahasiswa)
  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2.5, // Sedikit lebih tinggi
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias, // Agar InkWell mengikuti shape
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          decoration: BoxDecoration(
             // Anda bisa menggunakan gradient atau warna solid
             gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14, // Ukuran font disesuaikan
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Widget untuk kartu statistik (sedikit direvisi)
  Widget _buildStatCard({
    required String title,
    required String value,
    required String change,
    required String changePeriod,
    required IconData icon,
    required Color iconColor,
    required BuildContext context, // Tambahkan context jika diperlukan untuk theming
  }) {
    bool isPositiveChange = change.startsWith('+');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700], // Warna lebih lembut
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                        fontSize: 26, // Ukuran value lebih menonjol
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1)), // Warna utama
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        change,
                        style: TextStyle(
                            fontSize: 13,
                            color: isPositiveChange
                                ? Colors.green.shade700
                                : Colors.red.shade600,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        changePeriod,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}