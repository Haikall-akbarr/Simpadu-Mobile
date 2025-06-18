// lib/pages/absen_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
    final url = Uri.parse('https://dummyjson.com/products?limit=5&select=title');
    
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] != null && data['products'] is List) {
          setState(() {
            jadwalUntukAbsenList = data['products'];
            isLoading = false;
          });
        } else {
          throw Exception('Format data jadwal tidak sesuai.');
        }
      } else {
        throw Exception('Gagal memuat jadwal. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Absensi Hari Ini'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : jadwalUntukAbsenList.isEmpty
                  ? _buildEmptyWidget()
                  : RefreshIndicator(
                      onRefresh: fetchJadwalUntukAbsen,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: jadwalUntukAbsenList.length,
                        itemBuilder: (context, index) {
                          final item = jadwalUntukAbsenList[index];
                          final bool isActive = (index == 0);
                          return _buildAbsenCard(item, isActive);
                        },
                      ),
                    ),
    );
  }

  Widget _buildErrorWidget() {
    return Center( /* ... Kode sama seperti sebelumnya ... */ );
  }

  Widget _buildEmptyWidget() {
    return Center( /* ... Kode sama seperti sebelumnya ... */ );
  }

  Widget _buildAbsenCard(dynamic item, bool isActive) {
     // ... Kode sama seperti sebelumnya ...
     // Saya akan salin ulang agar lengkap
    final String namaMatkul = item['title'] ?? 'Nama Mata Kuliah Tidak Tersedia';
    final String waktu = item['time'] ?? '10:30 - 12:10';
    final String ruang = item['room'] ?? 'H - 205';
    final String dosen = item['lecturer'] ?? 'Dosen Pengampu';

    final Color titleColor = isActive ? Colors.blue.shade800 : Colors.grey.shade600;
    final Color infoColor = isActive ? Colors.black87 : Colors.grey.shade500;
    final double cardElevation = isActive ? 4.0 : 1.0;

    return Opacity(
      opacity: isActive ? 1.0 : 0.6,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: cardElevation,
        shadowColor: isActive ? Colors.blue.shade100 : Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '● Sedang Berlangsung',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              if (isActive) const SizedBox(height: 12),
              Text(
                namaMatkul,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time_outlined, size: 18, color: infoColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '$waktu | $ruang',
                      style: TextStyle(fontSize: 14, color: infoColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 18, color: infoColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Dosen: $dosen',
                      style: TextStyle(fontSize: 14, color: infoColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isActive)
                Text(
                  'Pilih Status Kehadiran:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                ),
              if (isActive) const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusButton('Hadir', Colors.green, item, isActive),
                  const SizedBox(width: 8),
                  _buildStatusButton('Izin', Colors.orange, item, isActive),
                  const SizedBox(width: 8),
                  _buildStatusButton('Sakit', Colors.red, item, isActive),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- PERUBAHAN UTAMA DI SINI ---
  Widget _buildStatusButton(String label, Color color, dynamic jadwalItem, bool isActive) {
    return Expanded(
      child: ElevatedButton(
        onPressed: isActive
            ? () {
                // Ganti SnackBar dengan memanggil fungsi popup baru
                _showAbsenSuccessPopup(
                  context,
                  label,
                  color,
                  jadwalItem['title'] ?? 'Mata Kuliah ini',
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? color : Colors.grey.shade300,
          foregroundColor: isActive ? Colors.white : Colors.grey.shade500,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }

  // --- FUNGSI BARU UNTUK MENAMPILKAN POPUP ---
  Future<void> _showAbsenSuccessPopup(BuildContext context, String label, Color color, String namaMatkul) async {
    IconData iconData;
    switch (label) {
      case 'Hadir':
        iconData = Icons.check_circle_outline_rounded;
        break;
      case 'Izin':
        iconData = Icons.info_outline_rounded;
        break;
      case 'Sakit':
        iconData = Icons.local_hospital_outlined;
        break;
      default:
        iconData = Icons.check_circle_outline_rounded;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User harus menekan tombol untuk menutup
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Agar ukuran popup sesuai konten
              children: <Widget>[
                Icon(iconData, color: color, size: 70),
                const SizedBox(height: 20),
                const Text(
                  'Absensi Berhasil!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
                    children: <TextSpan>[
                      const TextSpan(text: 'Status Anda sebagai '),
                      TextSpan(
                          text: label,
                          style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                      const TextSpan(text: ' untuk mata kuliah '),
                      TextSpan(
                          text: namaMatkul,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      const TextSpan(text: ' telah berhasil dicatat.'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1), // Warna biru tema
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Menutup popup
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}