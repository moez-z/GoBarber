import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/core/l10n_ext.dart';
import 'package:gobarber/core/theme/app_theme.dart';
import 'package:gobarber/providers/auth_provider.dart';

/// Persistent reminder for real users whose e-mail is not verified yet. It never blocks anything.
class VerificationBanner extends StatefulWidget {
  const VerificationBanner({super.key});
  @override
  State<VerificationBanner> createState() => _VerificationBannerState();
}

class _VerificationBannerState extends State<VerificationBanner> {
  String? note;
  bool busy = false;

  Future<void> resend() async {
    final l = context.l10n;
    final auth = context.read<AuthProvider>();
    setState(() => busy = true);
    final ok = await auth.resendVerification(languageCode: l.localeName);
    if (!mounted) return;
    setState(() {
      busy = false;
      note = ok ? l.verifySent : errorText(l, auth.error ?? ErrorCode.unknown);
    });
  }

  Future<void> refresh() async {
    final l = context.l10n;
    final auth = context.read<AuthProvider>();
    setState(() => busy = true);
    final verified = await auth.refreshUser();
    if (!mounted) return;
    setState(() {
      busy = false;
      note = verified ? null : l.verifyNotYet;
    });
  }

  @override
  Widget build(BuildContext context) {
    final u = context.watch<AuthProvider>().user;
    if (u == null || u.isDemo || u.emailVerified) return const SizedBox.shrink();
    final l = context.l10n;
    return Material(
      color: const Color(0xFF2A2110),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.mark_email_unread_outlined, color: C.amberHi, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(l.verifyBanner(u.email), style: const TextStyle(fontSize: 13))),
            ]),
            if (note != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(note!, style: muted)),
            Wrap(children: [
              TextButton(onPressed: busy ? null : resend, child: Text(l.verifyResend)),
              TextButton(onPressed: busy ? null : refresh, child: Text(l.verifyRefresh)),
            ]),
          ]),
        ),
      ),
    );
  }
}
