// lib/models/mahasiswa_model.dart

class Mahasiswa {
  String nim;
  String nama;
  String tempatLahir;
  String tanggalLahir; // Sebaiknya gunakan DateTime dan format saat ditampilkan
  String programStudi;
  String dosenPembimbing;
  String email;
  String nomorHp;
  String tahunMasuk;
  String jenisKelamin;
  String asal; // Asal daerah/kota
  String agama;
  String alamat;

  Mahasiswa({
    required this.nim,
    required this.nama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.programStudi,
    required this.dosenPembimbing,
    required this.email,
    required this.nomorHp,
    required this.tahunMasuk,
    required this.jenisKelamin,
    required this.asal,
    required this.agama,
    required this.alamat,
  });
}