// lib/models/mahasiswa_model.dart

class Mahasiswa {
  // Properti utama sesuai dengan kolom tabel di database
  String nim;
  String nama;
  String? tempatLahir;
  String? tanggalLahir; 
  String? email;
  String? nomorHp;
  String? tahunMasuk;
  String? alamatLengkap;
  String? image;

  // Properti untuk relasi (menyimpan ID)
  int? idProdi;
  String? idPegawai;
  int? idJk;
  int? idAgama;
  String? idKabupaten;
  String? idKelas;

  // Properti tambahan untuk menampilkan data di UI (didapat dari JOIN di backend)
  String? namaProdi;
  String? namaPegawai;
  String? namaJk;
  String? namaAgama;
  String? namaKabupaten;

  Mahasiswa({
    required this.nim,
    required this.nama,
    this.tempatLahir,
    this.tanggalLahir,
    this.email,
    this.nomorHp,
    this.tahunMasuk,
    this.alamatLengkap,
    this.image,
    this.idProdi,
    this.idPegawai,
    this.idJk,
    this.idAgama,
    this.idKabupaten,
    this.idKelas,
    this.namaProdi,
    this.namaPegawai,
    this.namaJk,
    this.namaAgama,
    this.namaKabupaten,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    String? safeString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    return Mahasiswa(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      email: json['email'],
      nomorHp: json['nomor_hp'],
      tahunMasuk: safeString(json['tahun_masuk']),
      alamatLengkap: json['alamat_lengkap'],
      image: json['image'],
      idProdi: json['id_prodi'],
      idPegawai: safeString(json['id_pegawai']),
      idJk: json['id_jk'],
      idAgama: json['id_agama'],
      idKabupaten: safeString(json['id_kabupaten']),
      idKelas: safeString(json['id_kelas']),
      namaProdi: json['nama_prodi'],
      namaPegawai: json['nama_pegawai'],
      namaJk: json['nama_jk'],
      namaAgama: json['nama_agama'],
      namaKabupaten: json['nama_kabupaten'],
    );
  }

  // --- PERBAIKAN UTAMA DI SINI ---
  Map<String, dynamic> toJson() {
    String? formattedDate;
    if (tanggalLahir != null && tanggalLahir!.isNotEmpty) {
      try {
        // Ambil hanya bagian tanggalnya saja (YYYY-MM-DD)
        formattedDate = tanggalLahir!.split('T')[0];
      } catch (e) {
        formattedDate = tanggalLahir; // fallback jika format tidak terduga
      }
    }
    
    return {
      'nim': nim,
      'nama': nama,
      'tempat_lahir': tempatLahir,
      // Kirim tanggal yang sudah diformat
      'tanggal_lahir': formattedDate, 
      'id_prodi': idProdi,
      'id_pegawai': idPegawai,
      'email': email,
      'nomor_hp': nomorHp,
      'tahun_masuk': tahunMasuk,
      'id_jk': idJk,
      'id_agama': idAgama,
      'id_kabupaten': idKabupaten,
      'id_kelas': idKelas,
      'alamat_lengkap': alamatLengkap,
      'image': image,
    };
  }
}
