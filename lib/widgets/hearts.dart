import 'package:flutter/material.dart';

import '../config/tokens.dart';
import '../game/rules.dart';

class Hearts extends StatelessWidget {
  const Hearts({required this.count, required this.label, super.key});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < GameRules.hearts; i++)
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Icon(
                i < count ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: i < count ? AppColors.danger : AppColors.faint,
                size: 22,
              ),
            ),
        ],
      ),
    );
  }
}
