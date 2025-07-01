import 'package:flutter/material.dart';
import 'tambah_mahasiswa_page.dart';
import 'kelola_mahasiswa_page.dart';
import 'admin_profil_page.dart'; // Impor halaman profil yang baru

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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Admin Prodi SIMAK',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 1,
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
              onPressed: () {
                // TODO: Aksi notifikasi admin
              }),
          
          // --- PERUBAHAN UTAMA DI SINI ---
          // Tombol avatar sekarang bisa diklik
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: GestureDetector(
              onTap: () {
                _navigateToPage(const AdminProfilPage()); // Navigasi ke halaman profil
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Selamat Datang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))]
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selamat Datang, Admin!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 6),
                  Text('Panel administrasi akademik program studi Anda.', style: TextStyle(fontSize: 15, color: Colors.white70)),
                ],
              ),
            ),

            // Tugas Utama
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Text('Tugas Utama', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'Tambah Mahasiswa',
                      color: Colors.blue.shade600,
                      onTap: () => _navigateToPage(const TambahMahasiswaPage()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.people_alt_outlined,
                      label: 'Kelola Mahasiswa',
                      color: Colors.green.shade600,
                      onTap: () => _navigateToPage(const KelolaMahasiswaPage()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Statistik
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
              child: Text('Statistik Akademik', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            ),
            _buildStatCard(title: 'Total Mahasiswa', value: totalMahasiswa.toString(), change: '+12%', changePeriod: 'Dari bulan lalu', icon: Icons.groups_outlined, iconColor: Colors.blue.shade700),
            _buildStatCard(title: 'Total Program Studi', value: totalProgramStudi.toString(), change: '+2', changePeriod: 'Program studi aktif', icon: Icons.school_outlined, iconColor: Colors.teal.shade600),
            _buildStatCard(title: 'Mahasiswa Baru', value: mahasiswaBaru.toString(), change: '+8%', changePeriod: 'Tahun ajaran ini', icon: Icons.person_add_outlined, iconColor: Colors.amber.shade700),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget-widget helper (tidak ada perubahan)
  Widget _buildActionCard({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 2.5, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(0.8), color], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(height: 12),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          ]),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required String change, required String changePeriod, required IconData icon, required Color iconColor}) {
    bool isPositiveChange = change.startsWith('+');
    return Card(
      elevation: 2, margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 28, color: iconColor)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
            const SizedBox(height: 4),
            Row(children: [
              Text(change, style: TextStyle(fontSize: 13, color: isPositiveChange ? Colors.green.shade700 : Colors.red.shade600, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Text(changePeriod, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ]),
          ])),
        ]),
      ),
    );
  }
}
