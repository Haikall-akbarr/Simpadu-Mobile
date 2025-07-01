// lib/admin_prodi/tambah_mahasiswa_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/mahasiswa_model.dart';

// Kelas helper untuk menampung data dropdown (ID dan Nama)
class DropdownOption {
  final dynamic id;
  final String nama;
  DropdownOption({required this.id, required this.nama});
}

class TambahMahasiswaPage extends StatefulWidget {
  final Mahasiswa? mahasiswaToEdit;
  const TambahMahasiswaPage({super.key, this.mahasiswaToEdit});

  @override
  State<TambahMahasiswaPage> createState() => _TambahMahasiswaPageState();
}

class _TambahMahasiswaPageState extends State<TambahMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _tahunMasukController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kelasController = TextEditingController(); // Tambahan untuk kelas

  // Selected IDs
  int? _selectedProdiId;
  int? _selectedJkId;
  int? _selectedAgamaId;
  String? _selectedKabupatenId;
  String? _selectedPegawaiId;

  // Data statis untuk dropdown (Nantinya ganti dengan API)
  final List<DropdownOption> _prodiOptions = [ DropdownOption(id: 1, nama: 'Teknik Informatika'), DropdownOption(id: 2, nama: 'Sistem Informasi'), ];
  final List<DropdownOption> _jkOptions = [ DropdownOption(id: 1, nama: 'Laki-laki'), DropdownOption(id: 2, nama: 'Perempuan'), ];
  final List<DropdownOption> _agamaOptions = [ DropdownOption(id: 1, nama: 'Islam'), DropdownOption(id: 2, nama: 'Kristen Protestan'), DropdownOption(id: 3, nama: 'Katolik'), DropdownOption(id: 4, nama: 'Hindu'), DropdownOption(id: 5, nama: 'Buddha'), DropdownOption(id: 6, nama: 'Khonghucu'), ];
  final List<DropdownOption> _pegawaiOptions = [ DropdownOption(id: 'DSN005', nama: 'Dr. Agus SBN, M.Kom'), DropdownOption(id: 'DSN006', nama: 'Indah Lestari, M.T.'), ];

  bool _isEditMode = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.mahasiswaToEdit != null) {
      _isEditMode = true;
      final mhs = widget.mahasiswaToEdit!;
      _nimController.text = mhs.nim;
      _namaController.text = mhs.nama;
      _tempatLahirController.text = mhs.tempatLahir ?? '';
      
      // --- PERBAIKAN PENGISIAN TANGGAL LAHIR ---
      if (mhs.tanggalLahir != null && mhs.tanggalLahir!.isNotEmpty) {
        try {
          // Parse dari timestamp dan format ke YYYY-MM-DD
          _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(mhs.tanggalLahir!));
        } catch (e) {
          _tanggalLahirController.text = mhs.tanggalLahir!.split('T')[0]; // fallback
        }
      }

      _emailController.text = mhs.email ?? '';
      _nomorHpController.text = mhs.nomorHp ?? '';
      _tahunMasukController.text = mhs.tahunMasuk ?? '';
      _alamatController.text = mhs.alamatLengkap ?? '';
      _kelasController.text = mhs.idKelas ?? '';

      _selectedProdiId = mhs.idProdi;
      _selectedJkId = mhs.idJk;
      _selectedAgamaId = mhs.idAgama;
      _selectedKabupatenId = mhs.idKabupaten;
      _selectedPegawaiId = mhs.idPegawai;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final mahasiswaData = Mahasiswa(
        nim: _nimController.text,
        nama: _namaController.text,
        tempatLahir: _tempatLahirController.text,
        // Cukup kirim tanggal dari controller, model.toJson() akan menanganinya
        tanggalLahir: _tanggalLahirController.text, 
        email: _emailController.text,
        nomorHp: _nomorHpController.text,
        tahunMasuk: _tahunMasukController.text,
        alamatLengkap: _alamatController.text,
        idProdi: _selectedProdiId,
        idJk: _selectedJkId,
        idAgama: _selectedAgamaId,
        idPegawai: _selectedPegawaiId,
        idKabupaten: _selectedKabupatenId,
        idKelas: _kelasController.text, // Ambil dari controller kelas
        image: widget.mahasiswaToEdit?.image,
      );

      try {
        http.Response response;
        // toJson() dari model akan otomatis memformat body dengan benar
        final requestBody = json.encode(mahasiswaData.toJson());
        final headers = {'Content-Type': 'application/json; charset=UTF-8'};

        if (_isEditMode) {
          final url = Uri.parse('https://ti054c03.agussbn.my.id/api/ubah-mahasiswa/${mahasiswaData.nim}');
          response = await http.put(url, headers: headers, body: requestBody).timeout(const Duration(seconds: 15));
        } else {
          final url = Uri.parse('https://ti054c03.agussbn.my.id/api/tambah-mahasiswa');
          response = await http.post(url, headers: headers, body: requestBody).timeout(const Duration(seconds: 15));
        }

        if (mounted) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            final message = _isEditMode ? 'Data berhasil diperbarui!' : 'Data berhasil ditambahkan!';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
            Navigator.pop(context, true);
          } else {
            final errorData = json.decode(response.body);
            _showErrorDialog('Gagal menyimpan data: ${errorData['message'] ?? response.body}');
          }
        }
      } catch (e) {
        if (mounted) _showErrorDialog('Terjadi kesalahan koneksi: $e');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
  
  void _showErrorDialog(String message) { showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Error'), content: Text(message), actions: [TextButton(child: const Text('OK'), onPressed: () => Navigator.of(context).pop())])); }
  Future<void> _selectDate(BuildContext context) async { final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1980), lastDate: DateTime.now()); if (picked != null) { setState(() { _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked); }); } }
  
  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _emailController.dispose();
    _nomorHpController.dispose();
    _tahunMasukController.dispose();
    _alamatController.dispose();
    _kelasController.dispose(); // jangan lupa dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: Text(_isEditMode ? 'Edit Data Mahasiswa' : 'Tambah Mahasiswa', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: const Color(0xFF0D47A1), iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_isEditMode ? 'Formulir Edit Data' : 'Formulir Pendaftaran', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                  const SizedBox(height: 24),
                  _buildTextField(_nimController, 'NIM', prefixIcon: Icons.badge_outlined, readOnly: _isEditMode),
                  _buildTextField(_namaController, 'Nama Lengkap', prefixIcon: Icons.person_outline),
                  _buildTextField(_tempatLahirController, 'Tempat Lahir', prefixIcon: Icons.location_city_outlined, isRequired: false),
                  Padding(padding: const EdgeInsets.only(bottom: 16.0), child: TextFormField(controller: _tanggalLahirController, decoration: InputDecoration(labelText: 'Tanggal Lahir', prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey[600]), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)), filled: true, fillColor: Colors.white), readOnly: true, onTap: () => _selectDate(context))),
                  _buildDropdown<int>(_selectedProdiId, 'Program Studi', _prodiOptions, (value) { setState(() => _selectedProdiId = value); }),
                  _buildDropdown<String>(_selectedPegawaiId, 'Dosen Pembimbing', _pegawaiOptions, (value) { setState(() => _selectedPegawaiId = value); }, isRequired: false),
                  _buildTextField(_emailController, 'Email', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  _buildTextField(_nomorHpController, 'Nomor HP', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                  _buildTextField(_tahunMasukController, 'Tahun Masuk', prefixIcon: Icons.calendar_view_day, keyboardType: TextInputType.number, isRequired: false),
                  _buildDropdown<int>(_selectedJkId, 'Jenis Kelamin', _jkOptions, (value) { setState(() => _selectedJkId = value); }, isRequired: false),
                  _buildDropdown<int>(_selectedAgamaId, 'Agama', _agamaOptions, (value) { setState(() => _selectedAgamaId = value); }, isRequired: false),
                  // Menambahkan input untuk Kelas dan Kabupaten (jika diperlukan)
                   _buildTextField(_kelasController, 'Kelas', prefixIcon: Icons.class_outlined, isRequired: false),
                  _buildTextField(_alamatController, 'Alamat Lengkap', prefixIcon: Icons.home_outlined, isRequired: false),
                  const SizedBox(height: 24),
                  if (_isLoading) const Center(child: CircularProgressIndicator()) else ElevatedButton(onPressed: _submitForm, style: ElevatedButton.styleFrom(backgroundColor: _isEditMode ? Colors.orange.shade700 : const Color(0xFF1976D2), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(_isEditMode ? 'Update Data' : 'Simpan Data', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isRequired = true, IconData? prefixIcon, TextInputType? keyboardType, bool readOnly = false}) { return Padding(padding: const EdgeInsets.only(bottom: 16.0), child: TextFormField(controller: controller, keyboardType: keyboardType, readOnly: readOnly, decoration: InputDecoration(labelText: '$label${isRequired ? '*' : ''}', filled: true, fillColor: readOnly ? Colors.grey[200] : Colors.white, prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))), validator: isRequired ? (value) { if (value == null || value.isEmpty) return '$label tidak boleh kosong'; if (label == "Email" && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Masukkan email yang valid'; if (label == "Nomor HP" && !RegExp(r'^[0-9]+$').hasMatch(value)) return 'Nomor HP hanya boleh angka'; return null; } : null)); }
  Widget _buildDropdown<T>(T? currentValue, String label, List<DropdownOption> options, ValueChanged<T?> onChanged, {bool isRequired = true, IconData? prefixIcon}) { return Padding(padding: const EdgeInsets.only(bottom: 16.0), child: DropdownButtonFormField<T>(value: currentValue, isExpanded: true, decoration: InputDecoration(labelText: '$label${isRequired ? '*' : ''}', prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)), fillColor: Colors.white, filled: true), hint: const Text('-- Pilih --'), items: options.map((DropdownOption option) => DropdownMenuItem<T>(value: option.id as T, child: Text(option.nama))).toList(), onChanged: onChanged, validator: isRequired ? (value) => (value == null) ? '$label harus dipilih' : null : null)); }
}
