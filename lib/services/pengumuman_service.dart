// lib/services/pengumuman_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class PengumumanService {
  // URL API berita tidak resmi (contoh: CNN Indonesia)
  static const String _newsApiUrl = 'https://api-berita-indonesia.vercel.app/cnn/terbaru/';

  static Future<String> fetchLatestPengumuman() async {
    try {
      final response = await http.get(Uri.parse(_newsApiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // API ini mengembalikan { "data": { "posts": [ ... ] } }
        final List<dynamic> posts = data['data']['posts'];

        if (posts.isNotEmpty) {
          // Mengambil judul dari berita pertama (paling baru)
          return posts[0]['title'] ?? 'Tidak ada judul pengumuman';
        } else {
          return 'Belum ada pengumuman';
        }
      } else {
        return 'Gagal memuat pengumuman (Server Error: ${response.statusCode})';
      }
    } catch (e) {
      return 'Gagal memuat pengumuman. Periksa koneksi internet Anda.';
    }
  }
}