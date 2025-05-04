
import 'package:flutter/material.dart';
import '../services/dummy_api.dart';

class MataKuliahPage extends StatelessWidget {
  const MataKuliahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mata Kuliah')),
      body: FutureBuilder<List<String>>(
        future: fetchMataKuliah(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Center(child: Text('Data tidak ditemukan.'));
          final today = 'Pemrograman Mobile';
          final sorted = snapshot.data!..sort((a, b) => a == today ? -1 : 1);
          return ListView(
            children: sorted
                .map((mk) => ListTile(
                      title: Text(mk),
                      leading: Icon(Icons.book, color: mk == today ? Colors.orange : Colors.grey),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
