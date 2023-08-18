import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan_it/screens/ImageUploadPage.dart';

void main() {
  runApp(const MaterialApp(home: QRCodeScannerApp()));
}

class QRCodeScannerApp extends StatefulWidget {
  const QRCodeScannerApp({super.key});

  @override
  State<StatefulWidget> createState() => _QRCodeScannerAppState();
}

class _QRCodeScannerAppState extends State<QRCodeScannerApp> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String scannedCode = ''; // Add this line

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final folderName = scanData.code ?? ''; // Use a default value if null
      setState(() {
        scannedCode = folderName; // Update the scannedCode
      });
      // ignore: avoid_print
      print('Scanned Code: $scannedCode'); // Print the scanned code
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageUploadPage(folderName: folderName),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Scanned Code: $scannedCode', // Display scanned code on the screen
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
