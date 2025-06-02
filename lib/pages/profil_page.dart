import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<Map<String, dynamic>> fetchProfilMahasiswa() async {
    final response = await http.get(
      Uri.parse('http://10.191.241.155:3001/api/students/C030323083'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat profil mahasiswa');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfilMahasiswa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat profil.'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          final data = snapshot.data!;
          final avatarUrl = 'http://10.191.241.155:3001/${data["avatar"]}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Foto Profil
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 16),

                // Nama dan NIM
                Text(
                  data['name'] ?? '-',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'NIM: ${data['nim'] ?? '-'}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Info Lainnya
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _infoRow(Icons.email, 'Email', data['email'] ?? '-'),
                        _infoRow(
                          Icons.school,
                          'Program Studi',
                          data['programStudi'] ?? '-',
                        ),
                        _infoRow(
                          Icons.grade,
                          'Semester',
                          '${data['semester'] ?? '-'}',
                        ),
                        _infoRow(
                          Icons.date_range,
                          'Tahun Masuk',
                          data['tahunMasuk'] ?? '-',
                        ),
                        _infoRow(
                          Icons.person_outline,
                          'Dosen Wali',
                          data['dosenWali'] ?? '-',
                        ),
                        _infoRow(
                          Icons.wc,
                          'Jenis Kelamin',
                          data['jenisKelamin'] == 'L'
                              ? 'Laki-laki'
                              : 'Perempuan',
                        ),
                        _infoRow(Icons.home, 'Alamat', data['alamat'] ?? '-'),
                        _infoRow(
                          Icons.phone,
                          'Telepon',
                          data['telepon'] ?? '-',
                        ),
                        _infoRow(
                          Icons.location_city,
                          'Kabupaten',
                          data['kabupaten'] ?? '-',
                        ),
                        _infoRow(
                          Icons.map,
                          'Provinsi',
                          data['provinsi'] ?? '-',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
