import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/core/widgets/ui.dart';
import 'package:gobarber/models/user.dart';
import 'package:gobarber/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final name = TextEditingController(), email = TextEditingController(), pw = TextEditingController();
  bool reg = false;
  ErrorCode? err;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pw.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final auth = context.read<AuthProvider>();
    final ok = reg
        ? await auth.register(name.text, email.text, pw.text)
        : await auth.signIn(email.text, pw.text);
    if (!ok && mounted) setState(() => err = auth.error);
  }

  Future<void> demo(Role r) async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.signInDemo(r);
    if (!ok && mounted) setState(() => err = auth.error);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Align(alignment: AlignmentDirectional.centerEnd, child: LanguageMenu()),
                const Icon(Icons.content_cut, size: 48, color: C.amber),
                const SizedBox(height: 8),
                const Text('GoBarber', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -1)),
                Text(l.tagline, textAlign: TextAlign.center, style: muted),
                const SizedBox(height: 28),
                if (reg) ...[
                  TextField(controller: name, decoration: InputDecoration(hintText: l.fullName)),
                  const SizedBox(height: 12),
                ],
                TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(hintText: l.email)),
                const SizedBox(height: 12),
                TextField(
                    controller: pw,
                    obscureText: true,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(hintText: l.password)),
                if (err != null)
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(errorText(l, err!), style: const TextStyle(color: C.err))),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: auth.busy ? null : submit,
                    child: Text(reg ? l.createAccount : l.signIn)),
                TextButton(
                    onPressed: () => setState(() { reg = !reg; err = null; }),
                    child: Text(reg ? l.haveAccount : l.newCustomer)),
                if (auth.supportsDemo) ...[
                  const SizedBox(height: 16),
                  Text(l.demoAccounts, textAlign: TextAlign.center,
                      style: const TextStyle(color: C.muted, fontSize: 11, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Wrap(alignment: WrapAlignment.center, spacing: 8, children: [
                    for (final r in Role.values)
                      ActionChip(label: Text(roleLabel(l, r)), onPressed: () => demo(r)),
                  ]),
                ],
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
