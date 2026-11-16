import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin.dart';
import 'barber.dart';
import 'customer.dart';
import 'login.dart';
import 'models.dart';
import 'store.dart';
import 'theme.dart';

void main() => runApp(ChangeNotifierProvider(create: (_) => Store(), child: const App()));

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'GoBarber',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        home: Consumer<Store>(
            builder: (_, s, __) => switch (s.me?.role) {
                  null => const LoginScreen(),
                  Role.customer => const CustomerShell(),
                  Role.barber => const BarberShell(),
                  Role.admin => const AdminShell(),
                }),
      );
}
