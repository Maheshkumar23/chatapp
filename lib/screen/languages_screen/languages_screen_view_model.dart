import 'dart:io';

import 'package:get/get.dart';
import 'package:orange_ui/screen/restart_app/restart_app.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/pref_res.dart';
import 'package:stacked/stacked.dart';

class LanguagesScreenViewModel extends BaseViewModel {
  static String selectedLanguage = Platform.localeName.split('_')[0];

  int? value = 0;
  List<String> languages = [
    'عربي',
    'dansk',
    'Nederlands',
    'English',
    'Français',
    'Deutsch',
    'Ελληνικά',
    'हिंदी',
    'bahasa Indonesia',
    'Italiano',
    '日本',
    '한국인',
    'Norsk Bokmal',
    'Polski',
    'Português',
    'Русский',
    '简体中文',
    'Español',
    'แบบไทย',
    'Türkçe',
    'Tiếng Việt',
  ];
  List<String> subLanguage = [
    'Arabic',
    'Danish',
    'Dutch',
    'English',
    'French',
    'German',
    'Greek',
    'Hindi',
    'Indonesian',
    'Italian',
    'Japanese',
    'Korean',
    'Norwegian Bokmal',
    'Polish',
    'Portuguese',
    'Russian',
    'Simplified Chinese',
    'Spanish',
    'Thai',
    'Turkish',
    'Vietnamese',
  ];
  List languageCode = [
    'ar',
    'da',
    'nl',
    'en',
    'fr',
    'de',
    'el',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'nb',
    'pl',
    'pt',
    'ru',
    'zh',
    'es',
    'th',
    'tr',
    'vi',
  ];

  void init() {
    prefData();
  }

  void onLanguageChange(int? value) async {
    this.value = value;
    await PrefService.saveString(
        PrefConst.languageCode, languageCode[value ?? 0]);
    selectedLanguage = languageCode[value ?? 0];
    RestartWidget.restartApp(Get.context!);
    notifyListeners();
  }

  void prefData() async {
    selectedLanguage = await PrefService.getString(PrefConst.languageCode) ??
        Platform.localeName.split('_')[0];
    value = languageCode.indexOf(selectedLanguage);
    notifyListeners();
  }
}
