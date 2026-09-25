import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart_model.dart';
import 'screens/catalog_screen.dart';
import 'theme.dart';

void main() {
  runApp(
    // Encima de MaterialApp para que todas las rutas (y el diálogo) lo vean.
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: const CarritoApp(),
    ),
  );
}

class CarritoApp extends StatelessWidget {
  const CarritoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrito Provider',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const CatalogScreen(),
    );
  }
}
