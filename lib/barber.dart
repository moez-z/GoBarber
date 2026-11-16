import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'store.dart';
import 'theme.dart';

class BarberShell extends StatefulWidget {
  const BarberShell({super.key});
  @override
  State<BarberShell> createState() => _BarberShellState();
}

class _BarberShellState extends State<BarberShell> {
  DateTime day = DateTime.now();
  void shift(int n) => setState(() => day = DateTime(day.year, day.month, day.day + n));

  @override
  Widget build(BuildContext context) {
    final s = context.watch<Store>(), b = s.myBarber;
    final list = s.dayAppts(b.id, day);
    final total = list.fold<double>(0, (a, x) => a + x.price);
    final active = list.where((a) => a.status == Status.confirmed || a.status == Status.checkedIn);
    final next = active.firstOrNull;
    return Scaffold(
      appBar: bar(context, 'My schedule'),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        box(
            Row(children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => shift(-1)),
              Expanded(
                  child: Column(children: [
                Text(DateFormat('EEEE, MMM d').format(day),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                Text(b.name, style: muted),
              ])),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => shift(1)),
            ]),
            p: const EdgeInsets.all(8)),
        Row(children: [
          stat('Booked', '${list.length} clients'),
          const SizedBox(width: 8),
          stat('Est. daily', money(total)),
          const SizedBox(width: 8),
          stat('Openings', '${s.slots(b.id, day, 30).length}'),
        ]),
        if (next != null)
          box(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                pill(next.status == Status.checkedIn ? 'In the chair' : 'Next in chair', C.amber),
                const SizedBox(height: 10),
                Text(next.customerName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text('${next.serviceName} • ${money(next.price)}', style: muted),
                Text('${hm(next.start)} — ${hm(next.end)} (${next.minutes}m)', style: muted),
                const SizedBox(height: 14),
                Row(children: [
                  if (next.status == Status.confirmed) ...[
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () => s.setStatus(next, Status.checkedIn), child: const Text('Check-in'))),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () => s.setStatus(next, Status.completed), child: const Text('Complete'))),
                ]),
              ]),
              border: C.amber),
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Timeline agenda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
        if (list.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No appointments this day.', style: muted))),
        for (final a in list)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: 64,
                child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(hm(a.start),
                        style: TextStyle(fontWeight: FontWeight.w600,
                            color: a.status == Status.completed ? C.muted : C.amberHi)))),
            Expanded(
                child: Opacity(
              opacity: a.status == Status.completed ? .6 : 1,
              child: box(
                  Row(children: [
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(a.customerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      Text('${a.serviceName} • ${money(a.price)}', style: muted),
                    ])),
                    pill(statusLabel(a.status), statusColor(a.status)),
                    if (a.status == Status.confirmed || a.status == Status.checkedIn)
                      PopupMenuButton<Status>(
                        onSelected: (v) => s.setStatus(a, v),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: Status.checkedIn, child: Text('Check-in')),
                          PopupMenuItem(value: Status.completed, child: Text('Complete')),
                          PopupMenuItem(value: Status.cancelled, child: Text('Cancel')),
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
