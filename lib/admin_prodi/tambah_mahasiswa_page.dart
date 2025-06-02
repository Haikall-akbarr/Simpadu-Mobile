// lib/admin_prodi/tambah_mahasiswa_page.dart
import 'package:flutter/material.dart';
import '../models/mahasiswa_model.dart'; // <<< PASTIKAN PATH INI BENAR
import 'kelola_mahasiswa_page.dart';

class TambahMahasiswaPage extends StatefulWidget {
  const TambahMahasiswaPage({super.key});

  @override
  State<TambahMahasiswaPage> createState() => _TambahMahasiswaPageState();
}

class _TambahMahasiswaPageState extends State<TambahMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController(); // Akan jadi date picker
  String? _selectedProgramStudi;
  final _dosenPembimbingController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorHpController = TextEditingController();
  // Tambahan untuk detail
  final _tahunMasukController = TextEditingController();
  String? _selectedJenisKelamin;
  final _asalController = TextEditingController();
  final _agamaController = TextEditingController();
  final _alamatController = TextEditingController();


  final List<String> _programStudiOptions = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Manajemen Informatika',
    'Teknik Mesin',
    'Teknik Elektro'
  ]; // Contoh
  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tanggalLahirController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Buat objek Mahasiswa baru
      final mahasiswaBaru = Mahasiswa(
        nim: _nimController.text,
        nama: _namaController.text,
        tempatLahir: _tempatLahirController.text,
        tanggalLahir: _tanggalLahirController.text,
        programStudi: _selectedProgramStudi!,
        dosenPembimbing: _dosenPembimbingController.text,
        email: _emailController.text,
        nomorHp: _nomorHpController.text,
        tahunMasuk: _tahunMasukController.text,
        jenisKelamin: _selectedJenisKelamin!,
        asal: _asalController.text,
        agama: _agamaController.text,
        alamat: _alamatController.text,
      );

      // Tambahkan ke list (dalam aplikasi nyata, ini akan dikirim ke API/database)
      KelolaMahasiswaPage.daftarMahasiswa.add(mahasiswaBaru);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data mahasiswa berhasil ditambahkan!')),
      );
      Navigator.pop(context, true); // Kirim true untuk refresh jika perlu
    }
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _dosenPembimbingController.dispose();
    _emailController.dispose();
    _nomorHpController.dispose();
    _tahunMasukController.dispose();
    _asalController.dispose();
    _agamaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isRequired = true, IconData? prefixIcon, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? '*' : ''}',
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
           fillColor: Colors.white,
           filled: true,
        ),
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          if (label == "Email" && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Masukkan email yang valid';
          }
          if (label == "Nomor HP" && !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Nomor HP hanya boleh angka';
          }
          return null;
        } : null,
      ),
    );
  }

   Widget _buildDropdownField(String? currentValue, String label, List<String> options, ValueChanged<String?> onChanged, {bool isRequired = true, IconData? prefixIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? '*' : ''}',
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return '$label harus dipilih';
          }
          return null;
        } : null,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Warna background seperti di gambar
      appBar: AppBar(
        title: const Text('Tambah Mahasiswa Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 0, // Card tanpa shadow, hanya border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.grey[300]!)
          ),
          color: Colors.white, // Form di dalam card putih
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Form Pendaftaran Mahasiswa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan isi form di bawah ini untuk menambahkan mahasiswa baru.',
                     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),

                  _buildTextField(_nimController, 'NIM', prefixIcon: Icons.badge_outlined, keyboardType: TextInputType.text),
                  _buildTextField(_namaController, 'Nama', prefixIcon: Icons.person_outline),
                  _buildTextField(_tempatLahirController, 'Tempat Lahir', prefixIcon: Icons.location_city_outlined),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _tanggalLahirController,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Lahir*',
                        prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                       validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal Lahir tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildDropdownField(_selectedProgramStudi, 'Program Studi', _programStudiOptions, (value) {
                    setState(() { _selectedProgramStudi = value; });
                  }, prefixIcon: Icons.school_outlined),
                  _buildTextField(_dosenPembimbingController, 'Dosen Pembimbing', prefixIcon: Icons.supervisor_account_outlined),
                  _buildTextField(_emailController, 'Email', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  _buildTextField(_nomorHpController, 'Nomor HP', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                  _buildTextField(_tahunMasukController, 'Tahun Masuk', prefixIcon: Icons.calendar_today_outlined, keyboardType: TextInputType.number),
                  _buildDropdownField(_selectedJenisKelamin, 'Jenis Kelamin', _jenisKelaminOptions, (value) {
                    setState(() { _selectedJenisKelamin = value; });
                  }, prefixIcon: Icons.wc_outlined),
                  _buildTextField(_asalController, 'Asal (Kota/Kab)', prefixIcon: Icons.map_outlined),
                  _buildTextField(_agamaController, 'Agama', prefixIcon: Icons.mosque_outlined), // Ganti icon jika perlu
                  _buildTextField(_alamatController, 'Alamat Lengkap', prefixIcon: Icons.home_outlined),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12)
                    ),
                    child: const Text('Simpan Data Mahasiswa', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}