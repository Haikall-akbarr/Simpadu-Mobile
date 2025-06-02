  // lib/admin_prodi/detail_mahasiswa_page.dart
  import 'package:flutter/material.dart';
  import '../models/mahasiswa_model.dart';

  class DetailMahasiswaPage extends StatelessWidget {
    final Mahasiswa mahasiswa;

    const DetailMahasiswaPage({super.key, required this.mahasiswa});

    // Perubahan di sini: Hapus const dari TextStyle jika menggunakan Colors.grey[index]
    Widget _buildDetailItem(String label, String value, {IconData? icon}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: Colors.grey[700]), // Ini seharusnya tidak masalah
              const SizedBox(width: 12),
            ] else ...[
              const SizedBox(width: 32), // Untuk alignment jika tidak ada icon
            ],
            Expanded(
              flex: 2,
              child: Text(
                label,
                // HAPUS const dari TextStyle jika ada Colors.grey[800]
                style: TextStyle(fontSize: 15, color: Colors.grey[800], fontWeight: FontWeight.w500),
              ),
            ),
            // HAPUS const dari Text dan TextStyle jika ada Colors.grey[800]
            Text(':  ',
                style: TextStyle(fontSize: 15, color: Colors.grey[800], fontWeight: FontWeight.w500)),
            Expanded(
              flex: 3,
              child: Text(
                value,
                // HAPUS const dari TextStyle jika ada Colors.grey[700] dan menyebabkan masalah
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      String initials = "";
      List<String> nameParts = mahasiswa.nama.split(" ");
      if (nameParts.isNotEmpty) {
        initials += nameParts[0][0];
        if (nameParts.length > 1) {
          initials += nameParts[nameParts.length - 1][0];
        }
      }
      initials = initials.toUpperCase();

      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Detail Mahasiswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF0D47A1),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: Colors.grey[300]!)
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade700,
                      child: Text(
                        initials,
                        style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      mahasiswa.nama,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      mahasiswa.nim,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 10),

                  _buildDetailItem('Nama Lengkap', mahasiswa.nama, icon: Icons.person_outline),
                  _buildDetailItem('NIM', mahasiswa.nim, icon: Icons.badge_outlined),
                  _buildDetailItem('Tempat Lahir', mahasiswa.tempatLahir, icon: Icons.location_city_outlined),
                  _buildDetailItem('Tanggal Lahir', mahasiswa.tanggalLahir, icon: Icons.calendar_today_outlined),
                  _buildDetailItem('Program Studi', mahasiswa.programStudi, icon: Icons.school_outlined),
                  _buildDetailItem('Dosen Pembimbing', mahasiswa.dosenPembimbing, icon: Icons.supervisor_account_outlined),
                  _buildDetailItem('Email', mahasiswa.email, icon: Icons.email_outlined),
                  _buildDetailItem('Nomor HP', mahasiswa.nomorHp, icon: Icons.phone_outlined),
                  // GANTI IKON DI SINI
                  _buildDetailItem('Tahun Masuk', mahasiswa.tahunMasuk, icon: Icons.calendar_today_outlined),
                  _buildDetailItem('Jenis Kelamin', mahasiswa.jenisKelamin, icon: Icons.wc_outlined),
                  _buildDetailItem('Asal', mahasiswa.asal, icon: Icons.map_outlined),
                  _buildDetailItem('Agama', mahasiswa.agama, icon: Icons.mosque_outlined),
                  _buildDetailItem('Alamat', mahasiswa.alamat, icon: Icons.home_outlined),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }