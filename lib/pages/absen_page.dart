
import 'package:flutter/material.dart';
import '../services/dummy_api.dart';

class AbsenPage extends StatelessWidget {
  const AbsenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekap Absen')),
      body: FutureBuilder<List<String>>(
        future: fetchRekapAbsen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Center(child: Text('Tidak ada data.'));
          return ListView(
            children: snapshot.data!
                .map((item) => ListTile(leading: const Icon(Icons.check), title: Text(item)))
                .toList(),
          );
        },
      ),
    );
  }
}
