import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/note_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'i18n/strings.g.dart';

Future<String> getInitialLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('app_language');
  if (savedLang == null || savedLang == 'sys') {
    String deviceLang = window.locale.languageCode;
    if (deviceLang != 'vi' && deviceLang != 'en') {
      deviceLang = 'en';
    }
    return deviceLang;
  } else {
    return savedLang;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Thiết lập ngôn ngữ ban đầu dựa trên thiết bị hoặc SharedPreferences
  final initialLanguage = await getInitialLanguage();
  if (initialLanguage == 'vi') {
    LocaleSettings.setLocale(AppLocale.vi);
  } else {
    LocaleSettings.setLocale(AppLocale.en);
  }

  runApp(
    TranslationProvider(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng MultiProvider để cung cấp nhiều trạng thái cho ứng dụng
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Note',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = ThemeData(
      brightness: brightness,
      colorSchemeSeed: Colors.indigo,
      useMaterial3: true,
    );
    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
    );
  }
}