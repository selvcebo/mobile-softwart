import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  final String? mensaje;
  const LoadingWidget({super.key, this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          if (mensaje != null) ...[
            const SizedBox(height: 12),
            Text(mensaje!, style: const TextStyle(color: AppColors.muted)),
          ],
        ],
      ),
    );
  }
}
