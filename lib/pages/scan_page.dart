import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isScanned = false;

  void _onDetect(Barcode barcode) {
    if (!isScanned) {
      final String? code = barcode.rawValue;
      if (code != null) {
        isScanned = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Code detected: $code')),
        );
        // Return after successful scan (optional)
        Navigator.pop(context, code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode/QR Code')),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final Barcode? barcode = capture.barcodes.firstOrNull;
          if (barcode != null) {
            _onDetect(barcode);
          }
        },
      ),
    );
  }
}
