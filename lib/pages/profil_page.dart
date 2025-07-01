// lib/pages/profil_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../login_page.dart'; // PERBAIKAN 1: Path import sudah benar

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<Map<String, dynamic>> fetchProfilMahasiswa() async {
    final response = await http
        .get(Uri.parse('https://ti054c03.agussbn.my.id/api/mahasiswa/C030323022'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final Map<String, dynamic> apiData = responseData['data'];
      final Map<String, dynamic> profilLengkap = {
        'nama': apiData['nama'] ?? 'Tanpa Nama',
        'nim': apiData['nim'] ?? '-',
        'email': apiData['email'] ?? '-',
        'telepon': apiData['no_hp'] ?? '-',
        'tempat_lahir': apiData['tempat_lahir'] ?? '-',
        'tanggal_lahir': apiData['tanggal_lahir'] ?? '-',
        'alamat': apiData['alamat'] ?? '-',
        'image': apiData['image'],
        'programStudi': 'Teknik Informatika',
        'semester': '4',
        'tahunMasuk': '2023',
        'dosenWali': 'Agus SBN, S.Kom., M.Kom',
        'jenisKelamin': 'Laki-laki',
        'kabupaten': 'Banjarmasin',
        'provinsi': 'Kalimantan Selatan',
      };
      return profilLengkap;
    } else {
      throw Exception('Gagal memuat profil mahasiswa dari API');
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length > 1 && nameParts.last.isNotEmpty) {
      return nameParts.first[0].toUpperCase() + nameParts.last[0].toUpperCase();
    } else if (nameParts.first.length > 1) {
      return nameParts.first.substring(0, 2).toUpperCase();
    } else {
      return nameParts.first[0].toUpperCase();
    }
  }
  
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(context: context, barrierDismissible: false, builder: (BuildContext context) { return AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), title: const Text('Konfirmasi Logout'), content: const Text('Apakah Anda yakin ingin keluar?'), actions: <Widget>[TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(context).pop()), TextButton(style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Iya, Keluar'), onPressed: () { Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (Route<dynamic> route) => false); })]);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 1.0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfilMahasiswa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat profil: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          final data = snapshot.data!;
          final String nama = data['nama'];
          final String initials = _getInitials(nama);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF6C63FF).withOpacity(0.9),
                  child: Text(initials, style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                Text(nama, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('NIM: ${data['nim']}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                const SizedBox(height: 4),
                Text('${data['programStudi']} - Semester ${data['semester']}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // --- PERBAIKAN 2: Menggunakan parameter bernama ---
                        _buildInfoTile(icon: Icons.email_outlined, label: 'Email', value: data['email']),
                        _buildInfoTile(icon: Icons.phone_outlined, label: 'Telepon', value: data['telepon']),
                        _buildInfoTile(icon: Icons.home_outlined, label: 'Alamat', value: data['alamat']),
                        const Divider(height: 24),
                        _buildInfoTile(icon: Icons.wc_outlined, label: 'Jenis Kelamin', value: data['jenisKelamin']),
                        _buildInfoTile(icon: Icons.person_search_outlined, label: 'Dosen Wali', value: data['dosenWali']),
                        _buildInfoTile(icon: Icons.calendar_today_outlined, label: 'Tahun Masuk', value: data['tahunMasuk']),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () => _showLogoutDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Definisi fungsi helper sudah benar menggunakan parameter bernama
  Widget _buildInfoTile({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade700, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}