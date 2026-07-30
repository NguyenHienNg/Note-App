import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/note_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/app_router.dart';
import 'i18n/strings.g.dart';
import 'services/diagnostics_service.dart';

String gAppLanguageCode = 'sys';

Future<void> initLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('app_language');
  gAppLanguageCode = savedLang ?? 'sys';
  
  if (savedLang == null || savedLang == 'sys') {
    LocaleSettings.useDeviceLocale();
  } else {
    LocaleSettings.setLocaleRaw(savedLang);
  }
}

void main() {
  // Bọc trong runZonedGuarded để bắt uncaught async errors
  // QUAN TRỌNG: ensureInitialized() và runApp() phải cùng zone
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Khởi tạo dữ liệu định dạng ngày tháng cho intl
      await initializeDateFormatting();

      // Khởi tạo DiagnosticsService (no-op trong release mode)
      DiagnosticsService.instance.initialize();

      // FIX: Lock orientation — tránh layout thrashing khi xoay máy
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // FIX: Edge-to-edge — Flutter không cần tính toán lại layout khi system bars thay đổi
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // Thiết lập ngôn ngữ ban đầu qua slang LocaleSettings
      await initLanguage();

      runApp(TranslationProvider(child: const MyApp()));
    },
    (error, stackTrace) {
      // Ghi lỗi không được bắt vào nhật ký chẩn đoán
      DiagnosticsService.instance.log(
        level: LogLevel.error,
        source: 'Uncaught Zone Error',
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // FIX: Tắt toàn bộ hoạt ảnh (kể cả bottom sheet, dialog...)
          // Nếu tắt, chỉnh tốc độ animation cực kỳ nhanh (coi như không có)
          timeDilation = themeProvider.enableAnimations ? 1.0 : 0.0001;

          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              ColorScheme lightColorScheme;
              ColorScheme darkColorScheme;

              if (themeProvider.themeColor == AppThemeColor.system &&
                  lightDynamic != null &&
                  darkDynamic != null) {
                // Hỗ trợ màu hệ thống (Material You - Android 12+)
                // Kiểm tra độ bão hòa màu (saturation) để tránh màu xám đục từ hình nền
                final lightHsv = HSVColor.fromColor(lightDynamic.primary);
                final darkHsv = HSVColor.fromColor(darkDynamic.primary);

                final lightSeed = lightHsv.saturation < 0.15
                    ? Colors.indigo
                    : lightDynamic.primary;
                final darkSeed = darkHsv.saturation < 0.15
                    ? Colors.indigo
                    : darkDynamic.primary;

                lightColorScheme = ColorScheme.fromSeed(
                  seedColor: lightSeed,
                  brightness: Brightness.light,
                );
                darkColorScheme = ColorScheme.fromSeed(
                  seedColor: darkSeed,
                  brightness: Brightness.dark,
                );
              } else {
                const seedColors = {
                  AppThemeColor.red: Colors.red,
                  AppThemeColor.green: Colors.green,
                  AppThemeColor.blue: Colors.blue,
                  AppThemeColor.brown: Colors.brown,
                  AppThemeColor.purple: Colors.purple,
                  AppThemeColor.yellow: Colors.yellow,
                  AppThemeColor.orange: Colors.orange,
                  AppThemeColor.system: Colors.indigo,
                };
                final seedColor =
                    seedColors[themeProvider.themeColor] ?? Colors.indigo;

                lightColorScheme = ColorScheme.fromSeed(
                  seedColor: seedColor,
                  brightness: Brightness.light,
                );
                darkColorScheme = ColorScheme.fromSeed(
                  seedColor: seedColor,
                  brightness: Brightness.dark,
                );
              }

              return MaterialApp.router(
                routerConfig: appRouter,
                title: 'Note',
                debugShowCheckedModeBanner: false,
                themeMode: themeProvider.themeMode,
                theme: _buildTheme(
                  lightColorScheme,
                  themeProvider.enableAnimations,
                ),
                darkTheme: _buildTheme(
                  darkColorScheme,
                  themeProvider.enableAnimations,
                ),
              );
            },
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(ColorScheme colorScheme, bool enableAnimations) {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
      // Sử dụng phông chữ hệ thống theo HĐH/hãng máy (Note: không phải hệ điều hành nào cũng có font riêng)
      fontFamilyFallback: const [
        'sans-serif',
        'Roboto',
        '.SF UI Text',
        '.SF UI Display',
        'Segoe UI',
      ],
      // Hiệu ứng hạt đặc trưng của Material You (InkSparkle)
      splashFactory: enableAnimations
          ? InkSparkle.splashFactory
          : NoSplash.splashFactory,
      highlightColor: enableAnimations ? null : Colors.transparent,
      splashColor: enableAnimations ? null : Colors.transparent,
    );
  }
}
