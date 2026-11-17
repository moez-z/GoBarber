import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gobarber/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr');
  await initializeDateFormatting('ar');
  runApp(GoBarberApp(deps: AppDependencies.fromConfig()));
}
