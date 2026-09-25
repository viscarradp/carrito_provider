import 'package:carrito_provider/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Recorre el flujo completo en un dispositivo real y guarda capturas
/// en evidencia/ (ver test_driver/integration_test.dart).
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Pausa real para que la grabación de pantalla se pueda seguir.
  Future<void> pause([int ms = 900]) =>
      Future<void>.delayed(Duration(milliseconds: ms));

  bool isEnabled(WidgetTester tester, String label) => tester
      .widget<FilledButton>(find.widgetWithText(FilledButton, label))
      .enabled;

  Future<void> tapProduct(WidgetTester tester, String name) async {
    await tester.ensureVisible(find.text(name));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
    await pause(600);
  }

  testWidgets('flujo de compra', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await pause();
    await binding.takeScreenshot('01-catalogo-vacio');

    await tapProduct(tester, 'Mochila Urbana Oxford');
    await tapProduct(tester, 'Auriculares Inalámbricos Pro');
    expect(find.text('2 de 3 seleccionados'), findsOneWidget);
    expect(isEnabled(tester, 'Continuar'), isFalse);
    await binding.takeScreenshot('02-dos-de-tres-bloqueado');

    await tapProduct(tester, 'Reloj Inteligente Fit Track');
    await tapProduct(tester, 'Termo de Acero Inoxidable');
    expect(find.text('Sobra 1'), findsOneWidget);
    expect(isEnabled(tester, 'Continuar'), isFalse);
    await binding.takeScreenshot('03-cuatro-bloqueado');

    await tapProduct(tester, 'Termo de Acero Inoxidable');
    expect(find.text('3 de 3 seleccionados'), findsOneWidget);
    expect(isEnabled(tester, 'Continuar'), isTrue);
    await binding.takeScreenshot('04-tres-habilitado');

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await pause();
    expect(find.text(r'$199.00'), findsOneWidget);
    await binding.takeScreenshot('05-resumen');

    await tester.tap(find.text('Proceder a pagar'));
    await tester.pumpAndSettle();
    await pause(1500);
    expect(find.text('¡Compra exitosa!'), findsOneWidget);
    await binding.takeScreenshot('06-dialogo-exito');

    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();
    await pause();
    expect(find.text('Resumen de compra'), findsOneWidget);
    expect(find.text(r'$199.00'), findsOneWidget);
    await binding.takeScreenshot('07-estado-conservado');
  });
}
