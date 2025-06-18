// lib/pages/khs_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// --- MODEL DATA (Sama seperti sebelumnya) ---
class KhsMataKuliah {
  final String kode;
  final String nama;
  final int sks;
  final String nilai;
  KhsMataKuliah({
    required this.kode,
    required this.nama,
    required this.sks,
    required this.nilai,
  });
  factory KhsMataKuliah.fromJson(Map<String, dynamic> json) => KhsMataKuliah(
    kode: json['kode_mk'],
    nama: json['nama_mk'],
    sks: json['sks'],
    nilai: json['nilai_huruf'],
  );
}

class KhsSemester {
  final String id;
  final String nama;
  final double ipSemester;
  final List<KhsMataKuliah> mataKuliah;
  KhsSemester({
    required this.id,
    required this.nama,
    required this.ipSemester,
    required this.mataKuliah,
  });
  factory KhsSemester.fromJson(Map<String, dynamic> json) {
    var listMk = json['matakuliah'] as List;
    return KhsSemester(
      id: json['id_semester'],
      nama: json['nama_semester'],
      ipSemester: (json['ip_semester'] as num).toDouble(),
      mataKuliah: listMk.map((i) => KhsMataKuliah.fromJson(i)).toList(),
    );
  }
}

class KhsData {
  final int totalSks;
  final double ipk;
  final String predikat;
  final List<KhsSemester> riwayatSemester;
  KhsData({
    required this.totalSks,
    required this.ipk,
    required this.predikat,
    required this.riwayatSemester,
  });
  factory KhsData.fromJson(Map<String, dynamic> json) {
    var listSemester = json['riwayat_semester'] as List;
    return KhsData(
      totalSks: json['total_sks_lulus'],
      ipk: (json['ipk'] as num).toDouble(),
      predikat: json['predikat'],
      riwayatSemester:
          listSemester.map((i) => KhsSemester.fromJson(i)).toList(),
    );
  }
}

// --- SERVICE DATA ---
Future<KhsData> fetchKhsData() async {
  final response = await http.get(
    Uri.parse(
      'https://api.mockfly.dev/mocks/c2e2889f-2f63-4411-a031-62df43a9a114/khs',
    ),
  );
  if (response.statusCode == 200) {
    return KhsData.fromJson(json.decode(response.body));
  } else {
    throw Exception('Gagal memuat data KHS');
  }
}

// --- UI HALAMAN KHS ---
class KhsPage extends StatefulWidget {
  const KhsPage({super.key});
  @override
  State<KhsPage> createState() => _KhsPageState();
}

class _KhsPageState extends State<KhsPage> {
  final Future<KhsData> _futureKhsData = fetchKhsData();
  String? _selectedSemesterId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Kartu Hasil Studi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<KhsData>(
        future: _futureKhsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Data KHS tidak ditemukan.'));
          }

          final khsData = snapshot.data!;
          _selectedSemesterId ??=
              khsData.riwayatSemester.isNotEmpty
                  ? khsData.riwayatSemester.first.id
                  : null;

          final selectedSemesterDetail =
              _selectedSemesterId != null
                  ? khsData.riwayatSemester.firstWhere(
                    (s) => s.id == _selectedSemesterId,
                  )
                  : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kartu Hasil Studi (KHS)',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Lihat hasil studi Anda per semester',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // --- Bagian Ringkasan (IPK, SKS, dll.) ---
                _buildSummaryCard(
                  Icons.summarize_outlined,
                  'Total SKS Lulus',
                  khsData.totalSks.toString(),
                ),
                const SizedBox(height: 12),
                _buildSummaryCard(
                  Icons.trending_up,
                  'IPK',
                  khsData.ipk.toStringAsFixed(2),
                ),
                const SizedBox(height: 12),
                _buildSummaryCard(
                  Icons.military_tech_outlined,
                  'Predikat',
                  khsData.predikat,
                ),
                const SizedBox(height: 20),
                _buildDownloadButton('Unduh Transkrip', () {
                  /* TODO */
                }),

                const Divider(height: 32),

                // --- Bagian Detail per Semester ---
                if (khsData.riwayatSemester.isNotEmpty &&
                    selectedSemesterDetail != null) ...[
                  _buildSemesterDropdown(khsData.riwayatSemester),
                  const SizedBox(height: 20),
                  _buildSemesterDetailCard(selectedSemesterDetail),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // === FUNGSI YANG HILANG SEBELUMNYA DITAMBAHKAN DI SINI ===
  // ==========================================================
  Widget _buildSummaryCard(IconData icon, String label, String value) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget helper lainnya ---

  Widget _buildSemesterDropdown(List<KhsSemester> semesterOptions) {
    return Row(
      children: [
        const Text(
          'Pilih Semester:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedSemesterId,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items:
                semesterOptions.map((semester) {
                  return DropdownMenuItem<String>(
                    value: semester.id,
                    child: Text(semester.nama, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSemesterId = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterDetailCard(KhsSemester semester) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    semester.nama,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'IP Semester: ',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      TextSpan(
                        text: semester.ipSemester.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                _headerText('Kode', 2),
                _headerText('Mata Kuliah', 5),
                _headerText('SKS', 1),
                _headerText('Nilai', 1),
              ],
            ),
          ),
          const Divider(height: 1),
          for (var mk in semester.mataKuliah) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  _bodyText(mk.kode, 2),
                  _bodyText(mk.nama, 5),
                  _bodyText(mk.sks.toString(), 1),
                  _bodyText(mk.nilai, 1, isBold: true),
                ],
              ),
            ),
            if (mk != semester.mataKuliah.last)
              const Divider(height: 1, indent: 16, endIndent: 16),
          ],
          const SizedBox(height: 8),
          _buildDownloadButton('Unduh KHS', () {
            /* TODO */
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _headerText(String text, int flex) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
        fontSize: 13,
      ),
    ),
  );
  Widget _bodyText(String text, int flex, {bool isBold = false}) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
    ),
  );
  Widget _buildDownloadButton(String label, VoidCallback onPressed) => SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.download_outlined, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          foregroundColor: Colors.blue.shade700,
          side: BorderSide(color: Colors.blue.shade700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
  );
}
