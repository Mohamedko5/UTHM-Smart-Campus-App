import 'package:flutter/material.dart';
import 'package:uthm_smart_campus/utils/app_language.dart';

class RoomBookingScreen extends StatefulWidget {
  const RoomBookingScreen({super.key});

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen>
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

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ── Form State ────────────────────────────────────────────────
  String? _selectedRoom;
  DateTime _selectedDate = DateTime.now();
  String? _selectedStart;
  String? _selectedEnd;
  String _purpose = '';
  int _attendees = 1;
  bool _isSubmitting = false;

  final TextEditingController _purposeCtrl = TextEditingController();

  // ── Room list ─────────────────────────────────────────────────
  final List<Map<String, dynamic>> _rooms = [
    {
      'id': 'DK1',
      'name': 'Lecture Hall DK1',
      'block': 'Block A',
      'capacity': 80,
      'icon': Icons.school_rounded,
      'color': Color(0xFF2563EB),
      'features': ['Projector', 'Whiteboard', 'AC', 'WiFi'],
    },
    {
      'id': 'DK2',
      'name': 'Lecture Hall DK2',
      'block': 'Block B',
      'capacity': 60,
      'icon': Icons.school_rounded,
      'color': Color(0xFF7C3AED),
      'features': ['Projector', 'Whiteboard', 'AC'],
    },
    {
      'id': 'DK3',
      'name': 'Seminar Room DK3',
      'block': 'Block A',
      'capacity': 40,
      'icon': Icons.meeting_room_rounded,
      'color': Color(0xFF0891B2),
      'features': ['TV Screen', 'Whiteboard', 'AC', 'WiFi'],
    },
    {
      'id': 'LAB1',
      'name': 'Computer Lab 1',
      'block': 'Block C',
      'capacity': 30,
      'icon': Icons.computer_rounded,
      'color': Color(0xFF10B981),
      'features': ['30 PCs', 'Projector', 'AC', 'WiFi'],
    },
    {
      'id': 'LAB2',
      'name': 'Computer Lab 2',
      'block': 'Block C',
      'capacity': 25,
      'icon': Icons.computer_rounded,
      'color': Color(0xFFF59E0B),
      'features': ['25 PCs', 'Projector', 'AC'],
    },
    {
      'id': 'DISC1',
      'name': 'Discussion Room 1',
      'block': 'Library',
      'capacity': 10,
      'icon': Icons.groups_rounded,
      'color': Color(0xFFEF4444),
      'features': ['Whiteboard', 'AC', 'WiFi'],
    },
  ];

  // ── Time slots ────────────────────────────────────────────────
  final List<String> _timeSlots = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
  ];

  // ── Booked slots (simulated) ──────────────────────────────────
  // Key = roomId_date, Value = list of booked start times
  final Map<String, List<String>> _bookedSlots = {
    'DK1_today': ['08:00', '09:00', '14:00', '15:00'],
    'DK3_today': ['10:00', '11:00'],
    'LAB1_today': ['08:00', '09:00', '10:00'],
  };

  List<String> _getBookedForRoom() {
    if (_selectedRoom == null) return [];
    final key = '${_selectedRoom}_today';
    return _bookedSlots[key] ?? [];
  }

  bool _isSlotBooked(String time) => _getBookedForRoom().contains(time);

  bool _isSlotAvailable(String time) => !_isSlotBooked(time);

  // ── Booked history ────────────────────────────────────────────
  final List<Map<String, dynamic>> _myBookings = [
    {
      'room': 'Seminar Room DK3',
      'block': 'Block A',
      'date': 'Tomorrow',
      'start': '14:00',
      'end': '16:00',
      'status': 'Confirmed',
      'icon': Icons.meeting_room_rounded,
      'color': Color(0xFF0891B2),
    },
    {
      'room': 'Discussion Room 1',
      'block': 'Library',
      'date': '20 Apr 2025',
      'start': '10:00',
      'end': '12:00',
      'status': 'Pending',
      'icon': Icons.groups_rounded,
      'color': Color(0xFFEF4444),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _purposeCtrl.dispose();
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
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── SECTION: Book a Room ─────────────────
                    _sectionTitle('Book a Room', Icons.add_circle_rounded),
                    const SizedBox(height: 14),

                    // Step 1 — Select room
                    _stepCard(
                      step: '1',
                      title: 'Select Room',
                      child: _buildRoomSelector(),
                    ),
                    const SizedBox(height: 14),

                    // Step 2 — Select date
                    _stepCard(
                      step: '2',
                      title: 'Select Date',
                      child: _buildDateSelector(),
                    ),
                    const SizedBox(height: 14),

                    // Step 3 — Time slots
                    _stepCard(
                      step: '3',
                      title: 'Available Time Slots',
                      child: _buildTimeSlots(),
                    ),
                    const SizedBox(height: 14),

                    // Step 4 — Details
                    _stepCard(
                      step: '4',
                      title: 'Booking Details',
                      child: _buildBookingDetails(),
                    ),
                    const SizedBox(height: 20),

                    // Booking rules
                    _buildRulesCard(),
                    const SizedBox(height: 20),

                    // Submit button
                    _buildSubmitButton(),
                    const SizedBox(height: 32),

                    // ── SECTION: My Bookings ─────────────────
                    _sectionTitle('My Bookings', Icons.history_rounded),
                    const SizedBox(height: 14),
                    ..._myBookings.map(_buildBookingHistoryCard),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                Text(context.tr('Room Booking'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    )),
                Text(context.tr('Reserve campus rooms & labs'),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.65),
                    )),
              ],
            ),
          ),
          // My bookings count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${_myBookings.length} booked',
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
  // HELPERS
  // ─────────────────────────────────────────────────────────────
  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kBlue500),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: kGray800,
            )),
      ],
    );
  }

  Widget _stepCard({
    required String step,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: kBlue500,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(step,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        )),
                  ),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kGray800,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 1 — ROOM SELECTOR
  // ─────────────────────────────────────────────────────────────
  Widget _buildRoomSelector() {
    return Column(
      children: _rooms.map((room) {
        final isSelected = _selectedRoom == room['id'];
        return GestureDetector(
          onTap: () => setState(() {
            _selectedRoom = room['id'];
            _selectedStart = null;
            _selectedEnd = null;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? kBlue50 : kGray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? kBlue500 : kGray200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: (room['color'] as Color)
                        .withOpacity(isSelected ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    room['icon'] as IconData,
                    color: room['color'] as Color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(room['name'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? kBlue700 : kGray800,
                          )),
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.location_on_rounded,
                            size: 11, color: kGray400),
                        const SizedBox(width: 3),
                        Text(room['block'],
                            style: TextStyle(fontSize: 11, color: kGray500)),
                        const SizedBox(width: 8),
                        Icon(Icons.people_rounded, size: 11, color: kGray400),
                        const SizedBox(width: 3),
                        Text('${room['capacity']} seats',
                            style: TextStyle(fontSize: 11, color: kGray500)),
                      ]),
                      // Features
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 5,
                        children: (room['features'] as List<String>)
                            .map((f) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected ? kBlue100 : kGray100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(f,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? kBlue700 : kGray500,
                                      )),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded,
                      color: kBlue500, size: 22),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 2 — DATE SELECTOR
  // ─────────────────────────────────────────────────────────────
  Widget _buildDateSelector() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Week strip
        Row(
          children: List.generate(6, (i) {
            final date = today.add(Duration(days: i));
            final isSelected = _selectedDate.day == date.day &&
                _selectedDate.month == date.month;
            final isToday = i == 0;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                    _selectedStart = null;
                    _selectedEnd = null;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? kBlue500 : kGray50,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: isSelected
                          ? kBlue500
                          : isToday
                              ? kBlue200
                              : kGray200,
                      width: isToday && !isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(days[i],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : kGray500,
                          )),
                      const SizedBox(height: 4),
                      Text('${date.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : kGray800,
                          )),
                      if (isToday) ...[
                        const SizedBox(height: 3),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : kBlue500,
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
        const SizedBox(height: 10),
        // Full date display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: kBlue50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kBlue100),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 16, color: kBlue500),
              const SizedBox(width: 8),
              Text(
                _formatDate(_selectedDate),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: kBlue700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 3 — TIME SLOTS
  // ─────────────────────────────────────────────────────────────
  Widget _buildTimeSlots() {
    if (_selectedRoom == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kGray50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kGray200, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline_rounded, size: 16, color: kGray400),
            const SizedBox(width: 8),
            Text(context.tr('Please select a room first'),
                style: TextStyle(fontSize: 13, color: kGray400)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        Row(
          children: [
            _legendDot(kGreen, 'Available'),
            const SizedBox(width: 14),
            _legendDot(kRed, 'Booked'),
            const SizedBox(width: 14),
            _legendDot(kBlue500, 'Selected'),
          ],
        ),
        const SizedBox(height: 12),

        // Slots grid
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _timeSlots.map((time) {
            final booked = _isSlotBooked(time);
            final isStart = _selectedStart == time;
            final isEnd = _selectedEnd == time;
            final isInRange = _isInRange(time);

            Color bgColor;
            Color textColor;
            Color borderColor;

            if (booked) {
              bgColor = const Color(0xFFFEE2E2);
              textColor = kRed;
              borderColor = const Color(0xFFFCA5A5);
            } else if (isStart || isEnd) {
              bgColor = kBlue500;
              textColor = Colors.white;
              borderColor = kBlue500;
            } else if (isInRange) {
              bgColor = kBlue100;
              textColor = kBlue700;
              borderColor = kBlue500;
            } else {
              bgColor = const Color(0xFFD1FAE5);
              textColor = const Color(0xFF065F46);
              borderColor = const Color(0xFF6EE7B7);
            }

            return GestureDetector(
              onTap: booked ? null : () => _selectTimeSlot(time),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Text(time,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          decoration:
                              booked ? TextDecoration.lineThrough : null,
                        )),
                    if (isStart)
                      Text(context.tr('Start'),
                          style: TextStyle(
                              fontSize: 8,
                              color: textColor,
                              fontWeight: FontWeight.w600)),
                    if (isEnd)
                      Text(context.tr('End'),
                          style: TextStyle(
                              fontSize: 8,
                              color: textColor,
                              fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        // Selected time summary
        if (_selectedStart != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kBlue50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kBlue100),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 16, color: kBlue500),
                const SizedBox(width: 8),
                Text(
                  _selectedEnd != null
                      ? 'Selected: $_selectedStart – $_selectedEnd  '
                          '(${_calcDuration()} hrs)'
                      : 'Start: $_selectedStart · Tap end time',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kBlue700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              fontSize: 11, color: kGray500, fontWeight: FontWeight.w500)),
    ]);
  }

  void _selectTimeSlot(String time) {
    setState(() {
      if (_selectedStart == null) {
        // First tap → set start
        _selectedStart = time;
        _selectedEnd = null;
      } else if (_selectedEnd == null && time != _selectedStart) {
        // Second tap → set end (must be after start)
        final startIdx = _timeSlots.indexOf(_selectedStart!);
        final endIdx = _timeSlots.indexOf(time);
        if (endIdx > startIdx) {
          // Check no booked slots in between
          bool conflict = false;
          for (int i = startIdx + 1; i <= endIdx; i++) {
            if (_isSlotBooked(_timeSlots[i])) {
              conflict = true;
              break;
            }
          }
          if (conflict) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    'Cannot select — a slot in between is already booked'),
                backgroundColor: kRed,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(16),
              ),
            );
          } else {
            _selectedEnd = time;
          }
        } else {
          // Tapped before start → reset
          _selectedStart = time;
          _selectedEnd = null;
        }
      } else {
        // Reset and start again
        _selectedStart = time;
        _selectedEnd = null;
      }
    });
  }

  bool _isInRange(String time) {
    if (_selectedStart == null || _selectedEnd == null) return false;
    final idx = _timeSlots.indexOf(time);
    final start = _timeSlots.indexOf(_selectedStart!);
    final end = _timeSlots.indexOf(_selectedEnd!);
    return idx > start && idx < end;
  }

  String _calcDuration() {
    if (_selectedStart == null || _selectedEnd == null) return '0';
    final start = int.parse(_selectedStart!.split(':')[0]);
    final end = int.parse(_selectedEnd!.split(':')[0]);
    return '${end - start}';
  }

  // ─────────────────────────────────────────────────────────────
  // STEP 4 — BOOKING DETAILS
  // ─────────────────────────────────────────────────────────────
  Widget _buildBookingDetails() {
    return Column(
      children: [
        // Purpose field
        TextField(
          controller: _purposeCtrl,
          onChanged: (v) => setState(() => _purpose = v),
          maxLines: 2,
          decoration: InputDecoration(
            hintText:
                context.tr('Purpose of booking (e.g. Group Study, Project Meeting)'),
            hintStyle: TextStyle(color: kGray400, fontSize: 12),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child:
                  Icon(Icons.notes_rounded, color: Color(0xFF94A3B8), size: 20),
            ),
            filled: true,
            fillColor: kGray50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBlue500, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Number of attendees
        Row(
          children: [
            const Icon(Icons.people_rounded,
                size: 18, color: Color(0xFF94A3B8)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(context.tr('Number of Attendees'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kGray800,
                  )),
            ),
            // Stepper
            Row(children: [
              _attendeeBtn(
                Icons.remove_rounded,
                () => setState(() {
                  if (_attendees > 1) _attendees--;
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  '$_attendees',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: kGray800,
                  ),
                ),
              ),
              _attendeeBtn(
                Icons.add_rounded,
                () => setState(() => _attendees++),
              ),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _attendeeBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: kBlue50,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: kBlue100),
        ),
        child: Icon(icon, size: 16, color: kBlue500),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // RULES CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildRulesCard() {
    final rules = [
      'Rooms must be booked at least 1 hour in advance',
      'Maximum booking duration: 3 hours per session',
      'Cancellation allowed up to 30 minutes before',
      'Students are responsible for the room condition',
      'Room must be vacated 5 minutes before next booking',
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kBlue50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBlue100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.info_outline_rounded, size: 16, color: kBlue500),
            const SizedBox(width: 8),
            Text(context.tr('Booking Rules'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: kBlue700,
                )),
          ]),
          const SizedBox(height: 10),
          ...rules.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(top: 5, right: 8),
                      decoration: const BoxDecoration(
                        color: kBlue500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(r,
                          style: TextStyle(
                              fontSize: 12, color: kBlue700, height: 1.4)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SUBMIT BUTTON
  // ─────────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    final canSubmit =
        _selectedRoom != null && _selectedStart != null && _selectedEnd != null;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: canSubmit
              ? const LinearGradient(
                  colors: [kBlue500, kTeal],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)
              : null,
          color: canSubmit ? null : kGray200,
          borderRadius: BorderRadius.circular(14),
          boxShadow: canSubmit
              ? [
                  BoxShadow(
                    color: kBlue500.withOpacity(0.38),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton.icon(
          onPressed: canSubmit ? _submitBooking : null,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.check_circle_outline_rounded,
                  color: Colors.white, size: 20),
          label: Text(
            _isSubmitting
                ? 'Confirming...'
                : canSubmit
                    ? 'Confirm Booking'
                    : 'Select Room, Date & Time',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: canSubmit ? Colors.white : kGray500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    _showBookingSuccess();
  }

  void _showBookingSuccess() {
    final room = _rooms.firstWhere((r) => r['id'] == _selectedRoom,
        orElse: () => {'name': 'Room'});
    final refNo = 'BK${DateTime.now().millisecond.toString().padLeft(4, '0')}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF059669), size: 38),
            ),
            const SizedBox(height: 16),
            Text(context.tr('Booking Confirmed!'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kGray800,
                )),
            const SizedBox(height: 6),
            Text(
              '${room['name']}\n$_selectedStart – $_selectedEnd\n${_formatDate(_selectedDate)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: kGray500, height: 1.5),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: kBlue50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.confirmation_number_rounded,
                      size: 16, color: kBlue500),
                  const SizedBox(width: 6),
                  Text('Reference: $refNo',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kBlue500,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedRoom = null;
                    _selectedStart = null;
                    _selectedEnd = null;
                    _purposeCtrl.clear();
                    _attendees = 1;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(context.tr('Done'),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BOOKING HISTORY CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildBookingHistoryCard(Map<String, dynamic> booking) {
    final isConfirmed = booking['status'] == 'Confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGray100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: (booking['color'] as Color).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              booking['icon'] as IconData,
              color: booking['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking['room'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kGray800,
                    )),
                const SizedBox(height: 3),
                Row(children: [
                  Icon(Icons.calendar_today_rounded, size: 11, color: kGray400),
                  const SizedBox(width: 3),
                  Text(booking['date'],
                      style: TextStyle(fontSize: 11, color: kGray500)),
                  const SizedBox(width: 8),
                  Icon(Icons.access_time_rounded, size: 11, color: kGray400),
                  const SizedBox(width: 3),
                  Text('${booking['start']} – ${booking['end']}',
                      style: TextStyle(fontSize: 11, color: kGray500)),
                ]),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isConfirmed
                  ? const Color(0xFFD1FAE5)
                  : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              booking['status'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isConfirmed
                    ? const Color(0xFF065F46)
                    : const Color(0xFF92400E),
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
                          context, ModalRoute.withName('/dashboard'));
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[i]['icon'] as IconData,
                          size: 24, color: kGray400),
                      const SizedBox(height: 4),
                      Text(context.tr(items[i]['label'] as String),
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

// ── Missing constant used in date picker ──────────────────────
const Color kBlue200 = Color(0xFF93C5FD);
