# Carrito de compras simplificado (Provider)

App Flutter de dos pantallas (Catálogo → Resumen de compra) que comparten estado solo con Provider.

## Ejecutar

```bash
flutter pub get
flutter run
```

Pruebas unitarias y de widget:

```bash
flutter test
```

Regenerar la evidencia en un simulador o dispositivo (guarda las capturas en `evidencia/`):

```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/flujo_test.dart
```

## Estructura

```
lib/
  main.dart                          ChangeNotifierProvider encima de MaterialApp
  models/cart_model.dart             ChangeNotifier: selección, total, toggle()
  models/product.dart                Producto y catálogo fijo (6 productos)
  screens/catalog_screen.dart        Pantalla 1
  screens/summary_screen.dart        Pantalla 2
  widgets/purchase_success_dialog.dart
```

## Criterios de desempeño

| # | Criterio | Dónde |
|---|---|---|
| 01 | ChangeNotifier completo | `CartModel` expone `selected`, `totalCents` y `toggle()` |
| 02 | Uso correcto de context | `context.watch` / `Consumer` en `build()`; `context.read` solo en `onTap` y `onChanged` |
| 03 | Restricción de selección | `CartModel.isReady` (exactamente 3). Con 2 o con 4, "Continuar" queda deshabilitado y se indica cuántos faltan o sobran |
| 04 | Total desde estado compartido | `totalCents` se calcula una sola vez en el modelo; el resumen y el diálogo solo lo muestran |
| 05 | Diálogo de compra exitosa | "Proceder a pagar" abre un `AlertDialog` con el total; "Aceptar" lo cierra y el estado se conserva |

Restricción de diseño: `SummaryScreen` y `PurchaseSuccessDialog` no reciben parámetros; la navegación usa `MaterialPageRoute` sin argumentos de ruta.

## Evidencia

`evidencia/flujo-completo.mp4` (grabación de 15 s en iPhone 17 Pro) y capturas numeradas:

1. `01-catalogo-vacio.png`: 0 de 3, navegación bloqueada
2. `02-dos-de-tres-bloqueado.png`: 2 de 3, "Falta 1"
3. `03-cuatro-bloqueado.png`: 4 de 3, "Sobra 1", sigue bloqueado
4. `04-tres-habilitado.png`: 3 de 3, "Continuar" habilitado
5. `05-resumen.png`: productos y total $199.00
6. `06-dialogo-exito.png`: diálogo con el monto pagado
7. `07-estado-conservado.png`: tras "Aceptar", el resumen sigue igual
