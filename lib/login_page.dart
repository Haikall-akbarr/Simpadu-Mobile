// lib/login_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:simpadu_mobile/pages/dashboard_page.dart';
import 'admin_prodi/admin_prodi_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  // --- FUNGSI LOGIN UNTUK MAHASISWA (MENGGUNAKAN API BARU) ---
  Future<bool> _loginStudent(String nim, String password) async {
    // API ini mengarah ke data mahasiswa spesifik (ID 4)
    const String apiUrl = 'https://ti054c03.agussbn.my.id/api/users/4';
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final Map<String, dynamic> userData = decodedData['data'];

        // Cocokkan email (NIM) dan password dari input dengan data dari API
        if (userData['email'] == nim &&
            userData['password'] == password &&
            userData['role'] == 'user') {
          return true; // Login mahasiswa berhasil
        }
      }
      return false; // Jika status code bukan 200 atau data tidak cocok
    } catch (e) {
      debugPrint('Error saat login mahasiswa: $e');
      return false; // Jika terjadi error (misal: tidak ada internet)
    }
  }

  // --- FUNGSI LOGIN UNTUK ADMIN (Sama seperti sebelumnya) ---
  Future<bool> _loginAdmin(String email, String password) async {
    const String apiUrl = 'https://ti054c03.agussbn.my.id/api/users';
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final List<dynamic> users = decodedData['data'];

        var user = users.firstWhere(
          (user) =>
              user['email'] == email &&
              user['password'] == password &&
              user['role'] == 'admin',
          orElse: () => null,
        );

        return user != null;
      }
      return false;
    } catch (e) {
      debugPrint('Error saat login admin: $e');
      return false;
    }
  }

  // --- FUNGSI HANDLE LOGIN YANG SUDAH DI-UPDATE ---
  void _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog(
        'Login Gagal',
        'NIM/Email dan password tidak boleh kosong.',
      );
      return;
    }

    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // 1. Coba login sebagai mahasiswa via API
    bool isStudentLoginSuccess = await _loginStudent(username, password);

    if (isStudentLoginSuccess) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
      return; // Hentikan proses jika login mahasiswa berhasil
    }

    // 2. Jika bukan mahasiswa, coba login sebagai admin via API
    bool isAdminLoginSuccess = await _loginAdmin(username, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (isAdminLoginSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminProdiDashboardPage(),
        ),
      );
    } else {
      // Jika kedua login gagal
      _showErrorDialog('Login Gagal', 'NIM/Email atau password salah.');
    }
  }

  // Fungsi helper untuk menampilkan dialog error
  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- TAMPILAN UI TIDAK DIUBAH, SAMA SEPERTI SEBELUMNYA ---
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/Poliban_logo1.png', height: 60),
                    const SizedBox(height: 10),
                    const Text(
                      'Masuk ke SIMPADU',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const Text(
                      'Sistem Informasi Terpadu POLIBAN',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey[700],
                        ),
                        border: const UnderlineInputBorder(),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF0D47A1),
                            width: 2,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey[700],
                        ),
                        border: const UnderlineInputBorder(),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF0D47A1),
                            width: 2,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[700],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          /* TODO: Lupa Password */
                        },
                        child: const Text(
                          'Lupa kata sandi?',
                          style: TextStyle(color: Color(0xFF0D47A1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: const Color(0xFF0D47A1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
