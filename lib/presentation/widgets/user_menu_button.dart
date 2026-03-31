import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

/// Botón de usuario en el AppBar — muestra nombre/correo y opción de logout.
class UserMenuButton extends StatelessWidget {
  const UserMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().usuario;
    final inicial = (usuario?.nombre ?? 'U')[0].toUpperCase();

    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'logout') {
          await context.read<AuthProvider>().logout();
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        }
      },
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                usuario?.nombre ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                usuario?.correo ?? '',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 16, color: AppColors.destructive),
              SizedBox(width: 8),
              Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: AppColors.destructive,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white.withValues(alpha: 0.25),
          child: Text(
            inicial,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
