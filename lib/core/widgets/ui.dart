import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/models/user.dart';
import 'package:gobarber/providers/auth_provider.dart';
import 'package:gobarber/providers/locale_provider.dart';

Widget box(Widget child,
        {EdgeInsets p = const EdgeInsets.all(16), Color? border, VoidCallback? onTap}) =>
    Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: C.card, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border ?? C.el)),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(16), onTap: onTap,
              child: Padding(padding: p, child: child))),
    );

Widget pill(String t, Color c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c.withValues(alpha: .15), borderRadius: BorderRadius.circular(99)),
      child: Text(t.toUpperCase(),
          style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: .5)),
    );

Widget avatar(String name, {double r = 24}) => CircleAvatar(
    radius: r, backgroundColor: C.el,
    child: Text(name.isEmpty ? '?' : name[0],
        style: const TextStyle(color: C.amberHi, fontWeight: FontWeight.w700)));

Widget stat(String l, String v) => Expanded(
    child: box(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l, style: muted),
          const SizedBox(height: 4),
          Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        ]),
        p: const EdgeInsets.all(12)));

Color statusColor(Status s) => switch (s) {
      Status.confirmed => C.amber,
      Status.checkedIn => C.blue,
      Status.completed => C.ok,
      Status.cancelled => C.err,
    };

String statusLabel(AppLocalizations l, Status s) => switch (s) {
      Status.confirmed => l.statusConfirmed,
      Status.checkedIn => l.statusCheckedIn,
      Status.completed => l.statusCompleted,
      Status.cancelled => l.statusCancelled,
    };

String roleLabel(AppLocalizations l, Role r) => switch (r) {
      Role.customer => l.roleCustomer,
      Role.employee => l.roleEmployee,
      Role.owner => l.roleOwner,
      Role.platformAdmin => l.rolePlatformAdmin,
    };

/// Chevron icons that point the right way in both LTR and RTL layouts.
IconData chevronBack(BuildContext c) =>
    Directionality.of(c) == TextDirection.rtl ? Icons.chevron_right : Icons.chevron_left;
IconData chevronForward(BuildContext c) =>
    Directionality.of(c) == TextDirection.rtl ? Icons.chevron_left : Icons.chevron_right;

class LanguageMenu extends StatelessWidget {
  const LanguageMenu({super.key});
  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
        tooltip: context.l10n.language,
        icon: const Icon(Icons.language),
        onSelected: (v) => context.read<LocaleProvider>().set(Locale(v)),
        itemBuilder: (_) => [
          PopupMenuItem(value: 'fr', child: Text(context.l10n.languageFr)),
          PopupMenuItem(value: 'ar', child: Text(context.l10n.languageAr)),
        ],
      );
}

AppBar bar(BuildContext c, String title) => AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      actions: [
        const LanguageMenu(),
        IconButton(
            tooltip: c.l10n.signOut,
            icon: const Icon(Icons.logout),
            onPressed: () => c.read<AuthProvider>().signOut()),
      ],
    );
