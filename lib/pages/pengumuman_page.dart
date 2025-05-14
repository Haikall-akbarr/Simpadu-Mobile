import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PengumumanService {
  static Future<String> fetchLatestPengumuman() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['title'] ?? 'Tidak ada pengumuman';
      } else {
        return 'Belum ada pengumuman';
      }
    } else {
      return 'Gagal memuat pengumuman';
    }
  }
}

class PengumumanPage extends StatefulWidget {
  const PengumumanPage({super.key});

  @override
  State<PengumumanPage> createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  String _pengumuman = 'Memuat pengumuman...';

  @override
  void initState() {
    super.initState();
    _loadPengumuman();
  }

  Future<void> _loadPengumuman() async {
    final pengumuman = await PengumumanService.fetchLatestPengumuman();
    setState(() {
      _pengumuman = pengumuman;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengumuman')),
      body: Center(child: Text(_pengumuman)),
    );
  }
}
