import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailKhsPage extends StatefulWidget {
  final String mahasiswaId;
  final String mahasiswaNama;

  const DetailKhsPage({
    super.key,
    required this.mahasiswaId,
    required this.mahasiswaNama,
  });

  @override
  State<DetailKhsPage> createState() => _DetailKhsPageState();
}

class _DetailKhsPageState extends State<DetailKhsPage> {
  List<dynamic> matakuliahList = [];

  Future<void> fetchMatakuliah() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.137.226:3000/matakuliah'),
      );

      if (response.statusCode == 200) {
        setState(() {
          matakuliahList = json.decode(response.body);
        });
      } else {
        throw Exception('Gagal memuat data matakuliah');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMatakuliah();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KHS: ${widget.mahasiswaNama}')),
      body: matakuliahList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: matakuliahList.length,
              itemBuilder: (context, index) {
                final item = matakuliahList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item['NAMA_MK'] ?? 'Mata kuliah tidak diketahui'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID MK: ${item['ID_MK'] ?? '-'}'),
                        Text('ID Perkuliahan: ${item['ID_PERKULIAHAN'] ?? '-'}'),
                        Text('ID Pegawai (Dosen): ${item['ID_PEGAWAI'] ?? '-'}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
