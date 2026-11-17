import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/format/date_format.dart';
import 'package:gobarber/core/format/money.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/core/widgets/ui.dart';
import 'package:gobarber/features/customer/book_screen.dart';
import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/providers/appointment_provider.dart';
import 'package:gobarber/providers/auth_provider.dart';
import 'package:gobarber/providers/catalog_provider.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ap = context.watch<AppointmentProvider>();
    final cat = context.watch<CatalogProvider>();
    final me = context.watch<AuthProvider>().user!;
    final now = DateTime.now();
    final all = ap.forCustomer(me.id);
    final up = all
        .where((a) => a.status != Status.cancelled && a.status != Status.completed && a.end.isAfter(now))
        .toList();
    final past = all.where((a) => !up.contains(a)).toList().reversed.toList();
    return DefaultTabController(
      length: 2,
      child: Column(children: [
        TabBar(indicatorColor: C.amber, tabs: [
          Tab(text: l.tabUpcoming(up.length)),
          Tab(text: l.tabPast(past.length)),
        ]),
        Expanded(
          child: TabBarView(children: [
            ListView(padding: const EdgeInsets.all(16), children: [
              if (up.isEmpty) Center(child: Text(l.noUpcoming, style: muted)),
              for (final a in up)
                box(
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      pill(l.confirmedSession, C.amber),
                      const SizedBox(height: 8),
                      Text(whenLabel(l, a.start),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(l.sessionDetails(a.serviceName, a.minutes, formatTnd(a.priceMillimes, l.localeName)),
                          style: muted),
                      Text(l.withBarber(a.barberName), style: muted),
                      const SizedBox(height: 12),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: C.err, side: const BorderSide(color: C.err)),
                          onPressed: () => ap.setStatus(a, Status.cancelled),
                          child: Text(l.cancelAppointment)),
                    ]),
                    border: C.amber.withValues(alpha: .4)),
            ]),
            ListView(padding: const EdgeInsets.all(16), children: [
              if (past.isEmpty) Center(child: Text(l.noHistory, style: muted)),
              for (final a in past)
                box(Row(children: [
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${a.serviceName} • ${formatTnd(a.priceMillimes, l.localeName)}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('${a.barberName} • ${fmtDate('d MMM y', a.start, l.localeName)}', style: muted),
                    const SizedBox(height: 6),
                    pill(statusLabel(l, a.status), statusColor(a.status)),
                  ])),
                  if (cat.barberById(a.barberId) != null)
                    SizedBox(
                        width: 110,
                        child: ElevatedButton(
                            onPressed: () {
                              final sv = cat.services.where((x) => x.id == a.serviceId);
                              openBooking(context, cat.barberById(a.barberId)!, sv.isEmpty ? null : sv.first);
                            },
                            child: Text(l.rebook, textAlign: TextAlign.center))),
                ])),
            ]),
          ]),
        ),
      ]),
    );
  }
}
