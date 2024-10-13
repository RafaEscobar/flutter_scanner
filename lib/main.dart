import 'package:flutter/material.dart';
import 'package:new_scanner/screens/scanner_screen.dart';
import 'package:new_scanner/services/provider_service.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const Myapp({super.key});

  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderService())
      ],
      builder: (_, __){
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: const ScannerScreen(),
        );
      }
    );
  }
}