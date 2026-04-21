import 'package:flutter/material.dart';
import 'package:uthm_smart_campus/utils/app_language.dart';
import 'package:uthm_smart_campus/utils/main_navigation.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen>
    with SingleTickerProviderStateMixin {
  // ── Colors ────────────────────────────────────────────────────
  static const Color kBlue700 = Color(0xFF113A6E);
  static const Color kBlue600 = Color(0xFF1A52A0);
  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kBlue100 = Color(0xFFDBEAFE);
  static const Color kBlue50 = Color(0xFFEFF6FF);
  static const Color kTeal = Color(0xFF0891B2);
  static const Color kGray50 = Color(0xFFF8FAFC);
  static const Color kGray100 = Color(0xFFF1F5F9);
  static const Color kGray200 = Color(0xFFE2E8F0);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray500 = Color(0xFF64748B);
  static const Color kGray800 = Color(0xFF1E293B);
  static const Color kGreen = Color(0xFF10B981);
  static const Color kRed = Color(0xFFEF4444);
  static const Color kAmber = Color(0xFFF59E0B);
  static const Color kPurple = Color(0xFF7C3AED);

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ── Filter state ──────────────────────────────────────────────
  String _filter = 'All'; // All | Today | Upcoming | Done

  // ── Reminders data ───────────────────────────────────────────
  final List<Map<String, dynamic>> _reminders = [
    {
      'id': 'r001',
      'title': 'Submit Lab Report',
      'subject': 'Data Structures',
      'time': '10:00 AM',
      'date': 'Today',
      'priority': 'High',
      'done': false,
      'color': Color(0xFFEF4444),
      'icon': Icons.assignment_rounded,
    },
    {
      'id': 'r002',
      'title': 'Group Project Meeting',
      'subject': 'Software Engineering',
      'time': '2:00 PM',
      'date': 'Today',
      'priority': 'Medium',
      'done': false,
      'color': Color(0xFFF59E0B),
      'icon': Icons.groups_rounded,
    },
    {
      'id': 'r003',
      'title': 'Morning Lecture',
      'subject': 'Database Systems',
      'time': '8:00 AM',
      'date': 'Today',
      'priority': 'Low',
      'done': true,
      'color': Color(0xFF10B981),
      'icon': Icons.school_rounded,
    },
    {
      'id': 'r004',
      'title': 'Quiz Preparation',
      'subject': 'Operating Systems',
      'time': 'All Day',
      'date': 'Tomorrow',
      'priority': 'High',
      'done': false,
      'color': Color(0xFFEF4444),
      'icon': Icons.quiz_rounded,
    },
    {
      'id': 'r005',
      'title': 'Library Book Return',
      'subject': 'UTHM Library',
      'time': 'Before 5 PM',
      'date': 'Tomorrow',
      'priority': 'High',
      'done': false,
      'color': Color(0xFFEF4444),
      'icon': Icons.library_books_rounded,
    },
    {
      'id': 'r006',
      'title': 'Assignment Submission',
      'subject': 'Network Technology',
      'time': '11:59 PM',
      'date': 'This Week',
      'priority': 'Medium',
      'done': false,
      'color': Color(0xFFF59E0B),
      'icon': Icons.upload_file_rounded,
    },
    {
      'id': 'r007',
      'title': 'Practical Exam',
      'subject': 'Computer Lab',
      'time': '9:00 AM',
      'date': 'This Week',
      'priority': 'High',
      'done': false,
      'color': Color(0xFF7C3AED),
      'icon': Icons.computer_rounded,
    },
    {
      'id': 'r008',
      'title': 'Seminar Attendance',
      'subject': 'Faculty of CS',
      'time': '3:00 PM',
      'date': 'This Week',
      'priority': 'Low',
      'done': false,
      'color': Color(0xFF0891B2),
      'icon': Icons.event_rounded,
    },
  ];

  // ── Filters ───────────────────────────────────────────────────
  final List<Map<String, dynamic>> _filterTabs = [
    {'label': 'All', 'icon': Icons.list_rounded},
    {'label': 'Today', 'icon': Icons.today_rounded},
    {'label': 'Upcoming', 'icon': Icons.upcoming_rounded},
    {'label': 'Done', 'icon': Icons.check_circle_rounded},
  ];

  List<Map<String, dynamic>> get _filtered {
    switch (_filter) {
      case 'Today':
        return _reminders
            .where((r) => r['date'] == 'Today' && !(r['done'] as bool))
            .toList();
      case 'Upcoming':
        return _reminders
            .where((r) =>
                (r['date'] == 'Tomorrow' || r['date'] == 'This Week') &&
                !(r['done'] as bool))
            .toList();
      case 'Done':
        return _reminders.where((r) => r['done'] as bool).toList();
      default:
        return _reminders;
    }
  }

  // Group by date
  Map<String, List<Map<String, dynamic>>> get _grouped {
    final Map<String, List<Map<String, dynamic>>> groups = {};
    for (final r in _filtered) {
      final date = r['date'] as String;
      groups.putIfAbsent(date, () => []).add(r);
    }
    return groups;
  }

  int get _pendingCount => _reminders.where((r) => !(r['done'] as bool)).length;

  int get _doneCount => _reminders.where((r) => r['done'] as bool).length;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Toggle done ───────────────────────────────────────────────
  void _toggleDone(String id) {
    setState(() {
      final idx = _reminders.indexWhere((r) => r['id'] == id);
      if (idx != -1) {
        _reminders[idx]['done'] = !(_reminders[idx]['done'] as bool);
      }
    });
  }

  // ── Delete reminder ───────────────────────────────────────────
  void _deleteReminder(String id) {
    setState(() {
      _reminders.removeWhere((r) => r['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('Reminder deleted')),
        backgroundColor: kRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {}, // Would restore in real app
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;
    final dateOrder = ['Today', 'Tomorrow', 'This Week'];

    return Scaffold(
      backgroundColor: kGray50,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────────────────
            _buildHeader(),

            // ── STATS ROW ───────────────────────────────────────
            _buildStatsRow(),

            // ── FILTER TABS ─────────────────────────────────────
            _buildFilterTabs(),

            // ── REMINDER LIST ───────────────────────────────────
            Expanded(
              child: _filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      children: [
                        for (final date in dateOrder)
                          if (grouped.containsKey(date)) ...[
                            _buildDateHeader(date),
                            const SizedBox(height: 8),
                            ...grouped[date]!.map(
                              (r) => _buildReminderCard(r),
                            ),
                            const SizedBox(height: 4),
                          ],
                      ],
                    ),
            ),
          ],
        ),
      ),

      // ── FAB ───────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReminderSheet,
        backgroundColor: kBlue500,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(context.tr('Add Reminder'),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
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
        bottom: 18,
      ),
      child: Row(
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
                Text(context.tr('Reminders'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    )),
                Text(context.tr('Stay on top of your deadlines'),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.65),
                    )),
              ],
            ),
          ),
          // Pending badge
          if (_pendingCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: kRed.withOpacity(0.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$_pendingCount pending',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STATS ROW
  // ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final total = _reminders.length;
    final highPri = _reminders
        .where((r) => r['priority'] == 'High' && !(r['done'] as bool))
        .length;
    final progress = total == 0 ? 0.0 : _doneCount / total;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        children: [
          Row(children: [
            _statBox('$_pendingCount', 'Pending', kRed,
                Icons.pending_actions_rounded),
            const SizedBox(width: 10),
            _statBox(
                '$_doneCount', 'Completed', kGreen, Icons.check_circle_rounded),
            const SizedBox(width: 10),
            _statBox('$highPri', 'High Priority', kAmber,
                Icons.priority_high_rounded),
          ]),
          const SizedBox(height: 12),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.tr('Overall Progress'),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kGray500)),
                  Text(
                    '${(_doneCount)}/${total} tasks',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: kBlue500),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: kGray100,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? kGreen : kBlue500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: color,
                    )),
                Text(label,
                    style: TextStyle(
                      fontSize: 9,
                      color: color.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // FILTER TABS
  // ─────────────────────────────────────────────────────────────
  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: _filterTabs.map((tab) {
          final isActive = _filter == tab['label'];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _filter = tab['label']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? kBlue500 : kGray50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive ? kBlue500 : kGray200,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      size: 16,
                      color: isActive ? Colors.white : kGray400,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tab['label'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? Colors.white : kGray500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // DATE SECTION HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _buildDateHeader(String date) {
    final colors = {
      'Today': kRed,
      'Tomorrow': kAmber,
      'This Week': kBlue500,
    };
    final icons = {
      'Today': Icons.today_rounded,
      'Tomorrow': Icons.event_rounded,
      'This Week': Icons.date_range_rounded,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icons[date] ?? Icons.event_rounded,
              size: 15, color: colors[date] ?? kGray500),
          const SizedBox(width: 6),
          Text(
            date.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: colors[date] ?? kGray500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: (colors[date] ?? kGray200).withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // REMINDER CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    final isDone = reminder['done'] as bool;
    final priority = reminder['priority'] as String;
    final color = reminder['color'] as Color;
    final id = reminder['id'] as String;

    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = kRed;
        break;
      case 'Medium':
        priorityColor = kAmber;
        break;
      default:
        priorityColor = kGreen;
    }

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: kRed,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
      ),
      onDismissed: (_) => _deleteReminder(id),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        builder: (_, v, child) => Opacity(
          opacity: v,
          child: Transform.translate(
              offset: Offset(0, 10 * (1 - v)), child: child),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isDone ? kGray50 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDone ? kGray200 : color.withOpacity(0.3),
              width: isDone ? 1 : 1.5,
            ),
            boxShadow: isDone
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // ── Check circle ─────────────────────────────
                GestureDetector(
                  onTap: () => _toggleDone(id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: isDone ? kGreen : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDone ? kGreen : kGray300,
                        width: 2,
                      ),
                    ),
                    child: isDone
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 15)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),

                // ── Icon ─────────────────────────────────────
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDone ? kGray100 : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    reminder['icon'] as IconData,
                    size: 20,
                    color: isDone ? kGray400 : color,
                  ),
                ),
                const SizedBox(width: 12),

                // ── Info ─────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDone ? kGray400 : kGray800,
                          decoration:
                              isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        reminder['subject'],
                        style: TextStyle(fontSize: 11, color: kGray500),
                      ),
                      const SizedBox(height: 6),
                      Row(children: [
                        // Time badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDone
                                ? kGray100
                                : priority == 'High'
                                    ? const Color(0xFFFEE2E2)
                                    : kBlue50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 10,
                              color: isDone
                                  ? kGray400
                                  : priority == 'High'
                                      ? kRed
                                      : kBlue500,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              reminder['time'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isDone
                                    ? kGray400
                                    : priority == 'High'
                                        ? kRed
                                        : kBlue500,
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(width: 6),

                        // Priority badge
                        if (!isDone)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              priority,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: priorityColor,
                              ),
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),

                // ── Delete button ─────────────────────────────
                GestureDetector(
                  onTap: () => _confirmDelete(id),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: kGray400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr('Delete Reminder?'),
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(context.tr('This reminder will be permanently deleted.')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('Cancel'), style: TextStyle(color: kGray500)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteReminder(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(context.tr('Delete'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // EMPTY STATE
  // ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    String emoji, title, subtitle;
    switch (_filter) {
      case 'Done':
        emoji = '✅';
        title = 'No completed tasks yet';
        subtitle = 'Complete a reminder and it will appear here';
        break;
      case 'Today':
        emoji = '🎉';
        title = 'All clear for today!';
        subtitle = 'No pending reminders for today';
        break;
      default:
        emoji = '🔔';
        title = 'No reminders yet';
        subtitle = 'Tap the button below to add your first reminder';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kGray800,
              )),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: kGray500, height: 1.5)),
          const SizedBox(height: 24),
          if (_filter != 'Done')
            GestureDetector(
              onTap: _showAddReminderSheet,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: kBlue500,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(context.tr('Add Reminder'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ADD REMINDER BOTTOM SHEET
  // ─────────────────────────────────────────────────────────────
  void _showAddReminderSheet() {
    final titleCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    String selectedDate = 'Today';
    String selectedTime = '9:00 AM';
    String selectedPriority = 'Medium';
    IconData selectedIcon = Icons.notifications_rounded;

    final dateOptions = ['Today', 'Tomorrow', 'This Week'];
    final priorityOptions = ['Low', 'Medium', 'High'];
    final iconOptions = [
      Icons.assignment_rounded,
      Icons.groups_rounded,
      Icons.school_rounded,
      Icons.quiz_rounded,
      Icons.library_books_rounded,
      Icons.upload_file_rounded,
      Icons.computer_rounded,
      Icons.event_rounded,
      Icons.notifications_rounded,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: kGray200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(context.tr('Add Reminder'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: kGray800,
                      )),
                  const SizedBox(height: 18),

                  // Title
                  _sheetLabel('Title'),
                  const SizedBox(height: 6),
                  _sheetInput(
                      titleCtrl, 'e.g. Submit Lab Report', Icons.title_rounded),
                  const SizedBox(height: 14),

                  // Subject
                  _sheetLabel('Subject / Course'),
                  const SizedBox(height: 6),
                  _sheetInput(
                      subjectCtrl, 'e.g. Data Structures', Icons.book_rounded),
                  const SizedBox(height: 14),

                  // Date
                  _sheetLabel('Date'),
                  const SizedBox(height: 6),
                  Row(
                    children: dateOptions.map((d) {
                      final isActive = selectedDate == d;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setSheet(() => selectedDate = d),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive ? kBlue500 : kGray50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isActive ? kBlue500 : kGray200,
                              ),
                            ),
                            child: Text(d,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isActive ? Colors.white : kGray500,
                                )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Priority
                  _sheetLabel('Priority'),
                  const SizedBox(height: 6),
                  Row(
                    children: priorityOptions.map((p) {
                      final isActive = selectedPriority == p;
                      final pColor = p == 'High'
                          ? kRed
                          : p == 'Medium'
                              ? kAmber
                              : kGreen;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setSheet(() => selectedPriority = p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  isActive ? pColor : pColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: pColor.withOpacity(isActive ? 1 : 0.3),
                              ),
                            ),
                            child: Text(p,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isActive ? Colors.white : pColor,
                                )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Icon picker
                  _sheetLabel('Icon'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: iconOptions.map((ico) {
                      final isActive = selectedIcon == ico;
                      return GestureDetector(
                        onTap: () => setSheet(() => selectedIcon = ico),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isActive ? kBlue500 : kGray50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isActive ? kBlue500 : kGray200,
                            ),
                          ),
                          child: Icon(ico,
                              size: 22,
                              color: isActive ? Colors.white : kGray400),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (titleCtrl.text.isEmpty) return;
                        final pColor = selectedPriority == 'High'
                            ? kRed
                            : selectedPriority == 'Medium'
                                ? kAmber
                                : kGreen;
                        setState(() {
                          _reminders.add({
                            'id': 'r${DateTime.now().millisecond}',
                            'title': titleCtrl.text,
                            'subject': subjectCtrl.text.isEmpty
                                ? 'General'
                                : subjectCtrl.text,
                            'time': selectedTime,
                            'date': selectedDate,
                            'priority': selectedPriority,
                            'done': false,
                            'color': pColor,
                            'icon': selectedIcon,
                          });
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.tr('Reminder added ✓')),
                            backgroundColor: kGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(16),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon:
                          const Icon(Icons.check_rounded, color: Colors.white),
                      label: Text(context.tr('Save Reminder'),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBlue500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sheetLabel(String text) => Text(text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: kGray500,
        letterSpacing: 0.5,
      ));

  Widget _sheetInput(TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kGray400, fontSize: 13),
        prefixIcon: Icon(icon, color: kGray400, size: 18),
        filled: true,
        fillColor: kGray50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kGray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kGray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBlue500, width: 2),
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
              final isActive = i == 2; // Alerts tab
              return Expanded(
                child: GestureDetector(
                  onTap: () => navigateToMainTab(context, i, '/reminder'),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[i]['icon'] as IconData,
                          size: 24, color: isActive ? kBlue500 : kGray400),
                      const SizedBox(height: 4),
                      Text(context.tr(items[i]['label'] as String),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? kBlue500 : kGray400,
                          )),
                      const SizedBox(height: 3),
                      if (isActive)
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
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
}

// ── Missing constant ──────────────────────────────────────────
const Color kGray300 = Color(0xFFCBD5E1);
