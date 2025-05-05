import 'dart:convert';
import 'package:http/http.dart' as http;

class PengumumanService {
  static Future<String> fetchLatestPengumuman() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['title'] ?? 'Tidak ada pengumuman';
      } else {
        return 'Belum ada pengumuman';
      }
    } else {
      return 'Gagal memuat pengumun';
    }
  }
}
