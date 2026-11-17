import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/format/date_format.dart';
import 'package:gobarber/core/format/money.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/core/widgets/ui.dart';
import 'package:gobarber/features/customer/book_screen.dart';
import 'package:gobarber/providers/appointment_provider.dart';
import 'package:gobarber/providers/auth_provider.dart';
import 'package:gobarber/providers/catalog_provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreState();
}

class _ExploreState extends State<ExploreScreen> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cat = context.watch<CatalogProvider>();
    final ap = context.watch<AppointmentProvider>();
    final me = context.watch<AuthProvider>().user!;
    final list = cat.barbers
        .where((b) => '${b.name} ${b.specialty} ${b.shop}'.toLowerCase().contains(q.toLowerCase()))
        .toList();
    final from = cat.cheapestPriceMillimes ?? 0;
    final minutes = cat.shortestServiceMinutes ?? 30;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text(l.hello(me.name.split(' ').first).toUpperCase(),
          style: const TextStyle(color: C.amberHi, fontSize: 12, fontWeight: FontWeight.w600)),
      Text(l.findBarber,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -.8)),
      const SizedBox(height: 16),
      TextField(
          onChanged: (v) => setState(() => q = v),
          decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.searchHint)),
      const SizedBox(height: 20),
      for (final b in list)
        box(Column(children: [
          Row(children: [
            avatar(b.name, r: 28),
            const SizedBox(width: 12),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(b.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              Text('${b.specialty} • ${b.shop}', style: muted),
              Text(l.rating(b.rating.toStringAsFixed(1), b.reviews),
                  style: const TextStyle(color: C.amberHi, fontSize: 13)),
            ])),
            Flexible(
                child: Text(l.fromPrice(formatTnd(from, l.localeName)),
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: C.amberHi, fontWeight: FontWeight.w600))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: Builder(builder: (_) {
              final next = ap.nextSlot(b, minutes);
              return Text(next == null ? l.fullyBooked : l.nextSlot(whenLabel(l, next)), style: muted);
            })),
            SizedBox(
                width: 140,
                child: ElevatedButton(
                    onPressed: () => openBooking(context, b), child: Text(l.viewSlots))),
          ]),
        ])),
      if (list.isEmpty) Center(child: Text(l.noBarber, style: muted)),
    ]);
  }
}
