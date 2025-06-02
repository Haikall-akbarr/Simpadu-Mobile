import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CetakKrsPage extends StatefulWidget {
  const CetakKrsPage({super.key});

  @override
  State<CetakKrsPage> createState() => _CetakKrsPageState();
}

class _CetakKrsPageState extends State<CetakKrsPage> {
  late Future<List<dynamic>> _appointments;

  Future<List<dynamic>> fetchAppointments() async {
    final response = await http.get(
      Uri.parse('https://kaido_c030323022.test/api/patient-appointments'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  @override
  void initState() {
    super.initState();
    _appointments = fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cetak KRS')),
      body: FutureBuilder<List<dynamic>>(
        future: _appointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data.'));
          }
          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['patient_name'] ?? 'Nama tidak tersedia',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Tanggal: ${item['appointment_date'] ?? '-'}'),
                      Text('Dokter: ${item['doctor_name'] ?? '-'}'),
                      Text('Status: ${item['status'] ?? '-'}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
