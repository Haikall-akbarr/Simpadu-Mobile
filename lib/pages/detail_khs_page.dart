import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailKhsPage extends StatefulWidget {
  final int mahasiswaId;
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
  List<dynamic> nilaiList = [];

  Future<void> fetchDetailKhs() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.110.81:3000/api/mahasiswa/${widget.mahasiswaId}/khs',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          nilaiList = json.decode(response.body);
        });
      } else {
        throw Exception('Gagal memuat nilai KHS');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDetailKhs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail KHS - ${widget.mahasiswaNama}')),
      body:
          nilaiList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: nilaiList.length,
                itemBuilder: (context, index) {
                  final item = nilaiList[index];
                  return ListTile(
                    title: Text(item['mataKuliah'] ?? 'Matkul Tidak Diketahui'),
                    subtitle: Text('Nilai: ${item['nilai'] ?? '-'}'),
                  );
                },
              ),
    );
  }
}
