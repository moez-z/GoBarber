import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'store.dart';
import 'theme.dart';

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});
  @override
  State<CustomerShell> createState() => _CShellState();
}

class _CShellState extends State<CustomerShell> {
  int i = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: bar(context, i == 0 ? 'GoBarber' : 'My appointments'),
        body: i == 0 ? const ExploreScreen() : const AppointmentsScreen(),
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: (v) => setState(() => i = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Explore'),
            NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), label: 'Appointments'),
          ],
        ),
      );
}

void openBooking(BuildContext c, Barber b, [Service? s]) => Navigator.push(
    c, MaterialPageRoute(builder: (_) => BookScreen(barber: b, initial: s)));

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreState();
}

class _ExploreState extends State<ExploreScreen> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final s = context.watch<Store>();
    final list = s.barbers
        .where((b) => '${b.name} ${b.specialty} ${b.shop}'.toLowerCase().contains(q.toLowerCase()))
        .toList();
    final from = s.services.isEmpty ? 0 : s.services.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('HELLO, ${s.me!.name.split(' ').first.toUpperCase()}',
          style: const TextStyle(color: C.amberHi, fontSize: 12, fontWeight: FontWeight.w600)),
      const Text('Find your barber',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -.8)),
      const SizedBox(height: 16),
      TextField(
          onChanged: (v) => setState(() => q = v),
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search barber or shop...')),
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
              Text('★ ${b.rating} (${b.reviews} reviews)',
                  style: const TextStyle(color: C.amberHi, fontSize: 13)),
            ])),
            Text('From ${money(from)}',
                style: const TextStyle(color: C.amberHi, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: Text(
                    s.nextSlot(b.id) == null ? 'Fully booked this week' : 'Next: ${when(s.nextSlot(b.id)!)}',
                    style: muted)),
            SizedBox(
                width: 130,
                child: ElevatedButton(onPressed: () => openBooking(context, b), child: const Text('View slots'))),
          ]),
        ])),
      if (list.isEmpty) const Center(child: Text('No barber found.', style: muted)),
    ]);
  }
}

class BookScreen extends StatefulWidget {
  final Barber barber;
  final Service? initial;
  const BookScreen({super.key, required this.barber, this.initial});
  @override
  State<BookScreen> createState() => _BookState();
}

class _BookState extends State<BookScreen> {
  Service? svc;
  late DateTime day;
  DateTime? slot;

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
        CircleAvatar(radius: 11, backgroundColor: C.amber,
            child: Text('$n', style: const TextStyle(color: C.bg, fontSize: 12, fontWeight: FontWeight.w700))),
        const SizedBox(width: 8),
        Text(t, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ]));

  @override
  Widget build(BuildContext context) {
    final s = context.watch<Store>(), b = widget.barber;
    svc ??= s.services.isEmpty ? null : s.services.first;
    final free = svc == null ? <DateTime>[] : s.slots(b.id, day, svc!.minutes);
    final n = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: Text(b.name)),
      body: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [
        step(1, 'Select service'),
        for (final v in s.services)
          box(
              Row(children: [
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(v.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('${v.minutes} min${v.desc.isEmpty ? '' : ' • ${v.desc}'}', style: muted),
                ])),
                Text(money(v.price), style: const TextStyle(color: C.amberHi, fontWeight: FontWeight.w700)),
                const SizedBox(width: 10),
                Icon(svc == v ? Icons.check_circle : Icons.circle_outlined,
                    color: svc == v ? C.amber : C.muted),
              ]),
              border: svc == v ? C.amber : null,
              onTap: () => setState(() { svc = v; slot = null; })),
        step(2, 'Choose date'),
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
                    Text(DateFormat('EEE').format(d).toUpperCase(),
                        style: TextStyle(fontSize: 11, color: sel ? C.bg : C.muted)),
                    Text('${d.day}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: sel ? C.bg : C.text)),
                  ]),
                ),
              );
            },
          ),
        ),
        step(3, 'Available time'),
        if (free.isEmpty)
          const Text('No openings on this day.', style: muted)
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
            onPressed: slot == null || svc == null ? null : () {
              final m = ScaffoldMessenger.of(context);
              final ok = context.read<Store>().book(b.id, svc!, slot!);
              m.showSnackBar(SnackBar(content: Text(ok ? 'Booked ${when(slot!)} with ${b.name}' : 'That slot was just taken.')));
              if (ok) { Navigator.pop(context); } else { setState(() => slot = null); }
            },
            child: Text(slot == null ? 'Pick a time' : 'Confirm • ${money(svc!.price)} • ${when(slot!)}'),
          ),
        ),
      ),
    );
  }
}

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<Store>(), now = DateTime.now();
    final all = s.mine();
    final up = all.where((a) => a.status != Status.cancelled && a.status != Status.completed && a.end.isAfter(now)).toList();
    final past = all.where((a) => !up.contains(a)).toList().reversed.toList();
    return DefaultTabController(
      length: 2,
      child: Column(children: [
        TabBar(indicatorColor: C.amber, tabs: [Tab(text: 'Upcoming (${up.length})'), Tab(text: 'Past (${past.length})')]),
        Expanded(
          child: TabBarView(children: [
            ListView(padding: const EdgeInsets.all(16), children: [
              if (up.isEmpty) const Center(child: Text('No upcoming appointments.', style: muted)),
              for (final a in up)
                box(
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      pill('Confirmed session', C.amber),
                      const SizedBox(height: 8),
                      Text(when(a.start), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${a.serviceName} • ${a.minutes} min • ${money(a.price)} (at desk)', style: muted),
                      Text('with ${a.barberName}', style: muted),
                      const SizedBox(height: 12),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(foregroundColor: C.err, side: const BorderSide(color: C.err)),
                          onPressed: () => s.setStatus(a, Status.cancelled),
                          child: const Text('Cancel appointment')),
                    ]),
                    border: C.amber.withOpacity(.4)),
            ]),
            ListView(padding: const EdgeInsets.all(16), children: [
              if (past.isEmpty) const Center(child: Text('No history yet.', style: muted)),
              for (final a in past)
                box(Row(children: [
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${a.serviceName} • ${money(a.price)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('${a.barberName} • ${DateFormat('MMM d, y').format(a.start)}', style: muted),
                    const SizedBox(height: 6),
                    pill(statusLabel(a.status), statusColor(a.status)),
                  ])),
                  if (s.barbers.any((b) => b.id == a.barberId))
                    SizedBox(
                        width: 90,
                        child: ElevatedButton(
                            onPressed: () {
                              final sv = s.services.where((x) => x.id == a.serviceId);
                              openBooking(context, s.barber(a.barberId), sv.isEmpty ? null : sv.first);
                            },
                            child: const Text('Rebook'))),
                ])),
            ]),
          ]),
        ),
      ]),
    );
  }
}
