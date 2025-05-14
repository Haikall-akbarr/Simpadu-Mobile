import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_khs_page.dart';

class KhsPage extends StatefulWidget {
  const KhsPage({super.key});

  @override
  State<KhsPage> createState() => _KhsPageState();
}

class _KhsPageState extends State<KhsPage> {
  List<dynamic> khsList = [];

  Future<void> fetchKhs() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.110.81:3000/api/mahasiswa'),
      );

      if (response.statusCode == 200) {
        setState(() {
          khsList = json.decode(response.body);
        });
      } else {
        throw Exception('Gagal memuat data KHS');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchKhs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KHS Mahasiswa')),
      body: khsList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: khsList.length,
              itemBuilder: (context, index) {
                final item = khsList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        item['nama'] ?? 'Tidak ada nama',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("NIM: ${item['nim'] ?? '-'}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailKhsPage(
                              mahasiswaId: item['id'],      // <-- Pastikan ada 'id' dari API
                              mahasiswaNama: item['nama'] ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
