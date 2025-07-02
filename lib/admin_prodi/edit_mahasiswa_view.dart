// lib/admin_prodi/edit_mahasiswa_view.dart

import 'package:flutter/material.dart';

// Model untuk dropdown
class JurusanOption {
  final int id;
  final String nama;
  JurusanOption({required this.id, required this.nama});
}

class ProdiOption {
  final int id;
  final String nama;
  final int idJurusan;
  ProdiOption({required this.id, required this.nama, required this.idJurusan});
}

class DropdownOption {
  final dynamic id;
  final String nama;
  DropdownOption({required this.id, required this.nama});
}

class EditMahasiswaView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isEditMode;
  final bool isLoading;
  final bool isDropdownLoading;
  final TextEditingController nimController;
  final TextEditingController namaController;
  final TextEditingController tempatLahirController;
  final TextEditingController tanggalLahirController;
  final TextEditingController emailController;
  final TextEditingController nomorHpController;
  final TextEditingController tahunMasukController;
  final TextEditingController alamatController;
  final TextEditingController kelasController;
  final List<JurusanOption> jurusanOptions;
  final List<ProdiOption> filteredProdiOptions;
  final List<DropdownOption> jkOptions;
  final List<DropdownOption> agamaOptions;
  final List<DropdownOption> pegawaiOptions;
  final int? selectedJurusanId;
  final int? selectedProdiId;
  final int? selectedJkId;
  final int? selectedAgamaId;
  final String? selectedPegawaiId;
  final ValueChanged<int?> onJurusanChanged;
  final ValueChanged<int?> onProdiChanged;
  final ValueChanged<int?> onJkChanged;
  final ValueChanged<int?> onAgamaChanged;
  final ValueChanged<String?> onPegawaiChanged;
  final VoidCallback selectDate;
  final VoidCallback submitForm;

  const EditMahasiswaView({
    super.key,
    required this.formKey,
    required this.isEditMode,
    required this.isLoading,
    required this.isDropdownLoading,
    required this.nimController,
    required this.namaController,
    required this.tempatLahirController,
    required this.tanggalLahirController,
    required this.emailController,
    required this.nomorHpController,
    required this.tahunMasukController,
    required this.alamatController,
    required this.kelasController,
    required this.jurusanOptions,
    required this.filteredProdiOptions,
    required this.jkOptions,
    required this.agamaOptions,
    required this.pegawaiOptions,
    required this.selectedJurusanId,
    required this.selectedProdiId,
    required this.selectedJkId,
    required this.selectedAgamaId,
    required this.selectedPegawaiId,
    required this.onJurusanChanged,
    required this.onProdiChanged,
    required this.onJkChanged,
    required this.onAgamaChanged,
    required this.onPegawaiChanged,
    required this.selectDate,
    required this.submitForm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Data Mahasiswa' : 'Tambah Mahasiswa', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(isEditMode ? 'Formulir Edit Data' : 'Formulir Pendaftaran', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                  const SizedBox(height: 24),
                  if (isDropdownLoading)
                    const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("Memuat data master...")))
                  else ...[
                    DropdownButtonFormField<int>(
                      value: selectedJurusanId,
                      isExpanded: true,
                      decoration: _inputDecoration('Jurusan*'),
                      hint: const Text('-- Pilih Jurusan --'),
                      items: jurusanOptions.map((jurusan) => DropdownMenuItem<int>(value: jurusan.id, child: Text(jurusan.nama))).toList(),
                      onChanged: onJurusanChanged,
                      validator: (value) => value == null ? 'Jurusan harus dipilih' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedProdiId,
                      isExpanded: true,
                      decoration: _inputDecoration('Program Studi*').copyWith(fillColor: selectedJurusanId == null ? Colors.grey[200] : Colors.white),
                      hint: const Text('-- Pilih Prodi --'),
                      items: selectedJurusanId == null ? [] : filteredProdiOptions.map((prodi) => DropdownMenuItem<int>(value: prodi.id, child: Text(prodi.nama, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: selectedJurusanId == null ? null : onProdiChanged,
                      validator: (value) => value == null ? 'Program Studi harus dipilih' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildTextField(nimController, 'NIM', prefixIcon: Icons.badge_outlined, readOnly: isEditMode),
                  _buildTextField(namaController, 'Nama Lengkap', prefixIcon: Icons.person_outline),
                  _buildTextField(tempatLahirController, 'Tempat Lahir', prefixIcon: Icons.location_city_outlined, isRequired: false),
                  Padding(padding: const EdgeInsets.only(bottom: 16.0), child: TextFormField(controller: tanggalLahirController, decoration: _inputDecoration('Tanggal Lahir', prefixIcon: Icons.calendar_today_outlined), readOnly: true, onTap: selectDate)),
                  _buildStaticDropdown<String>(selectedPegawaiId, 'Dosen Pembimbing', pegawaiOptions, onPegawaiChanged, isRequired: false),
                  _buildTextField(emailController, 'Email', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  _buildTextField(nomorHpController, 'Nomor HP', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                  _buildTextField(tahunMasukController, 'Tahun Masuk', prefixIcon: Icons.calendar_view_day, keyboardType: TextInputType.number, isRequired: false),
                  _buildStaticDropdown<int>(selectedJkId, 'Jenis Kelamin', jkOptions, onJkChanged, isRequired: false),
                  _buildStaticDropdown<int>(selectedAgamaId, 'Agama', agamaOptions, onAgamaChanged, isRequired: false),
                  _buildTextField(kelasController, 'Kelas', prefixIcon: Icons.class_outlined, isRequired: false),
                  _buildTextField(alamatController, 'Alamat Lengkap', prefixIcon: Icons.home_outlined, isRequired: false),
                  const SizedBox(height: 24),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isEditMode ? Colors.orange.shade700 : const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                      child: Text(isEditMode ? 'Update Data' : 'Simpan Data', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isRequired = true, IconData? prefixIcon, TextInputType? keyboardType, bool readOnly = false}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            decoration: _inputDecoration('$label${isRequired ? '*' : ''}', prefixIcon: prefixIcon).copyWith(fillColor: readOnly ? Colors.grey[200] : Colors.white),
            validator: isRequired ? (value) {
              if (value == null || value.isEmpty) return '$label tidak boleh kosong';
              if (label == "Email" && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Masukkan email yang valid';
              if (label == "Nomor HP" && !RegExp(r'^[0-9]+$').hasMatch(value)) return 'Nomor HP hanya boleh angka';
              return null;
            } : null
        )
    );
  }
 
  Widget _buildStaticDropdown<T>(T? currentValue, String label, List<DropdownOption> options, ValueChanged<T?> onChanged, {bool isRequired = true}) {
      final T? validValue = (currentValue != null && options.any((option) => option.id == currentValue)) ? currentValue : null;
      return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: DropdownButtonFormField<T>(
              value: validValue,
              isExpanded: true,
              decoration: _inputDecoration('$label${isRequired ? '*' : ''}'),
              hint: const Text('-- Pilih --'),
              items: options.map((DropdownOption option) => DropdownMenuItem<T>(value: option.id as T, child: Text(option.nama))).toList(),
              onChanged: onChanged,
              validator: isRequired ? (value) => (value == null) ? '$label harus dipilih' : null : null
          )
      );
  }
}