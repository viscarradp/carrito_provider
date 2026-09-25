import 'package:carrito_provider/models/cart_model.dart';
import 'package:carrito_provider/models/product.dart';
import 'package:carrito_provider/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toggle agrega y quita, y notifica cada cambio', () {
    final cart = CartModel();
    var notifications = 0;
    cart.addListener(() => notifications++);

    cart.toggle(catalog[0]);
    expect(cart.isSelected(catalog[0]), isTrue);
    expect(cart.count, 1);

    cart.toggle(catalog[0]);
    expect(cart.isSelected(catalog[0]), isFalse);
    expect(cart.count, 0);
    expect(notifications, 2);
  });

  test('isReady solo con exactamente 3', () {
    final cart = CartModel();
    for (final product in catalog.take(2)) {
      cart.toggle(product);
    }
    expect(cart.isReady, isFalse);
    expect(cart.remaining, 1);

    cart.toggle(catalog[2]);
    expect(cart.isReady, isTrue);

    cart.toggle(catalog[3]);
    expect(cart.isReady, isFalse);
    expect(cart.remaining, -1);
  });

  test('el total es la suma de los precios seleccionados', () {
    final cart = CartModel()
      ..toggle(catalog[0]) // 45.00
      ..toggle(catalog[3]) // 22.50
      ..toggle(catalog[5]); // 27.90
    expect(cart.totalCents, 9540);
  });

  test('selected no se puede modificar desde fuera', () {
    final cart = CartModel()..toggle(catalog[0]);
    expect(() => cart.selected.clear(), throwsUnsupportedError);
  });

  test('formatMoney', () {
    expect(formatMoney(0), r'$0.00');
    expect(formatMoney(2250), r'$22.50');
    expect(formatMoney(19900), r'$199.00');
    expect(formatMoney(123456789), r'$1,234,567.89');
  });
}
