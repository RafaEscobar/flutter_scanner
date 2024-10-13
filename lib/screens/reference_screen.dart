import 'package:flutter/material.dart';
import 'package:new_scanner/services/provider_service.dart';
import 'package:provider/provider.dart';

class ReferenceScreen extends StatelessWidget {
  const ReferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderService providerReader = context.read<ProviderService>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Referencia: '),
            Text(providerReader.reference),
          ],
        )
      ),
    );
  }
}