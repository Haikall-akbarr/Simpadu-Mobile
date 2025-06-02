// lib/login_page.dart
import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart'; // <<< SESUAIKAN PATH INI
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

  void _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // simulasi loading

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = false);

    if (username == 'C030323022' && password == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()), // Navigasi ke pages/dashboard_page.dart
      );
    } else if (username == 'Admin prodi' && password == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminProdiDashboardPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login Gagal'),
          content: const Text('Username atau password salah.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kode untuk UI LoginPage (Stack, Image, Form, TextField, Button)
    // SAMA SEPERTI JAWABAN SEBELUMNYA.
    // Pastikan Anda menggunakan kode UI lengkap dari jawaban sebelumnya.
    // Untuk ringkas, saya tidak menyalin ulang seluruh kode UI di sini.
    // Contoh awal:
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
                    )
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/Poliban_logo1.png', height: 60),
                    const SizedBox(height: 10),
                    const Text(
                      'Masuk ke SIMAK',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                    ),
                    const Text(
                      'Sistem Informasi Akademik',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'NIM / Username Admin',
                        prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
                        // Style lainnya dari jawaban sebelumnya
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Kata sandi anda',
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey[600]),
                          onPressed: () {
                            setState(() { _obscureText = !_obscureText; });
                          },
                        ),
                        // Style lainnya dari jawaban sebelumnya
                      ),
                    ),
                    // ... Sisa UI (Lupa password, Tombol Login, Buat Akun) dari jawaban sebelumnya ...
                     const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () { /* TODO: Lupa Password */ },
                        child: const Text('Lupa kata sandi?', style: TextStyle(color: Color(0xFF0D47A1))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: const Color(0xFF1976D2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Masuk', style: TextStyle(fontSize: 16)),
                          ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () { /* TODO: Buat Akun */ },
                      child: const Text('Belum Punya Akun? Buat Akun', style: TextStyle(color: Color(0xFF0D47A1))),
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