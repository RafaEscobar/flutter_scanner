import 'package:flutter/material.dart';
import 'package:new_scanner/main.dart';
import 'package:new_scanner/utils/modal_sheet.dart';
import 'package:new_scanner/widgets/barcode_scanner.dart';
import 'package:new_scanner/widgets/barcode_scanner_overlay.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {

  Widget body = Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(Myapp.navigatorKey.currentContext!).push(
              MaterialPageRoute(builder: (context) => const BarcodeScannerOverlay(),)
            );
          },
          icon: const Icon(
            Icons.qr_code,
            size: 80,
            color: Colors.black,
          )
        ),
        const SizedBox(height: 40,),
        IconButton(
          onPressed: () {
            Navigator.of(Myapp.navigatorKey.currentContext!).push(
              MaterialPageRoute(builder: (context) => const BarcodeScanner(),)
            );
          },
          icon: const Icon(
            Icons.barcode_reader,
            size: 80,
            color: Colors.black,
          )
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: ElevatedButton(
            onPressed: () => ModalSheet.showModalSheet(body),
            child: const Text('Escanear referencia')
          ),
        ),
      ),
    );
  }
}