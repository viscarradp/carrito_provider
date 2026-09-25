import 'package:flutter/material.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.priceCents,
    required this.icon,
  });

  final String id;
  final String name;
  final String description;

  /// Precio en centavos para no acumular errores de punto flotante al sumar.
  final int priceCents;
  final IconData icon;

  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Lista fija del catálogo.
const catalog = <Product>[
  Product(
    id: 'mochila',
    name: 'Mochila Urbana Oxford',
    description: 'Resistente al agua, 20 L',
    priceCents: 4500,
    icon: Icons.backpack_outlined,
  ),
  Product(
    id: 'auriculares',
    name: 'Auriculares Inalámbricos Pro',
    description: 'Cancelación activa de ruido',
    priceCents: 6500,
    icon: Icons.headphones_outlined,
  ),
  Product(
    id: 'reloj',
    name: 'Reloj Inteligente Fit Track',
    description: 'Pulsómetro y GPS dual',
    priceCents: 8900,
    icon: Icons.watch_outlined,
  ),
  Product(
    id: 'termo',
    name: 'Termo de Acero Inoxidable',
    description: 'Aislamiento térmico 24 h',
    priceCents: 2250,
    icon: Icons.local_drink_outlined,
  ),
  Product(
    id: 'lentes',
    name: 'Lentes de Sol Polarizados',
    description: 'Protección UV400 completa',
    priceCents: 3400,
    icon: Icons.wb_sunny_outlined,
  ),
  Product(
    id: 'cargador',
    name: 'Cargador Portátil 10 000 mAh',
    description: 'Carga rápida USB-C',
    priceCents: 2790,
    icon: Icons.battery_charging_full_outlined,
  ),
];
