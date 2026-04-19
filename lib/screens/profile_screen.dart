import 'package:flutter/material.dart';
import 'package:uthm_smart_campus/utils/app_language.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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

  // ── Student Profile Data ──────────────────────────────────────
  String _name = 'Ahmad Faris bin Abdullah';
  String _studentId = 'AF220001';
  String _email = 'af220001@uthm.edu.my';
  String _phone = '+60 12-345 6789';
  String _faculty = 'Faculty of Computer Science & IT';
  String _programme = 'Bachelor of Computer Science';
  String _year = 'Year 2, Semester 2';
  String _cgpa = '3.45';
  String _ic = '020101-01-1234';

  // ── Settings toggles ──────────────────────────────────────────
  bool _notifReminder = true;
  bool _notifTimetable = true;
  bool _notifShop = false;
  bool _darkMode = false;
  bool _biometric = false;
  bool _emailUpdates = true;

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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile card
                    _buildProfileCard(),
                    const SizedBox(height: 20),

                    // Academic info
                    _sectionLabel('🎓 ${context.tr('Academic Information')}'),
                    const SizedBox(height: 10),
                    _buildAcademicCard(),
                    const SizedBox(height: 20),

                    // Quick stats
                    _sectionLabel('📊 ${context.tr('Quick Stats')}'),
                    const SizedBox(height: 10),
                    _buildStatsRow(),
                    const SizedBox(height: 20),

                    // Notification settings
                    _sectionLabel('🔔 ${context.tr('Notifications')}'),
                    const SizedBox(height: 10),
                    _buildSettingsCard([
                      _toggleTile(
                        Icons.alarm_rounded,
                        context.tr('Reminder Alerts'),
                        context.tr('Get notified for upcoming deadlines'),
                        kAmber,
                        _notifReminder,
                        (v) => setState(() => _notifReminder = v),
                      ),
                      _divider(),
                      _toggleTile(
                        Icons.calendar_today_rounded,
                        context.tr('Timetable Updates'),
                        context.tr('Class schedule changes and reminders'),
                        kBlue500,
                        _notifTimetable,
                        (v) => setState(() => _notifTimetable = v),
                      ),
                      _divider(),
                      _toggleTile(
                        Icons.shopping_bag_rounded,
                        'Shop & Café Promos',
                        context.tr('Deals and new menu items'),
                        kGreen,
                        _notifShop,
                        (v) => setState(() => _notifShop = v),
                      ),
                      _divider(),
                      _toggleTile(
                        Icons.email_rounded,
                        context.tr('Email Updates'),
                        context.tr('University announcements via email'),
                        kTeal,
                        _emailUpdates,
                        (v) => setState(() => _emailUpdates = v),
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // App settings
                    _sectionLabel('⚙️ ${context.tr('App Settings')}'),
                    const SizedBox(height: 10),
                    _buildSettingsCard([
                      _toggleTile(
                        Icons.dark_mode_rounded,
                        context.tr('Dark Mode'),
                        context.tr('Switch to dark theme'),
                        kGray800,
                        _darkMode,
                        (v) => setState(() => _darkMode = v),
                      ),
                      _divider(),
                      _toggleTile(
                        Icons.fingerprint_rounded,
                        context.tr('Biometric Login'),
                        context.tr('Use fingerprint to login'),
                        kBlue600,
                        _biometric,
                        (v) => setState(() => _biometric = v),
                      ),
                      _divider(),
                      _navTile(
                        Icons.language_rounded,
                        context.tr('Language'),
                        AppLanguageScope.languageOf(context).label,
                        kTeal,
                        _showLanguageSheet,
                      ),
                      _divider(),
                      _navTile(
                        Icons.storage_rounded,
                        context.tr('Clear Cache'),
                        context.tr('Free up app storage'),
                        kAmber,
                        _confirmClearCache,
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Support
                    _sectionLabel('💬 ${context.tr('Support & Help')}'),
                    const SizedBox(height: 10),
                    _buildSettingsCard([
                      _navTile(
                        Icons.help_outline_rounded,
                        context.tr('Help Center'),
                        context.tr('FAQs and user guide'),
                        kBlue500,
                        () => _showSnack('Help Center opening...'),
                      ),
                      _divider(),
                      _navTile(
                        Icons.bug_report_rounded,
                        context.tr('Report a Bug'),
                        context.tr('Help us improve the app'),
                        kRed,
                        () => _showSnack('Bug report form opening...'),
                      ),
                      _divider(),
                      _navTile(
                        Icons.star_rate_rounded,
                        context.tr('Rate the App'),
                        context.tr('Leave a review on Play Store'),
                        kAmber,
                        () => _showSnack('Opening Play Store...'),
                      ),
                      _divider(),
                      _navTile(
                        Icons.info_outline_rounded,
                        context.tr('About'),
                        'Version 1.0.0 · UTHM 2025',
                        kGray400,
                        _showAboutDialog,
                      ),
                    ]),
                    const SizedBox(height: 28),

                    // Logout button
                    _buildLogoutButton(),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    )),
                Text('Student account & settings',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white60,
                    )),
              ],
            ),
          ),
          // Edit button
          GestureDetector(
            onTap: _showEditProfile,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(children: [
                Icon(Icons.edit_rounded, color: Colors.white, size: 15),
                SizedBox(width: 5),
                Text('Edit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // PROFILE CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kGray100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar + name row
          Row(
            children: [
              // Avatar circle
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kBlue500, kTeal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kBlue500.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(_name),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Online badge
                  Positioned(
                    bottom: 3,
                    right: 3,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: kGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Name + ID + faculty
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kGray800,
                        )),
                    const SizedBox(height: 4),
                    // Student ID badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: kBlue50,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: kBlue100),
                      ),
                      child: Text(_studentId,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: kBlue600,
                          )),
                    ),
                    const SizedBox(height: 5),
                    Text(_year,
                        style: TextStyle(fontSize: 12, color: kGray500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Contact details
          _infoRow(Icons.email_rounded, 'Email', _email, kBlue500),
          const SizedBox(height: 10),
          _infoRow(Icons.phone_rounded, 'Phone', _phone, kGreen),
          const SizedBox(height: 10),
          _infoRow(Icons.badge_rounded, 'IC Number', _ic, kAmber),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return Row(children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: kGray400,
                    fontWeight: FontWeight.w600)),
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kGray800)),
          ],
        ),
      ),
    ]);
  }

  // ─────────────────────────────────────────────────────────────
  // ACADEMIC CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildAcademicCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kGray100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(children: [
        _acadRow(Icons.account_balance_rounded, 'Faculty', _faculty, kBlue500),
        const SizedBox(height: 12),
        _acadRow(Icons.school_rounded, 'Programme', _programme, kPurple),
        const SizedBox(height: 12),
        _acadRow(Icons.calendar_today_rounded, 'Current Year', _year, kTeal),
        const SizedBox(height: 12),
        // CGPA with progress bar
        Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.grade_rounded, size: 18, color: kGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CGPA',
                      style: TextStyle(
                          fontSize: 10,
                          color: kGray400,
                          fontWeight: FontWeight.w600)),
                  Text(_cgpa,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: kGreen)),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: double.parse(_cgpa) / 4.0,
                  minHeight: 7,
                  backgroundColor: kGray100,
                  valueColor: const AlwaysStoppedAnimation<Color>(kGreen),
                ),
              ),
              const SizedBox(height: 3),
              Text('out of 4.00',
                  style: TextStyle(fontSize: 10, color: kGray400)),
            ],
          )),
        ]),
      ]),
    );
  }

  Widget _acadRow(IconData icon, String label, String value, Color color) {
    return Row(children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 12),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: kGray400, fontWeight: FontWeight.w600)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: kGray800)),
        ],
      )),
    ]);
  }

  // ─────────────────────────────────────────────────────────────
  // STATS ROW
  // ─────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final stats = [
      {
        'value': '5',
        'label': 'Subjects',
        'icon': Icons.book_rounded,
        'color': kBlue500
      },
      {
        'value': '3',
        'label': 'Bookings',
        'icon': Icons.meeting_room_rounded,
        'color': kTeal
      },
      {
        'value': '8',
        'label': 'Reminders',
        'icon': Icons.notifications_rounded,
        'color': kAmber
      },
      {
        'value': '3🔥',
        'label': 'Day Streak',
        'icon': Icons.local_fire_department_rounded,
        'color': kRed
      },
    ];
    return Row(
      children: stats.map((s) {
        final color = s['color'] as Color;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kGray100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(children: [
              Icon(s['icon'] as IconData, size: 22, color: color),
              const SizedBox(height: 6),
              Text(s['value'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
                  )),
              const SizedBox(height: 2),
              Text(context.tr(s['label'] as String),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 9,
                      color: kGray400,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SETTINGS CARD + TILES
  // ─────────────────────────────────────────────────────────────
  Widget _buildSettingsCard(List<Widget> children) {
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
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _toggleTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 19, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kGray800)),
            Text(subtitle, style: TextStyle(fontSize: 11, color: kGray400)),
          ],
        )),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: kBlue500,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ]),
    );
  }

  Widget _navTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 19, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kGray800)),
              Text(subtitle, style: TextStyle(fontSize: 11, color: kGray400)),
            ],
          )),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: kGray400),
        ]),
      ),
    );
  }

  Widget _divider() => Divider(
      height: 1, thickness: 1, indent: 66, endIndent: 16, color: kGray100);

  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: kGray800,
      ));

  // ─────────────────────────────────────────────────────────────
  // LOGOUT BUTTON
  // ─────────────────────────────────────────────────────────────
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _confirmLogout,
        icon: const Icon(Icons.logout_rounded, color: kRed, size: 20),
        label: const Text('Logout',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: kRed,
            )),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kRed, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // EDIT PROFILE BOTTOM SHEET
  // ─────────────────────────────────────────────────────────────
  void _showEditProfile() {
    final nameCtrl = TextEditingController(text: _name);
    final phoneCtrl = TextEditingController(text: _phone);
    final cgpaCtrl = TextEditingController(text: _cgpa);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
                )),
                const SizedBox(height: 18),

                const Text('Edit Profile',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: kGray800)),
                const SizedBox(height: 4),
                Text('Update your personal information',
                    style: TextStyle(fontSize: 13, color: kGray400)),
                const SizedBox(height: 22),

                // Avatar preview
                Center(
                  child: Stack(children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [kBlue500, kTeal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(_name),
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: kBlue500,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 13),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 22),

                // Name
                _editLabel('Full Name'),
                const SizedBox(height: 6),
                _editField(nameCtrl, 'Your full name', Icons.person_rounded),
                const SizedBox(height: 14),

                // Phone
                _editLabel('Phone Number'),
                const SizedBox(height: 6),
                _editField(phoneCtrl, '+60 XX-XXX XXXX', Icons.phone_rounded,
                    type: TextInputType.phone),
                const SizedBox(height: 14),

                // CGPA
                _editLabel('Current CGPA'),
                const SizedBox(height: 6),
                _editField(cgpaCtrl, '0.00 – 4.00', Icons.grade_rounded,
                    type: const TextInputType.numberWithOptions(decimal: true)),
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kBlue500, kTeal],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: kBlue500.withOpacity(0.4),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (nameCtrl.text.isNotEmpty) {
                            _name = nameCtrl.text;
                          }
                          if (phoneCtrl.text.isNotEmpty) {
                            _phone = phoneCtrl.text;
                          }
                          if (cgpaCtrl.text.isNotEmpty) {
                            _cgpa = cgpaCtrl.text;
                          }
                        });
                        Navigator.pop(context);
                        _showSnack('Profile updated successfully ✓');
                      },
                      icon: const Icon(Icons.save_rounded, color: Colors.white),
                      label: const Text('Save Changes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
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

  Widget _editLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: kGray500,
          letterSpacing: 0.4));

  Widget _editField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kGray400, fontSize: 13),
        prefixIcon: Icon(icon, color: kGray400, size: 18),
        filled: true,
        fillColor: kGray50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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
  // DIALOGS
  // ─────────────────────────────────────────────────────────────
  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return AnimatedBuilder(
          animation: appLanguageController,
          builder: (context, _) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    appLanguageController.tr('Choose Language'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kGray800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appLanguageController.tr(
                      'Select the language you want to use in the app.',
                    ),
                    style: TextStyle(fontSize: 13, color: kGray400),
                  ),
                  const SizedBox(height: 18),
                  _languageOption(
                    sheetContext: sheetContext,
                    language: AppLanguage.english,
                    subtitle:
                        appLanguageController.tr('Use English language'),
                    icon: Icons.language_rounded,
                  ),
                  const SizedBox(height: 10),
                  _languageOption(
                    sheetContext: sheetContext,
                    language: AppLanguage.malay,
                    subtitle: appLanguageController.tr('Guna Bahasa Melayu'),
                    icon: Icons.translate_rounded,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _languageOption({
    required BuildContext sheetContext,
    required AppLanguage language,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = appLanguageController.language == language;
    return GestureDetector(
      onTap: () async {
        final navigator = Navigator.of(sheetContext);
        await appLanguageController.setLanguage(language);
        if (navigator.canPop()) {
          navigator.pop();
        }
        if (mounted) {
          setState(() {});
          _showSnack(
            language == AppLanguage.english
                ? 'Language changed to English'
                : 'Bahasa ditukar kepada Melayu',
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? kBlue50 : kGray50,
          borderRadius: BorderRadius.circular(14),
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
                color: isSelected ? kBlue500 : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : kGray500,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? kBlue500 : kGray800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: kGray500),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: kBlue500),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: kRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: kRed, size: 32),
            ),
            const SizedBox(height: 14),
            const Text('Logout?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: kGray800)),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to logout from your UTHM account?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: kGray500),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kGray200),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: kGray600, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (_) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Logout',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _confirmClearCache() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cache?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'This will clear temporary files. Your data will not be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: kGray500)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnack('Cache cleared successfully ✓');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kAmber,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kBlue700, kBlue500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('🎓', style: TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 14),
            const Text('UTHM Smart Campus',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kGray800)),
            const SizedBox(height: 4),
            Text('Version 1.0.0',
                style: TextStyle(fontSize: 13, color: kGray400)),
            const SizedBox(height: 8),
            Text(
              'Developed for Universiti Tun Hussein Onn Malaysia\n© 2025 UTHM',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: kGray400, height: 1.5),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: kBlue500,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ));
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
              final isActive = i == 3; // Profile tab
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

// ── Extra color constant needed ───────────────────────────────
const Color kBlue600 = Color(0xFF1A52A0);
const Color kGray600 = Color(0xFF475569);
const Color kPurple = Color(0xFF7C3AED);
