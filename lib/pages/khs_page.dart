import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KhsPage extends StatefulWidget {
  const KhsPage({super.key});

  @override
  State<KhsPage> createState() => _KhsPageState();
}

class _KhsPageState extends State<KhsPage> {
  List<dynamic> khsList = [];

  Future<void> fetchKhs() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      setState(() {
        khsList = json.decode(response.body);
      });
    } else {
      throw Exception('Gagal memuat data KHS');
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
      body: ListView.builder(
        itemCount: khsList.length,
        itemBuilder: (context, index) {
          final item = khsList[index];
          return ListTile(
            title: Text(item['title']),
            subtitle: Text(item['body']),
          );
        },
      ),
    );
  }
}