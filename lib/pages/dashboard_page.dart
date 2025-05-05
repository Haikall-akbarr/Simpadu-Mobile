import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import 'khs_page.dart';
import 'cetak_krs_page.dart';
import 'pengumuman_page.dart';
import 'jadwal_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda Mahasiswa'), backgroundColor: Colors.blue),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: PageView(
              children: [
                Container(
                  decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner.jpg'),
                    fit: BoxFit.cover,
                  ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner2.jpg'),
                    fit: BoxFit.cover,
                  ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                MenuCard(icon: Icons.school, label: 'KHS', onTap: () => _navigate(context, const KhsPage())),
                MenuCard(icon: Icons.print, label: 'Cetak KRS', onTap: () => _navigate(context, const CetakKrsPage())),
                MenuCard(icon: Icons.info, label: 'Pengumuman', onTap: () => _navigate(context, const PengumumanPage())),
                MenuCard(icon: Icons.schedule, label: 'Jadwal Kuliah', onTap: () => _navigate(context, const JadwalPage())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}