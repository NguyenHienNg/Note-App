import 'dart:async';
import 'package:flutter/material.dart';
import '../services/update_service.dart';
import '../i18n/strings.g.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  String _selectedChannel = 'stable';
  bool _isLoadingChannel = true;
  double _apkSizeMB = 0.0;

  @override
  void initState() {
    super.initState();
    _loadChannel();
  }

  Future<void> _loadChannel() async {
    final channel = await UpdateService.instance.getUpdateChannel();
    await _updateApkSize();
    if (!mounted) return;
    setState(() {
      _selectedChannel = channel;
      _isLoadingChannel = false;
    });
  }

  Future<void> _updateApkSize() async {
    final size = await UpdateService.instance.getDownloadedApkSizeMB();
    if (mounted) {
      setState(() {
        _apkSizeMB = size;
      });
    }
  }

  Future<void> _onChannelChanged(String channel) async {
    setState(() {
      _selectedChannel = channel;
    });
    await UpdateService.instance.setUpdateChannel(channel);
  }

  /// Bắt đầu quy trình kiểm tra và cập nhật phiên bản
  Future<void> _startUpdateProcess() async {
    // 1. Hiển thị Custom Dialog kiểm tra phiên bản
    String dialogMessage = t.update_screen.dialog_checking_version;
    StateSetter? dialogSetState;
    bool isCancelled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setSt) {
            dialogSetState = setSt;
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              title: Text(t.update_screen.dialog_title_checking),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dialogMessage),
                    const SizedBox(height: 16),
                    const LinearProgressIndicator(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    isCancelled = true;
                    Navigator.of(dialogCtx).pop();
                  },
                  child: Text(t.update_screen.permission_btn_cancel),
                ),
              ],
            );
          },
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 600));

    if (isCancelled) return;

    // Cập nhật nội dung dialog thành "Đang kết nối tới máy chủ:"
    if (mounted && dialogSetState != null) {
      dialogSetState!(() {
        dialogMessage = t.update_screen.dialog_connecting_server;
      });
    }

    try {
      final updateInfo = await UpdateService.instance.checkUpdate();

      if (isCancelled || !mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Thoát Dialog kiểm tra

      if (!updateInfo.hasUpdate) {
        // Đã ở phiên bản mới nhất
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.update_screen.sheet_latest_already.replaceAll(
                '{version}',
                updateInfo.currentVersion,
              ),
            ),
          ),
        );
        return;
      }

      // 2. Mở Modal Sheet thông tin bản cập nhật mới
      _showReleaseInfoSheet(updateInfo);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Thoát Dialog kiểm tra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.update_screen.error_check_failed.replaceAll(
              '{error}',
              e.toString(),
            ),
          ),
        ),
      );
    }
  }

  /// Modal Sheet hiển thị thông tin bản cập nhật & Changelog
  void _showReleaseInfoSheet(UpdateInfo updateInfo) {
    final langCode = LocaleSettings.currentLocale.languageCode;
    final changelogMap = updateInfo.changelog;
    final changelogText =
        (changelogMap[langCode] as String?) ??
        (changelogMap['vi'] as String?) ??
        '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.system_update,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.update_screen.sheet_new_version_available,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${t.update_screen.sheet_current_version}: ${updateInfo.currentVersion}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${t.update_screen.sheet_latest_version}: ${updateInfo.latestVersion}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                t.update_screen.sheet_changelog_title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(changelogText, style: theme.textTheme.bodyMedium),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    Navigator.of(ctx).pop(); // Thoát Sheet

                    // 1. Kiểm tra xem đã có file APK "app-update.apk" sẵn trong máy chưa
                    final existingFile = await UpdateService.instance
                        .getDownloadedApkFile();
                    if (existingFile != null) {
                      final isValid = await UpdateService.instance
                          .verifyApkIntegrity(existingFile);

                      if (isValid) {
                        // File APK hoàn chỉnh hợp lệ -> Bỏ qua bước tải về, chuyển thẳng tới bước xin quyền & cài đặt
                        await _handleApkInstallation(existingFile.path);
                        return;
                      } else {
                        // File bị lỗi hoặc chưa tải xong -> Xóa file lỗi và tiến hành tải mới
                        await UpdateService.instance.deleteDownloadedApk();
                        await _updateApkSize();
                      }
                    }

                    // 2. Tiến hành tải file APK mới
                    _downloadAndInstallApk(updateInfo.downloadUrl);
                  },
                  icon: const Icon(Icons.download),
                  label: Text(t.update_screen.sheet_update_now_btn),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  /// 3 & 4. Tiến trình tải về APK có đo tốc độ & Cài đặt ứng dụng
  void _downloadAndInstallApk(String url) {
    int progress = 0;
    String speedText = '0.0 MB/s';
    bool isInstalling = false;
    StateSetter? dialogSetState;
    StreamSubscription<DownloadProgress>? subscription;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setSt) {
            dialogSetState = setSt;
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              title: Text(
                isInstalling
                    ? t.update_screen.dialog_installing_title
                    : t.update_screen.dialog_downloading_title,
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.update_screen.dialog_download_progress
                          .replaceAll('{progress}', progress.toString())
                          .replaceAll('{speed}', speedText),
                      style: Theme.of(ctx).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(value: progress / 100.0),
                  ],
                ),
              ),
              actions: [
                if (!isInstalling)
                  TextButton(
                    onPressed: () {
                      subscription?.cancel();
                      Navigator.of(dialogCtx).pop();
                    },
                    child: Text(t.update_screen.permission_btn_cancel),
                  ),
              ],
            );
          },
        );
      },
    );

    subscription = UpdateService.instance
        .downloadApk(url)
        .listen(
          (dp) async {
            if (dialogSetState != null) {
              dialogSetState!(() {
                progress = dp.progressPercent;
                speedText = dp.formattedSpeed;
                if (dp.isCompleted) {
                  isInstalling = true;
                }
              });
            }

            if (dp.isCompleted && dp.filePath != null) {
              await subscription?.cancel();
              await _updateApkSize();
              if (!mounted) return;

              // Thoát Dialog tải về
              Navigator.of(context, rootNavigator: true).pop();

              // Chuyển sang giai đoạn kiểm tra quyền & cài đặt
              await _handleApkInstallation(dp.filePath!);
            }
          },
          onError: (e) {
            subscription?.cancel();
            if (mounted) {
              Navigator.of(context, rootNavigator: true).pop(); // Thoát Dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.update_screen.error_check_failed.replaceAll(
                      '{error}',
                      e.toString(),
                    ),
                  ),
                ),
              );
            }
          },
        );
  }

  /// Xử lý cài đặt APK và hiển thị Dialog xin quyền trước khi chuyển sang Cài đặt hệ thống
  Future<void> _handleApkInstallation(String filePath) async {
    int tryCount = 0;
    bool isGranted = await UpdateService.instance.isInstallPermissionGranted();

    while (!isGranted && tryCount < 2) {
      tryCount++;

      if (!mounted) return;

      // Hiển thị Dialog yêu cầu cấp quyền trong ứng dụng
      final shouldOpenSettings = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            title: Text(t.update_screen.permission_dialog_title),
            content: SizedBox(
              width: double.maxFinite,
              child: Text(t.update_screen.permission_dialog_content),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(t.update_screen.permission_btn_cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(t.update_screen.permission_btn_settings),
              ),
            ],
          );
        },
      );

      if (shouldOpenSettings != true) {
        // Người dùng nhấn Hủy
        break;
      }

      // Mở cài đặt hệ thống Android
      await UpdateService.instance.requestInstallPermission();

      // Kiểm tra lại quyền sau khi người dùng quay lại ứng dụng
      isGranted = await UpdateService.instance.isInstallPermissionGranted();
    }

    if (!mounted) return;

    if (isGranted) {
      // Đã có quyền -> Hiển thị Dialog "Đang cài đặt..." và mở trình cài đặt APK
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 24.0,
          ),
          title: Text(t.update_screen.dialog_installing_title),
          content: const SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8),
                LinearProgressIndicator(value: 1.0),
              ],
            ),
          ),
        ),
      );

      final success = await UpdateService.instance.installApkFile(filePath);

      if (mounted) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop(); // Thoát Dialog "Đang cài đặt..."
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.update_screen.dialog_permission_error)),
          );
        }
      }
    } else {
      // Từ chối cấp quyền 2 lần hoặc nhấn Hủy
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.update_screen.dialog_permission_error)),
      );
    }
  }

  Widget _buildSettingsItem({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        leading: leading != null
            ? IconTheme(
                data: IconThemeData(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                child: leading,
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2.0),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showChannelSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return RadioGroup<String>(
          groupValue: _selectedChannel,
          onChanged: (String? value) {
            if (value != null) {
              _onChannelChanged(value);
              Navigator.pop(ctx);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  t.update_screen.channel_title,
                  style: Theme.of(ctx).textTheme.headlineSmall,
                ),
              ),
              RadioListTile<String>(
                title: Text(t.update_screen.channel_stable),
                value: 'stable',
              ),
              RadioListTile<String>(
                title: Text(t.update_screen.channel_beta),
                value: 'beta',
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  String _getChannelName(String code) {
    switch (code) {
      case 'beta':
        return t.update_screen.channel_beta;
      case 'stable':
      default:
        return t.update_screen.channel_stable;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.update_screen.app_bar_title)),
      body: SafeArea(
        child: _isLoadingChannel
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: [
                  _buildSettingsItem(
                    title: t.update_screen.channel_title,
                    subtitle: _getChannelName(_selectedChannel),
                    leading: const Icon(Icons.sync_alt),
                    onTap: _showChannelSelectionSheet,
                  ),
                  const Divider(height: 0, thickness: 1.5),
                  _buildSettingsItem(
                    title: t.update_screen.check_and_update_title,
                    subtitle: t.update_screen.check_and_update_subtitle,
                    leading: const Icon(Icons.system_update_outlined),
                    onTap: _startUpdateProcess,
                  ),
                  if (_apkSizeMB > 0)
                    _buildSettingsItem(
                      title: t.update_screen.delete_apk_title,
                      subtitle: t.update_screen.delete_apk_subtitle.replaceAll(
                        '{size}',
                        _apkSizeMB.toStringAsFixed(1),
                      ),
                      leading: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onTap: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final deleted = await UpdateService.instance
                            .deleteDownloadedApk();
                        await _updateApkSize();
                        if (deleted) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(t.update_screen.delete_apk_success),
                            ),
                          );
                        }
                      },
                    ),
                ],
              ),
      ),
    );
  }
}
