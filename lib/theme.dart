import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'store.dart';

class C {
  static const bg = Color(0xFF090D16), card = Color(0xFF111827), el = Color(0xFF1E293B);
  static const amber = Color(0xFFF59E0B), amberHi = Color(0xFFFFC174), text = Color(0xFFF8FAFC);
  static const muted = Color(0xFF94A3B8), ok = Color(0xFF10B981), err = Color(0xFFEF4444);
  static const blue = Color(0xFF8FD5FF);
}

const muted = TextStyle(color: C.muted, fontSize: 13);

ThemeData appTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  OutlineInputBorder ob(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: c));
  return base.copyWith(
    scaffoldBackgroundColor: C.bg,
    colorScheme: const ColorScheme.dark(primary: C.amber, onPrimary: C.bg, surface: C.card, error: C.err),
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(bodyColor: C.text, displayColor: C.text),
    appBarTheme: const AppBarTheme(backgroundColor: C.bg, elevation: 0, scrolledUnderElevation: 0),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: C.card, indicatorColor: C.amber.withOpacity(.2)),
    inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: const Color(0xFF0D131F),
        border: ob(C.el), enabledBorder: ob(C.el), focusedBorder: ob(C.amber)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: C.amber, foregroundColor: C.bg,
            disabledBackgroundColor: C.el, minimumSize: const Size.fromHeight(48),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            foregroundColor: C.text, side: const BorderSide(color: Color(0xFF334155)),
            minimumSize: const Size.fromHeight(48), shape: const StadiumBorder())),
  );
}

Widget box(Widget child,
        {EdgeInsets p = const EdgeInsets.all(16), Color? border, VoidCallback? onTap}) =>
    Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: C.card, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border ?? C.el)),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(16), onTap: onTap,
              child: Padding(padding: p, child: child))),
    );

Widget pill(String t, Color c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c.withOpacity(.15), borderRadius: BorderRadius.circular(99)),
      child: Text(t.toUpperCase(),
          style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: .5)),
    );

Widget avatar(String name, {double r = 24}) => CircleAvatar(
    radius: r, backgroundColor: C.el,
    child: Text(name.isEmpty ? '?' : name[0],
        style: const TextStyle(color: C.amberHi, fontWeight: FontWeight.w700)));

Widget stat(String l, String v) => Expanded(
    child: box(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l, style: muted),
          const SizedBox(height: 4),
          Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        ]),
        p: const EdgeInsets.all(12)));

String money(num n) => '\$${n.toStringAsFixed(0)}';
String hm(DateTime d) => DateFormat('h:mm a').format(d);

String when(DateTime d) {
  final n = DateTime.now();
  final diff = DateTime(d.year, d.month, d.day).difference(DateTime(n.year, n.month, n.day)).inDays;
  return diff == 0 ? 'Today, ${hm(d)}'
      : diff == 1 ? 'Tomorrow, ${hm(d)}'
      : '${DateFormat('EEE, MMM d').format(d)}, ${hm(d)}';
}

Color statusColor(Status s) => switch (s) {
      Status.confirmed => C.amber,
      Status.checkedIn => C.blue,
      Status.completed => C.ok,
      Status.cancelled => C.err,
    };

String statusLabel(Status s) => s == Status.checkedIn ? 'In chair' : s.name;

AppBar bar(BuildContext c, String title) => AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      actions: [
        IconButton(
            tooltip: 'Sign out', icon: const Icon(Icons.logout),
            onPressed: () => c.read<Store>().logout()),
      ],
    );
