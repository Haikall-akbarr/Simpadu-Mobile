// lib/pages/khs_page.dart
import 'package:flutter/material.dart';
import '../services/dummy_api.dart'; // Impor dari dummy_api.dart

// --- MODEL DATA & SERVICE FUNCTION SUDAH ADA DI DUMMY_API.DART ---
// --- TIDAK PERLU DEFINISI ULANG DI SINI ---

// --- UI HALAMAN KHS ---
class KhsPage extends StatefulWidget {
  const KhsPage({super.key});
  @override
  State<KhsPage> createState() => _KhsPageState();
}

class _KhsPageState extends State<KhsPage> {
  late Future<KhsData> _futureKhsData;
  KhsSemester? _selectedSemester; // Gunakan objek utuh untuk state

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureKhsData = fetchKhsData();
      _selectedSemester = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: const BackButton(color: Color.fromARGB(221, 255, 255, 255)), // Tombol kembali yang terlihat
        title: const Text('KHS', style: TextStyle(color: Color.fromARGB(221, 255, 255, 255), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: FutureBuilder<KhsData>(
        future: _futureKhsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.riwayatSemester.isEmpty) {
            return const Center(child: Text('Data KHS tidak ditemukan.'));
          }

          final khsData = snapshot.data!;
          // Set semester terpilih pertama kali jika belum ada
          _selectedSemester ??= khsData.riwayatSemester.last;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Semester', style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 8),
                _buildSemesterDropdown(khsData.riwayatSemester),
                const SizedBox(height: 24),

                if (_selectedSemester != null)
                  _buildSemesterDetailCard(_selectedSemester!),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Widget-widget helper ---

  Widget _buildSemesterDropdown(List<KhsSemester> semesterOptions) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<KhsSemester>(
          value: _selectedSemester,
          isExpanded: true,
          hint: const Text("-- Pilih semester --"),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: semesterOptions.map((semester) {
            return DropdownMenuItem<KhsSemester>(
              value: semester,
              child: Text(semester.nama, style: const TextStyle(fontWeight: FontWeight.w500)),
            );
          }).toList(),
          onChanged: (KhsSemester? newValue) {
            setState(() {
              _selectedSemester = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSemesterDetailCard(KhsSemester semester) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                semester.nama,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Text.rich(
              TextSpan(children: [
                const TextSpan(text: 'IP Semester: ', style: TextStyle(fontSize: 15, color: Colors.grey)),
                TextSpan(text: semester.ipSemester.toStringAsFixed(2), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              // ===============================================
              // === PERBAIKAN UTAMA ADA DI DALAM WIDGET INI ===
              // ===============================================
              _buildCourseTable(semester.mataKuliah),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(child: Text("Hasil Studi ${semester.nama}", style: const TextStyle(color: Colors.grey))),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined, size: 20),
            label: const Text('Unduh PDF'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              foregroundColor: Colors.blue.shade700,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        )
      ],
    );
  }

  // Widget baru untuk membuat tabel agar lebih terstruktur
  Widget _buildCourseTable(List<KhsMataKuliah> mataKuliah) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.0), // Kode
        1: FlexColumnWidth(5.0), // Mata Kuliah
        2: FlexColumnWidth(1.2), // SKS
        3: FlexColumnWidth(1.2), // Nilai
        4: FlexColumnWidth(1.2), // Bobot
      },
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[50]),
          children: [
            _headerCell('Kode'),
            _headerCell('Mata Kuliah'),
            _headerCell('SKS', align: TextAlign.center),
            _headerCell('Nilai', align: TextAlign.center),
            _headerCell('Bobot', align: TextAlign.center),
          ],
        ),
        // Table Rows
        for (var mk in mataKuliah)
          TableRow(
            children: [
              _bodyCell(mk.kode),
              _bodyCell(mk.nama),
              _bodyCell(mk.sks.toString(), align: TextAlign.center),
              _bodyCell(mk.nilai, align: TextAlign.center, isBold: true),
              _bodyCell(mk.bobot, align: TextAlign.center),
            ],
          ),
      ],
    );
  }

  // Widget helper untuk sel header tabel
  Widget _headerCell(String text, {TextAlign align = TextAlign.start}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text(text, textAlign: align, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 13)),
    );
  }

  // Widget helper untuk sel body tabel
  Widget _bodyCell(String text, {TextAlign align = TextAlign.start, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Text(text, textAlign: align, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 13, color: Colors.black87)),
    );
  }
}