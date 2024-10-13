import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:new_scanner/screens/reference_screen.dart';
import 'package:new_scanner/services/provider_service.dart';
import 'package:provider/provider.dart';

class BarcodeScannerOverlay extends StatefulWidget {
  const BarcodeScannerOverlay({super.key});

  @override
  State<BarcodeScannerOverlay> createState() => _BarcodeScannerOverlayState();
}

class _BarcodeScannerOverlayState extends State<BarcodeScannerOverlay> {
  late ProviderService providerReader;
  //* Delimitar escaneo a qr solamente
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  //* Estado para la linterna
  bool isTorchOn = false;

  //* Función que maneja los QRs escaneados
  void _handleScanning(BarcodeCapture barcodes) {
    final barcode = barcodes.barcodes.firstOrNull?.displayValue ?? '';
    if (barcode.isNotEmpty) {
      controller.stop();
      providerReader.reference = barcode;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ReferenceScreen(),)
      );
    }
  }

  void _toggleTorch(){
    setState(() {
      isTorchOn = !isTorchOn;
      controller.toggleTorch();
    });
  }

  @override
  void initState() {
    super.initState();
    controller.barcodes.listen(_handleScanning);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    providerReader = context.read<ProviderService>();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            fit: BoxFit.contain,
            controller: controller,
            scanWindow: scanWindow,
          ),
          CustomPaint(
            painter: ScannerOverlay(scanWindow: scanWindow),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              onPressed: _toggleTorch,
              icon: Icon(
                isTorchOn ? Icons.flash_off : Icons.flash_on,
                size: 40,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}