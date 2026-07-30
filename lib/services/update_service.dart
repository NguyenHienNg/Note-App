import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateInfo {
  final bool hasUpdate;
  final String currentVersion;
  final String latestVersion;
  final int buildNumber;
  final String downloadUrl;
  final String releaseDate;
  final Map<String, dynamic> changelog;

  UpdateInfo({
    required this.hasUpdate,
    required this.currentVersion,
    required this.latestVersion,
    required this.buildNumber,
    required this.downloadUrl,
    required this.releaseDate,
    required this.changelog,
  });
}

class DownloadProgress {
  final int receivedBytes;
  final int totalBytes;
  final int progressPercent;
  final String formattedSpeed;
  final String? filePath;
  final bool isCompleted;

  DownloadProgress({
    required this.receivedBytes,
    required this.totalBytes,
    required this.progressPercent,
    required this.formattedSpeed,
    this.filePath,
    this.isCompleted = false,
  });
}

class UpdateService {
  UpdateService._internal();
  static final UpdateService instance = UpdateService._internal();

  static const String apiUrl = 'https://api.nngh.workers.dev';
  static const String channelKey = 'app_update_channel';

  /// Đọc kênh cập nhật (stable / beta)
  Future<String> getUpdateChannel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(channelKey) ?? 'stable';
  }

  /// Lưu kênh cập nhật
  Future<void> setUpdateChannel(String channel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(channelKey, channel);
  }

  /// Đọc chuỗi version gốc từ pubspec.yaml asset
  Future<String> _readPubspecVersion() async {
    try {
      final content = await rootBundle.loadString('pubspec.yaml');
      final line = content
          .split('\n')
          .firstWhere((l) => l.trim().startsWith('version:'), orElse: () => '');
      if (line.isNotEmpty) {
        return line.split(':').last.trim();
      }
    } catch (_) {}
    return '';
  }

  /// Kiểm tra bản cập nhật mới từ Cloudflare Worker API
  Future<UpdateInfo> checkUpdate() async {
    // Đọc version gốc từ pubspec.yaml để biết chính xác có +N hay không
    final pubspecVersion = await _readPubspecVersion();
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    // Nếu pubspec không có dấu +, build number thực tế = 0
    // (Android mặc định trả buildNumber=1 dù pubspec không ghi +N)
    final int currentBuildNumber;
    if (pubspecVersion.contains('+')) {
      final buildStr = pubspecVersion.split('+').last.split('-').first.trim();
      currentBuildNumber = int.tryParse(buildStr) ?? 0;
    } else {
      currentBuildNumber = 0;
    }

    final channel = await getUpdateChannel();
    final response = await http
        .get(
          Uri.parse('$apiUrl?channel=$channel'),
          headers: {'Cache-Control': 'no-cache'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final latestVersionRaw = (data['latest_version'] as String? ?? '').trim();
    final buildNumber = (data['build_number'] as int?) ?? 0;
    final downloadUrl = data['download_url'] as String? ?? '';
    final releaseDate = data['release_date'] as String? ?? '';
    final changelog = (data['changelog'] as Map<String, dynamic>?) ?? {};

    // Chuẩn hóa chuỗi phiên bản (ví dụ "1.0.2-beta+1" -> "1.0.2")
    final latestVersionClean =
        latestVersionRaw.split('-').first.split('+').first.trim();
    final currentVersionClean =
        currentVersion.split('-').first.split('+').first.trim();

    final isLatestPreRelease = latestVersionRaw.contains('-');
    final isCurrentPreRelease = pubspecVersion.contains('-');

    bool hasUpdate = false;
    if (_isVersionNewer(latestVersionClean, currentVersionClean)) {
      hasUpdate = true;
    } else if (latestVersionClean == currentVersionClean) {
      if (!isCurrentPreRelease && isLatestPreRelease) {
        // Bản hiện tại là Stable (1.0.1) mà API là Beta (1.0.1-beta...) -> Không cần cập nhật
        hasUpdate = false;
      } else if (isCurrentPreRelease && !isLatestPreRelease) {
        // Bản hiện tại là Beta (1.0.1-beta) mà API đã ra Stable (1.0.1) -> Nâng cấp lên Stable
        hasUpdate = true;
      } else if (buildNumber > currentBuildNumber) {
        // Cả 2 cùng loại (cùng Stable hoặc cùng Beta) và số bản dựng trên API lớn hơn
        hasUpdate = true;
      }
    }

    return UpdateInfo(
      hasUpdate: hasUpdate,
      currentVersion: currentVersion,
      latestVersion: latestVersionRaw,
      buildNumber: buildNumber,
      downloadUrl: downloadUrl,
      releaseDate: releaseDate,
      changelog: changelog,
    );
  }

  /// Tải file APK với stream đếm tiến trình % và đo tốc độ mạng
  Stream<DownloadProgress> downloadApk(String url) async* {
    final client = http.Client();
    IOSink? sink;
    bool isCompleted = false;
    File? file;

    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final totalBytes = response.contentLength ?? 0;
      int receivedBytes = 0;

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/app-update.apk';
      file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

      sink = file.openWrite();

      final stopwatch = Stopwatch()..start();
      int lastCheckTimeMs = stopwatch.elapsedMilliseconds;
      int bytesSinceLastCheck = 0;
      String currentSpeedStr = '0.0 MB/s';

      await for (final chunk in response.stream) {
        sink.add(chunk);
        receivedBytes += chunk.length;
        bytesSinceLastCheck += chunk.length;

        final nowMs = stopwatch.elapsedMilliseconds;
        final timeDiffMs = nowMs - lastCheckTimeMs;

        if (timeDiffMs >= 500) {
          final speedBytesPerSec =
              (bytesSinceLastCheck / (timeDiffMs / 1000.0));
          if (speedBytesPerSec >= 1024 * 1024) {
            currentSpeedStr =
                '${(speedBytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s';
          } else {
            currentSpeedStr =
                '${(speedBytesPerSec / 1024).toStringAsFixed(0)} KB/s';
          }
          bytesSinceLastCheck = 0;
          lastCheckTimeMs = nowMs;
        }

        final percent = totalBytes > 0
            ? ((receivedBytes / totalBytes) * 100).toInt()
            : 0;
        yield DownloadProgress(
          receivedBytes: receivedBytes,
          totalBytes: totalBytes,
          progressPercent: percent,
          formattedSpeed: currentSpeedStr,
        );
      }

      isCompleted = true;
      stopwatch.stop();

      yield DownloadProgress(
        receivedBytes: receivedBytes,
        totalBytes: totalBytes,
        progressPercent: 100,
        formattedSpeed: currentSpeedStr,
        filePath: filePath,
        isCompleted: true,
      );
    } finally {
      await sink?.close();
      client.close();
      if (!isCompleted && file != null && await file.exists()) {
        await file.delete();
      }
    }
  }

  /// Kiểm tra xem đã có quyền cài đặt APK không xác định chưa
  Future<bool> isInstallPermissionGranted() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    final status = await Permission.requestInstallPackages.status;
    return status.isGranted;
  }

  /// Mở Cài đặt hệ thống Android để xin quyền Cài đặt ứng dụng không xác định
  Future<bool> requestInstallPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    final status = await Permission.requestInstallPackages.request();
    return status.isGranted;
  }

  /// Lấy file APK tạm đã tải về trong thư mục temp
  Future<File?> getDownloadedApkFile() async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/app-update.apk');
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  /// Lấy dung lượng file APK đã tải về (MB)
  Future<double> getDownloadedApkSizeMB() async {
    final file = await getDownloadedApkFile();
    if (file != null) {
      final bytes = await file.length();
      return bytes / (1024 * 1024);
    }
    return 0.0;
  }

  /// Xóa file APK cài đặt tạm
  Future<bool> deleteDownloadedApk() async {
    final file = await getDownloadedApkFile();
    if (file != null) {
      await file.delete();
      return true;
    }
    return false;
  }

  /// Kiểm tra tính toàn vẹn của file APK đã tải về
  Future<bool> verifyApkIntegrity(File file) async {
    try {
      if (!await file.exists()) return false;
      final length = await file.length();
      // File APK hợp lệ phải có dung lượng > 1MB và có Zip header (PK\x03\x04)
      if (length < 1024 * 1024) return false;

      final bytes = await file.openRead(0, 4).first;
      if (bytes.length >= 4 &&
          bytes[0] == 0x50 && // P
          bytes[1] == 0x4B && // K
          bytes[2] == 0x03 &&
          bytes[3] == 0x04) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Mở trình cài đặt APK hệ thống
  Future<bool> installApkFile(String filePath) async {
    if (kIsWeb || !Platform.isAndroid) return false;
    final result = await OpenFilex.open(filePath);
    return result.type == ResultType.done;
  }

  /// Helper so sánh Semantic Versioning (v1 > v2)
  bool _isVersionNewer(String v1, String v2) {
    try {
      final cleanV1 = v1.split('-').first.split('+').first.trim();
      final cleanV2 = v2.split('-').first.split('+').first.trim();

      final parts1 = cleanV1
          .split('.')
          .map((e) => int.tryParse(RegExp(r'\d+').stringMatch(e) ?? '') ?? 0)
          .toList();
      final parts2 = cleanV2
          .split('.')
          .map((e) => int.tryParse(RegExp(r'\d+').stringMatch(e) ?? '') ?? 0)
          .toList();

      final maxLength =
          parts1.length > parts2.length ? parts1.length : parts2.length;
      for (int i = 0; i < maxLength; i++) {
        final p1 = i < parts1.length ? parts1[i] : 0;
        final p2 = i < parts2.length ? parts2[i] : 0;
        if (p1 > p2) return true;
        if (p1 < p2) return false;
      }
    } catch (_) {}
    return false;
  }
}
