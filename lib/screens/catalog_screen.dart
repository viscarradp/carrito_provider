import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../models/product.dart';
import '../theme.dart';
import '../widgets/cart_badge.dart';
import '../widgets/product_thumb.dart';
import 'summary_screen.dart';

/// Pantalla 1 — Catálogo.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: const [CartBadge()],
      ),
      body: Column(
        children: [
          // Fijo arriba para que el conteo siempre esté a la vista.
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: _SelectionHeader(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                for (final product in catalog) _ProductTile(product: product),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _ContinueBar(),
    );
  }
}

class _SelectionHeader extends StatelessWidget {
  const _SelectionHeader();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final remaining = cart.remaining;
    final missing = remaining > 0;

    final String chip;
    final String hint;
    if (remaining == 0) {
      chip = 'Listo';
      hint = 'Selección completa: ya puedes continuar.';
    } else if (missing) {
      chip = remaining == 1 ? 'Falta 1' : 'Faltan $remaining';
      hint = remaining == 1
          ? 'Selecciona 1 producto más para continuar.'
          : 'Selecciona $remaining productos más para continuar.';
    } else {
      final extra = -remaining;
      chip = extra == 1 ? 'Sobra 1' : 'Sobran $extra';
      hint = extra == 1
          ? 'Quita 1 producto para continuar.'
          : 'Quita $extra productos para continuar.';
    }
    final chipColor = remaining == 0 ? AppColors.success : AppColors.price;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.checklist_rtl, color: AppColors.navy),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${cart.count} de ${CartModel.requiredCount} seleccionados',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: chipColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    chip,
                    style: TextStyle(
                      color: chipColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (cart.count / CartModel.requiredCount).clamp(0.0, 1.0),
                minHeight: 6,
                color: remaining < 0 ? AppColors.price : AppColors.navy,
                backgroundColor: AppColors.border,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, _) {
        final selected = cart.isSelected(product);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: selected ? AppColors.navy : AppColors.border,
                width: selected ? 1.5 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: MergeSemantics(
              child: InkWell(
                onTap: () => context.read<CartModel>().toggle(product),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ProductThumb(icon: product.icon),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              product.description,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatMoney(product.priceCents),
                              style: const TextStyle(
                                color: AppColors.price,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: selected,
                        onChanged: (_) =>
                            context.read<CartModel>().toggle(product),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ContinueBar extends StatelessWidget {
  const _ContinueBar();

  @override
  Widget build(BuildContext context) {
    final ready = context.watch<CartModel>().isReady;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                // Sin argumentos de ruta: el resumen lee el ChangeNotifier.
                onPressed: ready
                    ? () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SummaryScreen(),
                        ),
                      )
                    : null,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Continuar'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ready ? Icons.lock_open_outlined : Icons.lock_outline,
                    size: 14,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      ready
                          ? 'Selección lista'
                          : 'Selecciona exactamente 3 productos para continuar',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
