import 'package:flutter/material.dart';
// HAPUS CLASS PENGUMUMAN SERVICE YANG LAMA DARI FILE INI

// 1. TAMBAHKAN IMPORT INI
import '../services/pengumuman_service.dart';

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
    // 2. Sekarang ini akan memanggil service yang benar secara otomatis
    final pengumuman = await PengumumanService.fetchLatestPengumuman();
    setState(() {
      _pengumuman = pengumuman;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengumuman')),
      body: Padding( // Tambahkan sedikit padding agar lebih rapi
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text(_pengumuman, textAlign: TextAlign.center)),
      ),
    );
  }
}