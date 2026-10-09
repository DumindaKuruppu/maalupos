import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme_provider.dart';
import '../../auth/auth_provider.dart';

class DashboardDrawer extends ConsumerWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.phishing, size: 48, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  'app_title'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'subtitle_desc'.tr(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'change_language'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('English'),
            trailing: context.locale.languageCode == 'en'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              context.setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('sinhala'.tr()),
            trailing: context.locale.languageCode == 'si'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              context.setLocale(const Locale('si'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('tamil'.tr()),
            trailing: context.locale.languageCode == 'ta'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              context.setLocale(const Locale('ta'));
              Navigator.pop(context);
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'theme_mode'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: Text('light_mode'.tr()),
            trailing: themeMode == ThemeMode.light
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text('dark_mode'.tr()),
            trailing: themeMode == ThemeMode.dark
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_system_daydream),
            title: Text('system_mode'.tr()),
            trailing: themeMode == ThemeMode.system
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'logout'.tr(),
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
    );
  }
}
