import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'store.dart';
import 'theme.dart';

Future<List<String>?> ask(BuildContext c, String title, List<String> labels) {
  final ctl = labels.map((_) => TextEditingController()).toList();
  return showDialog<List<String>>(
    context: c,
    builder: (_) => AlertDialog(
      backgroundColor: C.el,
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (var i = 0; i < labels.length; i++)
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                    controller: ctl[i],
                    obscureText: labels[i] == 'Password',
                    decoration: InputDecoration(hintText: labels[i]))),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
        TextButton(
            onPressed: () => Navigator.pop(c, ctl.map((e) => e.text.trim()).toList()),
            child: const Text('Add')),
      ],
    ),
  );
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminState();
}

class _AdminState extends State<AdminShell> {
  int i = 0;

  Future<void> add(Store s) async {
    if (i == 1) {
      final v = await ask(context, 'New barber', ['Name', 'Email', 'Password', 'Specialty', 'Shop']);
      if (v != null && v[0].isNotEmpty && v[1].contains('@') && v[2].length >= 6) {
        s.addBarber(v[0], v[1], v[2], v[3], v[4]);
      }
    } else {
      final v = await ask(context, 'New service', ['Name', 'Minutes', 'Price']);
      final m = int.tryParse(v?[1] ?? ''), p = double.tryParse(v?[2] ?? '');
      if (v != null && v[0].isNotEmpty && m != null && p != null) s.addService(v[0], m, p);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<Store>();
    final live = s.appts.where((a) => a.status != Status.cancelled);
    final revenue = s.appts.where((a) => a.status == Status.completed).fold<double>(0, (a, x) => a + x.price);
    final recent = (s.appts.toList()..sort((a, b) => b.start.compareTo(a.start))).take(20);
    final pages = [
      ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [
          stat('Customers', '${s.users.where((u) => u.role == Role.customer).length}'),
          const SizedBox(width: 8),
          stat('Barbers', '${s.barbers.length}'),
        ]),
        Row(children: [
          stat('Bookings', '${live.length}'),
          const SizedBox(width: 8),
          stat('Revenue', money(revenue)),
        ]),
        const Text('Latest appointments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        for (final a in recent)
          box(
              Row(children: [
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${a.customerName} → ${a.barberName}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('${a.serviceName} • ${DateFormat('MMM d').format(a.start)}, ${hm(a.start)}', style: muted),
                ])),
                pill(statusLabel(a.status), statusColor(a.status)),
              ]),
              p: const EdgeInsets.all(12)),
      ]),
      ListView(padding: const EdgeInsets.all(16), children: [
        for (final b in s.barbers)
          box(Row(children: [
            avatar(b.name),
            const SizedBox(width: 12),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(b.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${b.specialty} • ${b.shop}', style: muted),
            ])),
            IconButton(icon: const Icon(Icons.delete_outline, color: C.err), onPressed: () => s.removeBarber(b)),
          ])),
      ]),
      ListView(padding: const EdgeInsets.all(16), children: [
        for (final v in s.services)
          box(Row(children: [
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(v.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${v.minutes} min', style: muted),
            ])),
            Text(money(v.price), style: const TextStyle(color: C.amberHi, fontWeight: FontWeight.w700)),
            IconButton(icon: const Icon(Icons.delete_outline, color: C.err), onPressed: () => s.removeService(v)),
          ])),
      ]),
    ];
    return Scaffold(
      appBar: bar(context, 'Admin'),
      body: pages[i],
      floatingActionButton: i == 0
          ? null
          : FloatingActionButton(
              backgroundColor: C.amber, foregroundColor: C.bg,
              onPressed: () => add(s), child: const Icon(Icons.add)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: i,
        onDestinationSelected: (v) => setState(() => i = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Overview'),
          NavigationDestination(icon: Icon(Icons.content_cut), label: 'Barbers'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Services'),
        ],
      ),
    );
  }
}
