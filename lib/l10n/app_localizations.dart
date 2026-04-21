import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ms'),
    Locale('ar'),
  ];

  static AppLocalizations of(BuildContext context) {
    final localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localizations != null, 'AppLocalizations is not available.');
    return localizations!;
  }

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String get appTitle => translate('appTitle');
  String get goodMorning => translate('goodMorning');
  String get goodAfternoon => translate('goodAfternoon');
  String get goodEvening => translate('goodEvening');
  String get searchCampusServices => translate('searchCampusServices');
  String get nextClass => translate('nextClass');
  String get campusServices => translate('campusServices');
  String get home => translate('home');
  String get schedule => translate('schedule');
  String get map => translate('map');
  String get store => translate('store');
  String get language => translate('language');
  String get english => translate('english');
  String get bahasaMelayu => translate('bahasaMelayu');
  String get arabic => translate('arabic');
  String get startsIn => translate('startsIn');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

const Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'appTitle': 'UTHM Smart Campus',
    'goodMorning': 'Good morning',
    'goodAfternoon': 'Good afternoon',
    'goodEvening': 'Good evening',
    'searchCampusServices': 'Search campus services...',
    'nextClass': 'Next Class',
    'campusServices': 'Campus Services',
    'home': 'Home',
    'schedule': 'Schedule',
    'map': 'Map',
    'store': 'Store',
    'language': 'Language',
    'english': 'English',
    'bahasaMelayu': 'Bahasa Melayu',
    'arabic': 'Arabic',
    'startsIn': 'Starts in',
  },
  'ms': {
    'appTitle': 'Kampus Pintar UTHM',
    'goodMorning': 'Selamat pagi',
    'goodAfternoon': 'Selamat petang',
    'goodEvening': 'Selamat malam',
    'searchCampusServices': 'Cari perkhidmatan kampus...',
    'nextClass': 'Kelas Seterusnya',
    'campusServices': 'Perkhidmatan Kampus',
    'home': 'Utama',
    'schedule': 'Jadual',
    'map': 'Peta',
    'store': 'Kedai',
    'language': 'Bahasa',
    'english': 'English',
    'bahasaMelayu': 'Bahasa Melayu',
    'arabic': 'Arabic',
    'startsIn': 'Bermula dalam',
  },
  'ar': {
    'appTitle': 'حرم UTHM الذكي',
    'goodMorning': 'صباح الخير',
    'goodAfternoon': 'مساء الخير',
    'goodEvening': 'مساء الخير',
    'searchCampusServices': 'ابحث عن خدمات الحرم...',
    'nextClass': 'المحاضرة القادمة',
    'campusServices': 'خدمات الحرم',
    'home': 'الرئيسية',
    'schedule': 'الجدول',
    'map': 'الخريطة',
    'store': 'المتجر',
    'language': 'اللغة',
    'english': 'English',
    'bahasaMelayu': 'Bahasa Melayu',
    'arabic': 'العربية',
    'startsIn': 'يبدأ خلال',
  },
};
