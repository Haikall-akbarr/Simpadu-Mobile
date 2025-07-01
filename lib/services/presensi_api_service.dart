// lib/services/presensi_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

// Model untuk menampung data status pertemuan
class StatusPertemuan {
  final String status;
  final int pertemuanKe;
  final String kodePertemuan;
  final int sisaWaktu;

  StatusPertemuan({
    required this.status,
    required this.pertemuanKe,
    required this.kodePertemuan,
    required this.sisaWaktu,
  });

  factory StatusPertemuan.fromJson(Map<String, dynamic> json) {
    return StatusPertemuan(
      status: json['status'] ?? 'belum_dibuka',
      pertemuanKe: json['pertemuan_ke'] ?? 0,
      kodePertemuan: json['kode_pertemuan'] ?? '',
      sisaWaktu: json['sisa_waktu'] ?? 0,
    );
  }
}

class PresensiApiService {
  // GANTI dengan URL dasar API Anda
  static const String _baseUrl = 'https://ti054c02.agussbn.my.id'; 

  // --- UNTUK MAHASISWA ---

  // 1. Cek Status Pertemuan
  static Future<StatusPertemuan> cekStatusPertemuan(String kodeMataKuliah) async {
    final url = Uri.parse('$_baseUrl/status-pertemuan/$kodeMataKuliah');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Jika sukses, ubah JSON menjadi object StatusPertemuan
        return StatusPertemuan.fromJson(json.decode(response.body));
      } else {
        // Jika gagal, kembalikan status default
        return StatusPertemuan(status: 'error', pertemuanKe: 0, kodePertemuan: '', sisaWaktu: 0);
      }
    } catch (e) {
      print('Error cek status pertemuan: $e');
      return StatusPertemuan(status: 'error', pertemuanKe: 0, kodePertemuan: '', sisaWaktu: 0);
    }
  }

  // 2. Kirim Absensi
  static Future<bool> kirimAbsensi({
    required String kodePertemuan,
    required String token, // Token JWT mahasiswa
  }) async {
    final url = Uri.parse('$_baseUrl/absen');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Menyertakan token di header
        },
        body: json.encode({'kode_pertemuan': kodePertemuan}),
      );

      if (response.statusCode == 200) {
        print('Absensi berhasil!');
        return true;
      } else {
        print('Gagal Absensi: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error kirim absensi: $e');
      return false;
    }
  }

  // --- UNTUK DOSEN ---

  // 3. Ambil Rekap Absensi
  static Future<Map<String, dynamic>?> getRekapAbsensi({
    required String kodeMataKuliah,
    required String token, // Token JWT Dosen
  }) async {
    final url = Uri.parse('$_baseUrl/rekap-absensi/$kodeMataKuliah');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Gagal mengambil rekap: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error ambil rekap: $e');
      return null;
    }
  }
}
