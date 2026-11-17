import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/core/format/date_format.dart';
import 'package:gobarber/core/format/money.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/core/widgets/ui.dart';
import 'package:gobarber/models/barber.dart';
import 'package:gobarber/models/service.dart';
import 'package:gobarber/providers/appointment_provider.dart';
import 'package:gobarber/providers/auth_provider.dart';
import 'package:gobarber/providers/catalog_provider.dart';

void openBooking(BuildContext c, Barber b, [Service? s]) =>
    Navigator.push(c, MaterialPageRoute(builder: (_) => BookScreen(barber: b, initial: s)));

class BookScreen extends StatefulWidget {
  const BookScreen({super.key, required this.barber, this.initial});
  final Barber barber;
  final Service? initial;
  @override
  State<BookScreen> createState() => _BookState();
}

class _BookState extends State<BookScreen> {
  Service? svc;
  late DateTime day;
  DateTime? slot;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    day = DateTime(n.year, n.month, n.day);
    svc = widget.initial;
  }

  Widget step(int n, String t) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(children: [
        CircleAvatar(
            radius: 11, backgroundColor: C.amber,
            child: Text('$n', style: const TextStyle(color: C.bg, fontSize: 12, fontWeight: FontWeight.w700))),
        const SizedBox(width: 8),
        Text(t, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ]));

  Future<void> confirm() async {
    final l = context.l10n;
    final m = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final b = widget.barber, s = svc!, at = slot!;
    final me = context.read<AuthProvider>().user!;
    setState(() => saving = true);
    try {
      await context.read<AppointmentProvider>().book(customer: me, barber: b, service: s, start: at);
      m.showSnackBar(SnackBar(content: Text(l.booked(whenLabel(l, at), b.name))));
      nav.pop();
    } on AppException catch (e) {
      m.showSnackBar(SnackBar(content: Text(errorText(l, e.code))));
      if (mounted) setState(() { saving = false; slot = null; });
    } catch (_) {
      m.showSnackBar(SnackBar(content: Text(errorText(l, ErrorCode.unknown))));
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cat = context.watch<CatalogProvider>();
    final ap = context.watch<AppointmentProvider>();
    final b = widget.barber;
    svc ??= cat.services.isEmpty ? null : cat.services.first;
    final free = svc == null ? <DateTime>[] : ap.slots(b, day, svc!.minutes);
    final n = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: Text(b.name)),
      body: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [
        step(1, l.selectService),
        for (final v in cat.services)
          box(
              Row(children: [
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(v.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('${l.minutesShort(v.minutes)}${v.desc.isEmpty ? '' : ' • ${v.desc}'}', style: muted),
                ])),
                Text(formatTnd(v.priceMillimes, l.localeName),
                    style: const TextStyle(color: C.amberHi, fontWeight: FontWeight.w700)),
                const SizedBox(width: 10),
                Icon(svc?.id == v.id ? Icons.check_circle : Icons.circle_outlined,
                    color: svc?.id == v.id ? C.amber : C.muted),
              ]),
              border: svc?.id == v.id ? C.amber : null,
              onTap: () => setState(() { svc = v; slot = null; })),
        step(2, l.chooseDate),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 14,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, k) {
              final d = DateTime(n.year, n.month, n.day + k), sel = d == day;
              return GestureDetector(
                onTap: () => setState(() { day = d; slot = null; }),
                child: Container(
                  width: 56,
                  decoration: BoxDecoration(
                      color: sel ? C.amber : C.card, borderRadius: BorderRadius.circular(12)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(fmtDate('EEE', d, l.localeName).toUpperCase(),
                        style: TextStyle(fontSize: 11, color: sel ? C.bg : C.muted)),
                    Text('${d.day}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: sel ? C.bg : C.text)),
                  ]),
                ),
              );
            },
          ),
        ),
        step(3, l.availableTime),
        if (free.isEmpty)
          Text(l.noOpenings, style: muted)
        else
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final t in free)
              ChoiceChip(
                label: Text(hm(t)),
                selected: slot == t,
                showCheckmark: false,
                selectedColor: C.amber,
                backgroundColor: C.card,
                labelStyle: TextStyle(color: slot == t ? C.bg : C.text, fontWeight: FontWeight.w600),
                onSelected: (_) => setState(() => slot = t),
              ),
          ]),
        const SizedBox(height: 24),
      ]),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: slot == null || svc == null || saving ? null : confirm,
            child: Text(slot == null || svc == null
                ? l.pickATime
                : l.confirmBooking(formatTnd(svc!.priceMillimes, l.localeName), whenLabel(l, slot!))),
          ),
        ),
      ),
    );
  }
}
