import 'package:flutter/material.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/core/widgets/ui.dart';

/// Placeholder: platform administration (shop approval, moderation, analytics) is built in Phase 9.
class PlatformAdminShell extends StatelessWidget {
  const PlatformAdminShell({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: bar(context, context.l10n.platformTitle),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.admin_panel_settings_outlined, size: 56, color: C.amber),
              const SizedBox(height: 16),
              Text(context.l10n.platformSoon, textAlign: TextAlign.center, style: muted),
            ]),
          ),
        ),
      );
}
