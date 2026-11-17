import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/core/format/date_format.dart';
import 'package:gobarber/core/format/money.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/core/widgets/ui.dart';
import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/models/user.dart';
import 'package:gobarber/providers/appointment_provider.dart';
import 'package:gobarber/providers/catalog_provider.dart';
import 'package:gobarber/providers/auth_provider.dart';

/// Returns the entered values (trimmed) when the user taps "Add", otherwise null.
Future<List<String>?> ask(BuildContext c, String title, List<String> labels) {
  final ctl = labels.map((_) => TextEditingController()).toList();
  final l = c.l10n;
  return showDialog<List<String>>(
    context: c,
    builder: (ctx) => AlertDialog(
      backgroundColor: C.el,
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (var i = 0; i < labels.length; i++)
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(controller: ctl[i], decoration: InputDecoration(hintText: labels[i]))),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
        TextButton(
            onPressed: () => Navigator.pop(ctx, ctl.map((e) => e.text.trim()).toList()),
            child: Text(l.add)),
      ],
    ),
  );
}

/// Shop owner (the former "admin" screens). Single-shop for now; multi-shop arrives in Phase 4.
class OwnerShell extends StatefulWidget {
  const OwnerShell({super.key});
  @override
  State<OwnerShell> createState() => _OwnerState();
}

class _OwnerState extends State<OwnerShell> {
  int i = 0;

  Future<void> run(Future<void> Function() action) async {
    final m = ScaffoldMessenger.of(context);
    final l = context.l10n;
    try {
      await action();
    } on AppException catch (e) {
      m.showSnackBar(SnackBar(content: Text(errorText(l, e.code))));
    } catch (_) {
      m.showSnackBar(SnackBar(content: Text(errorText(l, ErrorCode.unknown))));
    }
  }

  Future<void> add() async {
    final l = context.l10n;
    final cat = context.read<CatalogProvider>();
    if (i == 1) {
      final v = await ask(context, l.newBarber, [l.fieldName, l.email, l.fieldSpecialty, l.fieldShop]);
      if (v == null) return;
      await run(() => cat.addBarber(name: v[0], email: v[1], specialty: v[2], shop: v[3]));
    } else {
      final v = await ask(context, l.newService, [l.fieldName, l.fieldMinutes, l.fieldPrice]);
      if (v == null) return;
      final minutes = int.tryParse(latinDigits(v[1])), price = parseTndToMillimes(v[2]);
      if (minutes == null || price == null) {
        await run(() async => throw const AppException(ErrorCode.invalidInput));
        return;
      }
      await run(() => cat.addService(name: v[0], minutes: minutes, priceMillimes: price));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cat = context.watch<CatalogProvider>();
    final ap = context.watch<AppointmentProvider>();
    final auth = context.watch<AuthProvider>();
    String money(int v) => formatTnd(v, l.localeName);
    final live = ap.all.where((a) => a.status != Status.cancelled);
    final revenue = ap.all.where((a) => a.status == Status.completed).fold<int>(0, (a, x) => a + x.priceMillimes);
    final recent = (ap.all.toList()..sort((a, b) => b.start.compareTo(a.start))).take(20);
    final pages = [
      ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          stat(l.statBarbers, '${cat.barbers.length}'),
          const SizedBox(width: 8),
          stat(l.statBookings, '${live.length}'),
        ]),
        Row(children: [
          stat(l.statCustomers, '${ap.all.map((a) => a.customerId).toSet().length}'),
          const SizedBox(width: 8),
          stat(l.statRevenue, money(revenue)),
        ]),
        Text(l.latestAppointments, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        for (final a in recent)
          box(
              Row(children: [
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${a.customerName} → ${a.barberName}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('${a.serviceName} • ${fmtDate('d MMM', a.start, l.localeName)}, ${hm(a.start)}', style: muted),
                ])),
                pill(statusLabel(l, a.status), statusColor(a.status)),
              ]),
              p: const EdgeInsets.all(12)),
      ]),
      ListView(padding: const EdgeInsets.all(16), children: [
        for (final b in cat.barbers)
          box(Row(children: [
            avatar(b.name),
            const SizedBox(width: 12),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(b.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${b.specialty} • ${b.shop}', style: muted),
            ])),
            IconButton(
                icon: const Icon(Icons.delete_outline, color: C.err),
                onPressed: () => run(() async {
                      await cat.removeBarber(b);
                      await ap.load();
                    })),
          ])),
      ]),
      ListView(padding: const EdgeInsets.all(16), children: [
        for (final v in cat.services)
          box(Row(children: [
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(v.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(l.minutesShort(v.minutes), style: muted),
            ])),
            Text(money(v.priceMillimes), style: const TextStyle(color: C.amberHi, fontWeight: FontWeight.w700)),
            IconButton(
                icon: const Icon(Icons.delete_outline, color: C.err),
                onPressed: () => run(() => cat.removeService(v))),
          ])),
      ]),
    ];
    return Scaffold(
      appBar: bar(context, auth.user?.role == Role.owner ? l.ownerTitle : 'GoBarber'),
      body: pages[i],
      floatingActionButton: i == 0
          ? null
          : FloatingActionButton(
              backgroundColor: C.amber, foregroundColor: C.bg, onPressed: add, child: const Icon(Icons.add)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: i,
        onDestinationSelected: (v) => setState(() => i = v),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.dashboard_outlined), label: l.navOverview),
          NavigationDestination(icon: const Icon(Icons.content_cut), label: l.navBarbers),
          NavigationDestination(icon: const Icon(Icons.list_alt), label: l.navServices),
        ],
      ),
    );
  }
}
