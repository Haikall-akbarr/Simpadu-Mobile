// lib/admin_prodi/kelola_mahasiswa_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/mahasiswa_model.dart';
import 'detail_mahasiswa_page.dart';
import 'edit_mahasiswa_page.dart';

class KelolaMahasiswaPage extends StatefulWidget {
  const KelolaMahasiswaPage({super.key});
  @override
  State<KelolaMahasiswaPage> createState() => _KelolaMahasiswaPageState();
}

class _KelolaMahasiswaPageState extends State<KelolaMahasiswaPage> {
  late Future<List<Mahasiswa>> _mahasiswaFuture;
  List<Mahasiswa> _allMahasiswa = [];
  List<Mahasiswa> _filteredMahasiswa = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mahasiswaFuture = _fetchMahasiswa();
    _searchController.addListener(_filterMahasiswa);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_filterMahasiswa);
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Mahasiswa>> _fetchMahasiswa() async {
    final url = Uri.parse('https://ti054c03.agussbn.my.id/api/mahasiswa');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['data'] is List) {
          final List<dynamic> dataList = responseData['data'];
          _allMahasiswa = dataList.map((json) => Mahasiswa.fromJson(json)).toList();
          _allMahasiswa.sort((a, b) => a.nama.compareTo(b.nama));
          _filteredMahasiswa = List.from(_allMahasiswa);
          return _filteredMahasiswa;
        } else {
          throw Exception('Format data API tidak sesuai.');
        }
      } else {
        throw Exception('Gagal memuat data (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  void _refreshData() {
    setState(() {
      _searchController.clear();
      _mahasiswaFuture = _fetchMahasiswa();
    });
  }

  void _filterMahasiswa() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMahasiswa = _allMahasiswa.where((mhs) {
        final namaProdi = mhs.namaProdi?.toLowerCase() ?? '';
        final namaJurusan = mhs.namaJurusan?.toLowerCase() ?? '';

        return mhs.nim.toLowerCase().contains(query) ||
               mhs.nama.toLowerCase().contains(query) ||
               namaProdi.contains(query) ||
               namaJurusan.contains(query);
      }).toList();
    });
  }

  void _navigateToTambahMahasiswa() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditMahasiswaPage()),
    );
    if (result == true && mounted) {
      _refreshData();
    }
  }

  void _navigateToEditMahasiswa(Mahasiswa mahasiswa) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditMahasiswaPage(mahasiswaToEdit: mahasiswa)),
    );
    if (result == true && mounted) {
      _refreshData();
    }
  }

  void _navigateToDetailMahasiswa(Mahasiswa mahasiswa) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailMahasiswaPage(mahasiswa: mahasiswa)),
    );
  }

  Future<void> _deleteMahasiswa(String nim) async {
    final url = Uri.parse('https://ti054c03.agussbn.my.id/api/hapus-mahasiswa/$nim');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil dihapus'), backgroundColor: Colors.green));
        _refreshData();
      } else if (mounted) {
        final errorData = json.decode(response.body);
        _showErrorDialog('Gagal menghapus data. Server: ${errorData['message'] ?? response.body}');
      }
    } catch (e) {
      if (mounted) _showErrorDialog('Terjadi kesalahan koneksi saat menghapus data. Error: $e');
    }
  }

  void _confirmDelete(Mahasiswa mahasiswa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data ${mahasiswa.nama}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMahasiswa(mahasiswa.nim);
              },
            )
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Kelola Mahasiswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari NIM, Nama, Prodi, Jurusan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Mahasiswa>>(
              future: _mahasiswaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Gagal memuat data: ${snapshot.error}', textAlign: TextAlign.center)));
                }
                if (_filteredMahasiswa.isEmpty) {
                  return Center(child: Text(_searchController.text.isEmpty ? 'Data mahasiswa kosong.' : 'Data tidak ditemukan.'));
                }
                return RefreshIndicator(
                  onRefresh: () async => _refreshData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 80.0),
                    itemCount: _filteredMahasiswa.length,
                    itemBuilder: (context, index) => _buildMahasiswaCard(_filteredMahasiswa[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToTambahMahasiswa,
        label: const Text('Tambah'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMahasiswaCard(Mahasiswa mhs) {
    String initials = "";
    if (mhs.nama.isNotEmpty) {
      List<String> nameParts = mhs.nama.split(" ").where((p) => p.isNotEmpty).toList();
      if (nameParts.isNotEmpty) {
        initials += nameParts[0][0];
        if (nameParts.length > 1) {
          initials += nameParts[nameParts.length - 1][0];
        }
      }
    }
    initials = initials.toUpperCase();

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
                  backgroundImage: (mhs.image != null && mhs.image!.isNotEmpty) ? NetworkImage(mhs.image!) : null,
                  child: (mhs.image == null || mhs.image!.isEmpty) ? Text(initials, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark, fontSize: 18)) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mhs.nama, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(mhs.nim, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 6),
            _buildInfoRow(Icons.business_center_outlined, 'Jurusan', mhs.namaJurusan ?? 'N/A'),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.school_outlined, 'Prodi', '${mhs.jenjang ?? ''} - ${mhs.namaProdi ?? 'N/A'}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton(icon: Icons.visibility_outlined, label: 'Lihat', color: Colors.blue.shade700, onPressed: () => _navigateToDetailMahasiswa(mhs)),
                const SizedBox(width: 8),
                _actionButton(icon: Icons.edit_outlined, label: 'Edit', color: Colors.orange.shade700, onPressed: () => _navigateToEditMahasiswa(mhs)),
                const SizedBox(width: 8),
                _actionButton(icon: Icons.delete_outline, label: 'Hapus', color: Colors.red.shade700, onPressed: () => _confirmDelete(mhs)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) => Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[800]), overflow: TextOverflow.ellipsis)),
        ],
      );

  Widget _actionButton({required IconData icon, required String label, required Color color, required VoidCallback onPressed}) => TextButton.icon(
        icon: Icon(icon, size: 18, color: color),
        label: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
}