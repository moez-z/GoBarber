import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gobarber/app.dart';
import 'package:gobarber/core/widgets/ui.dart';
import 'package:gobarber/data/auth/backend_auth_repository.dart';
import 'package:gobarber/features/auth/login_screen.dart';
import 'package:gobarber/features/customer/customer_shell.dart';
import 'package:gobarber/features/owner/owner_shell.dart';
import 'package:gobarber/features/platform_admin/platform_admin_shell.dart';
import 'support/fake_auth_backend.dart';

Widget app({FakeAuthBackend? backend, bool? demoEnabled}) => GoBarberApp(
      deps: AppDependencies.memory(auth: backend == null ? null : BackendAuthRepository(backend)),
      useGoogleFonts: false,
      demoEnabled: demoEnabled,
    );

void tallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr');
    await initializeDateFormatting('ar');
  });

  testWidgets('login screen shows the brand and switches to Arabic RTL', (tester) async {
    tallScreen(tester);
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

  testWidgets('debug demo accounts open the matching role interface', (tester) async {
    tallScreen(tester);
    await tester.pumpWidget(app(demoEnabled: true));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Client'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomerShell), findsOneWidget);
    expect(find.textContaining('Vérifiez votre e-mail'), findsNothing); // demo users get no banner

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

  testWidgets('demo accounts are hidden when demo mode is off (release behaviour)', (tester) async {
    tallScreen(tester);
    await tester.pumpWidget(app(demoEnabled: false));
    await tester.pumpAndSettle();
    expect(find.text('Client'), findsNothing);
    expect(find.text('Propriétaire'), findsNothing);
  });

  testWidgets('real sign-in opens the customer interface and shows the verification banner', (tester) async {
    tallScreen(tester);
    final backend = FakeAuthBackend()..seed(email: 'ali@example.com', password: 'Passw0rd1', name: 'Ali');
    await tester.pumpWidget(app(backend: backend, demoEnabled: false));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'ali@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'Passw0rd1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
    await tester.pumpAndSettle();

    expect(find.byType(CustomerShell), findsOneWidget);
    expect(find.textContaining('Vérifiez votre e-mail'), findsOneWidget);
  });

  testWidgets('wrong password shows an error and stays on the login screen', (tester) async {
    tallScreen(tester);
    final backend = FakeAuthBackend()..seed(email: 'ali@example.com', password: 'Passw0rd1');
    await tester.pumpWidget(app(backend: backend, demoEnabled: false));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'ali@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'nope');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Se connecter'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('E-mail ou mot de passe incorrect.'), findsOneWidget);
  });

  testWidgets('registration validates the password policy, then creates a customer', (tester) async {
    tallScreen(tester);
    final backend = FakeAuthBackend();
    await tester.pumpWidget(app(backend: backend, demoEnabled: false));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Nouveau client'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Sami Trabelsi');
    await tester.enterText(find.byType(TextField).at(1), 'sami@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'abcdefgh'); // no digit
    await tester.tap(find.widgetWithText(ElevatedButton, 'Créer un compte'));
    await tester.pumpAndSettle();
    expect(find.text('Ajoutez au moins une lettre et un chiffre.'), findsOneWidget);
    expect(backend.accountCount, 0);

    await tester.enterText(find.byType(TextField).at(2), 'Passw0rd1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Créer un compte'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomerShell), findsOneWidget);
    expect(backend.verificationsSent, ['sami@example.com']);
  });

  testWidgets('forgot password sends a neutral confirmation', (tester) async {
    tallScreen(tester);
    final backend = FakeAuthBackend()..seed(email: 'ali@example.com', password: 'Passw0rd1');
    await tester.pumpWidget(app(backend: backend, demoEnabled: false));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mot de passe oublié ?'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'ali@example.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Envoyer le lien'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Si un compte existe'), findsOneWidget);
    expect(backend.resetsSent, ['ali@example.com']);
  });
}
