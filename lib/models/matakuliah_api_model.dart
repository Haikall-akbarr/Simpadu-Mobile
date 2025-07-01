// lib/models/matakuliah_api_model.dart

// Model ini sekarang menjadi satu-satunya sumber untuk definisi ApiMataKuliah
class ApiMataKuliah {
  final int id;
  final String kodeMk;
  final String namaMk;
  final String kodeProdi;
  final int sks;
  final int semester;
  final String status;
  final String? createdBy;
  final String? tahunAkademik;

  const ApiMataKuliah({
    required this.id,
    required this.kodeMk,
    required this.namaMk,
    required this.kodeProdi,
    required this.sks,
    required this.semester,
    required this.status,
    this.createdBy,
    this.tahunAkademik,
  });

  factory ApiMataKuliah.fromJson(Map<String, dynamic> json) {
    return ApiMataKuliah(
      id: json['id'] ?? 0,
      kodeMk: json['kode_matakuliah'] ?? '',
      namaMk: json['nama_matakuliah'] ?? 'Tanpa Nama',
      kodeProdi: json['kode_prodi'] ?? '',
      sks: json['sks'] ?? 0,
      semester: json['semester'] ?? 0,
      status: json['status'] ?? 'Tidak Aktif',
      createdBy: json['created_by'],
      tahunAkademik: json['kode_tahun_akademik'],
    );
  }
}