import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uthm_smart_campus/utils/app_language.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen>
    with SingleTickerProviderStateMixin {
  // ── Colors ────────────────────────────────────────────────────
  static const Color kBlue700 = Color(0xFF113A6E);
  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kBlue50 = Color(0xFFEFF6FF);
  static const Color kBlue100 = Color(0xFFDBEAFE);
  static const Color kGray50 = Color(0xFFF8FAFC);
  static const Color kGray100 = Color(0xFFF1F5F9);
  static const Color kGray200 = Color(0xFFE2E8F0);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray500 = Color(0xFF64748B);
  static const Color kGray800 = Color(0xFF1E293B);

  // ── UTHM Main Campus coordinates ─────────────────────────────
  static const LatLng _uthmCenter = LatLng(1.8608, 103.0838);

  // ── Google Map Controller ─────────────────────────────────────
  GoogleMapController? _mapController;

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ── State ─────────────────────────────────────────────────────
  String _selectedFilter = 'All';
  int? _selectedMarkerIndex;
  String _searchQuery = '';
  MapType _mapType = MapType.normal;
  final TextEditingController _searchCtrl = TextEditingController();

  // ── Filters ───────────────────────────────────────────────────
  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Lecture Hall', 'icon': Icons.school_rounded},
    {'label': 'Library', 'icon': Icons.local_library_rounded},
    {'label': 'Mosque', 'icon': Icons.mosque_rounded},
    {'label': 'Cafeteria', 'icon': Icons.restaurant_rounded},
    {'label': 'Lab', 'icon': Icons.computer_rounded},
    {'label': 'Sports', 'icon': Icons.sports_soccer_rounded},
  ];

  // ── Campus locations with REAL UTHM coordinates ───────────────
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Block A — Faculty of CS & IT',
      'category': 'Lecture Hall',
      'icon': Icons.school_rounded,
      'color': Color(0xFF2563EB),
      'description': 'Main lecture halls: DK1, DK2, DK3.',
      'floor': '4 Floors',
      'hours': 'Mon–Fri: 7:30 AM – 10:00 PM',
      'distance': '120m',
      'position': LatLng(1.8617, 103.0832),
    },
    {
      'name': 'Block B — Engineering Faculty',
      'category': 'Lecture Hall',
      'icon': Icons.school_rounded,
      'color': Color(0xFF7C3AED),
      'description': 'Engineering faculty lecture halls and seminar rooms.',
      'floor': '5 Floors',
      'hours': 'Mon–Fri: 7:30 AM – 10:00 PM',
      'distance': '250m',
      'position': LatLng(1.8625, 103.0845),
    },
    {
      'name': 'UTHM Main Library',
      'category': 'Library',
      'icon': Icons.local_library_rounded,
      'color': Color(0xFF7C3AED),
      'description':
          'Central library with 100,000+ books and digital resources.',
      'floor': '3 Floors',
      'hours': 'Mon–Fri: 8:00 AM – 11:00 PM\nSat: 9:00 AM – 6:00 PM',
      'distance': '180m',
      'position': LatLng(1.8605, 103.0835),
    },
    {
      'name': 'Al-Khawarizmi Mosque',
      'category': 'Mosque',
      'icon': Icons.mosque_rounded,
      'color': Color(0xFF059669),
      'description': 'Main campus mosque. Ablution facilities available.',
      'floor': '2 Floors',
      'hours': 'Open 24 hours (prayer times)',
      'distance': '300m',
      'position': LatLng(1.8598, 103.0850),
    },
    {
      'name': 'Main Cafeteria',
      'category': 'Cafeteria',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFFD97706),
      'description': 'Main student cafeteria. Multiple halal food stalls.',
      'floor': '1 Floor',
      'hours': 'Mon–Fri: 7:00 AM – 6:00 PM',
      'distance': '90m',
      'position': LatLng(1.8612, 103.0828),
    },
    {
      'name': 'Block C — Computer Lab',
      'category': 'Lab',
      'icon': Icons.computer_rounded,
      'color': Color(0xFF0891B2),
      'description': '200+ workstations. Available for student use.',
      'floor': '3 Floors',
      'hours': 'Mon–Fri: 8:00 AM – 9:00 PM',
      'distance': '200m',
      'position': LatLng(1.8602, 103.0842),
    },
    {
      'name': 'Sports Complex',
      'category': 'Sports',
      'icon': Icons.sports_soccer_rounded,
      'color': Color(0xFFEF4444),
      'description': 'Indoor sports hall, badminton courts, basketball & gym.',
      'floor': '2 Floors',
      'hours': 'Mon–Sun: 8:00 AM – 10:00 PM',
      'distance': '400m',
      'position': LatLng(1.8590, 103.0855),
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

  // ── Build markers for Google Map ──────────────────────────────
  Set<Marker> get _markers {
    return _filtered.asMap().entries.map((entry) {
      final i = entry.key;
      final loc = entry.value;
      return Marker(
        markerId: MarkerId('${loc['name']}'),
        position: loc['position'] as LatLng,
        infoWindow: InfoWindow(
          title: loc['name'],
          snippet: '${loc['category']} · ${loc['distance']}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _hue(loc['color'] as Color),
        ),
        onTap: () {
          setState(() => _selectedMarkerIndex = i);
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(loc['position'] as LatLng, 17.5),
          );
        },
      );
    }).toSet();
  }

  double _hue(Color c) {
    if (c.value == const Color(0xFF2563EB).value)
      return BitmapDescriptor.hueBlue;
    if (c.value == const Color(0xFF7C3AED).value)
      return BitmapDescriptor.hueViolet;
    if (c.value == const Color(0xFF059669).value)
      return BitmapDescriptor.hueGreen;
    if (c.value == const Color(0xFFD97706).value)
      return BitmapDescriptor.hueOrange;
    if (c.value == const Color(0xFF0891B2).value)
      return BitmapDescriptor.hueCyan;
    if (c.value == const Color(0xFFEF4444).value)
      return BitmapDescriptor.hueRed;
    return BitmapDescriptor.hueAzure;
  }

  void _goToLocation(int index) {
    final loc = _filtered[index];
    setState(() => _selectedMarkerIndex = index);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(loc['position'] as LatLng, 17.5),
    );
  }

  void _resetCamera() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_uthmCenter, 15.5),
    );
    setState(() => _selectedMarkerIndex = null);
  }

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
    _searchCtrl.dispose();
    _mapController?.dispose();
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
            _buildSearchBar(),
            _buildFilterPills(),
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // ── REAL GOOGLE MAP ────────────────────────
                  _buildMapSurface(),

                  // ── Controls ──────────────────────────────
                  Positioned(
                    right: 12,
                    top: 12,
                    child: _buildControls(),
                  ),

                  // ── Info card ─────────────────────────────
                  if (_selectedMarkerIndex != null)
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 10,
                      child: _buildInfoCard(_filtered[_selectedMarkerIndex!]),
                    ),
                ],
              ),
            ),
            _buildLocationStrip(),
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
          colors: [kBlue700, kBlue500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Row(children: [
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
              Text(context.tr('Campus Map'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  )),
              Row(children: [
                const Icon(Icons.location_on_rounded,
                    color: Colors.white70, size: 12),
                const SizedBox(width: 3),
                Text('UTHM, Parit Raja, Batu Pahat',
                    style: TextStyle(
                        fontSize: 11, color: Colors.white.withOpacity(0.7))),
              ]),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                    color: Color(0xFF10B981), shape: BoxShape.circle)),
            const SizedBox(width: 5),
            Text(context.tr('Live'),
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildMapSurface() {
    if (kIsWeb) {
      return _buildWebFallbackMap();
    }

    return GoogleMap(
      onMapCreated: (ctrl) => _mapController = ctrl,
      initialCameraPosition: const CameraPosition(
        target: _uthmCenter,
        zoom: 15.5,
      ),
      markers: _markers,
      mapType: _mapType,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      buildingsEnabled: true,
      onTap: (_) => setState(() => _selectedMarkerIndex = null),
    );
  }

  Widget _buildWebFallbackMap() {
    final list = _filtered;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDCEBFF), Color(0xFFF7FBFF)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kGray100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: kBlue50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.map_rounded, color: kBlue500),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Map preview mode',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: kGray800,
                          ),
                        ),
                        Text(
                          'Google Maps is not configured for web yet, so this fallback list is shown instead of crashing.',
                          style: TextStyle(
                            fontSize: 11,
                            color: kGray500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final loc = list[i];
                  final color = loc['color'] as Color;
                  final isSel = _selectedMarkerIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMarkerIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color:
                            isSel ? color.withValues(alpha: 0.08) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel ? color : kGray100,
                          width: isSel ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              loc['icon'] as IconData,
                              color: color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: kGray800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${loc['category']} · ${loc['distance']}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: kGray500,
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
          hintText: context.tr('Search buildings, labs, facilities...'),
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
                  })
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
                _selectedMarkerIndex = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? kBlue500 : kGray50,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: isActive ? kBlue500 : kGray200),
                ),
                child: Row(children: [
                  Icon(f['icon'] as IconData,
                      size: 14, color: isActive ? Colors.white : kGray500),
                  const SizedBox(width: 6),
                  Text(f['label'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : kGray500,
                      )),
                ]),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // MAP CONTROLS
  // ─────────────────────────────────────────────────────────────
  Widget _buildControls() {
    return Column(children: [
      _ctrlBtn(Icons.add_rounded,
          () => _mapController?.animateCamera(CameraUpdate.zoomIn())),
      const SizedBox(height: 6),
      _ctrlBtn(Icons.remove_rounded,
          () => _mapController?.animateCamera(CameraUpdate.zoomOut())),
      const SizedBox(height: 6),
      _ctrlBtn(Icons.my_location_rounded, _resetCamera),
      const SizedBox(height: 6),
      _ctrlBtn(
        _mapType == MapType.normal
            ? Icons.satellite_alt_rounded
            : Icons.map_rounded,
        () => setState(() {
          _mapType =
              _mapType == MapType.normal ? MapType.hybrid : MapType.normal;
        }),
      ),
    ]);
  }

  Widget _ctrlBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Icon(icon, size: 20, color: kGray500),
        ),
      );

  // ─────────────────────────────────────────────────────────────
  // SELECTED INFO CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildInfoCard(Map<String, dynamic> loc) {
    final color = loc['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(loc['icon'] as IconData, color: color, size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc['name'],
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Row(children: [
                Icon(Icons.access_time_rounded, size: 11, color: kGray400),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(loc['hours'],
                      style: TextStyle(fontSize: 10, color: kGray500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
              const SizedBox(height: 2),
              Text('${loc['distance']} · ${loc['floor']}',
                  style: TextStyle(fontSize: 10, color: kGray500)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _showDetail(loc),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.info_outline_rounded,
                color: Colors.white, size: 20),
          ),
        ),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // LOCATION DETAIL SHEET
  // ─────────────────────────────────────────────────────────────
  void _showDetail(Map<String, dynamic> loc) {
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
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: kGray200,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 18),
            Row(children: [
              Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16)),
                  child: Icon(loc['icon'] as IconData, color: color, size: 28)),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc['name'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B))),
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(7)),
                    child: Text(loc['category'],
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: color)),
                  ),
                ],
              )),
            ]),
            const SizedBox(height: 18),
            _row(Icons.info_outline_rounded, 'About', loc['description']),
            const SizedBox(height: 10),
            _row(Icons.layers_rounded, 'Floors', loc['floor']),
            const SizedBox(height: 10),
            _row(Icons.access_time_rounded, 'Hours', loc['hours']),
            const SizedBox(height: 10),
            _row(Icons.straighten_rounded, 'Distance',
                '${loc['distance']} from your location'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening directions to ${loc['name']}'),
                      backgroundColor: color,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                icon: const Icon(Icons.directions_walk_rounded,
                    color: Colors.white),
                label: Text(context.tr('Get Directions'),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: kGray100, borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, size: 16, color: kGray500)),
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
        )),
      ]);

  // ─────────────────────────────────────────────────────────────
  // LOCATION STRIP
  // ─────────────────────────────────────────────────────────────
  Widget _buildLocationStrip() {
    final list = _filtered;
    return Container(
      height: 108,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 5),
            child: Text('${list.length} ${context.tr('location(s) found')}',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: kGray500)),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final loc = list[i];
                final color = loc['color'] as Color;
                final isSel = _selectedMarkerIndex == i;
                return GestureDetector(
                  onTap: () => _goToLocation(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 150,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSel ? color.withOpacity(0.08) : kGray50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isSel ? color : kGray200,
                          width: isSel ? 2 : 1),
                    ),
                    child: Row(children: [
                      Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                              color: color.withOpacity(isSel ? 0.15 : 0.08),
                              borderRadius: BorderRadius.circular(9)),
                          child: Icon(loc['icon'] as IconData,
                              color: color, size: 18)),
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
                                color: isSel ? color : kGray800),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(loc['distance'],
                              style: TextStyle(fontSize: 10, color: kGray400)),
                        ],
                      )),
                    ]),
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
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.calendar_today_rounded, 'label': 'Schedule'},
      {'icon': Icons.notifications_rounded, 'label': 'Alerts'},
      {'icon': Icons.person_rounded, 'label': 'Profile'},
    ];
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: kGray100, width: 1))),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(
                items.length,
                (i) => Expanded(
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
                                style:
                                    TextStyle(fontSize: 10, color: kGray400)),
                          ],
                        ),
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
