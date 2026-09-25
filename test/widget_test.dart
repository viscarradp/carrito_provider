import 'package:carrito_provider/main.dart';
import 'package:carrito_provider/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  late CartModel cart;

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    cart = CartModel();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: cart, child: const CarritoApp()),
    );
  }

  bool isEnabled(WidgetTester tester, String label) => tester
      .widget<FilledButton>(find.widgetWithText(FilledButton, label))
      .enabled;

  Future<void> tapProduct(WidgetTester tester, String name) async {
    await tester.ensureVisible(find.text(name));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name));
    await tester.pump();
  }

  testWidgets('flujo completo: selección, bloqueo, resumen y diálogo', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('0 de 3 seleccionados'), findsOneWidget);
    expect(isEnabled(tester, 'Continuar'), isFalse);

    await tapProduct(tester, 'Mochila Urbana Oxford');
    await tapProduct(tester, 'Auriculares Inalámbricos Pro');
    expect(find.text('2 de 3 seleccionados'), findsOneWidget);
    expect(find.text('Falta 1'), findsOneWidget);
    expect(isEnabled(tester, 'Continuar'), isFalse);

    await tapProduct(tester, 'Reloj Inteligente Fit Track');
    expect(find.text('3 de 3 seleccionados'), findsOneWidget);
    expect(isEnabled(tester, 'Continuar'), isTrue);

    // Con 4 se vuelve a bloquear.
    await tapProduct(tester, 'Termo de Acero Inoxidable');
    expect(find.text('Sobra 1'), findsOneWidget);
    expect(isEnabled(tester, 'Continuar'), isFalse);

    await tapProduct(tester, 'Termo de Acero Inoxidable');
    expect(isEnabled(tester, 'Continuar'), isTrue);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.text('Resumen de compra'), findsOneWidget);
    expect(find.text('Mochila Urbana Oxford'), findsOneWidget);
    expect(find.text('Auriculares Inalámbricos Pro'), findsOneWidget);
    expect(find.text('Reloj Inteligente Fit Track'), findsOneWidget);
    expect(find.text('Termo de Acero Inoxidable'), findsNothing);
    expect(
      tester.widget<Text>(find.byKey(const Key('summary-total'))).data,
      r'$199.00',
    );

    // El diálogo no aparece antes de presionar el botón.
    expect(find.text('¡Compra exitosa!'), findsNothing);
    await tester.tap(find.text('Proceder a pagar'));
    await tester.pumpAndSettle();

    expect(find.text('¡Compra exitosa!'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('dialog-total'))).data,
      r'$199.00',
    );

    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();

    // Se cierra el diálogo y el estado sigue intacto.
    expect(find.text('¡Compra exitosa!'), findsNothing);
    expect(find.text('Resumen de compra'), findsOneWidget);
    expect(cart.count, 3);
    expect(cart.totalCents, 19900);
  });

  testWidgets('al volver al catálogo la selección se conserva', (tester) async {
    await pumpApp(tester);

    await tapProduct(tester, 'Mochila Urbana Oxford');
    await tapProduct(tester, 'Termo de Acero Inoxidable');
    await tapProduct(tester, 'Lentes de Sol Polarizados');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('3 de 3 seleccionados'), findsOneWidget);
    expect(isEnabled(tester, 'Continuar'), isTrue);
  });
}
