
import 'package:flutter/material.dart';
import '../services/dummy_api.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: FutureBuilder<Map<String, String>>(
        future: fetchProfilMahasiswa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Center(child: Text('Gagal memuat profil.'));
          return ListView(
            padding: const EdgeInsets.all(20),
            children: snapshot.data!.entries
                .map((e) => ListTile(
                      title: Text(e.key),
                      subtitle: Text(e.value),
                      leading: const Icon(Icons.person),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
