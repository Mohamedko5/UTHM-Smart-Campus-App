import 'package:flutter/material.dart';
import 'package:uthm_smart_campus/utils/app_language.dart';
import 'package:uthm_smart_campus/utils/main_navigation.dart';

enum PaymentMethod {
  cashOnDelivery,
  touchNGo,
  visa,
  masterCard,
}

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Map<String, dynamic> product;
  final int quantity;

  double get subtotal => (product['price'] as double) * quantity;
}

class MiniShopScreen extends StatefulWidget {
  const MiniShopScreen({super.key});

  @override
  State<MiniShopScreen> createState() => _MiniShopScreenState();
}

class _MiniShopScreenState extends State<MiniShopScreen>
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

  // ── State ─────────────────────────────────────────────────────
  String _selectedCategory = 'All';
  String _searchQuery = '';
  PaymentMethod? _selectedPaymentMethod;
  final Map<String, int> _cart = {}; // productId → quantity
  final TextEditingController _searchCtrl = TextEditingController();

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ── Categories ────────────────────────────────────────────────
  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Stationery', 'icon': Icons.edit_rounded},
    {'label': 'Books', 'icon': Icons.menu_book_rounded},
    {'label': 'Accessories', 'icon': Icons.watch_rounded},
    {'label': 'Snacks', 'icon': Icons.fastfood_rounded},
  ];

  // ── Products ──────────────────────────────────────────────────
  final List<Map<String, dynamic>> _products = [
    {
      'id': 'p001',
      'name': 'Notebook A4',
      'category': 'Stationery',
      'price': 3.50,
      'icon': Icons.book_outlined,
      'bgColor': Color(0xFFEFF6FF),
      'iconColor': Color(0xFF2563EB),
      'badge': '',
      'stock': 15,
    },
    {
      'id': 'p002',
      'name': 'Pencil Set (12pc)',
      'category': 'Stationery',
      'price': 2.00,
      'icon': Icons.edit_outlined,
      'bgColor': Color(0xFFF0FDF4),
      'iconColor': Color(0xFF16A34A),
      'badge': 'Popular',
      'stock': 30,
    },
    {
      'id': 'p003',
      'name': 'Geometry Set',
      'category': 'Stationery',
      'price': 5.90,
      'icon': Icons.architecture_rounded,
      'bgColor': Color(0xFFFEF9C3),
      'iconColor': Color(0xFFCA8A04),
      'badge': '',
      'stock': 8,
    },
    {
      'id': 'p004',
      'name': 'Blue Pen (×5)',
      'category': 'Stationery',
      'price': 3.00,
      'icon': Icons.draw_outlined,
      'bgColor': Color(0xFFFDF4FF),
      'iconColor': Color(0xFF9333EA),
      'badge': '',
      'stock': 50,
    },
    {
      'id': 'p005',
      'name': 'Highlighter Set',
      'category': 'Stationery',
      'price': 4.50,
      'icon': Icons.format_color_fill_rounded,
      'bgColor': Color(0xFFFFF7ED),
      'iconColor': Color(0xFFEA580C),
      'badge': 'New',
      'stock': 20,
    },
    {
      'id': 'p006',
      'name': 'Data Structures',
      'category': 'Books',
      'price': 45.00,
      'icon': Icons.auto_stories_rounded,
      'bgColor': Color(0xFFEFF6FF),
      'iconColor': Color(0xFF2563EB),
      'badge': '',
      'stock': 5,
    },
    {
      'id': 'p007',
      'name': 'Engineering Math',
      'category': 'Books',
      'price': 38.00,
      'icon': Icons.calculate_rounded,
      'bgColor': Color(0xFFF0FDF4),
      'iconColor': Color(0xFF16A34A),
      'badge': 'Sale',
      'stock': 3,
    },
    {
      'id': 'p008',
      'name': 'USB Flash Drive',
      'category': 'Accessories',
      'price': 15.00,
      'icon': Icons.usb_rounded,
      'bgColor': Color(0xFFFDF4FF),
      'iconColor': Color(0xFF9333EA),
      'badge': '',
      'stock': 12,
    },
    {
      'id': 'p009',
      'name': 'Laptop Stand',
      'category': 'Accessories',
      'price': 25.00,
      'icon': Icons.laptop_rounded,
      'bgColor': Color(0xFFECFDF5),
      'iconColor': Color(0xFF059669),
      'badge': 'Popular',
      'stock': 7,
    },
    {
      'id': 'p010',
      'name': 'Milo Packet',
      'category': 'Snacks',
      'price': 1.50,
      'icon': Icons.local_cafe_rounded,
      'bgColor': Color(0xFFFFF7ED),
      'iconColor': Color(0xFFEA580C),
      'badge': '',
      'stock': 100,
    },
    {
      'id': 'p011',
      'name': 'Biscuit Pack',
      'category': 'Snacks',
      'price': 2.00,
      'icon': Icons.cookie_rounded,
      'bgColor': Color(0xFFFEF9C3),
      'iconColor': Color(0xFFCA8A04),
      'badge': '',
      'stock': 40,
    },
  ];

  // ── Filtered products ─────────────────────────────────────────
  List<Map<String, dynamic>> get _filtered {
    return _products.where((p) {
      final matchCat =
          _selectedCategory == 'All' || p['category'] == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          (p['name'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  // ── Cart helpers ──────────────────────────────────────────────
  int get _cartItemCount => _cart.values.fold(0, (sum, qty) => sum + qty);

  double get _cartTotal {
    double total = 0;
    _cart.forEach((id, qty) {
      final product = _products.firstWhere(
        (p) => p['id'] == id,
        orElse: () => {'price': 0.0},
      );
      total += (product['price'] as double) * qty;
    });
    return total;
  }

  List<CartItem> get _cartItems {
    return _products
        .where((p) => _cart.containsKey(p['id']) && _cart[p['id']]! > 0)
        .map((p) => CartItem(
              product: p,
              quantity: _cart[p['id']] ?? 0,
            ))
        .toList();
  }

  String _paymentLabel(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cashOnDelivery => 'Cash on delivery',
      PaymentMethod.touchNGo => "Touch 'n Go",
      PaymentMethod.visa => 'Visa',
      PaymentMethod.masterCard => 'MasterCard',
    };
  }

  IconData _paymentIcon(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cashOnDelivery => Icons.payments_rounded,
      PaymentMethod.touchNGo => Icons.account_balance_wallet_rounded,
      PaymentMethod.visa => Icons.credit_card_rounded,
      PaymentMethod.masterCard => Icons.credit_score_rounded,
    };
  }

  void _addToCart(String id) {
    setState(() {
      _cart[id] = (_cart[id] ?? 0) + 1;
    });
  }

  void _removeFromCart(String id) {
    setState(() {
      if ((_cart[id] ?? 0) > 1) {
        _cart[id] = _cart[id]! - 1;
      } else {
        _cart.remove(id);
      }
    });
  }

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

            // ── CATEGORY PILLS ──────────────────────────────────
            _buildCategoryPills(),

            // ── PRODUCT GRID ────────────────────────────────────
            Expanded(child: _buildProductGrid()),

            // ── CART BOTTOM BAR ─────────────────────────────────
            if (_cartItemCount > 0) _buildCartBar(),
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
                Text(context.tr('Mini Shop'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    )),
                Text(context.tr('Campus stationery & essentials'),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.65),
                    )),
              ],
            ),
          ),

          // Cart icon with badge
          GestureDetector(
            onTap: _cartItemCount > 0 ? _showCartSheet : null,
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
                  child: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white, size: 22),
                ),
                if (_cartItemCount > 0)
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
                        child: Text(
                          '$_cartItemCount',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
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
          hintText: context.tr('Search products...'),
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
  // CATEGORY PILLS
  // ─────────────────────────────────────────────────────────────
  Widget _buildCategoryPills() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _categories.map((cat) {
            final isActive = _selectedCategory == cat['label'];
            return GestureDetector(
              onTap: () => setState(() {
                _selectedCategory = cat['label'];
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? kBlue500 : kGray50,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isActive ? kBlue500 : kGray200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      size: 14,
                      color: isActive ? Colors.white : kGray500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat['label'],
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
  // PRODUCT GRID
  // ─────────────────────────────────────────────────────────────
  Widget _buildProductGrid() {
    final products = _filtered;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: kGray400),
            const SizedBox(height: 16),
            Text(context.tr('No products found'),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B))),
            const SizedBox(height: 6),
            Text(context.tr('Try a different search or category'),
                style: TextStyle(fontSize: 13, color: kGray500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 12, 16, _cartItemCount > 0 ? 8 : 16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 250 + (index * 60)),
          curve: Curves.easeOut,
          builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
                offset: Offset(0, 12 * (1 - v)), child: child),
          ),
          child: _buildProductTile(products[index]),
        );
      },
    );
  }

  Widget _buildProductTile(Map<String, dynamic> product) {
    final id = product['id'] as String;
    final qty = _cart[id] ?? 0;
    final badge = product['badge'] as String;
    final isLowStock = (product['stock'] as int) <= 5;

    return GestureDetector(
      onTap: () => _showProductDetail(product),
      child: Container(
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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: product['bgColor'] as Color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      product['icon'] as IconData,
                      size: 30,
                      color: product['iconColor'] as Color,
                    ),
                  ),
                  if (badge.isNotEmpty)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _badgeColor(badge),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (isLowStock)
                    Positioned(
                      bottom: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xFFFED7AA)),
                        ),
                        child: const Text(
                          'Low stock',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEA580C),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kGray800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _productDescription(product),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: kGray500),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'RM ${(product['price'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: kBlue500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: kGray100,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '${product['stock']} left',
                            style: TextStyle(
                              fontSize: 9,
                              color: kGray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              qty == 0
                  ? GestureDetector(
                      onTap: () => _addToCart(id),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: kBlue500,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        _qtyBtn(
                          Icons.add_rounded,
                          () => _addToCart(id),
                          kBlue500,
                          Colors.white,
                        ),
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
                        _qtyBtn(
                          Icons.remove_rounded,
                          () => _removeFromCart(id),
                          kGray100,
                          kGray800,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String _productDescription(Map<String, dynamic> product) {
    return switch (product['category'] as String) {
      'Stationery' => 'Campus writing and study essential',
      'Books' => 'Reference material for coursework',
      'Accessories' => 'Useful tech and study accessory',
      'Snacks' => 'Quick grab-and-go campus snack',
      _ => 'Mini Shop campus essential',
    };
  }

  Color _badgeColor(String badge) {
    return switch (badge) {
      'Sale' => const Color(0xFFEF4444),
      'New' => kGreen,
      'Popular' => kBlue500,
      _ => kTeal,
    };
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final id = product['id'] as String;
    final qty = _cart[id] ?? 0;
    final isLowStock = (product['stock'] as int) <= 5;
    final badge = product['badge'] as String;

    return GestureDetector(
      onTap: () => _showProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: qty > 0 ? kBlue500 : kGray100,
            width: qty > 0 ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image area ────────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: product['bgColor'] as Color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Icon(
                    product['icon'] as IconData,
                    size: 46,
                    color: product['iconColor'] as Color,
                  ),
                ),

                // Badge
                if (badge.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: badge == 'Sale'
                            ? const Color(0xFFEF4444)
                            : badge == 'New'
                                ? const Color(0xFF10B981)
                                : kBlue500,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                // Low stock badge
                if (isLowStock)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFED7AA)),
                      ),
                      child: Text(
                        'Low stock',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEA580C),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ── Info ──────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'RM ${(product['price'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: kBlue600,
                          ),
                        ),

                        // Add / Quantity stepper
                        qty == 0
                            ? GestureDetector(
                                onTap: () => _addToCart(id),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: kBlue500,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: const Icon(Icons.add_rounded,
                                      color: Colors.white, size: 18),
                                ),
                              )
                            : Row(
                                children: [
                                  _qtyBtn(
                                    Icons.remove_rounded,
                                    () => _removeFromCart(id),
                                    const Color(0xFFEFF6FF),
                                    kBlue500,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Text(
                                      '$qty',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                  _qtyBtn(
                                    Icons.add_rounded,
                                    () => _addToCart(id),
                                    kBlue500,
                                    Colors.white,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, Color bg, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, size: 14, color: iconColor),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // CART BOTTOM BAR
  // ─────────────────────────────────────────────────────────────
  Widget _buildCartBar() {
    return GestureDetector(
      onTap: _showCartSheet,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kBlue600, kTeal],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kBlue500.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_cartItemCount',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'View Cart',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              'RM ${_cartTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 15,
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
  // PRODUCT DETAIL BOTTOM SHEET
  // ─────────────────────────────────────────────────────────────
  void _showProductDetail(Map<String, dynamic> product) {
    final id = product['id'] as String;
    final qty = _cart[id] ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) {
          final currentQty = _cart[id] ?? 0;
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
                const SizedBox(height: 20),

                // Product image hero
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: product['bgColor'] as Color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    product['icon'] as IconData,
                    size: 72,
                    color: product['iconColor'] as Color,
                  ),
                ),
                const SizedBox(height: 18),

                // Name + price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Text(
                      'RM ${(product['price'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: kBlue500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Category + stock
                Row(children: [
                  _infoBadge(
                    product['category'],
                    const Color(0xFFEFF6FF),
                    kBlue600,
                  ),
                  const SizedBox(width: 8),
                  _infoBadge(
                    '${product['stock']} in stock',
                    const Color(0xFFD1FAE5),
                    const Color(0xFF059669),
                  ),
                ]),
                const SizedBox(height: 20),

                // Quantity stepper
                Row(
                  children: [
                    const Text('Quantity:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        )),
                    const Spacer(),
                    Row(children: [
                      _qtyBtn(
                        Icons.remove_rounded,
                        () {
                          _removeFromCart(id);
                          setSheetState(() {});
                          setState(() {});
                        },
                        kGray100,
                        kGray800,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          '$currentQty',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      _qtyBtn(
                        Icons.add_rounded,
                        () {
                          _addToCart(id);
                          setSheetState(() {});
                          setState(() {});
                        },
                        kBlue500,
                        Colors.white,
                      ),
                    ]),
                  ],
                ),
                const SizedBox(height: 20),

                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [kBlue500, kTeal],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: kBlue500.withOpacity(0.4),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _addToCart(id);
                        setSheetState(() {});
                        setState(() {});
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.shopping_cart_rounded,
                          color: Colors.white, size: 20),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoBadge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: textColor)),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // CART SHEET
  // ─────────────────────────────────────────────────────────────
  void _showCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) {
          final cartItems = _cartItems;

          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
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
                      Text(context.tr('Your Cart'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          )),
                      const Spacer(),
                      Text('$_cartItemCount items',
                          style: TextStyle(fontSize: 13, color: kGray500)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),

                // Items list
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: 56, color: kGray400),
                              const SizedBox(height: 12),
                              Text(context.tr('Your cart is empty'),
                                  style:
                                      TextStyle(fontSize: 15, color: kGray500)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: cartItems.length,
                          itemBuilder: (_, i) {
                            final cartItem = cartItems[i];
                            final p = cartItem.product;
                            final id = p['id'] as String;
                            final qty = cartItem.quantity;
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
                                    color: p['bgColor'] as Color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    p['icon'] as IconData,
                                    color: p['iconColor'] as Color,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(p['name'],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1E293B),
                                          )),
                                      Text(
                                        'RM ${((p['price'] as double) * qty).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: kBlue500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(children: [
                                  _qtyBtn(
                                    Icons.remove_rounded,
                                    () {
                                      _removeFromCart(id);
                                      setSheetState(() {});
                                      setState(() {});
                                    },
                                    kGray100,
                                    kGray800,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text('$qty',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        )),
                                  ),
                                  _qtyBtn(
                                    Icons.add_rounded,
                                    () {
                                      _addToCart(id);
                                      setSheetState(() {});
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

                // Total + checkout
                if (cartItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(children: [
                      const Divider(height: 1),
                      const SizedBox(height: 14),
                      Row(children: [
                        Text(context.tr('Total'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            )),
                        const Spacer(),
                        Text(
                          'RM ${_cartTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: kBlue500,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Payment Method',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: kGray800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: PaymentMethod.values.map((method) {
                          return _paymentMethodTile(
                            method: method,
                            setSheetState: setSheetState,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_selectedPaymentMethod == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please choose one payment method',
                                  ),
                                  backgroundColor: const Color(0xFFEF4444),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                              return;
                            }

                            final paymentMethod = _selectedPaymentMethod!;
                            Navigator.pop(context);
                            _showOrderSuccess(paymentMethod);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBlue500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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

  // ─────────────────────────────────────────────────────────────
  // ORDER SUCCESS DIALOG
  // ─────────────────────────────────────────────────────────────
  Widget _paymentMethodTile({
    required PaymentMethod method,
    required StateSetter setSheetState,
  }) {
    final isSelected = _selectedPaymentMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPaymentMethod = method);
        setSheetState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 155,
        padding: const EdgeInsets.all(11),
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
            Icon(
              _paymentIcon(method),
              size: 18,
              color: isSelected ? kBlue500 : kGray500,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _paymentLabel(method),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? kBlue500 : kGray800,
                ),
              ),
            ),
            Radio<PaymentMethod>(
              value: method,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedPaymentMethod = value);
                setSheetState(() {});
              },
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: kBlue500,
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderSuccess(PaymentMethod paymentMethod) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF059669), size: 36),
            ),
            const SizedBox(height: 16),
            Text(context.tr('Order Placed!'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                )),
            const SizedBox(height: 8),
            Text(
              'Your order of RM ${_cartTotal.toStringAsFixed(2)} has been placed.\nPayment: ${_paymentLabel(paymentMethod)}\nCollect at the Mini Shop counter.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: kGray500),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
                child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _cart.clear();
                    _selectedPaymentMethod = null;
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
                        fontWeight: FontWeight.w700, color: Colors.white)),
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
            children: List.generate(kMainNavItems.length, (i) {
              final isActive = kMainNavItems[i]['route'] == '/shop';
              return Expanded(
                child: GestureDetector(
                  onTap: () => navigateToMainTab(context, i, '/shop'),
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
                        context.tr(kMainNavItems[i]['label'] as String),
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

// ── Color used in product card price ─────────────────────────
const Color kBlue600 = Color(0xFF1A52A0);
