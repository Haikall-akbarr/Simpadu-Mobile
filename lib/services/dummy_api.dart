// lib/services/dummy_api.dart
import 'dart:async';

// 1. Definisikan struktur data baru yang lebih lengkap
class MataKuliah {
  final String kodeMk;
  final String nama;
  final int sks;
  final String dosen;
  final String hari;
  final String waktu;
  final String ruangan;
  final int hadir;
  final int totalPertemuan;
  final String nilai;

  const MataKuliah({
    required this.kodeMk,
    required this.nama,
    required this.sks,
    required this.dosen,
    required this.hari,
    required this.waktu,
    required this.ruangan,
    required this.hadir,
    required this.totalPertemuan,
    required this.nilai,
  });
}

// 2. Fungsi untuk menyediakan data dummy dengan struktur baru
Future<List<MataKuliah>> fetchMataKuliah() async {
  await Future.delayed(const Duration(milliseconds: 800));

  return [
    const MataKuliah(
      kodeMk: 'CSC101',
      nama: 'Pengantar Ilmu Komputer',
      sks: 3,
      dosen: 'Dr. Hendro Wijaya, M.Kom',
      hari: 'Senin',
      waktu: '13:00 - 15:30',
      ruangan: 'Lab Komputer 3',
      hadir: 11,
      totalPertemuan: 12,
      nilai: 'A',
    ),
    const MataKuliah(
      kodeMk: 'CSC201',
      nama: 'Struktur Data dan Algoritma',
      sks: 4,
      dosen: 'Dr. Maya Indira, M.Sc',
      hari: 'Rabu',
      waktu: '08:00 - 10:30',
      ruangan: 'Ruang 2.3',
      hadir: 7,
      totalPertemuan: 8,
      nilai: 'B+',
    ),
    const MataKuliah(
      kodeMk: 'CSC301',
      nama: 'Pemrograman Web',
      sks: 3,
      dosen: 'Prof. Anton Supriadi, Ph.D',
      hari: 'Kamis',
      waktu: '10:00 - 12:30',
      ruangan: 'Lab Multimedia',
      hadir: 10,
      totalPertemuan: 10,
      nilai: 'A-',
    ),
    const MataKuliah(
      kodeMk: 'CSC305',
      nama: 'Basis Data Lanjut',
      sks: 3,
      dosen: 'Rahimi Fitri, S.Kom., M.Kom',
      hari: 'Jumat',
      waktu: '08:00 - 10:30',
      ruangan: 'Lab Database',
      hadir: 14,
      totalPertemuan: 14,
      nilai: 'A',
    ),
  ];
}

// Fungsi-fungsi lain yang mungkin masih Anda perlukan
Future<bool> fetchStatusAktif() async {
  await Future.delayed(const Duration(seconds: 1));
  return true;
}

// Tambahkan fungsi lain dari dummy_api.dart lama Anda di sini jika ada...