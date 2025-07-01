// lib/admin_prodi/detail_mahasiswa_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mahasiswa_model.dart';

class DetailMahasiswaPage extends StatelessWidget {
  final Mahasiswa mahasiswa;

  const DetailMahasiswaPage({super.key, required this.mahasiswa});

  // --- PERBAIKAN DI SINI ---
  String _formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) return 'N/A';
    try {
      // Parse tanggal dari format timestamp dan format ulang
      final DateTime date = DateTime.parse(tanggal);
      // Format ke dalam Bahasa Indonesia
      return DateFormat('d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      // Jika format dari API tidak standar, kembalikan apa adanya
      return tanggal;
    }
  }

  Widget _buildDetailItem(String label, String? value, {IconData? icon}) {
    final displayValue = (value == null || value.isEmpty) ? 'N/A' : value;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 12),
          ] else ...[
            const SizedBox(width: 32),
          ],
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.grey[800], fontWeight: FontWeight.w500),
            ),
          ),
          Text(':  ',
              style: TextStyle(fontSize: 15, color: Colors.grey[800], fontWeight: FontWeight.w500)),
          Expanded(
            flex: 4,
            child: Text(
              displayValue,
              style: TextStyle(fontSize: 15, color: Colors.grey[900]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String initials = "";
    if (mahasiswa.nama.isNotEmpty) {
      List<String> nameParts = mahasiswa.nama.split(" ").where((p) => p.isNotEmpty).toList();
      if (nameParts.isNotEmpty) {
        initials += nameParts[0][0];
        if (nameParts.length > 1) {
          initials += nameParts[nameParts.length - 1][0];
        }
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
                // ... bagian CircleAvatar dan nama tidak berubah ...
                 Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade700,
                    backgroundImage: (mahasiswa.image != null && mahasiswa.image!.isNotEmpty) 
                        ? NetworkImage(mahasiswa.image!) 
                        : null,
                    child: (mahasiswa.image == null || mahasiswa.image!.isEmpty) 
                        ? Text(
                            initials,
                            style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                          )
                        : null,
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
                // --- PERBAIKAN TAMPILAN TANGGAL ---
                _buildDetailItem('Tanggal Lahir', _formatTanggal(mahasiswa.tanggalLahir), icon: Icons.calendar_today_outlined),
                // --- PERBAIKAN TAMPILAN N/A ---
                _buildDetailItem('Jenis Kelamin', mahasiswa.namaJk, icon: Icons.wc_outlined),
                _buildDetailItem('Agama', mahasiswa.namaAgama, icon: Icons.mosque_outlined),
                
                const SizedBox(height: 10),
                Divider(color: Colors.grey[200]),
                const SizedBox(height: 10),

                // --- PERBAIKAN TAMPILAN N/A ---
                _buildDetailItem('Program Studi', mahasiswa.namaProdi, icon: Icons.school_outlined),
                _buildDetailItem('Kelas', mahasiswa.idKelas, icon: Icons.class_outlined),
                _buildDetailItem('Tahun Masuk', mahasiswa.tahunMasuk, icon: Icons.calendar_view_day_rounded),
                _buildDetailItem('Dosen Pembimbing', mahasiswa.namaPegawai, icon: Icons.supervisor_account_outlined),

                const SizedBox(height: 10),
                Divider(color: Colors.grey[200]),
                const SizedBox(height: 10),

                _buildDetailItem('Email', mahasiswa.email, icon: Icons.email_outlined),
                _buildDetailItem('Nomor HP', mahasiswa.nomorHp, icon: Icons.phone_outlined),
                _buildDetailItem('Asal (Kabupaten)', mahasiswa.namaKabupaten, icon: Icons.map_outlined),
                _buildDetailItem('Alamat Lengkap', mahasiswa.alamatLengkap, icon: Icons.home_outlined),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
