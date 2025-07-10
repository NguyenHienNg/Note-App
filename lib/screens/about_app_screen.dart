// lib/screens/about_app_screen.dart

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
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
              'v$_version ($_buildNumber)', // Phiên bản và số bản dựng
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