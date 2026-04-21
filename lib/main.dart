import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uthm_smart_campus/data/demo_students.dart';
import 'package:uthm_smart_campus/l10n/app_localizations.dart';
import 'package:uthm_smart_campus/models/student.dart';
import 'package:uthm_smart_campus/screens/auth/forgot_password_screen.dart';
import 'package:uthm_smart_campus/screens/auth/register_screen.dart';
import 'package:uthm_smart_campus/screens/booking_room.dart';
import 'package:uthm_smart_campus/screens/cafe_screen.dart';
import 'package:uthm_smart_campus/screens/campus_map_screen.dart';
import 'package:uthm_smart_campus/screens/dashboard_screen.dart';
import 'package:uthm_smart_campus/screens/login_screen.dart';
import 'package:uthm_smart_campus/screens/mini_shop_screen.dart';
import 'package:uthm_smart_campus/screens/notifications/notifications_screen.dart';
import 'package:uthm_smart_campus/screens/profile_screen.dart';
import 'package:uthm_smart_campus/screens/reminder_screen.dart';
import 'package:uthm_smart_campus/screens/study_planner_screen.dart';
import 'package:uthm_smart_campus/screens/timetable_screen.dart';
import 'package:uthm_smart_campus/utils/app_language.dart';
import 'package:uthm_smart_campus/utils/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appLanguageController.load();
  await appThemeController.load();

  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const UTHMApp());
}

class UTHMApp extends StatelessWidget {
  const UTHMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([appLanguageController, appThemeController]),
      builder: (context, _) {
        return AppLanguageScope(
          notifier: appLanguageController,
          child: MaterialApp(
            title: appLanguageController.tr('UTHM Smart Campus'),
            debugShowCheckedModeBanner: false,
            locale: appLanguageController.language.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            builder: (context, child) {
              return _GlobalThemeLayer(
                isDarkMode: appThemeController.isDarkMode,
                child: child ?? const SizedBox.shrink(),
              );
            },
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: appThemeController.themeMode,
            initialRoute: '/login',
            routes: {
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/forgot-password': (_) => const ForgotPasswordScreen(),
              '/dashboard': (_) => const DashboardScreen(),
              '/timetable': (_) => const TimetableScreen(),
              '/map': (_) => const CampusMapScreen(),
              '/shop': (_) => const MiniShopScreen(),
              '/cafe': (_) => const CafeScreen(),
              '/booking': (_) => const RoomBookingScreen(),
              '/reminder': (_) => const ReminderScreen(),
              '/study_planner': (_) => const StudyPlannerScreen(),
              '/profile': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                final student = args is Student ? args : demoStudents.first;
                return ProfileScreen(student: student);
              },
              '/notifications': (_) => const NotificationsScreen(),
            },
          ),
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF113A6E),
        foregroundColor: Colors.white,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF60A5FA),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF020617),
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E293B),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF111827),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _GlobalThemeLayer extends StatelessWidget {
  const _GlobalThemeLayer({
    required this.isDarkMode,
    required this.child,
  });

  final bool isDarkMode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: isDarkMode ? 1 : 0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: Container(
              color: const Color(0xFF020617).withValues(alpha: 0.42),
            ),
          ),
        ),
      ],
    );
  }
}
