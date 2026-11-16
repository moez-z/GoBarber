import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store.dart';
import 'theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final name = TextEditingController(), email = TextEditingController(), pw = TextEditingController();
  bool reg = false;
  String? err;

  void submit() {
    final s = context.read<Store>();
    final ok = reg ? s.register(name.text, email.text, pw.text) : s.login(email.text, pw.text);
    if (!ok) {
      setState(() => err = reg
          ? 'Check your details (valid email, 6+ char password, email not already used).'
          : 'Wrong email or password.');
    }
  }

  void demo(String e, String p) => setState(() {
        reg = false;
        email.text = e;
        pw.text = p;
        err = null;
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Icon(Icons.content_cut, size: 48, color: C.amber),
                  const SizedBox(height: 8),
                  const Text('GoBarber', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -1)),
                  const Text('Book your chair. Run your day.', textAlign: TextAlign.center, style: muted),
                  const SizedBox(height: 28),
                  if (reg) ...[
                    TextField(controller: name, decoration: const InputDecoration(hintText: 'Full name')),
                    const SizedBox(height: 12),
                  ],
                  TextField(controller: email, keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email')),
                  const SizedBox(height: 12),
                  TextField(controller: pw, obscureText: true,
                      decoration: const InputDecoration(hintText: 'Password')),
                  if (err != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(err!, style: const TextStyle(color: C.err))),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: submit, child: Text(reg ? 'Create account' : 'Sign in')),
                  TextButton(
                      onPressed: () => setState(() { reg = !reg; err = null; }),
                      child: Text(reg ? 'I already have an account' : 'New customer? Create an account')),
                  const SizedBox(height: 16),
                  const Text('DEMO ACCOUNTS', textAlign: TextAlign.center,
                      style: TextStyle(color: C.muted, fontSize: 11, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Wrap(alignment: WrapAlignment.center, spacing: 8, children: [
                    ActionChip(label: const Text('Customer'),
                        onPressed: () => demo('customer@gobarber.com', 'customer123')),
                    ActionChip(label: const Text('Barber'),
                        onPressed: () => demo('marcus@gobarber.com', 'barber123')),
                    ActionChip(label: const Text('Admin'),
                        onPressed: () => demo('admin@gobarber.com', 'admin123')),
                  ]),
                ]),
              ),
            ),
          ),
        ),
      );
}
