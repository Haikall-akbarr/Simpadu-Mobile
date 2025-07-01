// lib/main.dart 
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'splash_screen.dart'; // Pastikan file ini ada dan mengarah ke LoginPage setelahnya

void main() async {
  // 3. Pastikan Flutter binding sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('id_ID', null);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMAK Mahasiswa', // Anda bisa ganti jadi 'SIMAK Poliban' atau sejenisnya
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Tambahkan ini untuk menghilangkan banner debug
      home: const SplashScreen(),
    );
  }
}