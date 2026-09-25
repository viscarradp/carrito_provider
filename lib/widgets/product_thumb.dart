import 'package:flutter/material.dart';

import '../theme.dart';

class ProductThumb extends StatelessWidget {
  const ProductThumb({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.navy, size: 28),
    );
  }
}
