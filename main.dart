import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';

MaterialApp(
  // ...
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('zh'),
    Locale('ja'),
  ],
  // ...
)