import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gobarber/app.dart';
import 'package:gobarber/core/widgets/ui.dart';
import 'package:gobarber/features/auth/login_screen.dart';
import 'package:gobarber/features/customer/customer_shell.dart';
import 'package:gobarber/features/owner/owner_shell.dart';
import 'package:gobarber/features/platform_admin/platform_admin_shell.dart';

Widget app() => GoBarberApp(deps: AppDependencies.memory(), useGoogleFonts: false);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr');
    await initializeDateFormatting('ar');
  });

  testWidgets('login screen shows the brand and switches to Arabic RTL', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.text('GoBarber'), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(LoginScreen))), TextDirection.ltr);

    await tester.tap(find.byType(LanguageMenu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    expect(Directionality.of(tester.element(find.byType(LoginScreen))), TextDirection.rtl);
  });

  testWidgets('demo accounts open the matching role interface', (tester) async {
    // Tall surface so every demo chip is on screen (the default 800x600 hides some).
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Client'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomerShell), findsOneWidget);

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Propriétaire'));
    await tester.pumpAndSettle();
    expect(find.byType(OwnerShell), findsOneWidget);

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Admin plateforme'));
    await tester.pumpAndSettle();
    expect(find.byType(PlatformAdminShell), findsOneWidget);
  });
}
