import 'package:flutter/foundation.dart';

import 'product.dart';

/// Único estado compartido entre el catálogo y el resumen de compra.
///
/// Ninguna pantalla recibe productos ni totales por constructor o argumentos
/// de ruta: ambas leen de aquí a través de Provider.
class CartModel extends ChangeNotifier {
  static const requiredCount = 3;

  final List<Product> _selected = [];

  List<Product> get selected => List.unmodifiable(_selected);

  int get count => _selected.length;

  /// La navegación al resumen solo se habilita con exactamente [requiredCount].
  bool get isReady => count == requiredCount;

  /// Positivo: productos que faltan. Negativo: productos que sobran.
  int get remaining => requiredCount - count;

  /// Se calcula una sola vez aquí; las pantallas solo lo muestran.
  int get totalCents =>
      _selected.fold(0, (sum, product) => sum + product.priceCents);

  bool isSelected(Product product) => _selected.contains(product);

  void toggle(Product product) {
    if (!_selected.remove(product)) {
      _selected.add(product);
    }
    notifyListeners();
  }
}
