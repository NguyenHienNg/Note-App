// lib/screens/about_app_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../i18n/strings.g.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  String _version = '';
  String _buildNumber = '';
  bool _hasExplicitBuildNumber = false;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    String ver = '';
    String build = '';
    bool hasExplicitBuild = false;

    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      ver = packageInfo.version;
      build = packageInfo.buildNumber;
    } catch (_) {}

    try {
      final pubspecContent = await rootBundle.loadString('pubspec.yaml');
      final versionLine = pubspecContent
          .split('\n')
          .firstWhere((line) => line.trim().startsWith('version:'), orElse: () => '');
      if (versionLine.isNotEmpty) {
        final versionValue = versionLine.split(':').last.trim();
        final parts = versionValue.split('+');
        ver = parts[0].trim();
        if (parts.length > 1 && parts[1].trim().isNotEmpty) {
          build = parts[1].trim();
          hasExplicitBuild = true;
        } else {
          build = '';
          hasExplicitBuild = false;
        }
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _version = ver;
      _buildNumber = build;
      _hasExplicitBuildNumber = hasExplicitBuild;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.about_app_screen.app_bar_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Biểu tượng Flutter (quay lại mặc định)
            ClipRRect( // Sử dụng ClipRRect để bo tròn icon nếu nó hình vuông
              borderRadius: BorderRadius.circular(16.0), // Bo tròn 16px
              child: Image.asset(
                'assets/icon/ic_launcher.png', // Thay thế bằng đường dẫn icon của bạn nếu có
                height: 100,
                width: 100,
                errorBuilder: (context, error, stackTrace) {
                  // THAY ĐỔI: Quay lại hiển thị Icons.flutter_dash nếu không tìm thấy ảnh
                  return const Icon(Icons.flutter_dash, size: 100); 
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
                t.about_app_screen.app_name_fallback, // Tên ứng dụng (fallback là 'Note')
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              (_hasExplicitBuildNumber && _buildNumber.isNotEmpty)
                  ? 'v$_version ($_buildNumber)'
                  : 'v$_version',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              t.about_app_screen.copyright, // Thông tin bản quyền
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}