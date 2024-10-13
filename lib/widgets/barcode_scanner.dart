import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:new_scanner/screens/reference_screen.dart';
import 'package:new_scanner/services/provider_service.dart';
import 'package:new_scanner/utils/filter_string.dart';
import 'package:provider/provider.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> with SingleTickerProviderStateMixin {
  late ProviderService providerReader;
  //* Controlador para el escaner
  final MobileScannerController controller = MobileScannerController();
  //* Estado para la linterna
  bool isTorchOn = false;
  //* Controlador de la animación
  late AnimationController _animationController;
  late Animation<double> _animation;

  //* Función que maneja los códigos de barras escaneados
  void _handleScanning(BarcodeCapture barcodes) {
    final barcode = barcodes.barcodes.firstOrNull?.displayValue ?? '';
    if (barcode.isNotEmpty) {
      bool isBarCode = FilterString.isABarCode(barcode);
      if (isBarCode) {
        controller.stop();
        setState(() => isTorchOn = !isTorchOn);
        providerReader.reference = barcode;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ReferenceScreen(),)
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    providerReader = context.read<ProviderService>();
  }

  //* Función para encender o apagar la linterna
  void _toggleTorch() {
    setState(() {
      isTorchOn = !isTorchOn;
      controller.toggleTorch();
    });
  }

  @override
  void initState() {
    super.initState();
    //* Listener de códigos de barras
    controller.barcodes.listen(_handleScanning);
    //* Inicio del escaneo automáticamente
    controller.start();

    //* Configuración de la animación
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -100, end: 1).animate(_animationController);
  }

  @override
  Future<void> dispose() async {
    _animationController.dispose();
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover,
          ),
          //* Línea de escaneo animada
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height / 2 + _animation.value,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color:Colors.blue,
                ),
              );
            },
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
          ),
        ],
      ),
    );
  }
}