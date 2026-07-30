import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Cấp độ log
enum LogLevel {
  info,
  warning,
  error,
}

/// Một entry trong nhật ký chẩn đoán
class DiagnosticEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String source;
  final String message;
  final String? stackTrace;

  DiagnosticEntry({
    required this.timestamp,
    required this.level,
    required this.source,
    required this.message,
    this.stackTrace,
  });

  String get formattedTime =>
      DateFormat('dd/MM/yyyy – HH:mm:ss').format(timestamp);

  String get levelLabel {
    switch (level) {
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
    }
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln('[$levelLabel] $formattedTime');
    sb.writeln('Source: $source');
    sb.writeln('Message: $message');
    if (stackTrace != null && stackTrace!.isNotEmpty) {
      sb.writeln('StackTrace:');
      sb.writeln(stackTrace);
    }
    return sb.toString();
  }
}

/// Service singleton quản lý nhật ký chẩn đoán.
/// Chỉ hoạt động trong chế độ debug/profile.
/// Trong release, mọi phương thức đều là no-op.
class DiagnosticsService {
  DiagnosticsService._internal();
  static final DiagnosticsService _instance = DiagnosticsService._internal();
  static DiagnosticsService get instance => _instance;

  final List<DiagnosticEntry> _entries = [];
  static const int _maxEntries = 500;
  bool _initialized = false;

  /// Kiểm tra xem tính năng có được bật không (chỉ bật ở debug/profile)
  static bool get isEnabled => !kReleaseMode;

  /// Danh sách các entry (bản sao để tránh mutation bên ngoài)
  List<DiagnosticEntry> get entries => List.unmodifiable(_entries);

  /// Số lượng entry hiện tại
  int get count => _entries.length;

  /// Khởi tạo service: bắt Flutter errors và uncaught zone errors
  void initialize() {
    if (!isEnabled || _initialized) return;
    _initialized = true;

    // Bắt lỗi framework Flutter (render, layout, build, v.v.)
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      log(
        level: LogLevel.error,
        source: 'Flutter Framework',
        message: details.exceptionAsString(),
        stackTrace: details.stack?.toString(),
      );
      // Vẫn gọi handler gốc để không làm mất thông tin trên console
      originalOnError?.call(details);
    };

    log(
      level: LogLevel.info,
      source: 'DiagnosticsService',
      message: 'Diagnostics initialized (mode: ${kDebugMode ? "debug" : "profile"})',
    );
  }

  /// Ghi một entry vào nhật ký
  void log({
    required LogLevel level,
    required String source,
    required String message,
    String? stackTrace,
  }) {
    if (!isEnabled) return;

    final entry = DiagnosticEntry(
      timestamp: DateTime.now(),
      level: level,
      source: source,
      message: message,
      stackTrace: stackTrace,
    );

    _entries.add(entry);

    // Giới hạn số entry tối đa
    if (_entries.length > _maxEntries) {
      _entries.removeRange(0, _entries.length - _maxEntries);
    }
  }

  /// Trích xuất logcat (Android) — chỉ lấy log gần đây liên quan đến app
  Future<String?> fetchLogcat({int lines = 200}) async {
    if (!isEnabled) return null;

    try {
      if (Platform.isAndroid) {
        final result = await Process.run(
          'logcat',
          ['-d', '-t', '$lines', '-v', 'time'],
        );
        if (result.exitCode == 0) {
          return result.stdout as String;
        }
      }
    } catch (e) {
      log(
        level: LogLevel.warning,
        source: 'DiagnosticsService',
        message: 'Failed to fetch logcat: $e',
      );
    }
    return null;
  }

  /// Xuất toàn bộ nhật ký thành chuỗi text
  String exportAsText() {
    if (_entries.isEmpty) return '';

    final sb = StringBuffer();
    sb.writeln('=== Diagnostics Log ===');
    sb.writeln('Exported: ${DateFormat('dd/MM/yyyy – HH:mm:ss').format(DateTime.now())}');
    sb.writeln('Total entries: ${_entries.length}');
    sb.writeln('Mode: ${kDebugMode ? "debug" : "profile"}');
    sb.writeln('========================');
    sb.writeln();

    for (final entry in _entries) {
      sb.writeln(entry.toString());
      sb.writeln('---');
    }

    return sb.toString();
  }

  /// Xóa toàn bộ nhật ký
  void clear() {
    _entries.clear();
  }
}
