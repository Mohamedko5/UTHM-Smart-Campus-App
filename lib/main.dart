import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uthm_smart_campus/screens/booking_room.dart';
import 'package:uthm_smart_campus/screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/campus_map_screen.dart';
import 'screens/mini_shop_screen.dart';
import 'screens/cafe_screen.dart';
import 'screens/reminder_screen.dart';
import 'screens/study_planner_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make status bar transparent
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
    return MaterialApp(
      title: 'UTHM Smart Campus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/timetable': (_) => const TimetableScreen(),
        '/map': (_) => const CampusMapScreen(),
        '/shop': (_) => const MiniShopScreen(),
        '/cafe': (_) => const CafeScreen(),
        '/booking': (_) => const RoomBookingScreen(),
        '/reminder': (_) => const ReminderScreen(),
        '/study_planner': (_) => const StudyPlannerScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
