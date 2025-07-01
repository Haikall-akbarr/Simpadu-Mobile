// lib/services/dummy_api.dart
import 'dart:async';

// --- MODEL DATA UNTUK KHS ---
class KhsMataKuliah {
  final String kode;
  final String nama;
  final int sks;
  final String nilai;
  final String bobot;

  KhsMataKuliah({required this.kode, required this.nama, required this.sks, required this.nilai, required this.bobot});
}

class KhsSemester {
  final String id;
  final String nama;
  final double ipSemester;
  final List<KhsMataKuliah> mataKuliah;

  KhsSemester({required this.id, required this.nama, required this.ipSemester, required this.mataKuliah});
}

class KhsData {
  final int totalSks;
  final double ipk;
  final String predikat;
  final List<KhsSemester> riwayatSemester;

  KhsData({required this.totalSks, required this.ipk, required this.predikat, required this.riwayatSemester});
}


// --- FUNGSI UNTUK MEMBUAT DATA KHS DARI DATA DUMMY ---
Future<KhsData> fetchKhsData() async {
  await Future.delayed(const Duration(milliseconds: 500));

  final List<KhsMataKuliah> semester4Courses = [
    KhsMataKuliah(kode: 'CSC203', nama: 'Arsitektur Komputer', sks: 3, nilai: 'B+', bobot: '3.50'),
    KhsMataKuliah(kode: 'CSC204', nama: 'Basis Data', sks: 4, nilai: 'A', bobot: '4.00'),
    KhsMataKuliah(kode: 'CSC205', nama: 'Pemrograman Berorientasi Objek', sks: 4, nilai: 'A-', bobot: '3.75'),
    KhsMataKuliah(kode: 'MAT202', nama: 'Aljabar Linear', sks: 3, nilai: 'B', bobot: '3.00'),
  ];
  
  final List<KhsMataKuliah> semester3Courses = [
    KhsMataKuliah(kode: 'CSC101', nama: 'Pengantar Ilmu Komputer', sks: 3, nilai: 'A', bobot: '4.00'),
    KhsMataKuliah(kode: 'CSC102', nama: 'Logika Informatika', sks: 3, nilai: 'A', bobot: '4.00'),
  ];

  final semester3 = KhsSemester(id: '20241', nama: 'Semester 3 (Ganjil 2024/2025)', ipSemester: 4.00, mataKuliah: semester3Courses);
  final semester4 = KhsSemester(id: '20242', nama: 'Semester 4 (Genap 2024/2025)', ipSemester: 3.55, mataKuliah: semester4Courses);
  
  return KhsData(
    totalSks: 50,
    ipk: 3.53,
    predikat: 'Cum Laude',
    riwayatSemester: [semester3, semester4],
  );
}

// Fungsi lain yang masih dibutuhkan
Future<bool> fetchStatusAktif() async {
  await Future.delayed(const Duration(seconds: 1));
  return true;
}