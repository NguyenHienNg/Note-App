import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../i18n/strings.g.dart';

class ThemeColorScreen extends StatelessWidget {
  const ThemeColorScreen({super.key});

  static String getThemeColorName(AppThemeColor color) {
    switch (color) {
      case AppThemeColor.red:
        return t.settings_screen.color_red;
      case AppThemeColor.green:
        return t.settings_screen.color_green;
      case AppThemeColor.blue:
        return t.settings_screen.color_blue;
      case AppThemeColor.brown:
        return t.settings_screen.color_brown;
      case AppThemeColor.purple:
        return t.settings_screen.color_purple;
      case AppThemeColor.yellow:
        return t.settings_screen.color_yellow;
      case AppThemeColor.orange:
        return t.settings_screen.color_orange;
      case AppThemeColor.system:
        return t.settings_screen.color_system;
    }
  }

  static Color getColorForTheme(AppThemeColor color) {
    switch (color) {
      case AppThemeColor.red: return Colors.red;
      case AppThemeColor.green: return Colors.green;
      case AppThemeColor.blue: return Colors.blue;
      case AppThemeColor.brown: return Colors.brown;
      case AppThemeColor.purple: return Colors.purple;
      case AppThemeColor.yellow: return Colors.yellow;
      case AppThemeColor.orange: return Colors.orange;
      case AppThemeColor.system: return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings_screen.theme_color_selection_title),
      ),
      body: RadioGroup<AppThemeColor>(
        groupValue: themeProvider.themeColor,
        onChanged: (AppThemeColor? value) {
          if (value != null) {
            themeProvider.setThemeColor(value);
          }
        },
        child: ListView(
          children: AppThemeColor.values.map((color) {
            return RadioListTile<AppThemeColor>(
              title: Text(getThemeColorName(color)),
              secondary: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: getColorForTheme(color),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: color == AppThemeColor.system
                    ? Icon(Icons.color_lens, size: 16, color: Theme.of(context).colorScheme.primary)
                    : null,
              ),
              value: color,
            );
          }).toList(),
        ),
      ),
    );
  }
}
