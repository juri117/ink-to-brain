import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const prefKey = 'app_language';

  static const options = <String, String>{
    'en': 'English',
    'vi': 'Tiếng Việt',
  };

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(prefKey) ?? 'en';
    _locale = Locale(options.containsKey(code) ? code : 'en');
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    final next = options.containsKey(code) ? code : 'en';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefKey, next);
    if (_locale.languageCode == next) return;
    _locale = Locale(next);
    notifyListeners();
  }
}

final localeController = LocaleController();
