import 'package:flutter/material.dart';
import '../widgets/menu_card.dart';
import 'khs_page.dart';
import 'cetak_krs_page.dart';
import 'pengumuman_page.dart';
import 'jadwal_page.dart';
import '../services/pengumuman_service.dart' as pengumumanService;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String latestNews = 'Memuat pengumuman...';

  @override
  void initState() {
    super.initState();
    _loadLatestNews();
  }

  void _loadLatestNews() async {
    try {
      final news = await pengumumanService.PengumumanService.fetchLatestPengumuman();
      setState(() {
        latestNews = news;
      });
    } catch (e) {
      setState(() {
        latestNews = 'Gagal memuat pengumuman.';
      });
    }
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _jadwalCard(
    BuildContext context,
    String matkul,
    String jam,
    String ruangan,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JadwalPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF0F2F5),
        ),
        child: Row(
          children: [
            const Icon(Icons.class_, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    matkul,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$jam  |  $ruangan',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.jpg'),
                      radius: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'M. HAIKAL AKBAR ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Mahasiswa - Teknik Informatika',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _navigate(context, const PengumumanPage()),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDEEFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.campaign, color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            latestNews,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Jadwal Hari Ini",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Senin, 05 Mei", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _jadwalCard(
                      context,
                      'Kecerdasan Buatan',
                      '10:30 - 12:10',
                      'H-205',
                    ),
                    const SizedBox(height: 8),
                    _jadwalCard(
                      context,
                      'Metode Numerik',
                      '13:00 - 15:30',
                      'H-103',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Text(
                      "Menu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    MenuCard(
                      icon: Icons.school,
                      label: 'KHS',
                      onTap: () => _navigate(context, const KhsPage()),
                    ),
                    MenuCard(
                      icon: Icons.print,
                      label: 'Cetak KRS',
                      onTap: () => _navigate(context, const CetakKrsPage()),
                    ),
                    MenuCard(
                      icon: Icons.info,
                      label: 'Pengumuman',
                      onTap: () => _navigate(context, const PengumumanPage()),
                    ),
                    MenuCard(
                      icon: Icons.schedule,
                      label: 'Jadwal Kuliah',
                      onTap: () => _navigate(context, const JadwalPage()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
