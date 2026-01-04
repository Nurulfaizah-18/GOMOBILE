import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage for persistent data
  await LocalStorageService.init();

  // Initialize locale data for date formatting
  await initializeDateFormatting('id_ID', null);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GOMOBILE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      home: const SplashPage(),
    );
  }
}
