import 'package:flutter/material.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/widgets/ui.dart';
import 'package:gobarber/features/customer/appointments_screen.dart';
import 'package:gobarber/features/customer/explore_screen.dart';

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});
  @override
  State<CustomerShell> createState() => _CShellState();
}

class _CShellState extends State<CustomerShell> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: bar(context, i == 0 ? 'GoBarber' : l.titleAppointments),
      body: i == 0 ? const ExploreScreen() : const AppointmentsScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: i,
        onDestinationSelected: (v) => setState(() => i = v),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.explore_outlined), label: l.navExplore),
          NavigationDestination(icon: const Icon(Icons.confirmation_number_outlined), label: l.navAppointments),
        ],
      ),
    );
  }
}
