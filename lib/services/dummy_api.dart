
Future<List<String>> fetchMataKuliah() async {
  await Future.delayed(const Duration(seconds: 1));
  return ['Pemrograman Mobile', 'Jaringan Komputer', 'Statistika', 'Sistem Basis Data'];
}

Future<List<String>> fetchRekapAbsen() async {
  await Future.delayed(const Duration(seconds: 1));
  return ['Hadir - Pemrograman Mobile', 'Hadir - Jaringan Komputer', 'Izin - Statistika'];
}

Future<Map<String, String>> fetchProfilMahasiswa() async {
  await Future.delayed(const Duration(seconds: 1));
  return {
    'Nama': 'M. Haikal Akbar',
    'NIM': 'C030323022',
    'Program Studi': 'Teknik Informatika',
    'Kampus': 'Politeknik Negeri Banjarmasin',
  };
}
