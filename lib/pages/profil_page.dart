// lib/pages/profil_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; // Untuk membuat data dummy

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  // Fungsi ini sekarang mengambil data dari API publik dan menyesuaikannya
  Future<Map<String, dynamic>> fetchProfilMahasiswa() async {
    // 1. Mengambil data dari API publik dummyjson.com
    final response = await http.get(
      // Mengambil data user acak antara ID 1 sampai 100
      Uri.parse('https://dummyjson.com/users/${Random().nextInt(99) + 1}'),
    );

    if (response.statusCode == 200) {
      final dataFromApi = json.decode(response.body);

      // 2. Menyesuaikan data dari API ke format yang dibutuhkan oleh UI Anda
      // Beberapa data seperti NIM, Prodi, dll. kita buat dummy karena tidak ada di API.
      final Map<String, dynamic> profilMahasiswa = {
        'name': '${dataFromApi['firstName']} ${dataFromApi['lastName']}',
        'nim': 'C030323${Random().nextInt(99).toString().padLeft(3, '0')}',
        'programStudi': 'Teknik Informatika',
        'semester': Random().nextInt(6) + 2, // Semester acak antara 2 dan 8
        'tahunMasuk': (DateTime.now().year - (Random().nextInt(3) + 1)).toString(), // Tahun masuk acak
        'dosenWali': 'Dr. Dosen Dummy, M.Kom',
        'email': dataFromApi['email'],
        'jenisKelamin': dataFromApi['gender'] == 'male' ? 'Laki-laki' : 'Perempuan',
        'alamat': '${dataFromApi['address']['address']}, ${dataFromApi['address']['city']}',
        'telepon': dataFromApi['phone'],
        // Data ini tidak ada di API, bisa di-hardcode atau dikosongkan
        'kabupaten': dataFromApi['address']['city'],
        'provinsi': dataFromApi['address']['state'],
      };

      return profilMahasiswa;
    } else {
      throw Exception('Gagal memuat profil mahasiswa dari API');
    }
  }

  // Fungsi untuk membuat inisial dari nama
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Latar belakang abu-abu muda
      appBar: AppBar(
        // AppBar yang sudah disederhanakan
        title: const Text('Profil Mahasiswa'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        centerTitle: true, // Judul di tengah
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
          final String nama = data['name'];
          final String initials = _getInitials(nama);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header Profil
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: const Color(0xFF6C63FF).withOpacity(0.9),
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NIM: ${data['nim']}',
                            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${data['programStudi']} - Semester ${data['semester']}',
                            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Tombol Edit Profil
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Aksi untuk edit profil
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('TODO: Buka halaman edit profil.')),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Profil'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: Colors.grey[800],
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Daftar Informasi Detail
                _buildInfoTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Tahun Masuk',
                  value: data['tahunMasuk'],
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.person_search_outlined,
                  label: 'Dosen Wali',
                  value: data['dosenWali'],
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: data['email'],
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Telepon',
                  value: data['telepon'],
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.wc_outlined,
                  label: 'Jenis Kelamin',
                  value: data['jenisKelamin'],
                ),
                const Divider(),
                _buildInfoTile(
                  icon: Icons.home_outlined,
                  label: 'Alamat',
                  value: data['alamat'],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget helper untuk setiap baris info
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
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
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}