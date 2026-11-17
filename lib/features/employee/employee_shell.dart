import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/format/date_format.dart';
import 'package:gobarber/core/format/money.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/core/widgets/ui.dart';
import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/providers/appointment_provider.dart';
import 'package:gobarber/providers/auth_provider.dart';
import 'package:gobarber/providers/catalog_provider.dart';

/// Employee / barber: their own daily schedule.
class EmployeeShell extends StatefulWidget {
  const EmployeeShell({super.key});
  @override
  State<EmployeeShell> createState() => _EmployeeShellState();
}

class _EmployeeShellState extends State<EmployeeShell> {
  DateTime day = DateTime.now();
  void shift(int n) => setState(() => day = DateTime(day.year, day.month, day.day + n));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = context.watch<AuthProvider>().user!;
    final b = context.watch<CatalogProvider>().barberForUser(me.id);
    final ap = context.watch<AppointmentProvider>();
    if (b == null) {
      return Scaffold(
          appBar: bar(context, l.mySchedule),
          body: Center(child: Text(l.noBarberProfile, style: muted)));
    }
    final list = ap.forBarberDay(b.id, day);
    final total = list.fold<int>(0, (a, x) => a + x.priceMillimes);
    final next = list
        .where((a) => a.status == Status.confirmed || a.status == Status.checkedIn)
        .firstOrNull;
    String money(int v) => formatTnd(v, l.localeName);
    return Scaffold(
      appBar: bar(context, l.mySchedule),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        box(
            Row(children: [
              IconButton(icon: Icon(chevronBack(context)), onPressed: () => shift(-1)),
              Expanded(
                  child: Column(children: [
                Text(fmtDate('EEEE d MMMM', day, l.localeName),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                Text(b.name, style: muted),
              ])),
              IconButton(icon: Icon(chevronForward(context)), onPressed: () => shift(1)),
            ]),
            p: const EdgeInsets.all(8)),
        Row(children: [
          stat(l.statBooked, l.nClients(list.length)),
          const SizedBox(width: 8),
          stat(l.statEstDaily, money(total)),
          const SizedBox(width: 8),
          stat(l.statOpenings, '${ap.slots(b, day, 30).length}'),
        ]),
        if (next != null)
          box(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                pill(next.status == Status.checkedIn ? l.inTheChair : l.nextInChair, C.amber),
                const SizedBox(height: 10),
                Text(next.customerName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text('${next.serviceName} • ${money(next.priceMillimes)}', style: muted),
                Text('${hm(next.start)} — ${hm(next.end)} (${l.minutesShort(next.minutes)})', style: muted),
                const SizedBox(height: 14),
                Row(children: [
                  if (next.status == Status.confirmed) ...[
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () => ap.setStatus(next, Status.checkedIn),
                            child: Text(l.checkIn))),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () => ap.setStatus(next, Status.completed),
                          child: Text(l.complete))),
                ]),
              ]),
              border: C.amber),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.timeline, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
        if (list.isEmpty)
          Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(l.noAppointmentsDay, style: muted))),
        for (final a in list)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: 64,
                child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(hm(a.start),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: a.status == Status.completed ? C.muted : C.amberHi)))),
            Expanded(
                child: Opacity(
              opacity: a.status == Status.completed ? .6 : 1,
              child: box(
                  Row(children: [
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(a.customerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      Text('${a.serviceName} • ${money(a.priceMillimes)}', style: muted),
                    ])),
                    pill(statusLabel(l, a.status), statusColor(a.status)),
                    if (a.status == Status.confirmed || a.status == Status.checkedIn)
                      PopupMenuButton<Status>(
                        onSelected: (v) => ap.setStatus(a, v),
                        itemBuilder: (_) => [
                          PopupMenuItem(value: Status.checkedIn, child: Text(l.checkIn)),
                          PopupMenuItem(value: Status.completed, child: Text(l.complete)),
                          PopupMenuItem(value: Status.cancelled, child: Text(l.cancel)),
                        ],
                      ),
                  ]),
                  p: const EdgeInsets.all(12)),
            )),
          ]),
      ]),
    );
  }
}
