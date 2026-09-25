import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../theme.dart';

/// El total también sale del ChangeNotifier, no de un argumento.
class PurchaseSuccessDialog extends StatelessWidget {
  const PurchaseSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      icon: CircleAvatar(
        radius: 28,
        backgroundColor: AppColors.success.withValues(alpha: 0.12),
        child: const Icon(
          Icons.check_rounded,
          color: AppColors.success,
          size: 32,
        ),
      ),
      title: const Text('¡Compra exitosa!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tu pedido ha sido confirmado correctamente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const Text(
                  'MONTO TOTAL PAGADO',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatMoney(cart.totalCents),
                  key: const Key('dialog-total'),
                  style: const TextStyle(
                    color: AppColors.price,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${cart.count} productos comprados',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
