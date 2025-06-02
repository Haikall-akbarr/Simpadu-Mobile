// lib/pages/absen_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Jika Anda memiliki fungsi fetchRekapAbsen di dummy_api.dart dan ingin menggunakannya,
// pastikan untuk mengimpornya. Namun, kode di bawah menggunakan fetchJadwalUntukAbsen.
// import '../services/dummy_api.dart';

class AbsenPage extends StatefulWidget {
  const AbsenPage({super.key});

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  List<dynamic> jadwalUntukAbsenList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchJadwalUntukAbsen();
  }

  Future<void> fetchJadwalUntukAbsen() async {
    // Anda perlu mengganti URL ini dengan API jadwal kuliah Anda yang sebenarnya
    // Endpoint ini harus mengembalikan daftar mata kuliah yang dijadwalkan hari ini
    // atau yang memerlukan input absensi.
    final url = Uri.parse('https://dummyjson.com/products?limit=5&select=title,lecturer,time,room'); // Contoh dummy API
    // Untuk API sebenarnya, contoh: Uri.parse('http://YOUR_API_IP:PORT/api/jadwal-hari-ini');

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Sesuaikan key 'products' dengan key yang benar dari API Anda.
        // API Anda harusnya mengembalikan list jadwal.
        if (data['products'] != null && data['products'] is List) {
          setState(() {
            jadwalUntukAbsenList = data['products'];
            isLoading = false;
          });
        } else {
          throw Exception('Format data jadwal tidak sesuai dari API.');
        }
      } else {
        setState(() {
          errorMessage = 'Gagal memuat jadwal untuk absensi. Status: ${response.statusCode}';
          isLoading = false;
        });
        throw Exception('Gagal memuat jadwal untuk absensi. Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Terjadi kesalahan: $e';
      });
      debugPrint('Error fetching jadwal untuk absen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Absensi Kehadiran'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : jadwalUntukAbsenList.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada jadwal yang memerlukan input absensi saat ini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: jadwalUntukAbsenList.length,
                      itemBuilder: (context, index) {
                        final item = jadwalUntukAbsenList[index];
                        return _buildAbsenCard(item);
                      },
                    ),
    );
  }

  Widget _buildAbsenCard(dynamic item) {
    // Anda perlu menyesuaikan field ini dengan data dari API Anda
    final String namaMatkul = item['title'] ?? 'Nama Mata Kuliah Tidak Tersedia';
    // Contoh data statis untuk waktu, ruang, dan dosen jika tidak ada di API dummy
    final String waktu = item['time'] ?? '08:00 - 09:40'; // Ganti dengan item['waktu_mulai'] - item['waktu_selesai']
    final String ruang = item['room'] ?? 'Ruang A101';     // Ganti dengan item['ruangan']
    final String dosen = item['lecturer'] ?? 'Dr. Dosen Pengampu, M.Kom'; // Ganti dengan item['nama_dosen']

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              namaMatkul,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time_outlined, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$waktu | $ruang',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.person_outline, size: 18, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Dosen: $dosen',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Pilih Status Kehadiran:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[800]),
            ),
            const SizedBox(height: 10),
            Row(
              // Menggunakan MainAxisAlignment.spaceBetween dan SizedBox untuk jarak
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton('Hadir', Colors.green.shade600, item),
                const SizedBox(width: 8), // Jarak antar tombol
                _buildStatusButton('Izin', Colors.orange.shade600, item),
                const SizedBox(width: 8), // Jarak antar tombol
                _buildStatusButton('Sakit', Colors.red.shade600, item),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, Color color, dynamic jadwalItem) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implementasi logika submit absensi ke API
          // Anda akan memerlukan ID jadwal/perkuliahan dan status yang dipilih.
          // Contoh: submitAbsensi(jadwalItem['id_perkuliahan'], label);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Absensi untuk ${jadwalItem['title'] ?? 'Matkul'}: $label berhasil dicatat (simulasi).'),
              backgroundColor: color,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}