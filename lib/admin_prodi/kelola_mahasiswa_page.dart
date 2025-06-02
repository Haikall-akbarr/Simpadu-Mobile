// lib/admin_prodi/kelola_mahasiswa_page.dart
import 'package:flutter/material.dart';
import '../models/mahasiswa_model.dart';
import 'detail_mahasiswa_page.dart';
import 'tambah_mahasiswa_page.dart';
// Anda mungkin perlu membuat halaman edit atau memodifikasi TambahMahasiswaPage
// import 'edit_mahasiswa_page.dart';

class KelolaMahasiswaPage extends StatefulWidget {
  const KelolaMahasiswaPage({super.key});

  // Data dummy (akan tetap digunakan untuk contoh ini)
  static List<Mahasiswa> daftarMahasiswa = [
    Mahasiswa(
      nim: 'C030123456',
      nama: 'Budi Santoso',
      tempatLahir: 'Banjarmasin',
      tanggalLahir: '2003-05-12',
      programStudi: 'Teknik Informatika',
      dosenPembimbing: 'Dr. Hendro Wijaya, M.Kom',
      email: 'budi@poliban.ac.id',
      nomorHp: '081234567890',
      tahunMasuk: '2021',
      jenisKelamin: 'Laki-laki',
      asal: 'Banjarmasin',
      agama: 'Islam',
      alamat: 'Jl. Merdeka No. 1',
    ),
    Mahasiswa(
      nim: 'C030654321',
      nama: 'Siti Aminah',
      tempatLahir: 'Martapura',
      tanggalLahir: '2002-08-20',
      programStudi: 'Sistem Informasi',
      dosenPembimbing: 'Prof. Dr. Anisa Rahmawati, M.Sc',
      email: 'siti.a@poliban.ac.id',
      nomorHp: '089876543210',
      tahunMasuk: '2020',
      jenisKelamin: 'Perempuan',
      asal: 'Martapura',
      agama: 'Islam',
      alamat: 'Jl. Pahlawan No. 15',
    ),
     Mahasiswa(
      nim: 'C030320003',
      nama: 'Ahmad Subarjo',
      tempatLahir: 'Pelaihari',
      tanggalLahir: '2001-01-15',
      programStudi: 'Manajemen Informatika',
      dosenPembimbing: 'Dr. Rina Amelia, M.T.',
      email: 'ahmad.s@poliban.ac.id',
      nomorHp: '081122334455',
      tahunMasuk: '2020',
      jenisKelamin: 'Laki-laki',
      asal: 'Pelaihari',
      agama: 'Islam',
      alamat: 'Jl. Angsana No. 10',
    ),
  ];

  @override
  State<KelolaMahasiswaPage> createState() => _KelolaMahasiswaPageState();
}

class _KelolaMahasiswaPageState extends State<KelolaMahasiswaPage> {
  List<Mahasiswa> _filteredMahasiswa = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Urutkan daftar mahasiswa berdasarkan nama secara default
    KelolaMahasiswaPage.daftarMahasiswa.sort((a, b) => a.nama.compareTo(b.nama));
    _filteredMahasiswa = List.from(KelolaMahasiswaPage.daftarMahasiswa);
    _searchController.addListener(_filterMahasiswa);
  }

  void _filterMahasiswa() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMahasiswa = KelolaMahasiswaPage.daftarMahasiswa.where((mhs) {
        return mhs.nim.toLowerCase().contains(query) ||
               mhs.nama.toLowerCase().contains(query) ||
               mhs.programStudi.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _navigateToTambahMahasiswa() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahMahasiswaPage()),
    );
    if (result == true && mounted) {
      setState(() {
        KelolaMahasiswaPage.daftarMahasiswa.sort((a, b) => a.nama.compareTo(b.nama));
        _filterMahasiswa();
      });
    }
  }

  // TODO: Buat halaman EditMahasiswaPage atau modifikasi TambahMahasiswaPage untuk mode edit
  void _navigateToEditMahasiswa(Mahasiswa mahasiswa) async {
    // Contoh navigasi, Anda perlu membuat EditMahasiswaPage
    // atau memodifikasi TambahMahasiswaPage untuk menerima data mahasiswa
    // dan berfungsi dalam mode edit.
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => TambahMahasiswaPage(mahasiswaToEdit: mahasiswa), // Contoh jika TambahMahasiswaPage dimodifikasi
    //   ),
    // );
    // if (result == true && mounted) {
    //   setState(() {
    //     KelolaMahasiswaPage.daftarMahasiswa.sort((a, b) => a.nama.compareTo(b.nama));
    //    _filterMahasiswa();
    //   });
    // }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('TODO: Implementasi edit untuk ${mahasiswa.nama}')),
    );
  }


  void _navigateToDetailMahasiswa(Mahasiswa mahasiswa) {
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailMahasiswaPage(mahasiswa: mahasiswa)),
    );
  }

  void _deleteMahasiswa(Mahasiswa mahasiswa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Hapus Mahasiswa'),
          content: Text('Apakah Anda yakin ingin menghapus data ${mahasiswa.nama} (${mahasiswa.nim})?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              child: const Text('Hapus'),
              onPressed: () {
                if (mounted) {
                  setState(() {
                    KelolaMahasiswaPage.daftarMahasiswa.remove(mahasiswa);
                    _filterMahasiswa();
                  });
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data ${mahasiswa.nama} berhasil dihapus.')));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMahasiswa);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Kelola Data Mahasiswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
        // Tombol tambah mahasiswa sekarang menggunakan FAB
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0), // Lebih rounded
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari NIM, Nama, Program Studi...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              _searchController.clear();
                              // _filterMahasiswa(); // Otomatis ter-trigger oleh listener
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          // List Mahasiswa
          Expanded(
            child: _filteredMahasiswa.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'Belum ada data mahasiswa.'
                          : 'Data tidak ditemukan untuk "${_searchController.text}".',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 80.0), // Padding bawah untuk FAB
                    itemCount: _filteredMahasiswa.length,
                    itemBuilder: (context, index) {
                      final mahasiswa = _filteredMahasiswa[index];
                      return _buildMahasiswaCard(mahasiswa);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToTambahMahasiswa,
        tooltip: 'Tambah Mahasiswa Baru',
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1976D2), // Warna biru yang konsisten
      ),
    );
  }

  Widget _buildMahasiswaCard(Mahasiswa mhs) {
    // Ambil inisial nama
    String initials = "";
    List<String> nameParts = mhs.nama.split(" ");
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0];
      if (nameParts.length > 1 && nameParts[nameParts.length-1].isNotEmpty) {
        initials += nameParts[nameParts.length - 1][0];
      }
    }
    initials = initials.toUpperCase();
    if(initials.length == 1 && mhs.nama.length > 1) { // jika nama cuma 1 kata, ambil 2 huruf pertama
        initials = mhs.nama.substring(0, (mhs.nama.length < 2 ? mhs.nama.length : 2)).toUpperCase();
    }


    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
                  child: Text(
                    initials,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mhs.nama,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mhs.nim,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 6),
            _buildInfoRow(Icons.school_outlined, 'Prodi', mhs.programStudi),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.calendar_today_outlined, 'Tahun Masuk', mhs.tahunMasuk),
            const SizedBox(height: 12),
            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Aksi di sebelah kanan
              children: [
                _actionButton(
                  icon: Icons.visibility_outlined,
                  label: 'Lihat',
                  color: Colors.blue.shade700,
                  onPressed: () => _navigateToDetailMahasiswa(mhs),
                ),
                const SizedBox(width: 8),
                _actionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: Colors.orange.shade700,
                  onPressed: () => _navigateToEditMahasiswa(mhs),
                ),
                const SizedBox(width: 8),
                _actionButton(
                  icon: Icons.delete_outline,
                  label: 'Hapus',
                  color: Colors.red.shade700,
                  onPressed: () => _deleteMahasiswa(mhs),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      icon: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // visualDensity: VisualDensity.compact,
      ),
    );
  }
}