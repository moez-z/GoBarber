import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/config/app_config.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/data/memory/memory_repositories.dart';
import 'package:gobarber/data/repositories.dart';
import 'package:gobarber/features/auth/login_screen.dart';
import 'package:gobarber/features/customer/customer_shell.dart';
import 'package:gobarber/features/employee/employee_shell.dart';
import 'package:gobarber/features/owner/owner_shell.dart';
import 'package:gobarber/features/platform_admin/platform_admin_shell.dart';
import 'package:gobarber/models/user.dart';
import 'package:gobarber/providers/appointment_provider.dart';
import 'package:gobarber/providers/auth_provider.dart';
import 'package:gobarber/providers/catalog_provider.dart';
import 'package:gobarber/providers/locale_provider.dart';

/// The repositories the app runs on. Swap this factory for Firebase repositories in Phase 3.
class AppDependencies {
  AppDependencies({required this.auth, required this.catalog, required this.appointments});
  final AuthRepository auth;
  final CatalogRepository catalog;
  final AppointmentRepository appointments;

  factory AppDependencies.memory() {
    final db = MemoryDb();
    return AppDependencies(
        auth: MemoryAuthRepository(db),
        catalog: MemoryCatalogRepository(db),
        appointments: MemoryAppointmentRepository(db));
  }

  factory AppDependencies.fromConfig() {
    if (AppConfig.useMockData) return AppDependencies.memory();
    throw StateError('Firebase repositories are not implemented yet (Phase 2/3). Use USE_MOCK_DATA=true.');
  }
}

class GoBarberApp extends StatelessWidget {
  const GoBarberApp({super.key, required this.deps, this.useGoogleFonts = true});
  final AppDependencies deps;
  final bool useGoogleFonts;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider(deps.auth)),
          ChangeNotifierProvider(create: (_) => CatalogProvider(deps.catalog)..load()),
          ChangeNotifierProvider(create: (_) => AppointmentProvider(deps.appointments)..load()),
        ],
        child: _AppView(useGoogleFonts: useGoogleFonts),
      );
}

class _AppView extends StatelessWidget {
  const _AppView({required this.useGoogleFonts});
  final bool useGoogleFonts;

  @override
  Widget build(BuildContext context) {
    final chosen = context.watch<LocaleProvider>().locale;
    final code = chosen?.languageCode ?? WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final lang = code == 'ar' ? 'ar' : 'fr';
    return MaterialApp(
      title: 'GoBarber',
      debugShowCheckedModeBanner: false,
      theme: appTheme(lang, googleFonts: useGoogleFonts),
      locale: chosen,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (locale, supported) {
        for (final s in supported) {
          if (s.languageCode == locale?.languageCode) return s;
        }
        return const Locale('fr');
      },
      home: const _Gate(),
    );
  }
}

/// Shows a loader while data loads, then routes by role (customer / employee / owner / platformAdmin).
/// Hiding screens is NOT security: real authorization is enforced by Firestore rules in Phase 3.
class _Gate extends StatelessWidget {
  const _Gate();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final cat = context.watch<CatalogProvider>();
    final ap = context.watch<AppointmentProvider>();
    if (!(cat.loaded && ap.loaded)) {
      final err = cat.error ?? ap.error;
      return Scaffold(
        body: Center(
          child: err == null
              ? const CircularProgressIndicator()
              : Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(errorText(context.l10n, err)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: () {
                        cat.load();
                        ap.load();
                      },
                      child: Text(context.l10n.retry)),
                ]),
        ),
      );
    }
    return switch (user?.role) {
      null => const LoginScreen(),
      Role.customer => const CustomerShell(),
      Role.employee => const EmployeeShell(),
      Role.owner => const OwnerShell(),
      Role.platformAdmin => const PlatformAdminShell(),
    };
  }
}
