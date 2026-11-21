import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/core/validation/field_error_text.dart';
import 'package:gobarber/core/validation/validators.dart';
import 'package:gobarber/providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});
  final String initialEmail;
  @override
  State<ForgotPasswordScreen> createState() => _ForgotState();
}

class _ForgotState extends State<ForgotPasswordScreen> {
  late final TextEditingController email = TextEditingController(text: widget.initialEmail);
  FieldError? emailErr;
  ErrorCode? err;
  bool sent = false;

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  Future<void> send() async {
    final l = context.l10n;
    final auth = context.read<AuthProvider>();
    final e = validateEmail(email.text);
    if (e != null) {
      setState(() {
        emailErr = e;
        err = null;
        sent = false;
      });
      return;
    }
    setState(() {
      emailErr = null;
      err = null;
    });
    final ok = await auth.sendPasswordReset(email.text, languageCode: l.localeName);
    if (!mounted) return;
    setState(() {
      sent = ok;
      err = ok ? null : auth.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final busy = context.watch<AuthProvider>().busy;
    return Scaffold(
      appBar: AppBar(title: Text(l.resetTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(l.resetIntro, style: muted),
                const SizedBox(height: 16),
                TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                        hintText: l.email,
                        errorText: emailErr == null ? null : fieldErrorText(l, emailErr!))),
                if (err != null)
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(errorText(l, err!), style: const TextStyle(color: C.err))),
                if (sent)
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(l.resetSent, style: const TextStyle(color: C.ok))),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: busy ? null : send, child: Text(l.resetSend)),
                TextButton(onPressed: () => Navigator.pop(context), child: Text(l.backToSignIn)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
