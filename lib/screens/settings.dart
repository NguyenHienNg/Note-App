import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/theme_provider.dart';
import 'about_app_screen.dart';

// Chuyển SettingsScreen thành StatefulWidget để quản lý trạng thái ngôn ngữ
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Uri _githubUrl = Uri.parse('https://github.com/NguyenHienNg/My-App');

  // Biến trạng thái cục bộ để theo dõi ngôn ngữ được chọn
  // Mặc định là 'vi' (Tiếng Việt)
  String _selectedLanguageCode = 'vi'; // Có thể lưu vào SharedPreferences sau

  @override
  void initState() {
    super.initState();
    // Trong thực tế, bạn sẽ tải ngôn ngữ đã lưu từ SharedPreferences ở đây
    _loadSelectedLanguage();
  }

  // Hàm giả lập tải ngôn ngữ đã chọn
  void _loadSelectedLanguage() {
    // Đây là nơi bạn sẽ đọc từ SharedPreferences hoặc một nơi lưu trữ khác
    // Ví dụ: final prefs = await SharedPreferences.getInstance();
    // String? savedLang = prefs.getString('app_language');
    setState(() {
      // _selectedLanguageCode = savedLang ?? 'vi';
    });
  }

  Future<void> _launchUrl(Uri url, BuildContext context) async {
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể mở liên kết: $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Hàm hiển thị sheet chọn ngôn ngữ
  void _showLanguageSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Chọn Ngôn ngữ',
                style: Theme.of(ctx).textTheme.headlineSmall,
              ),
            ),
            RadioListTile<String>(
              title: const Text('Tiếng Việt'),
              value: 'vi',
              groupValue: _selectedLanguageCode,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguageCode = value;
                  });
                  // Trong thực tế, bạn sẽ lưu ngôn ngữ đã chọn vào SharedPreferences ở đây
                  // Và sau đó thông báo cho MaterialApp để thay đổi Locale.
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _selectedLanguageCode,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguageCode = value;
                  });
                  // Lưu và thông báo MaterialApp
                  Navigator.pop(ctx);
                }
              },
            ),
            // Bạn có thể thêm các ngôn ngữ khác ở đây
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // Hàm helper để lấy tên ngôn ngữ hiển thị
  String _getLanguageName(String code) {
    switch (code) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return 'Không xác định';
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.normal,
                ),
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showThemeSelectionSheet(BuildContext context, ThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Chọn Chủ đề',
                style: Theme.of(ctx).textTheme.headlineSmall,
              ),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Hệ thống'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Sáng'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Tối'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(ctx);
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Mặc định hệ thống';
      case ThemeMode.light:
        return 'Sáng';
      case ThemeMode.dark:
        return 'Tối';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          children: [
            const SizedBox(height: 16.0),
            _buildSectionHeader(context, 'Cài đặt'),
            const SizedBox(height: 8.0),
            _buildSettingsItem(
              context,
              title: 'Chủ đề',
              subtitle: _getThemeModeName(themeProvider.themeMode),
              onTap: () => _showThemeSelectionSheet(context, themeProvider),
            ),
            // THÊM MỤC NGÔN NGỮ MỚI
            _buildSettingsItem(
              context,
              title: 'Ngôn ngữ',
              subtitle: _getLanguageName(_selectedLanguageCode), // Hiển thị ngôn ngữ đang chọn
              onTap: () => _showLanguageSelectionSheet(context), // Mở sheet chọn ngôn ngữ
            ),
            const Divider(height: 0, thickness: 1), // Đường kẻ phân cách giữa các nhóm
            const SizedBox(height: 16.0),

            _buildSectionHeader(context, 'About'),
            const SizedBox(height: 8.0),
            _buildSettingsItem(
              context,
              title: 'Xem mã nguồn',
              subtitle: 'Mã nguồn của ứng dụng này có sẵn để đọc trên GitHub. Ngoài ra bạn có thể gửi yêu cầu cho chúng tôi về những cải tiến và sửa lỗi của bạn.',
              onTap: () => _launchUrl(_githubUrl, context),
            ),
            _buildSettingsItem(
              context,
              title: 'Giúp chúng tôi dịch!',
              subtitle: 'Nếu bạn thích Trình chạy hoạt động, bạn nên cân nhắc dịch ứng dụng này cho ngôn ngữ của bạn.',
              onTap: () => _launchUrl(_githubUrl, context),
            ),
            _buildSettingsItem(
              context,
              title: 'Báo cáo lỗi',
              subtitle: 'Nếu bạn có bất kỳ gợi ý hay vấn đề nào, vui lòng báo cáo chúng vào dự án của chúng tôi tại GitHub.',
              onTap: () => _launchUrl(_githubUrl, context),
            ),
            _buildSettingsItem(
              context,
              title: 'Về ứng dụng',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutAppScreen()),
                );
              },
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}