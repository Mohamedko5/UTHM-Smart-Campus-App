import 'package:flutter/material.dart';
import 'package:uthm_smart_campus/utils/main_navigation.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen>
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

  // ── State ─────────────────────────────────────────────────────
  String _selectedFilter = 'All';
  int? _selectedMarker;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ── Filter categories ─────────────────────────────────────────
  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'icon': '🗺️'},
    {'label': 'Lecture Hall', 'icon': '🏛️'},
    {'label': 'Library', 'icon': '📚'},
    {'label': 'Mosque', 'icon': '🕌'},
    {'label': 'Cafeteria', 'icon': '🍽️'},
    {'label': 'Lab', 'icon': '🔬'},
    {'label': 'Sports', 'icon': '⚽'},
  ];

  // ── Campus buildings / locations ──────────────────────────────
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Block A — Faculty of CS',
      'category': 'Lecture Hall',
      'icon': '🏛️',
      'color': Color(0xFF2563EB),
      'description':
          'Main lecture halls for Computer Science faculty. Rooms: DK1, DK2, DK3.',
      'floor': '4 Floors',
      'hours': 'Mon–Fri: 7:30 AM – 10:00 PM',
      'distance': '120m',
      'x': 0.22, // relative position on map (0–1)
      'y': 0.25,
    },
    {
      'name': 'Block B — Engineering',
      'category': 'Lecture Hall',
      'icon': '🏛️',
      'color': Color(0xFF2563EB),
      'description':
          'Engineering faculty block with modern lecture halls and seminar rooms.',
      'floor': '5 Floors',
      'hours': 'Mon–Fri: 7:30 AM – 10:00 PM',
      'distance': '250m',
      'x': 0.62,
      'y': 0.22,
    },
    {
      'name': 'UTHM Main Library',
      'category': 'Library',
      'icon': '📚',
      'color': Color(0xFF7C3AED),
      'description':
          'Central library with over 100,000 books and digital resources. 3 study floors.',
      'floor': '3 Floors',
      'hours': 'Mon–Fri: 8:00 AM – 11:00 PM\nSat: 9:00 AM – 6:00 PM',
      'distance': '180m',
      'x': 0.50,
      'y': 0.42,
    },
    {
      'name': 'Al-Khawarizmi Mosque',
      'category': 'Mosque',
      'icon': '🕌',
      'color': Color(0xFF059669),
      'description':
          'Main campus mosque. Prayer times observed. Ablution facilities available.',
      'floor': '2 Floors',
      'hours': 'Open 24 hours (Prayer times)',
      'distance': '300m',
      'x': 0.78,
      'y': 0.55,
    },
    {
      'name': 'Main Cafeteria',
      'category': 'Cafeteria',
      'icon': '🍽️',
      'color': Color(0xFFD97706),
      'description':
          'Main student cafeteria with multiple food stalls. Halal certified.',
      'floor': '1 Floor',
      'hours': 'Mon–Fri: 7:00 AM – 6:00 PM',
      'distance': '90m',
      'x': 0.20,
      'y': 0.55,
    },
    {
      'name': 'Block C — Computer Lab',
      'category': 'Lab',
      'icon': '🔬',
      'color': Color(0xFF0891B2),
      'description':
          'Computer labs with 200+ workstations. Available for student use.',
      'floor': '3 Floors',
      'hours': 'Mon–Fri: 8:00 AM – 9:00 PM',
      'distance': '200m',
      'x': 0.42,
      'y': 0.68,
    },
    {
      'name': 'Sports Complex',
      'category': 'Sports',
      'icon': '⚽',
      'color': Color(0xFFEF4444),
      'description':
          'Indoor sports hall, badminton courts, basketball courts and gym.',
      'floor': '2 Floors',
      'hours': 'Mon–Sun: 8:00 AM – 10:00 PM',
      'distance': '400m',
      'x': 0.72,
      'y': 0.80,
    },
  ];

  // ── Filtered locations ────────────────────────────────────────
  List<Map<String, dynamic>> get _filtered {
    return _locations.where((loc) {
      final matchFilter =
          _selectedFilter == 'All' || loc['category'] == _selectedFilter;
      final matchSearch = _searchQuery.isEmpty ||
          (loc['name'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
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
    _searchCtrl.dispose();
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

            // ── SEARCH BAR ──────────────────────────────────────
            _buildSearchBar(),

            // ── FILTER PILLS ────────────────────────────────────
            _buildFilterPills(),

            // ── MAP VIEW ────────────────────────────────────────
            Expanded(
              flex: 5,
              child: _buildMapView(),
            ),

            // ── LOCATION LIST ───────────────────────────────────
            _buildLocationList(),
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
        bottom: 16,
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
                const Text(
                  'Campus Map',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: Colors.white70, size: 13),
                    const SizedBox(width: 3),
                    Text(
                      'UTHM Main Campus, Parit Raja',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Live indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SEARCH BAR
  // ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Search buildings or locations...',
          hintStyle: TextStyle(color: kGray400, fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded,
              color: Color(0xFF94A3B8), size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: Color(0xFF94A3B8), size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: kGray50,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }

  // ─────────────────────────────────────────────────────────────
  // FILTER PILLS
  // ─────────────────────────────────────────────────────────────
  Widget _buildFilterPills() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _filters.map((f) {
            final isActive = _selectedFilter == f['label'];
            return GestureDetector(
              onTap: () => setState(() {
                _selectedFilter = f['label'];
                _selectedMarker = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? kBlue500 : kGray50,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isActive ? kBlue500 : kGray200,
                  ),
                ),
                child: Row(
                  children: [
                    Text(f['icon'], style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 5),
                    Text(
                      f['label'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : kGray500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // MAP VIEW  (simulated interactive campus map)
  // ─────────────────────────────────────────────────────────────
  Widget _buildMapView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => setState(() => _selectedMarker = null),
          child: Stack(
            children: [
              // ── Map background ──────────────────────────────
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD4E8C2),
                      Color(0xFFC8E0B0),
                      Color(0xFFB8D49E),
                    ],
                  ),
                ),
              ),

              // ── Grid overlay ────────────────────────────────
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _MapGridPainter(),
              ),

              // ── Roads ───────────────────────────────────────
              ..._buildRoads(constraints),

              // ── Building footprints ─────────────────────────
              ..._buildBuildings(constraints),

              // ── Markers ─────────────────────────────────────
              ..._filtered.asMap().entries.map((entry) {
                final i = entry.key;
                final loc = entry.value;
                final x = (loc['x'] as double) * constraints.maxWidth;
                final y = (loc['y'] as double) * constraints.maxHeight;
                return _buildMarker(loc, i, x, y, constraints);
              }),

              // ── Zoom controls ───────────────────────────────
              Positioned(
                right: 12,
                bottom: 60,
                child: _buildMapControls(),
              ),

              // ── Selected info card ──────────────────────────
              if (_selectedMarker != null)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 10,
                  child: _buildInfoCard(_filtered[_selectedMarker!]),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildRoads(BoxConstraints c) {
    return [
      // Horizontal roads
      Positioned(
        top: c.maxHeight * 0.44,
        left: 0,
        right: 0,
        child: Container(
          height: 8,
          color: Colors.white.withOpacity(0.55),
        ),
      ),
      Positioned(
        top: c.maxHeight * 0.68,
        left: 0,
        right: 0,
        child: Container(
          height: 6,
          color: Colors.white.withOpacity(0.45),
        ),
      ),
      // Vertical roads
      Positioned(
        left: c.maxWidth * 0.38,
        top: 0,
        bottom: 0,
        child: Container(
          width: 7,
          color: Colors.white.withOpacity(0.55),
        ),
      ),
      Positioned(
        left: c.maxWidth * 0.63,
        top: 0,
        bottom: 0,
        child: Container(
          width: 6,
          color: Colors.white.withOpacity(0.45),
        ),
      ),
    ];
  }

  List<Widget> _buildBuildings(BoxConstraints c) {
    final rects = [
      Rect.fromLTWH(c.maxWidth * 0.08, c.maxHeight * 0.12, c.maxWidth * 0.24,
          c.maxHeight * 0.22),
      Rect.fromLTWH(c.maxWidth * 0.44, c.maxHeight * 0.10, c.maxWidth * 0.18,
          c.maxHeight * 0.16),
      Rect.fromLTWH(c.maxWidth * 0.08, c.maxHeight * 0.50, c.maxWidth * 0.24,
          c.maxHeight * 0.14),
      Rect.fromLTWH(c.maxWidth * 0.66, c.maxHeight * 0.48, c.maxWidth * 0.22,
          c.maxHeight * 0.16),
      Rect.fromLTWH(c.maxWidth * 0.38, c.maxHeight * 0.62, c.maxWidth * 0.20,
          c.maxHeight * 0.18),
      Rect.fromLTWH(c.maxWidth * 0.66, c.maxHeight * 0.72, c.maxWidth * 0.24,
          c.maxHeight * 0.18),
    ];

    return rects.map((r) {
      return Positioned(
        left: r.left,
        top: r.top,
        width: r.width,
        height: r.height,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withOpacity(0.18),
            border: Border.all(
              color: const Color(0xFF2563EB).withOpacity(0.35),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildMarker(
    Map<String, dynamic> loc,
    int index,
    double x,
    double y,
    BoxConstraints c,
  ) {
    final isSelected = _selectedMarker == index;
    final color = loc['color'] as Color;

    return Positioned(
      left: x - 16,
      top: y - 40,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMarker = _selectedMarker == index ? null : index;
          });
        },
        child: AnimatedScale(
          scale: isSelected ? 1.25 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            children: [
              // Pin head
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withOpacity(0.85),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    loc['icon'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

              // Pin tail
              CustomPaint(
                size: const Size(12, 8),
                painter: _PinTailPainter(color),
              ),

              // Label
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    (loc['name'] as String).split('—').first.trim(),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> loc) {
    final color = loc['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
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
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Text(loc['icon'], style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc['name'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Row(children: [
                  Icon(Icons.access_time_rounded, size: 11, color: kGray400),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      loc['hours'],
                      style: TextStyle(fontSize: 10, color: kGray500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
                const SizedBox(height: 2),
                Row(children: [
                  Icon(Icons.straighten_rounded, size: 11, color: kGray400),
                  const SizedBox(width: 3),
                  Text(
                    '${loc['distance']} away · ${loc['floor']}',
                    style: TextStyle(fontSize: 10, color: kGray500),
                  ),
                ]),
              ],
            ),
          ),

          // Direction button
          GestureDetector(
            onTap: () => _showLocationDetail(loc),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.info_outline_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        _mapCtrlBtn(Icons.add_rounded, () {}),
        const SizedBox(height: 6),
        _mapCtrlBtn(Icons.remove_rounded, () {}),
        const SizedBox(height: 6),
        _mapCtrlBtn(Icons.my_location_rounded, () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Getting your location...'),
              backgroundColor: kBlue500,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 1),
            ),
          );
        }),
      ],
    );
  }

  Widget _mapCtrlBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: kGray500),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // LOCATION DETAIL BOTTOM SHEET
  // ─────────────────────────────────────────────────────────────
  void _showLocationDetail(Map<String, dynamic> loc) {
    final color = loc['color'] as Color;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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

            // Header row
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child:
                        Text(loc['icon'], style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          loc['category'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Info rows
            _infoRow(Icons.info_outline_rounded, 'About', loc['description']),
            const SizedBox(height: 10),
            _infoRow(Icons.layers_rounded, 'Floors', loc['floor']),
            const SizedBox(height: 10),
            _infoRow(Icons.access_time_rounded, 'Opening Hours', loc['hours']),
            const SizedBox(height: 10),
            _infoRow(Icons.straighten_rounded, 'Distance',
                '${loc['distance']} from current location'),
            const SizedBox(height: 20),

            // Direction button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.directions_walk_rounded,
                    color: Colors.white),
                label: const Text(
                  'Get Directions',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: kGray100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: kGray500),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: kGray400,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // LOCATION LIST (below map)
  // ─────────────────────────────────────────────────────────────
  Widget _buildLocationList() {
    final list = _filtered;
    return Container(
      height: 110,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Text(
              '${list.length} locations found',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: kGray500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final loc = list[index];
                final color = loc['color'] as Color;
                final isSel = _selectedMarker == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedMarker = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 140,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSel ? color.withOpacity(0.08) : kGray50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSel ? color : kGray200,
                        width: isSel ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(loc['icon'], style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (loc['name'] as String).split('—').first.trim(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isSel ? color : kGray800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                loc['distance'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: kGray400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
            children: List.generate(kMainNavItems.length, (i) {
              final isActive = i == 2;
              return Expanded(
                child: GestureDetector(
                  onTap: () => navigateToMainTab(context, i, '/map'),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        kMainNavItems[i]['icon'] as IconData,
                        size: 24,
                        color: isActive ? kBlue500 : kGray400,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kMainNavItems[i]['label'] as String,
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
// CUSTOM PAINTERS
// ─────────────────────────────────────────────────────────────────────────────
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  _PinTailPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
