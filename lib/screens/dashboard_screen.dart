import 'package:flutter/material.dart';
import 'package:uthm_smart_campus/l10n/app_localizations.dart';
import 'package:uthm_smart_campus/models/student.dart';
import 'package:uthm_smart_campus/screens/profile_screen.dart';
import 'package:uthm_smart_campus/utils/app_language.dart';
import 'package:uthm_smart_campus/utils/main_navigation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  // ── Colors ────────────────────────────────────────────────────
  static const Color kBlue700 = Color(0xFF113A6E);
  static const Color kBlue600 = Color(0xFF1A52A0);
  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kTeal = Color(0xFF0891B2);
  static const Color kGray50 = Color(0xFFF8FAFC);
  static const Color kGray100 = Color(0xFFF1F5F9);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray800 = Color(0xFF1E293B);

  // ── State ─────────────────────────────────────────────────────

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  Student? _loggedInStudent;

  // ── Next Class Data ───────────────────────────────────────────
  final Map<String, String> _nextClass = {
    'subject': 'Data Structures',
    'room': 'DK3, Block A',
    'time': '10:00 AM',
    'minutes': '20 min',
  };

  // ── Feature Cards Data ────────────────────────────────────────
  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Timetable',
      'subtitle': 'View schedule',
      'icon': '📅',
      'color': Color(0xFFDBEAFE),
      'route': 'timetable',
    },
    {
      'title': 'Campus Map',
      'subtitle': 'Navigate',
      'icon': '🗺️',
      'color': Color(0xFFDCFCE7),
      'route': 'map',
    },
    {
      'title': 'Mini Shop',
      'subtitle': 'Stationery',
      'icon': '🛒',
      'color': Color(0xFFFEF9C3),
      'route': 'shop',
    },
    {
      'title': 'Café',
      'subtitle': 'Order food',
      'icon': '☕',
      'color': Color(0xFFFCE7F3),
      'route': 'cafe',
    },
    {
      'title': 'Room Booking',
      'subtitle': 'Reserve',
      'icon': '🏛️',
      'color': Color(0xFFEDE9FE),
      'route': 'booking',
    },
    {
      'title': 'Reminder',
      'subtitle': '3 pending',
      'icon': '🔔',
      'color': Color(0xFFFFEDD5),
      'route': 'reminder',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Login passes the selected local Student through route arguments.
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Student) {
      _loggedInStudent = args;
    }
  }

  // ── Navigation handler ────────────────────────────────────────
  void _onNavTap(int index) {
    navigateToMainTab(context, index, '/dashboard');
  }

  // ── Feature card tap ─────────────────────────────────────────
  void _onFeatureTap(String route) {
    const routeMap = {
      'timetable': '/timetable',
      'map': '/map',
      'shop': '/shop',
      'cafe': '/cafe',
      'booking': '/booking',
      'reminder': '/reminder',
      'study_planner': '/study_planner',
    };
    final targetRoute = routeMap[route];

    if (targetRoute != null) {
      Navigator.pushNamed(context, targetRoute);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$route is not available yet.'),
        backgroundColor: kBlue500,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: kGray50,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // ── HEADER ────────────────────────────────────────
            _buildHeader(),

            // ── BODY ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // White rounded top that overlaps header
                    Transform.translate(
                      offset: const Offset(0, -16),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: kGray50,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Next class banner
                              _buildNextClassBanner(),
                              const SizedBox(height: 20),

                              // Section title
                              Text(
                                l10n.campusServices,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: kGray800,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 2x3 feature grid
                              _buildFeatureGrid(),
                              const SizedBox(height: 16),

                              // Study Planner featured card
                              _buildStudyPlannerCard(),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ── BOTTOM NAV ──────────────────────────────────────────
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);
    final student = _loggedInStudent;
    final studentName = student?.fullName ?? 'UTHM Student';
    final matric = student?.matric ?? 'Demo Mode';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kBlue700, kBlue500],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      child: Column(
        children: [
          // Top row: greeting + avatar
          Row(
            children: [
              // Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                matric,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.78),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildLanguageSwitcher(),
                      ],
                    ),
                  ],
                ),
              ),

              // Notification bell
              GestureDetector(
                onTap: () => _onFeatureTap('reminder'),
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🔔', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),

              // Avatar
              GestureDetector(
                onTap: () {
                  if (student == null) return;

                  // Pass the same logged-in Student object into ProfileScreen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(student: student),
                    ),
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: _buildStudentAvatar(student),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Search bar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(Icons.search_rounded,
                    color: Colors.white.withValues(alpha: 0.7), size: 20),
                const SizedBox(width: 10),
                Text(
                  l10n.searchCampusServices,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentAvatar(Student? student) {
    final imagePath = student?.profileImagePath;

    if (imagePath != null && imagePath.isNotEmpty) {
      return ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: 42,
          height: 42,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      );
    }

    return const Icon(
      Icons.person_rounded,
      color: Colors.white,
      size: 24,
    );
  }

  Widget _buildLanguageSwitcher() {
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: appLanguageController,
      builder: (context, _) {
        final currentLanguage = appLanguageController.language;
        final currentCode = switch (currentLanguage) {
          AppLanguage.english => 'EN',
          AppLanguage.malay => 'MS',
          AppLanguage.arabic => 'AR',
        };

        return PopupMenuButton<AppLanguage>(
          tooltip: l10n.language,
          initialValue: currentLanguage,
          color: Colors.white,
          elevation: 10,
          offset: const Offset(0, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onSelected: (language) async {
            await appLanguageController.setLanguage(language);
            if (mounted) {
              setState(() {});
            }
          },
          itemBuilder: (context) {
            return AppLanguage.values.map((language) {
              final isSelected = language == currentLanguage;
              final label = switch (language) {
                AppLanguage.english => l10n.english,
                AppLanguage.malay => l10n.bahasaMelayu,
                AppLanguage.arabic => l10n.arabic,
              };

              return PopupMenuItem<AppLanguage>(
                value: language,
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: isSelected ? kBlue500 : kGray400,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: TextStyle(
                        color: kGray800,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.26),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.language_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  currentCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withValues(alpha: 0.75),
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // NEXT CLASS BANNER
  // ─────────────────────────────────────────────────────────────
  Widget _buildNextClassBanner() {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kBlue600, kTeal],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kBlue500.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('📚', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),

          // Class info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.nextClass,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _nextClass['subject']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_nextClass['room']} · ${l10n.startsIn} ${_nextClass['minutes']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Time chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _nextClass['time']!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // FEATURE GRID  (2 x 3)
  // ─────────────────────────────────────────────────────────────
  Widget _buildFeatureGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemCount: _features.length,
      itemBuilder: (context, index) {
        final feature = _features[index];
        return _buildFeatureCard(feature, index);
      },
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _onFeatureTap(feature['route']),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kGray100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon container
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: feature['color'] as Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    feature['icon'] as String,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              // Title + subtitle + arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr(feature['title'] as String),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kGray800,
                        ),
                      ),
                      Text(
                        context.tr(feature['subtitle'] as String),
                        style: TextStyle(
                          fontSize: 11,
                          color: kGray400,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: kGray400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STUDY PLANNER FEATURED CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildStudyPlannerCard() {
    return GestureDetector(
      onTap: () => _onFeatureTap('study_planner'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF064E3B), kBlue700],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('📖', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '✨ NEW FEATURE',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.tr('Smart Study Planner'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    context.tr('AI-assisted study schedule'),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${context.tr('Open')} →',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BOTTOM NAVIGATION BAR
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kGray100, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(kMainNavItems.length, (index) {
              final isActive = index == 0;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onNavTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Icon(
                        kMainNavItems[index]['icon'] as IconData,
                        size: 24,
                        color: isActive ? kBlue500 : kGray400,
                      ),
                      const SizedBox(height: 4),

                      // Label
                      Text(
                        _localizedMainNavLabel(
                          kMainNavItems[index]['label'] as String,
                        ),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? kBlue500 : kGray400,
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Active dot indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isActive ? 5 : 0,
                        height: isActive ? 5 : 0,
                        decoration: BoxDecoration(
                          color: kBlue500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────
  String _getGreeting() {
    final l10n = AppLocalizations.of(context);
    final hour = DateTime.now().hour;
    if (hour < 12) return '${l10n.goodMorning} 👋';
    if (hour < 17) return '${l10n.goodAfternoon} 👋';
    return '${l10n.goodEvening} 👋';
  }

  String _localizedMainNavLabel(String label) {
    final l10n = AppLocalizations.of(context);

    return switch (label) {
      'Home' => l10n.home,
      'Schedule' => l10n.schedule,
      'Map' => l10n.map,
      'Store' => l10n.store,
      _ => context.tr(label),
    };
  }
}

