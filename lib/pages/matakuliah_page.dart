// lib/pages/matakuliah_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'detail_matakuliah_page.dart';
import '../models/matakuliah_api_model.dart'; // <<< Impor dari file model yang benar

// --- SERVICE API ---
Future<List<ApiMataKuliah>> fetchMataKuliahFromApi() async {
  const String apiUrl = 'https://ti054c01.agussbn.my.id/matakuliah';
  const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiVVNSMDAxIiwiZW1haWwiOiJhZG1pbkB1bml2ZXJzaXR5LmFjLmlkIiwicm9sZSI6ImFkbWluX2FrYWRlbWlrIiwia29kZV9wcm9kaSI6IiIsIm5hbWEiOiJBZG1pbiBBa2FkZW1payIsIm5pcCI6IiIsIm5pbSI6IiIsImV4cCI6MTc1MTM1ODc0MSwibmJmIjoxNzUxMzU1MTQxLCJpYXQiOjE3NTEzNTUxNDF9.P1q3_iHVNiXD_ubS9hTMdS4Yhrn8NhgcTcUv_e78A_s';
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'}).timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> dataList = responseData['data'];
      return dataList.map((json) => ApiMataKuliah.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data (Status: ${response.statusCode})');
    }
  } catch (e) {
    throw Exception('Gagal terhubung ke server: $e');
  }
}

// --- UI HALAMAN MATAKULIAH ---
class MataKuliahPage extends StatefulWidget {
  const MataKuliahPage({super.key});
  @override
  State<MataKuliahPage> createState() => _MataKuliahPageState();
}

class _MataKuliahPageState extends State<MataKuliahPage> {
  late Future<List<ApiMataKuliah>> _futureMataKuliah;
  List<ApiMataKuliah> _allMataKuliah = [];
  List<ApiMataKuliah> _filteredMataKuliah = [];
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterData);
  }

  void _loadData() {
    setState(() {
      _futureMataKuliah = fetchMataKuliahFromApi();
    });
  }
  
  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredMataKuliah = List.from(_allMataKuliah);
      } else {
        _filteredMataKuliah = _allMataKuliah.where((mk) {
          return mk.namaMk.toLowerCase().contains(query) || mk.kodeMk.toLowerCase().contains(query);
        }).toList();
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Mata Kuliah'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: FutureBuilder<List<ApiMataKuliah>>(
              future: _futureMataKuliah,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Gagal memuat data: ${snapshot.error}', textAlign: TextAlign.center)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Data mata kuliah tidak ditemukan.'));
                }

                _allMataKuliah = snapshot.data!;
                if (_searchController.text.isEmpty) {
                   _filteredMataKuliah = List.from(_allMataKuliah);
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: _filteredMataKuliah.length,
                    itemBuilder: (context, index) {
                      return _buildMataKuliahCard(_filteredMataKuliah[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: [
          TextField(controller: _searchController, decoration: InputDecoration(hintText: 'Cari mata kuliah...', prefixIcon: Icon(Icons.search, color: Colors.grey[600]), filled: true, fillColor: Colors.grey[100], contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16), border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide.none))),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: _buildFilterButton('Semua', 0)), const SizedBox(width: 12), Expanded(child: _buildFilterButton('Semester Ini', 1))]),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return ElevatedButton(onPressed: () { setState(() => _selectedFilterIndex = index); }, style: ElevatedButton.styleFrom(backgroundColor: isSelected ? const Color(0xFF0D47A1) : Colors.grey[200], foregroundColor: isSelected ? Colors.white : Colors.grey[700], elevation: isSelected ? 2 : 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(text));
  }

  Widget _buildMataKuliahCard(ApiMataKuliah mk) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(6)), child: Text(mk.kodeMk, style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 12))),
                Text('${mk.sks} SKS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700])),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mk.namaMk, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.class_outlined, 'Semester ${mk.semester}'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.tag, 'Prodi: ${mk.kodeProdi}'),
                const SizedBox(height: 16),
                 Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: mk.status == 'Aktif' ? Colors.green.shade100 : Colors.red.shade100, borderRadius: BorderRadius.circular(6)),
                  child: Text('Status: ${mk.status}', style: TextStyle(color: mk.status == 'Aktif' ? Colors.green.shade800 : Colors.red.shade800, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMataKuliahPage(kodeMk: mk.kodeMk)));
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
              ),
              child: Text('Detail Kelas', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) => Row(children: [Icon(icon, size: 18, color: Colors.grey.shade600), const SizedBox(width: 10), Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)))]);
}