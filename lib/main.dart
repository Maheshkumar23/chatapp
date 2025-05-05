import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/get_started_screen/get_started_screen.dart';
import 'package:orange_ui/screen/languages_screen/languages_screen_view_model.dart';
import 'package:orange_ui/screen/restart_app/restart_app.dart';
import 'package:orange_ui/service/ads_service.dart';
import 'package:orange_ui/service/firebase_notification_manager.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:orange_ui/utils/pref_res.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseNotificationManager.shared.showNotification(message);
  // showNotification(message);
}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // Status bar color
    statusBarColor: ColorRes.transparent,
    // Status bar brightness (optional)
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light, // For iOS (dark icons)
  ));
  WidgetsFlutterBinding.ensureInitialized();
  LanguagesScreenViewModel.selectedLanguage =
      await PrefService.getString(PrefConst.languageCode) ?? Platform.localeName.split('_')[0];
  print("Before Firebase init");
  await Firebase.initializeApp();
  print("Firebase initialized");
  // FirebaseNotificationManager.shared;
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FlutterBranchSdk.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const RestartWidget(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

// FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// late AndroidNotificationChannel channel;

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    consentForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => ScrollConfiguration(behavior: MyBehavior(), child: child!),
      supportedLocales: S.delegate.supportedLocales,
      locale: Locale(LanguagesScreenViewModel.selectedLanguage),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: FontRes.regular,
          primaryColor: ColorRes.darkOrange,
          splashColor: ColorRes.transparent,
          highlightColor: ColorRes.transparent,
          textSelectionTheme: const TextSelectionThemeData(cursorColor: ColorRes.davyGrey),
          useMaterial3: false),
      home: const GetStartedScreen(),
    );
  }

  void consentForm() async {
    AdsService.requestConsentInfoUpdate();
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
