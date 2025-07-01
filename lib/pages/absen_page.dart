// lib/pages/absen_page.dart

import 'package:flutter/material.dart';
import 'dart:async';

// Pastikan Anda mengimpor service API yang sudah kita buat sebelumnya
import '../services/presensi_api_service.dart'; 

class AbsenPage extends StatefulWidget {
  const AbsenPage({super.key});

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  // State untuk mengelola timer dan status pertemuan
  Timer? _timer;
  StatusPertemuan? _pertemuanAktif;
  
  // State untuk UI
  bool _isLoading = true;
  String _statusMessage = 'Mencari kelas yang aktif...';
  bool _sudahAbsen = false; // Flag untuk menandakan jika user sudah berhasil absen

  // --- DATA PENTING ---
  // Kode mata kuliah ini harusnya didapat secara dinamis, misal dari jadwal.
  // Untuk sekarang kita hardcode.
  final String _kodeMataKuliah = 'PTI101'; 
  
  // Token JWT mahasiswa, didapat setelah login.
  // TOKEN SUDAH DIPERBARUI SESUAI PERMINTAAN ANDA.
  final String _tokenMahasiswa = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiVVNSMDAxIiwiZW1haWwiOiJhZG1pbkB1bml2ZXJzaXR5LmFjLmlkIiwicm9sZSI6ImFkbWluX2FrYWRlbWlrIiwia29kZV9wcm9kaSI6IiIsIm5hbWEiOiJBZG1pbiBBa2FkZW1payIsIm5pcCI6IiIsIm5pbSI6IiIsImV4cCI6MTc1MTMzMzMzMSwibmJmIjoxNzUxMzI5NzMxLCJpYXQiOjE3NTEzMjk3MzF9.7UL6h3sskbAn0cowR-zQh4gl7JWBvykgU3_V6LuvmJw';

  @override
  void initState() {
    super.initState();
    // Mulai memeriksa status pertemuan setiap 15 detik
    _startPeriodicCheck();
  }

  @override
  void dispose() {
    // Selalu batalkan timer saat halaman ditutup untuk menghindari memory leak
    _timer?.cancel();
    super.dispose();
  }

  void _startPeriodicCheck() {
    _isLoading = true; // Tampilkan loading indicator saat pertama kali masuk
    // Timer akan memanggil fungsi _cekStatus secara periodik
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!_sudahAbsen) { // Hanya cek jika belum absen
         _cekStatus();
      }
    });
    // Panggil sekali di awal tanpa menunggu timer
    _cekStatus();
  }

  Future<void> _cekStatus() async {
    if (!mounted) return;

    try {
      final status = await PresensiApiService.cekStatusPertemuan(_kodeMataKuliah);
      if (mounted) {
        setState(() {
          if (status.status == 'dibuka') {
            _pertemuanAktif = status;
            _statusMessage = 'Kelas ditemukan!';
          } else {
            _pertemuanAktif = null; // Tidak ada kelas yang aktif
            _statusMessage = 'Saat ini tidak ada sesi kelas yang dibuka.\nMenunggu dosen memulai sesi...';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _pertemuanAktif = null;
          _statusMessage = 'Gagal terhubung ke server. Memeriksa kembali...';
        });
      }
    }
  }

  Future<void> _handleAbsen() async {
    if (_pertemuanAktif == null) return;
    if (_sudahAbsen) {
      _showInfoPopup('Anda sudah melakukan absensi untuk sesi ini.');
      return;
    }

    setState(() => _isLoading = true); // Tampilkan loading saat proses absen

    final berhasil = await PresensiApiService.kirimAbsensi(
      kodePertemuan: _pertemuanAktif!.kodePertemuan,
      token: _tokenMahasiswa,
    );
    
    if (mounted) {
      if (berhasil) {
        setState(() {
          _sudahAbsen = true;
          _isLoading = false;
        });
        _showAbsenSuccessPopup();
      } else {
        setState(() => _isLoading = false);
        _showInfoPopup('Gagal melakukan absensi. Pastikan Token JWT valid dan coba lagi.');
      }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cekStatus,
              child: _pertemuanAktif != null && !_sudahAbsen
                  ? ListView( // Gunakan ListView agar bisa di-refresh
                      padding: const EdgeInsets.all(16.0),
                      children: [_buildAbsenCard(_pertemuanAktif!)],
                    )
                  : _buildStatusMessage(),
            ),
    );
  }

  Widget _buildStatusMessage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _sudahAbsen ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                      size: 80,
                      color: _sudahAbsen ? Colors.green : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _sudahAbsen ? 'Absensi Berhasil Dicatat!' : _statusMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.black54, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAbsenCard(StatusPertemuan item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4.0,
      shadowColor: Colors.blue.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, color: Colors.green, size: 12),
                  const SizedBox(width: 6),
                  const Text(
                    'Sedang Berlangsung',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pertemuan ke-${item.pertemuanKe}', // Judul dari data API
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time_filled, size: 18, color: Colors.black87),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Sisa Waktu: ${(item.sisaWaktu / 60).floor()} menit', // Info dari data API
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Silakan lakukan absensi dengan menekan tombol di bawah:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.touch_app_rounded),
                label: const Text('Lakukan Absensi (Hadir)'),
                onPressed: _handleAbsen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
             // Tombol Izin dan Sakit kita nonaktifkan karena API hanya mendukung "Hadir"
            const Row(
              children: [
                Expanded(child: AbsenButtonDisabled(label: 'Izin')),
                SizedBox(width: 8),
                Expanded(child: AbsenButtonDisabled(label: 'Sakit')),
              ],
            )
          ],
        ),
      ),
    );
  }
  
  // Fungsi-fungsi untuk menampilkan popup
  Future<void> _showAbsenSuccessPopup() async {
     // Implementasi popup sukses Anda bisa ditaruh di sini
     // Saya akan menggunakan dialog sederhana sebagai contoh
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Absensi Berhasil'),
        content: const Text('Kehadiran Anda telah berhasil dicatat oleh sistem.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _showInfoPopup(String message) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Informasi'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }
}

// Widget helper untuk tombol yang dinonaktifkan
class AbsenButtonDisabled extends StatelessWidget {
  final String label;
  const AbsenButtonDisabled({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null, // null onPressed akan menonaktifkan tombol
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade300,
        foregroundColor: Colors.grey.shade500,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}
