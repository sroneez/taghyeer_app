// Location: lib/main.dart

import 'package:flutter/material.dart';
import 'core/storage/prefs_helper.dart';
import 'core/storage/hive_service.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PrefsHelper.init();
  await HiveService.init();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taghyeer Tech Assignment',
      theme: ThemeData.light(),
      home: const Scaffold(body: Center(child: Text('Setup Complete!'))),
    );
  }
}