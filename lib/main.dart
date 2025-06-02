// lib/main.dart (MILIK ANDA - SUDAH OK)
import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Pastikan file ini ada dan mengarah ke LoginPage setelahnya

void main() {
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
         // Anda bisa mengambil ThemeData dari jawaban saya sebelumnya untuk tampilan yang lebih konsisten
        // dengan halaman admin, atau biarkan seperti ini jika sudah sesuai.
        // Contoh dari jawaban saya sebelumnya:
        // primaryColor: const Color(0xFF0D47A1),
        // scaffoldBackgroundColor: Colors.grey[50],
        // colorScheme: ColorScheme.fromSeed(
        //     seedColor: const Color(0xFF0D47A1),
        //     primary: const Color(0xFF0D47A1),
        //     secondary: const Color(0xFF1976D2),
        // ),
        // fontFamily: 'Poppins',
        // appBarTheme: const AppBarTheme(
        //   backgroundColor: Color(0xFF0D47A1),
        //   foregroundColor: Colors.white,
        //   elevation: 1,
        //   titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        // ),
        // elevatedButtonTheme: ElevatedButtonThemeData( /* ... */ ),
        // inputDecorationTheme: InputDecorationTheme( /* ... */ ),
        // cardTheme: CardTheme( /* ... */ ),
        // useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Tambahkan ini untuk menghilangkan banner debug
      home: const SplashScreen(),
    );
  }
}