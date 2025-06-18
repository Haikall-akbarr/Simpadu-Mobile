// lib/admin_prodi/tambah_mahasiswa_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Diperlukan untuk format tanggal
import '../models/mahasiswa_model.dart';
import 'kelola_mahasiswa_page.dart';

class TambahMahasiswaPage extends StatefulWidget {
  // Parameter opsional untuk menampung data mahasiswa yang akan diedit
  final Mahasiswa? mahasiswaToEdit;

  // Constructor untuk menerima parameter
  const TambahMahasiswaPage({super.key, this.mahasiswaToEdit});

  @override
  State<TambahMahasiswaPage> createState() => _TambahMahasiswaPageState();
}

class _TambahMahasiswaPageState extends State<TambahMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  // Semua controller
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  String? _selectedProgramStudi;
  final _dosenPembimbingController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _tahunMasukController = TextEditingController();
  String? _selectedJenisKelamin;
  final _asalController = TextEditingController();
  final _agamaController = TextEditingController();
  final _alamatController = TextEditingController();

  // Opsi dropdown
  final List<String> _programStudiOptions = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Manajemen Informatika',
    'Teknik Mesin',
    'Teknik Elektro',
  ];
  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    // Cek apakah ada data yang dikirim (mode edit)
    if (widget.mahasiswaToEdit != null) {
      _isEditMode = true;
      // Isi semua field form dengan data yang ada
      _nimController.text = widget.mahasiswaToEdit!.nim;
      _namaController.text = widget.mahasiswaToEdit!.nama;
      _tempatLahirController.text = widget.mahasiswaToEdit!.tempatLahir;
      _tanggalLahirController.text = widget.mahasiswaToEdit!.tanggalLahir;
      _selectedProgramStudi = widget.mahasiswaToEdit!.programStudi;
      _dosenPembimbingController.text = widget.mahasiswaToEdit!.dosenPembimbing;
      _emailController.text = widget.mahasiswaToEdit!.email;
      _nomorHpController.text = widget.mahasiswaToEdit!.nomorHp;
      _tahunMasukController.text = widget.mahasiswaToEdit!.tahunMasuk;
      _selectedJenisKelamin = widget.mahasiswaToEdit!.jenisKelamin;
      _asalController.text = widget.mahasiswaToEdit!.asal;
      _agamaController.text = widget.mahasiswaToEdit!.agama;
      _alamatController.text = widget.mahasiswaToEdit!.alamat;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _isEditMode && _tanggalLahirController.text.isNotEmpty
              ? DateTime.tryParse(_tanggalLahirController.text) ??
                  DateTime.now()
              : DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        // Format tanggal menjadi YYYY-MM-DD
        _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final mahasiswaData = Mahasiswa(
        nim: _nimController.text, // NIM tidak diedit, jadi nilainya tetap
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

      if (_isEditMode) {
        // --- LOGIKA UNTUK UPDATE DATA ---
        int index = KelolaMahasiswaPage.daftarMahasiswa.indexWhere(
          (mhs) => mhs.nim == widget.mahasiswaToEdit!.nim,
        );
        if (index != -1) {
          // Tidak perlu setState karena perubahan terjadi pada static list dan
          // refresh akan ditangani oleh halaman sebelumnya setelah pop.
          KelolaMahasiswaPage.daftarMahasiswa[index] = mahasiswaData;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data mahasiswa berhasil diperbarui!')),
        );
      } else {
        // --- LOGIKA UNTUK TAMBAH DATA ---
        KelolaMahasiswaPage.daftarMahasiswa.add(mahasiswaData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data mahasiswa berhasil ditambahkan!')),
        );
      }
      Navigator.pop(context, true); // Kirim 'true' untuk refresh list
    }
  }

  @override
  void dispose() {
    // --- LENGKAPI SEMUA DISPOSE CONTROLLER ---
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Data Mahasiswa' : 'Tambah Mahasiswa Baru',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _isEditMode
                        ? 'Formulir Edit Data'
                        : 'Formulir Pendaftaran Mahasiswa',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildTextField(
                    _nimController,
                    'NIM',
                    prefixIcon: Icons.badge_outlined,
                    readOnly: _isEditMode,
                  ),
                  _buildTextField(
                    _namaController,
                    'Nama',
                    prefixIcon: Icons.person_outline,
                  ),
                  _buildTextField(
                    _tempatLahirController,
                    'Tempat Lahir',
                    prefixIcon: Icons.location_city_outlined,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _tanggalLahirController,
                      decoration: InputDecoration(
                        labelText: 'Tanggal Lahir*',
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Tanggal Lahir tidak boleh kosong'
                                  : null,
                    ),
                  ),
                  _buildDropdownField(
                    _selectedProgramStudi,
                    'Program Studi',
                    _programStudiOptions,
                    (value) {
                      setState(() {
                        _selectedProgramStudi = value;
                      });
                    },
                    prefixIcon: Icons.school_outlined,
                  ),
                  _buildTextField(
                    _dosenPembimbingController,
                    'Dosen Pembimbing',
                    prefixIcon: Icons.supervisor_account_outlined,
                  ),
                  _buildTextField(
                    _emailController,
                    'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildTextField(
                    _nomorHpController,
                    'Nomor HP',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    _tahunMasukController,
                    'Tahun Masuk',
                    prefixIcon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  _buildDropdownField(
                    _selectedJenisKelamin,
                    'Jenis Kelamin',
                    _jenisKelaminOptions,
                    (value) {
                      setState(() {
                        _selectedJenisKelamin = value;
                      });
                    },
                    prefixIcon: Icons.wc_outlined,
                  ),
                  _buildTextField(
                    _asalController,
                    'Asal (Kota/Kab)',
                    prefixIcon: Icons.map_outlined,
                  ),
                  _buildTextField(
                    _agamaController,
                    'Agama',
                    prefixIcon: Icons.mosque_outlined,
                  ),
                  _buildTextField(
                    _alamatController,
                    'Alamat Lengkap',
                    prefixIcon: Icons.home_outlined,
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isEditMode
                              ? Colors.orange.shade700
                              : const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isEditMode ? 'Update Data' : 'Simpan Data',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk TextField
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isRequired = true,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? '*' : ''}',
          filled: true,
          fillColor: readOnly ? Colors.grey[200] : Colors.white,
          prefixIcon:
              prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.grey[600])
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        validator:
            isRequired
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label tidak boleh kosong';
                  }
                  if (label == "Email" &&
                      !RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  if (label == "Nomor HP" &&
                      !RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Nomor HP hanya boleh angka';
                  }
                  return null;
                }
                : null,
      ),
    );
  }

  // LENGKAPI FUNGSI _buildDropdownField
  Widget _buildDropdownField(
    String? currentValue,
    String label,
    List<String> options,
    ValueChanged<String?> onChanged, {
    bool isRequired = true,
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? '*' : ''}',
          prefixIcon:
              prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.grey[600])
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          fillColor: Colors.white,
          filled: true,
        ),
        items:
            options.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
        validator:
            isRequired
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label harus dipilih';
                  }
                  return null;
                }
                : null,
      ),
    );
  }
}
