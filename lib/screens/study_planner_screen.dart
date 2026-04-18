import 'package:flutter/material.dart';

class StudyPlannerScreen extends StatefulWidget {
  const StudyPlannerScreen({super.key});

  @override
  State<StudyPlannerScreen> createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen>
    with SingleTickerProviderStateMixin {
  // ── Colors ────────────────────────────────────────────────────
  static const Color kBlue700 = Color(0xFF113A6E);
  static const Color kBlue600 = Color(0xFF1A52A0);
  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kBlue100 = Color(0xFFDBEAFE);
  static const Color kBlue50 = Color(0xFFEFF6FF);
  static const Color kTeal = Color(0xFF0891B2);
  static const Color kGreen900 = Color(0xFF064E3B);
  static const Color kGreen700 = Color(0xFF065F46);
  static const Color kGreen500 = Color(0xFF10B981);
  static const Color kGray50 = Color(0xFFF8FAFC);
  static const Color kGray100 = Color(0xFFF1F5F9);
  static const Color kGray200 = Color(0xFFE2E8F0);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray500 = Color(0xFF64748B);
  static const Color kGray800 = Color(0xFF1E293B);
  static const Color kAmber = Color(0xFFF59E0B);
  static const Color kPurple = Color(0xFF7C3AED);
  static const Color kRed = Color(0xFFEF4444);

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ── State ─────────────────────────────────────────────────────
  int _streakCount = 3; // days studied in a row
  bool _hasTimetable = true; // toggle to false to see empty state
  String _selectedView = 'Today'; // Today | Weekly | All

  // ── Streak days ───────────────────────────────────────────────
  final List<Map<String, dynamic>> _streakDays = [
    {'day': 'Mon', 'done': true},
    {'day': 'Tue', 'done': true},
    {'day': 'Wed', 'done': true},
    {'day': 'Thu', 'done': false},
    {'day': 'Fri', 'done': false},
    {'day': 'Sat', 'done': false},
    {'day': 'Sun', 'done': false},
  ];

  // ── Today's study suggestions ─────────────────────────────────
  final List<Map<String, dynamic>> _todaySuggestions = [
    {
      'subject': 'Data Structures',
      'day': 'Thursday',
      'duration': '1.5 hrs',
      'timing': 'Before 10:00 AM class',
      'tags': ['Deep Focus', 'Review Notes'],
      'tagColors': [Color(0xFFEDE9FE), Color(0xFFFEF3C7)],
      'tagText': [Color(0xFF6D28D9), Color(0xFF92400E)],
      'icon': Icons.account_tree_rounded,
      'color': Color(0xFF2563EB),
      'progress': 0.0,
      'tip': 'Focus on binary trees and sorting algorithms',
    },
    {
      'subject': 'Database Systems',
      'day': 'Thursday',
      'duration': '1 hr',
      'timing': 'After lunch break',
      'tags': ['Practice SQL'],
      'tagColors': [Color(0xFFD1FAE5)],
      'tagText': [Color(0xFF065F46)],
      'icon': Icons.storage_rounded,
      'color': Color(0xFF10B981),
      'progress': 0.4,
      'tip': 'Practice JOIN queries and normalization',
    },
    {
      'subject': 'Operating Systems',
      'day': 'Thursday',
      'duration': '45 min',
      'timing': 'Evening session',
      'tags': ['Light Revision'],
      'tagColors': [Color(0xFFFFEDD5)],
      'tagText': [Color(0xFFEA580C)],
      'icon': Icons.memory_rounded,
      'color': Color(0xFF7C3AED),
      'progress': 0.7,
      'tip': 'Review process scheduling chapter',
    },
  ];

  // ── Weekly plan ───────────────────────────────────────────────
  final List<Map<String, dynamic>> _weeklyPlan = [
    {
      'day': 'Mon',
      'subjects': 'Data Structures + SE',
      'hours': 3.0,
      'maxHours': 4.0,
      'done': true,
      'color': Color(0xFF2563EB),
    },
    {
      'day': 'Tue',
      'subjects': 'Database + DS',
      'hours': 2.5,
      'maxHours': 4.0,
      'done': true,
      'color': Color(0xFF10B981),
    },
    {
      'day': 'Wed',
      'subjects': 'OS + Network Tech',
      'hours': 3.0,
      'maxHours': 4.0,
      'done': true,
      'color': Color(0xFF7C3AED),
    },
    {
      'day': 'Thu',
      'subjects': 'DS + Database + OS',
      'hours': 3.25,
      'maxHours': 4.0,
      'done': false,
      'color': Color(0xFFF59E0B),
    },
    {
      'day': 'Fri',
      'subjects': 'Network Tech + Review',
      'hours': 2.0,
      'maxHours': 3.0,
      'done': false,
      'color': Color(0xFF0891B2),
    },
    {
      'day': 'Sat',
      'subjects': 'Light revision only',
      'hours': 1.0,
      'maxHours': 2.0,
      'done': false,
      'color': Color(0xFFEF4444),
    },
    {
      'day': 'Sun',
      'subjects': 'Rest day',
      'hours': 0.0,
      'maxHours': 0.0,
      'done': false,
      'color': Color(0xFF94A3B8),
    },
  ];

  // ── Study tips ────────────────────────────────────────────────
  final List<String> _tips = [
    '📚 Study 1–2 hours before each class for better retention',
    '⏱️ Use the Pomodoro technique: 25 min study, 5 min break',
    '🧠 Review notes within 24 hours of a lecture',
    '💧 Stay hydrated — it helps your brain focus better',
    '🌙 Get 7–8 hours of sleep before exams',
  ];
  int _currentTip = 0;

  // ── Completed today ───────────────────────────────────────────
  final Set<int> _completedToday = {};

  double get _totalWeeklyHours =>
      _weeklyPlan.fold(0.0, (s, d) => s + (d['hours'] as double));

  double get _completedHours => _weeklyPlan
      .where((d) => d['done'] as bool)
      .fold(0.0, (s, d) => s + (d['hours'] as double));

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGray50,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────────────────
            _buildHeader(),

            // ── BODY ────────────────────────────────────────────
            Expanded(
              child: _hasTimetable ? _buildMainContent() : _buildEmptyState(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HEADER  (dark green → blue gradient)
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kGreen900, kGreen700, kBlue700],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        children: [
          // Title row
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Smart Study Planner',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        )),
                    Text(
                      'Study smarter — built from your timetable',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
              // Streak badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  const Text('🔥', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '$_streakCount day streak',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Weekly streak tracker
          Row(
            children: _streakDays.asMap().entries.map((e) {
              final i = e.key;
              final day = e.value;
              final done = day['done'] as bool;
              final isToday = i == 3; // Thursday = index 3

              return Expanded(
                child: Column(
                  children: [
                    Text(
                      day['day'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(isToday ? 1 : 0.6),
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: done
                            ? kGreen500
                            : isToday
                                ? Colors.white
                                : Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: done
                              ? kGreen500
                              : isToday
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: done
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 14)
                            : isToday
                                ? Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: kGreen700,
                                    ),
                                  )
                                : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // MAIN CONTENT
  // ─────────────────────────────────────────────────────────────
  Widget _buildMainContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── View toggle ────────────────────────────────────
          _buildViewToggle(),
          const SizedBox(height: 18),

          // ── Study tip card ─────────────────────────────────
          _buildTipCard(),
          const SizedBox(height: 20),

          // ── Today's suggestions ────────────────────────────
          if (_selectedView == 'Today' || _selectedView == 'All') ...[
            _sectionHeader('✨ Today\'s Suggestions',
                '${_todaySuggestions.length} sessions planned'),
            const SizedBox(height: 12),
            ..._todaySuggestions.asMap().entries.map(
                  (e) => _buildStudyCard(e.value, e.key),
                ),
            const SizedBox(height: 20),
          ],

          // ── Weekly plan ────────────────────────────────────
          if (_selectedView == 'Weekly' || _selectedView == 'All') ...[
            _sectionHeader(
              '📆 Weekly Study Plan',
              '${_completedHours.toStringAsFixed(1)} / '
                  '${_totalWeeklyHours.toStringAsFixed(1)} hrs done',
            ),
            const SizedBox(height: 12),
            _buildWeeklyProgressBar(),
            const SizedBox(height: 12),
            ..._weeklyPlan.map(_buildWeeklyRow),
            const SizedBox(height: 20),
          ],

          // ── Study stats summary ────────────────────────────
          _buildStatsGrid(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // VIEW TOGGLE
  // ─────────────────────────────────────────────────────────────
  Widget _buildViewToggle() {
    final views = ['Today', 'Weekly', 'All'];
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: kGray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: views.map((v) {
          final isActive = _selectedView == v;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedView = v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    v,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? kBlue500 : kGray500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // TIP CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildTipCard() {
    return GestureDetector(
      onTap: () =>
          setState(() => _currentTip = (_currentTip + 1) % _tips.length),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kGreen900, kBlue700],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kGreen900.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.lightbulb_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Study Tip',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white60,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      )),
                  const SizedBox(height: 3),
                  Text(
                    _tips[_currentTip],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.refresh_rounded,
                color: Colors.white.withOpacity(0.6), size: 16),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: kGray800,
            )),
        Text(subtitle,
            style: TextStyle(
              fontSize: 12,
              color: kGray400,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STUDY CARD  (Today's suggestions)
  // ─────────────────────────────────────────────────────────────
  Widget _buildStudyCard(Map<String, dynamic> session, int index) {
    final isDone = _completedToday.contains(index);
    final color = session['color'] as Color;
    final tags = session['tags'] as List<String>;
    final tagColors = session['tagColors'] as List<Color>;
    final tagText = session['tagText'] as List<Color>;
    final progress = session['progress'] as double;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + (index * 100)),
      curve: Curves.easeOut,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child:
            Transform.translate(offset: Offset(0, 16 * (1 - v)), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDone ? kGray50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDone ? kGray200 : color.withOpacity(0.25),
            width: isDone ? 1 : 1.5,
          ),
          boxShadow: isDone
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          children: [
            // ── Card body ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: subject + day badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDone ? kGray100 : color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            session['icon'] as IconData,
                            size: 18,
                            color: isDone ? kGray400 : color,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          session['subject'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDone ? kGray400 : kGray800,
                            decoration:
                                isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ]),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDone ? kGray100 : kBlue50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          session['day'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDone ? kGray400 : kBlue600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Recommended study time label
                  Text(
                    'RECOMMENDED STUDY TIME',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: kGray400,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Duration + timing
                  Row(children: [
                    Icon(Icons.timer_outlined,
                        size: 18, color: isDone ? kGray400 : color),
                    const SizedBox(width: 6),
                    Text(
                      session['duration'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDone ? kGray400 : color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '· ${session['timing']}',
                      style: TextStyle(fontSize: 12, color: kGray400),
                    ),
                  ]),
                  const SizedBox(height: 10),

                  // Tip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDone ? kGray50 : color.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      Icon(Icons.tips_and_updates_rounded,
                          size: 13, color: isDone ? kGray400 : color),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          session['tip'],
                          style: TextStyle(
                            fontSize: 11,
                            color: isDone ? kGray400 : color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 10),

                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: List.generate(tags.length, (i) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDone ? kGray100 : tagColors[i],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tags[i],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDone ? kGray400 : tagText[i],
                          ),
                        ),
                      );
                    }),
                  ),

                  // Progress bar (if in progress)
                  if (progress > 0 && !isDone) ...[
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: kGray100,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ]),
                  ],
                ],
              ),
            ),

            // ── Action bar ───────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: isDone ? kGray50 : color.withOpacity(0.06),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(children: [
                // Start / Done button
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      if (isDone) {
                        _completedToday.remove(index);
                      } else {
                        _completedToday.add(index);
                      }
                    }),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDone ? kGray200 : color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isDone
                                ? Icons.refresh_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isDone ? 'Mark Incomplete' : 'Start Studying',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Timer button
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kGray200),
                  ),
                  child: Icon(
                    Icons.timer_rounded,
                    size: 18,
                    color: isDone ? kGray400 : color,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // WEEKLY OVERALL PROGRESS BAR
  // ─────────────────────────────────────────────────────────────
  Widget _buildWeeklyProgressBar() {
    final progress =
        _totalWeeklyHours == 0 ? 0.0 : _completedHours / _totalWeeklyHours;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGray100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weekly Progress',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kGray800,
                  )),
              Text(
                '${_completedHours.toStringAsFixed(1)} / '
                '${_totalWeeklyHours.toStringAsFixed(1)} hrs',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: kBlue500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: kGray100,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? kGreen500 : kBlue500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}% complete',
                style: TextStyle(
                    fontSize: 11, color: kGray500, fontWeight: FontWeight.w500),
              ),
              Text(
                '${(_totalWeeklyHours - _completedHours).toStringAsFixed(1)} hrs remaining',
                style: TextStyle(
                    fontSize: 11, color: kGray400, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // WEEKLY ROW
  // ─────────────────────────────────────────────────────────────
  Widget _buildWeeklyRow(Map<String, dynamic> day) {
    final isDone = day['done'] as bool;
    final hours = day['hours'] as double;
    final maxHours = day['maxHours'] as double;
    final color = day['color'] as Color;
    final progress = maxHours == 0 ? 0.0 : hours / maxHours;
    final isRestDay = maxHours == 0;
    final isToday = day['day'] == 'Thu';

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isToday
            ? kBlue50
            : isDone
                ? const Color(0xFFF0FDF4)
                : Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: isToday
              ? kBlue100
              : isDone
                  ? const Color(0xFFD1FAE5)
                  : kGray100,
          width: isToday ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Day badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDone
                  ? kGreen500
                  : isToday
                      ? kBlue500
                      : color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: isDone
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : Center(
                    child: Text(
                      day['day'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isToday ? Colors.white : color,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Subject + progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day['subjects'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDone ? kGray500 : kGray800,
                    decoration: isDone ? TextDecoration.none : null,
                  ),
                ),
                const SizedBox(height: 4),
                if (!isRestDay)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: kGray100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDone ? kGreen500 : color,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Hours
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isRestDay ? '😴' : '${hours.toStringAsFixed(1)}h',
                style: TextStyle(
                  fontSize: isRestDay ? 18 : 14,
                  fontWeight: FontWeight.w800,
                  color: isDone
                      ? kGreen500
                      : isToday
                          ? kBlue500
                          : color,
                ),
              ),
              if (!isRestDay)
                Text(
                  'of ${maxHours.toStringAsFixed(0)}h',
                  style: TextStyle(fontSize: 10, color: kGray400),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STATS GRID
  // ─────────────────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    final stats = [
      {
        'value': '${_completedHours.toStringAsFixed(1)}h',
        'label': 'Studied\nThis Week',
        'icon': Icons.schedule_rounded,
        'color': kBlue500,
        'bg': kBlue50,
      },
      {
        'value': '$_streakCount',
        'label': 'Day\nStreak',
        'icon': Icons.local_fire_department_rounded,
        'color': kAmber,
        'bg': const Color(0xFFFFF7ED),
      },
      {
        'value': '${_completedToday.length}/${_todaySuggestions.length}',
        'label': 'Sessions\nDone Today',
        'icon': Icons.task_alt_rounded,
        'color': kGreen500,
        'bg': const Color(0xFFF0FDF4),
      },
      {
        'value': '5',
        'label': 'Subjects\nTracked',
        'icon': Icons.book_rounded,
        'color': kPurple,
        'bg': const Color(0xFFF5F3FF),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📊 Study Statistics',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: kGray800,
            )),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
          ),
          itemCount: stats.length,
          itemBuilder: (_, i) {
            final s = stats[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: s['bg'] as Color,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (s['color'] as Color).withOpacity(0.15),
                ),
              ),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (s['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(s['icon'] as IconData,
                      color: s['color'] as Color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(s['value'] as String,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: s['color'] as Color,
                          )),
                      Text(s['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: kGray500,
                            height: 1.3,
                          )),
                    ],
                  ),
                ),
              ]),
            );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // EMPTY STATE  (no timetable set up)
  // ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: kBlue50,
                shape: BoxShape.circle,
                border: Border.all(color: kBlue100, width: 2),
              ),
              child: const Icon(Icons.calendar_today_rounded,
                  size: 46, color: kBlue500),
            ),
            const SizedBox(height: 24),
            const Text('No Study Plan Yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kGray800,
                )),
            const SizedBox(height: 10),
            Text(
              'Add your class timetable first so we can '
              'suggest the best study times for you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: kGray500, height: 1.55),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kBlue50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBlue100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_rounded,
                      size: 18, color: kBlue500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '💡 Tip: Studying 1–2 hrs before class '
                      'improves retention by up to 40%',
                      style: TextStyle(
                        fontSize: 12,
                        color: kBlue600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/timetable'),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text('Set Up My Timetable',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() => _hasTimetable = true),
              child: Text('Preview with sample data',
                  style: TextStyle(color: kGray400, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BOTTOM NAV
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.calendar_today_rounded, 'label': 'Schedule'},
      {'icon': Icons.notifications_rounded, 'label': 'Alerts'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kGray100, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(items.length, (i) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (i == 0)
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('/dashboard'),
                      );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[i]['icon'] as IconData,
                          size: 24, color: kGray400),
                      const SizedBox(height: 4),
                      Text(items[i]['label'] as String,
                          style: TextStyle(fontSize: 10, color: kGray400)),
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
}

// ── Constants ─────────────────────────────────────────────────
const Color kBlue600 = Color(0xFF1A52A0);
const Color kPurple = Color(0xFF7C3AED);
