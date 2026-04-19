import 'package:flutter/material.dart';
import 'package:uthm_smart_campus/utils/app_language.dart';

class CafeScreen extends StatefulWidget {
  const CafeScreen({super.key});

  @override
  State<CafeScreen> createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> with TickerProviderStateMixin {
  // ── Colors ────────────────────────────────────────────────────
  static const Color kBlue700 = Color(0xFF113A6E);
  static const Color kBlue600 = Color(0xFF1A52A0);
  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kTeal = Color(0xFF0891B2);
  static const Color kPurple = Color(0xFF6D28D9);
  static const Color kGray50 = Color(0xFFF8FAFC);
  static const Color kGray100 = Color(0xFFF1F5F9);
  static const Color kGray200 = Color(0xFFE2E8F0);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray500 = Color(0xFF64748B);
  static const Color kGray800 = Color(0xFF1E293B);
  static const Color kGreen = Color(0xFF10B981);

  // ── Tab controller ────────────────────────────────────────────
  late TabController _tabController;

  // ── State ─────────────────────────────────────────────────────
  final Map<String, int> _order = {}; // itemId → qty
  bool _isOpen = true;

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ── Menu categories & items ───────────────────────────────────
  final List<String> _tabs = [
    'Drinks',
    'Snacks',
    'Meals',
    'Desserts',
  ];

  final Map<String, List<Map<String, dynamic>>> _menu = {
    'Drinks': [
      {
        'id': 'd001',
        'name': 'Teh Tarik',
        'desc': 'Pulled milk tea, Malaysian classic',
        'price': 2.00,
        'icon': Icons.coffee_rounded,
        'bgColor': Color(0xFFFFF7ED),
        'iconColor': Color(0xFFEA580C),
        'tag': 'Best Seller',
        'tagColor': Color(0xFFEF4444),
        'calories': '120 kcal',
      },
      {
        'id': 'd002',
        'name': 'Iced Milo',
        'desc': 'Cold chocolate malt drink',
        'price': 2.50,
        'icon': Icons.local_cafe_rounded,
        'bgColor': Color(0xFFFEF9C3),
        'iconColor': Color(0xFFCA8A04),
        'tag': '',
        'tagColor': Colors.transparent,
        'calories': '180 kcal',
      },
      {
        'id': 'd003',
        'name': 'Green Tea',
        'desc': 'Japanese sencha, freshly brewed',
        'price': 3.00,
        'icon': Icons.emoji_food_beverage_rounded,
        'bgColor': Color(0xFFF0FDF4),
        'iconColor': Color(0xFF16A34A),
        'tag': 'Healthy',
        'tagColor': Color(0xFF10B981),
        'calories': '5 kcal',
      },
      {
        'id': 'd004',
        'name': 'Kopi O Ais',
        'desc': 'Black iced coffee, no sugar',
        'price': 2.00,
        'icon': Icons.coffee_maker_rounded,
        'bgColor': Color(0xFFF5F3FF),
        'iconColor': Color(0xFF7C3AED),
        'tag': '',
        'tagColor': Colors.transparent,
        'calories': '10 kcal',
      },
      {
        'id': 'd005',
        'name': 'Fresh Orange Juice',
        'desc': 'Freshly squeezed, no added sugar',
        'price': 4.00,
        'icon': Icons.local_drink_rounded,
        'bgColor': Color(0xFFFFF7ED),
        'iconColor': Color(0xFFF97316),
        'tag': 'Fresh',
        'tagColor': Color(0xFF10B981),
        'calories': '90 kcal',
      },
      {
        'id': 'd006',
        'name': 'Bandung',
        'desc': 'Rose syrup with evaporated milk',
        'price': 2.50,
        'icon': Icons.water_drop_rounded,
        'bgColor': Color(0xFFFDF2F8),
        'iconColor': Color(0xFFEC4899),
        'tag': '',
        'tagColor': Colors.transparent,
        'calories': '150 kcal',
      },
    ],
    'Snacks': [
      {
        'id': 's001',
        'name': 'Butter Croissant',
        'desc': 'Freshly baked, flaky pastry',
        'price': 3.50,
        'icon': Icons.breakfast_dining_rounded,
        'bgColor': Color(0xFFFEF9C3),
        'iconColor': Color(0xFFCA8A04),
        'tag': 'Fresh',
        'tagColor': Color(0xFF10B981),
        'calories': '280 kcal',
      },
      {
        'id': 's002',
        'name': 'Karipap (3pcs)',
        'desc': 'Crispy curry puff, local favourite',
        'price': 2.00,
        'icon': Icons.lunch_dining_rounded,
        'bgColor': Color(0xFFFFF7ED),
        'iconColor': Color(0xFFEA580C),
        'tag': 'Popular',
        'tagColor': Color(0xFF2563EB),
        'calories': '210 kcal',
      },
      {
        'id': 's003',
        'name': 'Roti Bakar',
        'desc': 'Toast with butter & kaya jam',
        'price': 2.50,
        'icon': Icons.bakery_dining_rounded,
        'bgColor': Color(0xFFFEF9C3),
        'iconColor': Color(0xFFCA8A04),
        'tag': '',
        'tagColor': Colors.transparent,
        'calories': '240 kcal',
      },
      {
        'id': 's004',
        'name': 'Pisang Goreng (4pcs)',
        'desc': 'Deep fried banana fritters',
        'price': 2.00,
        'icon': Icons.fastfood_rounded,
        'bgColor': Color(0xFFFFF7ED),
        'iconColor': Color(0xFFF97316),
        'tag': 'Best Seller',
        'tagColor': Color(0xFFEF4444),
        'calories': '320 kcal',
      },
    ],
    'Meals': [
      {
        'id': 'm001',
        'name': 'Nasi Lemak',
        'desc': 'Coconut rice with sambal, egg & anchovies',
        'price': 5.50,
        'icon': Icons.rice_bowl_rounded,
        'bgColor': Color(0xFFF0FDF4),
        'iconColor': Color(0xFF16A34A),
        'tag': 'Best Seller',
        'tagColor': Color(0xFFEF4444),
        'calories': '650 kcal',
      },
      {
        'id': 'm002',
        'name': 'Mee Goreng',
        'desc': 'Spicy fried noodles with egg & tofu',
        'price': 5.00,
        'icon': Icons.ramen_dining_rounded,
        'bgColor': Color(0xFFFFF7ED),
        'iconColor': Color(0xFFEA580C),
        'tag': '',
        'tagColor': Colors.transparent,
        'calories': '580 kcal',
      },
      {
        'id': 'm003',
        'name': 'Nasi Campur',
        'desc': 'Mixed rice with 3 side dishes of choice',
        'price': 6.00,
        'icon': Icons.set_meal_rounded,
        'bgColor': Color(0xFFEFF6FF),
        'iconColor': Color(0xFF2563EB),
        'tag': 'Value',
        'tagColor': Color(0xFF7C3AED),
        'calories': '700 kcal',
      },
      {
        'id': 'm004',
        'name': 'Sandwich Set',
        'desc': 'Chicken sandwich with salad & drink',
        'price': 7.00,
        'icon': Icons.lunch_dining_rounded,
        'bgColor': Color(0xFFF0FDF4),
        'iconColor': Color(0xFF16A34A),
        'tag': 'Healthy',
        'tagColor': Color(0xFF10B981),
        'calories': '420 kcal',
      },
    ],
    'Desserts': [
      {
        'id': 'ds001',
        'name': 'Cendol',
        'desc': 'Shaved ice with coconut milk & gula melaka',
        'price': 3.50,
        'icon': Icons.icecream_rounded,
        'bgColor': Color(0xFFF0FDF4),
        'iconColor': Color(0xFF16A34A),
        'tag': 'Popular',
        'tagColor': Color(0xFF2563EB),
        'calories': '240 kcal',
      },
      {
        'id': 'ds002',
        'name': 'Ais Kacang',
        'desc': 'Shaved ice with red beans & syrup',
        'price': 4.00,
        'icon': Icons.ac_unit_rounded,
        'bgColor': Color(0xFFEFF6FF),
        'iconColor': Color(0xFF2563EB),
        'tag': '',
        'tagColor': Colors.transparent,
        'calories': '300 kcal',
      },
      {
        'id': 'ds003',
        'name': 'Kuih Lapis',
        'desc': 'Layered steamed cake, soft & sweet',
        'price': 2.00,
        'icon': Icons.cake_rounded,
        'bgColor': Color(0xFFFDF2F8),
        'iconColor': Color(0xFFEC4899),
        'tag': 'Local',
        'tagColor': Color(0xFF7C3AED),
        'calories': '180 kcal',
      },
    ],
  };

  // ── Order helpers ─────────────────────────────────────────────
  int get _orderItemCount => _order.values.fold(0, (sum, q) => sum + q);

  double get _orderTotal {
    double total = 0;
    _order.forEach((id, qty) {
      for (final items in _menu.values) {
        final item = items.firstWhere(
          (i) => i['id'] == id,
          orElse: () => {'price': 0.0},
        );
        total += (item['price'] as double) * qty;
      }
    });
    return total;
  }

  Map<String, dynamic>? _findItem(String id) {
    for (final items in _menu.values) {
      try {
        return items.firstWhere((i) => i['id'] == id);
      } catch (_) {}
    }
    return null;
  }

  void _add(String id) => setState(() => _order[id] = (_order[id] ?? 0) + 1);
  void _remove(String id) => setState(() {
        if ((_order[id] ?? 0) > 1) {
          _order[id] = _order[id]! - 1;
        } else {
          _order.remove(id);
        }
      });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
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

            // ── STATUS BAR ──────────────────────────────────────
            _buildStatusBar(),

            // ── TAB BAR ─────────────────────────────────────────
            _buildTabBar(),

            // ── MENU LIST ───────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabs.map((tab) {
                  return _buildMenuList(_menu[tab] ?? []);
                }).toList(),
              ),
            ),

            // ── ORDER BAR ───────────────────────────────────────
            if (_orderItemCount > 0) _buildOrderBar(),
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
          colors: [Color(0xFF4C1D95), kBlue600],
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
          // Back
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

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr('UTHM Café'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    )),
                Text(context.tr('Halal certified · Campus food court'),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.65),
                    )),
              ],
            ),
          ),

          // Order badge
          GestureDetector(
            onTap: _orderItemCount > 0 ? _showOrderSheet : null,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.receipt_long_rounded,
                      color: Colors.white, size: 22),
                ),
                if (_orderItemCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('$_orderItemCount',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
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
  // STATUS BAR  (open / hours / wait time)
  // ─────────────────────────────────────────────────────────────
  Widget _buildStatusBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Open/Closed indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color:
                  _isOpen ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _isOpen ? kGreen : const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _isOpen ? 'Open Now' : 'Closed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _isOpen
                        ? const Color(0xFF065F46)
                        : const Color(0xFF991B1B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Hours
          Icon(Icons.access_time_rounded, size: 13, color: kGray400),
          const SizedBox(width: 4),
          Text('7:00 AM – 6:00 PM',
              style: TextStyle(fontSize: 12, color: kGray500)),

          const Spacer(),

          // Wait time
          Icon(Icons.timer_rounded, size: 13, color: kGray400),
          const SizedBox(width: 4),
          Text('~5 min wait',
              style: TextStyle(
                  fontSize: 12, color: kGray500, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // TAB BAR
  // ─────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: kBlue500,
        unselectedLabelColor: kGray400,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: kBlue500,
        indicatorWeight: 2.5,
        dividerColor: kGray100,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: _tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // MENU LIST
  // ─────────────────────────────────────────────────────────────
  Widget _buildMenuList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 12, 16, _orderItemCount > 0 ? 8 : 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 250 + (index * 70)),
          curve: Curves.easeOut,
          builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
                offset: Offset(0, 12 * (1 - v)), child: child),
          ),
          child: _buildMenuItem(items[index]),
        );
      },
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    final id = item['id'] as String;
    final qty = _order[id] ?? 0;
    final tag = item['tag'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: qty > 0 ? kBlue500 : kGray100,
          width: qty > 0 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ── Food icon ─────────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: item['bgColor'] as Color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    size: 30,
                    color: item['iconColor'] as Color,
                  ),
                ),
                if (tag.isNotEmpty)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: item['tagColor'] as Color,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // ── Info ──────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kGray800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item['desc'],
                    style: TextStyle(fontSize: 11, color: kGray500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(children: [
                    Text(
                      'RM ${(item['price'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: kBlue500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: kGray100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        item['calories'],
                        style: TextStyle(
                            fontSize: 9,
                            color: kGray500,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ]),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Add / Stepper ─────────────────────────────────
            qty == 0
                ? GestureDetector(
                    onTap: () => _add(id),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: kBlue500,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 20),
                    ),
                  )
                : Column(
                    children: [
                      _stepBtn(Icons.add_rounded, () => _add(id), kBlue500,
                          Colors.white),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '$qty',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: kGray800,
                          ),
                        ),
                      ),
                      _stepBtn(Icons.remove_rounded, () => _remove(id),
                          kGray100, kGray800),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _stepBtn(
      IconData icon, VoidCallback onTap, Color bg, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 15, color: iconColor),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ORDER BAR  (sticky bottom)
  // ─────────────────────────────────────────────────────────────
  Widget _buildOrderBar() {
    return GestureDetector(
      onTap: _showOrderSheet,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
              color: kBlue500.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_orderItemCount',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'View Order',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'RM ${_orderTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ORDER SHEET
  // ─────────────────────────────────────────────────────────────
  void _showOrderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final orderedItems = <Map<String, dynamic>>[];
          _order.forEach((id, qty) {
            if (qty > 0) {
              final item = _findItem(id);
              if (item != null) {
                orderedItems.add({...item, 'qty': qty});
              }
            }
          });

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle + title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(children: [
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
                    const SizedBox(height: 16),
                    Row(children: [
                      Text(context.tr('Your Order'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: kGray800,
                          )),
                      const Spacer(),
                      // Clear all
                      GestureDetector(
                        onTap: () {
                          setState(() => _order.clear());
                          setSheet(() {});
                          Navigator.pop(ctx);
                        },
                        child: Text(context.tr('Clear all'),
                            style: TextStyle(
                                fontSize: 13,
                                color: const Color(0xFFEF4444),
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ]),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),

                // Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: orderedItems.length,
                    itemBuilder: (_, i) {
                      final item = orderedItems[i];
                      final id = item['id'] as String;
                      final qty = _order[id] ?? 0;
                      final subtotal = (item['price'] as double) * qty;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kGray50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kGray100),
                        ),
                        child: Row(children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: item['bgColor'] as Color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: item['iconColor'] as Color,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: kGray800,
                                    )),
                                Text(
                                  'RM ${subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: kBlue500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Stepper
                          Row(children: [
                            _stepBtn(
                              Icons.remove_rounded,
                              () {
                                _remove(id);
                                setSheet(() {});
                                setState(() {});
                                if (_order.isEmpty) {
                                  Navigator.pop(ctx);
                                }
                              },
                              kGray100,
                              kGray800,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('$qty',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  )),
                            ),
                            _stepBtn(
                              Icons.add_rounded,
                              () {
                                _add(id);
                                setSheet(() {});
                                setState(() {});
                              },
                              kBlue500,
                              Colors.white,
                            ),
                          ]),
                        ]),
                      );
                    },
                  ),
                ),

                // Total + place order
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                  child: Column(children: [
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // Summary rows
                    _summaryRow('Subtotal',
                        'RM ${_orderTotal.toStringAsFixed(2)}', false),
                    const SizedBox(height: 6),
                    _summaryRow('Service charge (6%)',
                        'RM ${(_orderTotal * 0.06).toStringAsFixed(2)}', false),
                    const Divider(height: 20),
                    _summaryRow('Total',
                        'RM ${(_orderTotal * 1.06).toStringAsFixed(2)}', true),
                    const SizedBox(height: 16),

                    // Place order
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _showOrderConfirmed();
                        },
                        icon: const Icon(Icons.check_circle_outline_rounded,
                            color: Colors.white),
                        label: const Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlue500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isBold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
              color: isBold ? kGray800 : kGray500,
            )),
        Text(value,
            style: TextStyle(
              fontSize: isBold ? 17 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? kBlue500 : kGray800,
            )),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ORDER CONFIRMED DIALOG
  // ─────────────────────────────────────────────────────────────
  void _showOrderConfirmed() {
    final orderNum =
        'ORD${DateTime.now().millisecond.toString().padLeft(3, '0')}';
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
            Text(context.tr('Order Confirmed!'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kGray800,
                )),
            const SizedBox(height: 6),
            Text(
              'Order #$orderNum has been placed.\nPick up at the café counter.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: kGray500),
            ),
            const SizedBox(height: 12),
            // Est. time
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_rounded, size: 16, color: kBlue500),
                  const SizedBox(width: 6),
                  Text(context.tr('Ready in ~5 minutes'),
                      style: TextStyle(
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
                  setState(() => _order.clear());
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
                      fontSize: 15,
                    )),
              ),
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
