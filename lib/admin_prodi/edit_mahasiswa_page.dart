// lib/admin_prodi/edit_mahasiswa_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/mahasiswa_model.dart';
import 'edit_mahasiswa_view.dart';

class EditMahasiswaPage extends StatefulWidget {
  final Mahasiswa? mahasiswaToEdit;
  const EditMahasiswaPage({super.key, this.mahasiswaToEdit});

  @override
  State<EditMahasiswaPage> createState() => _EditMahasiswaPageState();
}

class _EditMahasiswaPageState extends State<EditMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _tahunMasukController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kelasController = TextEditingController();

  int? _selectedJurusanId;
  int? _selectedProdiId;

  List<JurusanOption> _jurusanOptions = [];
  List<ProdiOption> _allProdiOptions = [];
  List<ProdiOption> _filteredProdiOptions = [];

  bool _isDropdownLoading = true;

  int? _selectedJkId;
  int? _selectedAgamaId;
  String? _selectedKabupatenId;
  String? _selectedPegawaiId;

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
      _fillForm(widget.mahasiswaToEdit!);
    }
    _loadDropdownData();
  }

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
    _kelasController.dispose();
    super.dispose();
  }

  Future<void> _loadDropdownData() async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('https://ti054c02.agussbn.my.id/api/data/jurusan')),
        http.get(Uri.parse('https://ti054c02.agussbn.my.id/api/data/prodi')),
      ]);

      if (mounted) {
        if (responses[0].statusCode == 200) {
          final List<dynamic> jurusanJson = json.decode(responses[0].body)['data'];
          setState(() {
            _jurusanOptions = jurusanJson.map((j) => JurusanOption(id: j['id_jurusan'], nama: j['nama_jurusan'])).toList();
          });
        }
        if (responses[1].statusCode == 200) {
          final List<dynamic> prodiJson = json.decode(responses[1].body)['data'];
          setState(() {
             _allProdiOptions = prodiJson.map((p) => ProdiOption(id: p['id_prodi'], nama: '${p['jenjang']} - ${p['nama_prodi']}', idJurusan: p['id_jurusan'])).toList();
          });
        }

        if (_isEditMode && widget.mahasiswaToEdit?.idProdi != null) {
          _setInitialDropdowns();
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat data master: $e')));
    } finally {
      if (mounted) setState(() => _isDropdownLoading = false);
    }
  }

  void _fillForm(Mahasiswa mhs) {
    _nimController.text = mhs.nim;
    _namaController.text = mhs.nama;
    _tempatLahirController.text = mhs.tempatLahir ?? '';
    if (mhs.tanggalLahir != null && mhs.tanggalLahir!.isNotEmpty) {
      _tanggalLahirController.text = mhs.tanggalLahir!.split('T')[0];
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
  
  void _setInitialDropdowns() {
    if (_selectedProdiId == null) return;
    final selectedProdi = _allProdiOptions.firstWhere((p) => p.id == _selectedProdiId, orElse: () => ProdiOption(id: 0, nama: '', idJurusan: 0));
    if (selectedProdi.id != 0) {
      setState(() {
        _selectedJurusanId = selectedProdi.idJurusan;
        _filteredProdiOptions = _allProdiOptions.where((p) => p.idJurusan == _selectedJurusanId).toList();
      });
    }
  }

  void _onJurusanChanged(int? newJurusanId) {
    setState(() {
      _selectedJurusanId = newJurusanId;
      _filteredProdiOptions = _allProdiOptions.where((prodi) => prodi.idJurusan == newJurusanId).toList();
      _selectedProdiId = null; 
    });
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1980), lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
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

  // --- FUNGSI INI SUDAH DILENGKAPI ---
  Future<void> _submitForm() async {
    // 1. Validasi form
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // 2. Kumpulkan data dari form
      final mahasiswaData = Mahasiswa(
        nim: _nimController.text,
        nama: _namaController.text,
        tempatLahir: _tempatLahirController.text,
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
        idKelas: _kelasController.text,
        image: widget.mahasiswaToEdit?.image,
      );

      try {
        http.Response response;
        final requestBody = json.encode(mahasiswaData.toJson());
        final headers = {'Content-Type': 'application/json; charset=UTF-8'};
        
        // 3. Tentukan aksi: edit atau tambah
        if (_isEditMode) {
          // --- Logika UPDATE DATA ---
          final url = Uri.parse('https://ti054c03.agussbn.my.id/api/ubah-mahasiswa/${mahasiswaData.nim}');
          response = await http.put(url, headers: headers, body: requestBody).timeout(const Duration(seconds: 15));
        } else {
          // --- Logika SIMPAN DATA BARU ---
          final url = Uri.parse('https://ti054c03.agussbn.my.id/api/tambah-mahasiswa');
          response = await http.post(url, headers: headers, body: requestBody).timeout(const Duration(seconds: 15));
        }

        // 4. Proses respons dari server
        if (mounted) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            final message = _isEditMode ? 'Data berhasil diperbarui!' : 'Data berhasil ditambahkan!';
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
            Navigator.pop(context, true); // Kembali & refresh
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

  @override
  Widget build(BuildContext context) {
    return EditMahasiswaView(
      formKey: _formKey,
      isEditMode: _isEditMode,
      isLoading: _isLoading,
      isDropdownLoading: _isDropdownLoading,
      nimController: _nimController,
      namaController: _namaController,
      tempatLahirController: _tempatLahirController,
      tanggalLahirController: _tanggalLahirController,
      emailController: _emailController,
      nomorHpController: _nomorHpController,
      tahunMasukController: _tahunMasukController,
      alamatController: _alamatController,
      kelasController: _kelasController,
      jurusanOptions: _jurusanOptions,
      filteredProdiOptions: _filteredProdiOptions,
      jkOptions: _jkOptions,
      agamaOptions: _agamaOptions,
      pegawaiOptions: _pegawaiOptions,
      selectedJurusanId: _selectedJurusanId,
      selectedProdiId: _selectedProdiId,
      selectedJkId: _selectedJkId,
      selectedAgamaId: _selectedAgamaId,
      selectedPegawaiId: _selectedPegawaiId,
      onJurusanChanged: _onJurusanChanged,
      onProdiChanged: (value) => setState(() => _selectedProdiId = value),
      onJkChanged: (value) => setState(() => _selectedJkId = value),
      onAgamaChanged: (value) => setState(() => _selectedAgamaId = value),
      onPegawaiChanged: (value) => setState(() => _selectedPegawaiId = value),
      selectDate: () => _selectDate(context),
      submitForm: _submitForm,
    );
  }
}