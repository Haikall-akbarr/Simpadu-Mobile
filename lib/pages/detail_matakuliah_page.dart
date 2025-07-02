// lib/pages/detail_matakuliah_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/matakuliah_api_model.dart'; // <<< PERBAIKAN: Impor dari file model yang benar

class DetailMataKuliahPage extends StatefulWidget {
  final String kodeMk;
  const DetailMataKuliahPage({super.key, required this.kodeMk});

  @override
  State<DetailMataKuliahPage> createState() => _DetailMataKuliahPageState();
}

class _DetailMataKuliahPageState extends State<DetailMataKuliahPage> {
  late Future<ApiMataKuliah> _futureDetailMk;

  @override
  void initState() {
    super.initState();
    _futureDetailMk = _fetchDetailMataKuliah();
  }

  Future<ApiMataKuliah> _fetchDetailMataKuliah() async {
    final apiUrl = 'https://ti054c01.agussbn.my.id/matakuliah/${widget.kodeMk}';
    const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiVVNSMDAxIiwiZW1haWwiOiJhZG1pbkB1bml2ZXJzaXR5LmFjLmlkIiwicm9sZSI6ImFkbWluX2FrYWRlbWlrIiwia29kZV9wcm9kaSI6IiIsIm5hbWEiOiJBZG1pbiBBa2FkZW1payIsIm5pcCI6IiIsIm5pbSI6IiIsImV4cCI6MTc1MTM1ODc0MSwibmJmIjoxNzUxMzU1MTQxLCJpYXQiOjE3NTEzNTUxNDF9.P1q3_iHVNiXD_ubS9hTMdS4Yhrn8NhgcTcUv_e78A_s';
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'}).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return ApiMataKuliah.fromJson(responseData['data']);
      } else {
        throw Exception('Gagal memuat detail (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detail Mata Kuliah'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<ApiMataKuliah>(
        future: _futureDetailMk,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          final mk = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(mk),
                const SizedBox(height: 20),
                _buildInfoCard(mk),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(ApiMataKuliah mk) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mk.namaMk, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
            const SizedBox(height: 8),
            Text(mk.kodeMk, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderInfo('SKS', mk.sks.toString()),
                _buildHeaderInfo('Semester', mk.semester.toString()),
                _buildHeaderInfo('Status', mk.status, isStatus: true, statusColor: mk.status == 'Aktif' ? Colors.green : Colors.red),
              ],
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeaderInfo(String label, String value, {bool isStatus = false, Color? statusColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        const SizedBox(height: 4),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor?.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: statusColor)),
          )
        else
          Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoCard(ApiMataKuliah mk) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Informasi Tambahan", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const Divider(height: 20),
            _buildInfoRow(Icons.business_outlined, 'Program Studi', mk.kodeProdi),
            _buildInfoRow(Icons.tag_outlined, 'Tahun Akademik', mk.tahunAkademik ?? '-'),
            _buildInfoRow(Icons.person_outline, 'Dibuat Oleh', mk.createdBy ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 16),
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[800])),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}