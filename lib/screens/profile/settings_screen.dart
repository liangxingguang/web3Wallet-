import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../generated/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(loc.language),
            trailing: DropdownButton<Locale?>(
              value: localeProvider.locale,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(loc.systemDefault),
                ),
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text(loc.english),
                ),
                DropdownMenuItem(
                  value: Locale('zh'),
                  child: Text(loc.simplifiedChinese),
                ),
                DropdownMenuItem(
                  value: Locale('ja'),
                  child: Text(loc.japanese),
                ),
              ],
              onChanged: (locale) {
                localeProvider.setLocale(locale);
              },
            ),
          ),
        ],
      ),
    );
  }
}