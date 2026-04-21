import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english('English', Locale('en')),
  malay('Bahasa Melayu', Locale('ms')),
  arabic('العربية', Locale('ar'));

  const AppLanguage(this.label, this.locale);

  final String label;
  final Locale locale;

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.locale.languageCode == code,
      orElse: () => AppLanguage.english,
    );
  }
}

class AppLanguageController extends ChangeNotifier {
  static const String _storageKey = 'selected_language_code';

  AppLanguage _language = AppLanguage.english;
  bool _isLoaded = false;

  AppLanguage get language => _language;
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _language = AppLanguage.fromCode(prefs.getString(_storageKey));
    _isLoaded = true;
    notifyListeners();
  }

  String tr(String text) {
    if (_language == AppLanguage.english) {
      return text;
    }

    if (_language == AppLanguage.malay) {
      return _ms[text] ?? text;
    }

    return _ar[text] ?? text;
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) {
      return;
    }

    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, language.locale.languageCode);
    notifyListeners();
  }
}

final appLanguageController = AppLanguageController();

class AppLanguageScope extends InheritedNotifier<AppLanguageController> {
  const AppLanguageScope({
    super.key,
    required AppLanguageController super.notifier,
    required super.child,
  });

  static AppLanguageController controllerOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppLanguageScope>();
    return scope?.notifier ?? appLanguageController;
  }

  static AppLanguage languageOf(BuildContext context) {
    return controllerOf(context).language;
  }

  static Locale localeOf(BuildContext context) {
    return languageOf(context).locale;
  }

  static String tr(BuildContext context, String text) {
    return controllerOf(context).tr(text);
  }
}

const Map<String, String> _ms = {
  'UTHM Smart Campus': 'Kampus Pintar UTHM',
  'Home': 'Utama',
  'Timetable': 'Jadual',
  'Schedule': 'Jadual',
  'Alerts': 'Amaran',
  'Map': 'Peta',
  'Shop': 'Kedai',
  'Store': 'Kedai',
  'Profile': 'Profil',
  'Good morning': 'Selamat pagi',
  'Good afternoon': 'Selamat petang',
  'Good evening': 'Selamat malam',
  'Search campus services...': 'Cari perkhidmatan kampus...',
  'Search products...': 'Cari produk...',
  'Search buildings, labs, facilities...': 'Cari bangunan, makmal, kemudahan...',
  'Next Class': 'Kelas Seterusnya',
  'Campus Services': 'Perkhidmatan Kampus',
  'View schedule': 'Lihat jadual',
  'Campus Map': 'Peta Kampus',
  'Navigate': 'Navigasi',
  'Mini Shop': 'Kedai Mini',
  'Campus stationery & essentials': 'Alat tulis dan keperluan kampus',
  'No products found': 'Tiada produk ditemui',
  'Try a different search or category': 'Cuba carian atau kategori lain',
  'Your Cart': 'Troli Anda',
  'Your cart is empty': 'Troli anda kosong',
  'Total': 'Jumlah',
  'Order Placed!': 'Pesanan Berjaya!',
  'Done': 'Selesai',
  'Stationery': 'Alat tulis',
  'Café': 'Kafe',
  'UTHM Café': 'Kafe UTHM',
  'Halal certified · Campus food court':
      'Disahkan halal · Medan selera kampus',
  'Your Order': 'Pesanan Anda',
  'Clear all': 'Kosongkan semua',
  'Order Confirmed!': 'Pesanan Disahkan!',
  'Ready in ~5 minutes': 'Siap dalam ~5 minit',
  'Order food': 'Pesan makanan',
  'Room Booking': 'Tempahan Bilik',
  'Reserve campus rooms & labs': 'Tempah bilik dan makmal kampus',
  'Please select a room first': 'Sila pilih bilik dahulu',
  'Start': 'Mula',
  'End': 'Tamat',
  'Purpose of booking (e.g. Group Study, Project Meeting)':
      'Tujuan tempahan (cth. belajar berkumpulan, mesyuarat projek)',
  'Number of Attendees': 'Bilangan Peserta',
  'Booking Rules': 'Peraturan Tempahan',
  'Booking Confirmed!': 'Tempahan Disahkan!',
  'Reserve': 'Tempah',
  'Reminder': 'Peringatan',
  'Reminders': 'Peringatan',
  'Stay on top of your deadlines': 'Pantau tarikh akhir anda',
  'Add Reminder': 'Tambah Peringatan',
  'Save Reminder': 'Simpan Peringatan',
  'Reminder deleted': 'Peringatan dipadam',
  'Reminder added ✓': 'Peringatan ditambah ✓',
  'Delete Reminder?': 'Padam Peringatan?',
  'This reminder will be permanently deleted.':
      'Peringatan ini akan dipadam secara kekal.',
  'Cancel': 'Batal',
  'Delete': 'Padam',
  'Overall Progress': 'Kemajuan Keseluruhan',
  '3 pending': '3 belum selesai',
  'Smart Study Planner': 'Perancang Belajar Pintar',
  'AI-assisted study schedule': 'Jadual belajar dibantu AI',
  'Study Tip': 'Tip Belajar',
  'Weekly Progress': 'Kemajuan Mingguan',
  'Study Statistics': 'Statistik Belajar',
  'No Study Plan Yet': 'Belum Ada Pelan Belajar',
  'Set Up My Timetable': 'Sediakan Jadual Saya',
  'Preview with sample data': 'Pratonton dengan data contoh',
  'Live': 'Langsung',
  'Get Directions': 'Dapatkan Arah',
  'location(s) found': 'lokasi ditemui',
  'My Profile': 'Profil Saya',
  'Student ID': 'ID Pelajar',
  'Edit Profile': 'Edit Profil',
  'Academic Information': 'Maklumat Akademik',
  'Quick Stats': 'Statistik Ringkas',
  'Subjects': 'Subjek',
  'Bookings': 'Tempahan',
  'Day Streak': 'Hari Berturut',
  'Notifications': 'Notifikasi',
  'Reminder Alerts': 'Amaran Peringatan',
  'Get notified for upcoming deadlines':
      'Terima notifikasi untuk tarikh akhir akan datang',
  'Timetable Updates': 'Kemas Kini Jadual',
  'Class schedule changes and reminders':
      'Perubahan jadual kelas dan peringatan',
  'Shop & Café Promos': 'Promosi Kedai & Kafe',
  'Deals and new menu items': 'Tawaran dan menu baharu',
  'Email Updates': 'Kemas Kini Emel',
  'University announcements via email': 'Pengumuman universiti melalui emel',
  'App Settings': 'Tetapan Aplikasi',
  'Dark Mode': 'Mod Gelap',
  'Switch to dark theme': 'Tukar kepada tema gelap',
  'Biometric Login': 'Log Masuk Biometrik',
  'Use fingerprint to login': 'Gunakan cap jari untuk log masuk',
  'Language': 'Bahasa',
  'Clear Cache': 'Kosongkan Cache',
  'Free up app storage': 'Kosongkan storan aplikasi',
  'Support & Help': 'Sokongan & Bantuan',
  'Help Center': 'Pusat Bantuan',
  'FAQs and user guide': 'Soalan lazim dan panduan pengguna',
  'Report a Bug': 'Laporkan Pepijat',
  'Help us improve the app': 'Bantu kami menambah baik aplikasi',
  'Rate the App': 'Nilai Aplikasi',
  'Leave a review on Play Store': 'Tinggalkan ulasan di Play Store',
  'About': 'Tentang',
  'Logout': 'Log Keluar',
  'Choose Language': 'Pilih Bahasa',
  'Select the language you want to use in the app.':
      'Pilih bahasa yang ingin digunakan dalam aplikasi.',
  'Use English language': 'Gunakan bahasa Inggeris',
  'Guna Bahasa Melayu': 'Guna Bahasa Melayu',
  'Use Arabic language': 'Gunakan bahasa Arab',
  'Language changed to English': 'Bahasa ditukar kepada Inggeris',
  'Language changed to Malay': 'Bahasa ditukar kepada Melayu',
  'Language changed to Arabic': 'Bahasa ditukar kepada Arab',
};

const Map<String, String> _ar = {
  'UTHM Smart Campus': 'حرم UTHM الذكي',
  'Home': 'الرئيسية',
  'Timetable': 'الجدول',
  'Schedule': 'الجدول',
  'Alerts': 'التنبيهات',
  'Map': 'الخريطة',
  'Shop': 'المتجر',
  'Store': 'المتجر',
  'Profile': 'الملف الشخصي',
  'Good morning': 'صباح الخير',
  'Good afternoon': 'مساء الخير',
  'Good evening': 'مساء الخير',
  'Search campus services...': 'ابحث عن خدمات الحرم...',
  'Search products...': 'ابحث عن المنتجات...',
  'Search buildings, labs, facilities...':
      'ابحث عن المباني والمختبرات والمرافق...',
  'Next Class': 'المحاضرة القادمة',
  'Campus Services': 'خدمات الحرم',
  'View schedule': 'عرض الجدول',
  'Campus Map': 'خريطة الحرم',
  'Navigate': 'التنقل',
  'Mini Shop': 'المتجر المصغر',
  'Campus stationery & essentials': 'قرطاسية واحتياجات الحرم',
  'No products found': 'لم يتم العثور على منتجات',
  'Try a different search or category': 'جرب بحثا أو تصنيفا آخر',
  'Your Cart': 'سلتك',
  'Your cart is empty': 'سلتك فارغة',
  'Total': 'المجموع',
  'Order Placed!': 'تم إرسال الطلب!',
  'Done': 'تم',
  'Stationery': 'قرطاسية',
  'CafÃ©': 'المقهى',
  'Café': 'المقهى',
  'UTHM CafÃ©': 'مقهى UTHM',
  'UTHM Café': 'مقهى UTHM',
  'Halal certified Â· Campus food court': 'حلال · ساحة طعام الحرم',
  'Halal certified · Campus food court': 'حلال · ساحة طعام الحرم',
  'Your Order': 'طلبك',
  'Clear all': 'مسح الكل',
  'Order Confirmed!': 'تم تأكيد الطلب!',
  'Ready in ~5 minutes': 'جاهز خلال ~5 دقائق',
  'Order food': 'اطلب الطعام',
  'Room Booking': 'حجز القاعات',
  'Reserve campus rooms & labs': 'احجز القاعات والمختبرات',
  'Please select a room first': 'يرجى اختيار قاعة أولا',
  'Start': 'البداية',
  'End': 'النهاية',
  'Purpose of booking (e.g. Group Study, Project Meeting)':
      'سبب الحجز مثل دراسة جماعية أو اجتماع مشروع',
  'Number of Attendees': 'عدد الحضور',
  'Booking Rules': 'قواعد الحجز',
  'Booking Confirmed!': 'تم تأكيد الحجز!',
  'Reserve': 'احجز',
  'Reminder': 'تذكير',
  'Reminders': 'التذكيرات',
  'Stay on top of your deadlines': 'تابع مواعيدك النهائية',
  'Add Reminder': 'إضافة تذكير',
  'Save Reminder': 'حفظ التذكير',
  'Reminder deleted': 'تم حذف التذكير',
  'Reminder added âœ“': 'تمت إضافة التذكير',
  'Reminder added ✓': 'تمت إضافة التذكير',
  'Delete Reminder?': 'حذف التذكير؟',
  'This reminder will be permanently deleted.':
      'سيتم حذف هذا التذكير نهائيا.',
  'Cancel': 'إلغاء',
  'Delete': 'حذف',
  'Overall Progress': 'التقدم العام',
  '3 pending': '3 قيد الانتظار',
  'Smart Study Planner': 'مخطط الدراسة الذكي',
  'AI-assisted study schedule': 'جدول دراسة بمساعدة الذكاء الاصطناعي',
  'Study Tip': 'نصيحة دراسية',
  'Weekly Progress': 'التقدم الأسبوعي',
  'Study Statistics': 'إحصائيات الدراسة',
  'No Study Plan Yet': 'لا توجد خطة دراسة بعد',
  'Set Up My Timetable': 'إعداد جدولي',
  'Preview with sample data': 'معاينة ببيانات تجريبية',
  'Live': 'مباشر',
  'Get Directions': 'احصل على الاتجاهات',
  'location(s) found': 'موقع تم العثور عليه',
  'My Profile': 'ملفي الشخصي',
  'Student ID': 'رقم الطالب',
  'Edit Profile': 'تعديل الملف',
  'Academic Information': 'المعلومات الأكاديمية',
  'Quick Stats': 'إحصائيات سريعة',
  'Subjects': 'المواد',
  'Bookings': 'الحجوزات',
  'Day Streak': 'أيام متتالية',
  'Notifications': 'الإشعارات',
  'Reminder Alerts': 'تنبيهات التذكير',
  'Get notified for upcoming deadlines':
      'استلم إشعارات للمواعيد القادمة',
  'Timetable Updates': 'تحديثات الجدول',
  'Class schedule changes and reminders':
      'تغييرات جدول المحاضرات والتذكيرات',
  'Shop & CafÃ© Promos': 'عروض المتجر والمقهى',
  'Shop & Café Promos': 'عروض المتجر والمقهى',
  'Deals and new menu items': 'العروض وعناصر القائمة الجديدة',
  'Email Updates': 'تحديثات البريد الإلكتروني',
  'University announcements via email':
      'إعلانات الجامعة عبر البريد الإلكتروني',
  'App Settings': 'إعدادات التطبيق',
  'Dark Mode': 'الوضع الداكن',
  'Switch to dark theme': 'التبديل إلى الوضع الداكن',
  'Biometric Login': 'تسجيل الدخول بالبصمة',
  'Use fingerprint to login': 'استخدم البصمة لتسجيل الدخول',
  'Language': 'اللغة',
  'Clear Cache': 'مسح الذاكرة المؤقتة',
  'Free up app storage': 'تحرير مساحة التطبيق',
  'Support & Help': 'الدعم والمساعدة',
  'Help Center': 'مركز المساعدة',
  'FAQs and user guide': 'الأسئلة الشائعة ودليل المستخدم',
  'Report a Bug': 'الإبلاغ عن خطأ',
  'Help us improve the app': 'ساعدنا في تحسين التطبيق',
  'Rate the App': 'قيّم التطبيق',
  'Leave a review on Play Store': 'اترك تقييما في متجر Play',
  'About': 'حول',
  'Logout': 'تسجيل الخروج',
  'Choose Language': 'اختر اللغة',
  'Select the language you want to use in the app.':
      'اختر اللغة التي تريد استخدامها في التطبيق.',
  'Use English language': 'استخدم اللغة الإنجليزية',
  'Guna Bahasa Melayu': 'استخدم Bahasa Melayu',
  'Use Arabic language': 'استخدم اللغة العربية',
  'Language changed to English': 'تم تغيير اللغة إلى الإنجليزية',
  'Language changed to Malay': 'تم تغيير اللغة إلى Bahasa Melayu',
  'Language changed to Arabic': 'تم تغيير اللغة إلى العربية',
  'Open': 'فتح',
};

extension AppLocalizationsX on BuildContext {
  String tr(String text) => AppLanguageScope.tr(this, text);
}
