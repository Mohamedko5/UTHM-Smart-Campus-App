import 'package:flutter/material.dart';
import 'package:uthm_smart_campus/utils/main_navigation.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with SingleTickerProviderStateMixin {
  // ── Colors ────────────────────────────────────────────────────
  static const Color kBlue700 = Color(0xFF113A6E);
  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kBlue50 = Color(0xFFEFF6FF);
  static const Color kBlue100 = Color(0xFFDBEAFE);
  static const Color kBlue600 = Color(0xFF1A52A0);
  static const Color kGray50 = Color(0xFFF8FAFC);
  static const Color kGray100 = Color(0xFFF1F5F9);
  static const Color kGray200 = Color(0xFFE2E8F0);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray500 = Color(0xFF64748B);
  static const Color kGray800 = Color(0xFF1E293B);

  // ── State ─────────────────────────────────────────────────────
  int _selectedDay = 1; // 0=Mon, 1=Tue, 2=Wed, 3=Thu, 4=Fri

  // ── Days ──────────────────────────────────────────────────────
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  // ── Timetable Data (per day) ──────────────────────────────────
  final Map<int, List<Map<String, dynamic>>> _schedule = {
    0: [
      // Monday
      {
        'subject': 'Operating Systems',
        'lecturer': 'Dr. Azman Zakaria',
        'room': 'DK2, Block B',
        'start': '08:00',
        'end': '09:00',
        'color': Color(0xFF7C3AED),
      },
      {
        'subject': 'Software Engineering',
        'lecturer': 'Dr. Mohd Hanafi',
        'room': 'DK1, Block B',
        'start': '14:00',
        'end': '16:00',
        'color': Color(0xFFF59E0B),
      },
    ],
    1: [
      // Tuesday
      {
        'subject': 'Data Structures',
        'lecturer': 'Dr. Siti Norzahra',
        'room': 'DK3, Block A',
        'start': '08:00',
        'end': '09:00',
        'color': Color(0xFF2563EB),
      },
      {
        'subject': 'Database Systems',
        'lecturer': 'Prof. Rashid Aziz',
        'room': 'Lab 2, Block C',
        'start': '10:00',
        'end': '11:00',
        'color': Color(0xFF10B981),
      },
      {
        'subject': 'Software Engineering',
        'lecturer': 'Dr. Mohd Hanafi',
        'room': 'DK1, Block B',
        'start': '14:00',
        'end': '16:00',
        'color': Color(0xFFF59E0B),
      },
    ],
    2: [
      // Wednesday
      {
        'subject': 'Data Structures',
        'lecturer': 'Dr. Siti Norzahra',
        'room': 'Lab 1, Block A',
        'start': '09:00',
        'end': '11:00',
        'color': Color(0xFF2563EB),
      },
      {
        'subject': 'Network Technology',
        'lecturer': 'Dr. Harun Malik',
        'room': 'DK4, Block D',
        'start': '15:00',
        'end': '17:00',
        'color': Color(0xFF0891B2),
      },
    ],
    3: [
      // Thursday
      {
        'subject': 'Database Systems',
        'lecturer': 'Prof. Rashid Aziz',
        'room': 'DK2, Block C',
        'start': '08:00',
        'end': '10:00',
        'color': Color(0xFF10B981),
      },
      {
        'subject': 'Operating Systems',
        'lecturer': 'Dr. Azman Zakaria',
        'room': 'Lab 3, Block B',
        'start': '13:00',
        'end': '15:00',
        'color': Color(0xFF7C3AED),
      },
    ],
    4: [
      // Friday
      {
        'subject': 'Network Technology',
        'lecturer': 'Dr. Harun Malik',
        'room': 'DK5, Block E',
        'start': '08:00',
        'end': '09:00',
        'color': Color(0xFF0891B2),
      },
    ],
  };

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    // Set selected day to today (Mon=0 ... Fri=4), default Tue if weekend
    final weekday = DateTime.now().weekday; // 1=Mon, 7=Sun
    _selectedDay = (weekday >= 1 && weekday <= 5) ? weekday - 1 : 1;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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

  // ── Switch day ────────────────────────────────────────────────
  void _selectDay(int index) {
    setState(() => _selectedDay = index);
    _animController
      ..reset()
      ..forward();
  }

  // ── Add class dialog ──────────────────────────────────────────
  void _showAddClassDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddClassSheet(
        dayName: _days[_selectedDay],
        onAdd: (classData) {
          setState(() {
            _schedule[_selectedDay]?.add(classData);
          });
        },
      ),
    );
  }

  // ── Edit class ────────────────────────────────────────────────
  void _showEditDialog(int classIndex) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Edit Class',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Edit functionality will be added in the next update.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _schedule[_selectedDay]?.removeAt(classIndex);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final classes = _schedule[_selectedDay] ?? [];

    return Scaffold(
      backgroundColor: kGray50,
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────
          _buildHeader(),

          // ── BODY ────────────────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: classes.isEmpty
                  ? _buildEmptyState()
                  : _buildClassList(classes),
            ),
          ),
        ],
      ),

      // ── FAB ─────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddClassDialog,
        backgroundColor: kBlue500,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Class',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      // ── BOTTOM NAV ──────────────────────────────────────────
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HEADER  (blue gradient + day tabs)
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
      child: Column(
        children: [
          // Title row
          Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Timetable',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Semester 2, 2024/2025',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),

              // Total classes badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_schedule[_selectedDay]?.length ?? 0} classes',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Day tabs
          Row(
            children: List.generate(_days.length, (index) {
              final isSelected = _selectedDay == index;
              final isToday = (DateTime.now().weekday - 1) == index &&
                  DateTime.now().weekday <= 5;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _selectDay(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: isToday && !isSelected
                          ? Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _days[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? kBlue700
                                : Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(height: 3),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isSelected ? kBlue500 : Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // CLASS LIST
  // ─────────────────────────────────────────────────────────────
  Widget _buildClassList(List<Map<String, dynamic>> classes) {
    // Sort classes by start time
    final sorted = List<Map<String, dynamic>>.from(classes)
      ..sort((a, b) => a['start'].compareTo(b['start']));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOut,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - value)),
              child: child,
            ),
          ),
          child: _buildClassCard(sorted[index], index),
        );
      },
    );
  }

  Widget _buildClassCard(Map<String, dynamic> cls, int index) {
    final Color subjectColor = cls['color'] as Color;

    return GestureDetector(
      onLongPress: () => _showEditDialog(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kGray100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // ── Left color bar ───────────────────────────────
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: subjectColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),

              // ── Time column ──────────────────────────────────
              Container(
                width: 58,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cls['start'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: kGray500,
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 28,
                      color: kGray200,
                    ),
                    Text(
                      cls['end'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: kGray500,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Divider ──────────────────────────────────────
              Container(width: 1, color: kGray100),

              // ── Class info ───────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject name
                      Text(
                        cls['subject'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: kGray800,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Lecturer
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded,
                              size: 13, color: kGray400),
                          const SizedBox(width: 4),
                          Text(
                            cls['lecturer'],
                            style: TextStyle(
                              fontSize: 12,
                              color: kGray500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Room badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: kBlue50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: kBlue100),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🏫',
                                    style: TextStyle(fontSize: 11)),
                                const SizedBox(width: 5),
                                Text(
                                  cls['room'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: kBlue600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Duration badge
                          _buildDurationBadge(
                              cls['start'], cls['end'], subjectColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Edit button ──────────────────────────────────
              GestureDetector(
                onTap: () => _showEditDialog(index),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: kGray400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationBadge(String start, String end, Color color) {
    // Calculate duration in hours
    final startParts = start.split(':');
    final endParts = end.split(':');
    final startH = int.parse(startParts[0]);
    final endH = int.parse(endParts[0]);
    final duration = endH - startH;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${duration}h',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // EMPTY STATE
  // ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📅', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          const Text(
            'No Classes Today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kGray800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no classes on ${_days[_selectedDay]}.\nEnjoy your free day! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: kGray500, height: 1.5),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _showAddClassDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: kBlue500,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '＋  Add a Class',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BOTTOM NAV
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kGray100, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(kMainNavItems.length, (index) {
              final isActive = index == 1;
              return Expanded(
                child: GestureDetector(
                  onTap: () => navigateToMainTab(context, index, '/timetable'),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        kMainNavItems[index]['icon'] as IconData,
                        size: 24,
                        color: isActive ? kBlue500 : kGray400,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kMainNavItems[index]['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? kBlue500 : kGray400,
                        ),
                      ),
                      const SizedBox(height: 2),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// ADD CLASS BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _AddClassSheet extends StatefulWidget {
  final String dayName;
  final Function(Map<String, dynamic>) onAdd;

  const _AddClassSheet({required this.dayName, required this.onAdd});

  @override
  State<_AddClassSheet> createState() => __AddClassSheetState();
}

class __AddClassSheetState extends State<_AddClassSheet> {
  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kGray200 = Color(0xFFE2E8F0);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray50 = Color(0xFFF8FAFC);

  final _subjectCtrl = TextEditingController();
  final _lecturerCtrl = TextEditingController();
  final _roomCtrl = TextEditingController();
  String _startTime = '08:00';
  String _endTime = '09:00';

  final List<Color> _colors = [
    const Color(0xFF2563EB),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFF7C3AED),
    const Color(0xFF0891B2),
    const Color(0xFFEF4444),
  ];
  int _selectedColor = 0;

  InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kGray400, fontSize: 13),
        prefixIcon: Icon(icon, color: kGray400, size: 18),
        filled: true,
        fillColor: kGray50,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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

            Text(
              'Add Class — ${widget.dayName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 18),

            // Subject
            TextField(
              controller: _subjectCtrl,
              decoration: _inputDeco(
                  'Subject name (e.g. Data Structures)', Icons.book_outlined),
            ),
            const SizedBox(height: 12),

            // Lecturer
            TextField(
              controller: _lecturerCtrl,
              decoration: _inputDeco('Lecturer name (e.g. Dr. Ahmad)',
                  Icons.person_outline_rounded),
            ),
            const SizedBox(height: 12),

            // Room
            TextField(
              controller: _roomCtrl,
              decoration: _inputDeco(
                  'Room (e.g. DK3, Block A)', Icons.location_on_outlined),
            ),
            const SizedBox(height: 12),

            // Time row
            Row(
              children: [
                Expanded(
                  child: _buildTimePicker('Start', _startTime, (t) {
                    setState(() => _startTime = t);
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTimePicker('End', _endTime, (t) {
                    setState(() => _endTime = t);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Color picker
            const Text(
              'Subject Color',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(_colors.length, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _selectedColor == i ? 36 : 30,
                    height: _selectedColor == i ? 36 : 30,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: _colors[i],
                      shape: BoxShape.circle,
                      border: _selectedColor == i
                          ? Border.all(
                              color: _colors[i].withValues(alpha: 0.4),
                              width: 4,
                            )
                          : null,
                    ),
                    child: _selectedColor == i
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_subjectCtrl.text.isEmpty) return;
                  widget.onAdd({
                    'subject': _subjectCtrl.text,
                    'lecturer':
                        _lecturerCtrl.text.isEmpty ? 'TBA' : _lecturerCtrl.text,
                    'room': _roomCtrl.text.isEmpty ? 'TBA' : _roomCtrl.text,
                    'start': _startTime,
                    'end': _endTime,
                    'color': _colors[_selectedColor],
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save Class',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
      String label, String value, Function(String) onChanged) {
    return GestureDetector(
      onTap: () async {
        final parts = value.split(':');
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          ),
        );
        if (picked != null) {
          onChanged(
              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: kGray50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kGray200),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, color: kGray400, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10,
                        color: kGray400,
                        fontWeight: FontWeight.w600)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
