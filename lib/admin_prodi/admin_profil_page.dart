import 'package:flutter/material.dart';
import '../login_page.dart'; // Import halaman login untuk navigasi

class AdminProfilPage extends StatelessWidget {
  const AdminProfilPage({super.key});

  // Fungsi untuk menampilkan popup konfirmasi logout
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User harus menekan tombol
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Konfirmasi Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Iya, Keluar'),
              onPressed: () {
                // Menutup semua halaman dan kembali ke halaman login
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profil Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            // Bagian Header Profil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF0D47A1).withOpacity(0.1),
                    child: const Text(
                      'AD',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Admin Prodi', // Nama admin (bisa dibuat dinamis)
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'admin@poliban.ac.id', // Email admin (bisa dibuat dinamis)
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Menu Pengaturan
            Card(
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.vpn_key_outlined,
                    title: 'Ganti Kata Sandi',
                    onTap: () {
                      // TODO: Navigasi ke halaman ganti password
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildMenuTile(
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan Akun',
                    onTap: () {
                      // TODO: Navigasi ke halaman pengaturan
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Logout
            Card(
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: _buildMenuTile(
                icon: Icons.logout,
                title: 'Logout',
                color: Colors.red.shade700,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk setiap baris menu
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[700]),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      trailing: color == null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}
