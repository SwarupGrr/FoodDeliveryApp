import 'package:flutter/material.dart';
import 'menuLanding.dart';
import 'feedbackPage.dart';
import 'giftPage.dart';
import 'userProfile.dart';

const Color _kBg = Color(0xFFFFF1E4);
const Color _kPanel = Color(0xFFEFE3D3);
const Color _kCard = Color(0xFFFFFAF5);
const Color _kRed = Color(0xFFC40F0F);
const Color _kDarkRed = Color(0xFF7A0D14);
const Color _kAccent = Color(0xFFFFC94D);
const Color _kText = Color(0xFF2B1A17);
const Color _kGrey = Color(0xFF8A8480);
const Color _kDisabled = Color(0xFFB5B0AC);

class _Category {
  final IconData icon;
  final String label;
  const _Category(this.icon, this.label);
}

class _Product {
  final String image;
  final String name;
  final String desc;
  final String price;
  final bool soldOut;
  const _Product(this.image, this.name, this.desc, this.price,
      {this.soldOut = false});
}

const List<_Category> _categories = [
  _Category(Icons.fastfood_outlined, 'fast food'),
  _Category(Icons.set_meal_outlined, 'Non-veg'),
  _Category(Icons.eco_outlined, 'Vegan'),
  _Category(Icons.cake_outlined, 'Desserts'),
  _Category(Icons.local_drink_outlined, 'Drinks'),
];

const List<_Product> _products = [
  _Product('assets/images/jhol_momo.png', 'Jhol Momo', 'Jhol style', 'Rs 250'),
  _Product('assets/images/chicken_chowmein.png', 'Chicken Chowmein',
      'Spicy, wok-tossed', 'Rs 320'),
  _Product('assets/images/buff_sekuwa.png', 'Buff Sekuwa', 'Grilled, 6 pcs',
      'Rs 380'),
  _Product('assets/images/veg_thukpa.png', 'Veg Thukpa', 'Garden vegetables',
      'Rs 280'),
  _Product('assets/images/fried_momo.png', 'Fried Momo', 'Crispy, 6 pcs',
      'Rs 300'),
  _Product('assets/images/egg_noodle_soup.png', 'Egg Noodle Soup',
      'With egg & greens', 'Rs 290',
      soldOut: true),
];

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedCategory = 0;
  int _selectedNav = 2;
  int _cartCount = 0;
  int _cartTotal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Container(
        color: _kBg,
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(builder: (context, c) {
            final double w = c.maxWidth;
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: w * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(w: w),
                  _LocationCard(w: w),
                  _PromoBanner(w: w),
                  _CategoryRow(
                    w: w,
                    selected: _selectedCategory,
                    onTap: (i) => setState(() => _selectedCategory = i),
                  ),
                  _ReservationCard(w: w),
                  _ProductSection(
                    w: w,
                    cartCount: _cartCount,
                    cartTotal: _cartTotal,
                    onAdd: (p) => setState(() {
                      _cartCount++;
                      _cartTotal += int.parse(
                          p.price.replaceAll(RegExp(r'[^0-9]'), ''));
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(MediaQuery.of(context).size.width),
    );
  }

  Widget _buildBottomNav(double w) {
    const items = [
      [Icons.star_border, 'Feedback'],
      [Icons.grid_view_rounded, 'Menu'],
      [Icons.home_outlined, 'Home'],
      [Icons.card_giftcard, 'Gift'],
    ];

    return Container(
      color: _kRed,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: w * 0.015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == _selectedNav;
              final color = selected ? _kAccent : Colors.white;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Do nothing if already on this page
                  if (i == _selectedNav) {
                    return;
                  }

                  setState(() {
                    _selectedNav = i;
                  });

                  if (i == 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeedbackPage()),
                    );
                  } else if (i == 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MenuLanding()),
                    );
                  } else if (i == 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Homepage()),
                    );
                  } else if (i == 3) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Giftpage()),
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[i][0] as IconData, color: color, size: w * 0.06),
                    SizedBox(height: w * 0.004),
                    Text(
                      items[i][1] as String,
                      style: TextStyle(
                        color: color,
                        fontSize: w * 0.024,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final double w;
  const _Header({required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.05, w * 0.03, w * 0.05, w * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: w * 0.25,
            height: w * 0.25,
            child: Image.asset('assets/images/momo_logo_noBG.png', fit: BoxFit.contain),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'momo on\nclouds',
                  style: TextStyle(
                    color: _kRed,
                    fontSize: w * 0.06,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'fast food\ntreat',
                  style: TextStyle(
                    color: _kRed,
                    fontSize: w * 0.03,
                    height: 1.1,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Column(
  children: [
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilePage(),
          ),
        );
      },
      child: Container(
        width: w * 0.11,
        height: w * 0.11,
        decoration: const BoxDecoration(
          color: _kRed,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: w * 0.07,
        ),
      ),
    ),

    SizedBox(height: w * 0.02),
  ],
)
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final double w;
  const _LocationCard({required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: w * 0.035, vertical: w * 0.022),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.015),
              decoration: BoxDecoration(
                color: _kRed.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_on, color: _kRed, size: w * 0.045),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Located at',
                      style: TextStyle(color: _kGrey, fontSize: w * 0.026)),
                  Text(
                    'Tarachhi, Lekhnath, Street 19',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _kText,
                      fontSize: w * 0.032,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: _kText, size: w * 0.05),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final double w;
  const _PromoBanner({required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.05, w * 0.035, w * 0.05, 0),
      child: AspectRatio(
        aspectRatio: 1.9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: _kRed,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(w * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'FRESH.\nHANDMADE.\nMOMO.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.07,
                              height: 1.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: w * 0.04, vertical: w * 0.018),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'order now',
                                style: TextStyle(
                                  color: _kRed,
                                  fontSize: w * 0.034,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: w * 0.015),
                              Icon(Icons.arrow_forward,
                                  color: _kRed, size: w * 0.04),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox.expand(
                    child: Image.asset(
                      'assets/images/momo_promo.png',
                      fit: BoxFit.cover,
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
}

class _CategoryRow extends StatelessWidget {
  final double w;
  final int selected;
  final ValueChanged<int> onTap;
  const _CategoryRow(
      {required this.w, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.05, w * 0.04, w * 0.05, w * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_categories.length, (i) {
          final c = _categories[i];
          final sel = i == selected;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: w * 0.13,
                  height: w * 0.13,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: sel ? _kRed : _kCard,
                    border: Border.all(color: _kRed, width: 1),
                  ),
                  child: Icon(c.icon,
                      color: sel ? Colors.white : _kRed, size: w * 0.065),
                ),
                SizedBox(height: w * 0.01),
                Text(c.label,
                    style: TextStyle(color: _kText, fontSize: w * 0.026)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final double w;
  const _ReservationCard({required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: w * 0.035, vertical: w * 0.025),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kRed.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Icon(Icons.table_restaurant_outlined,
                color: _kRed, size: w * 0.07),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reserve a Table',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _kText,
                      fontSize: w * 0.036,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Strong with us! Pick a date and time',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _kGrey, fontSize: w * 0.026),
                  ),
                ],
              ),
            ),
            SizedBox(width: w * 0.02),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.035, vertical: w * 0.015),
              decoration: BoxDecoration(
                color: _kRed,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Reserve',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.028,
                          fontWeight: FontWeight.w600)),
                  SizedBox(width: w * 0.01),
                  Icon(Icons.arrow_forward,
                      color: Colors.white, size: w * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductSection extends StatelessWidget {
  final double w;
  final int cartCount;
  final int cartTotal;
  final ValueChanged<_Product> onAdd;
  const _ProductSection({
    required this.w,
    required this.cartCount,
    required this.cartTotal,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: w * 0.04),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.03, w * 0.04, w * 0.04),
      decoration: const BoxDecoration(
        color: _kPanel,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FRESH FROM OUR KITCHEN',
            style: TextStyle(
              color: _kGrey,
              fontSize: w * 0.022,
              letterSpacing: 0.5,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  'Popular choices',
                  style: TextStyle(
                    color: _kDarkRed,
                    fontSize: w * 0.07,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: w * 0.01),
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: _kText,
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.025),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: w * 0.035,
              mainAxisSpacing: w * 0.035,
              childAspectRatio: 0.66,
            ),
            itemBuilder: (context, i) => _ProductCard(
              w: w,
              product: _products[i],
              onAdd: () => onAdd(_products[i]),
            ),
          ),
          SizedBox(height: w * 0.04),
          _CartSummary(w: w, count: cartCount, total: cartTotal),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final double w;
  final _Product product;
  final VoidCallback onAdd;
  const _ProductCard(
      {required this.w, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(w * 0.02),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(product.image, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: w * 0.015,
                  left: w * 0.015,
                  child: Container(
                    padding: EdgeInsets.all(w * 0.008),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.stop_circle_outlined,
                        color: _kRed, size: w * 0.03),
                  ),
                ),
                if (product.soldOut)
                  Positioned(
                    bottom: w * 0.015,
                    right: w * 0.015,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 0.015, vertical: w * 0.006),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Sold out',
                          style: TextStyle(
                              color: Colors.white, fontSize: w * 0.02)),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: w * 0.015),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _kText,
              fontSize: w * 0.034,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            product.desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: _kGrey, fontSize: w * 0.026),
          ),
          SizedBox(height: w * 0.01),
          Text(
            product.price,
            style: TextStyle(
              color: _kRed,
              fontSize: w * 0.036,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: w * 0.015),
          GestureDetector(
            onTap: product.soldOut ? null : onAdd,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: w * 0.022),
              decoration: BoxDecoration(
                color: product.soldOut ? _kDisabled : _kRed,
                borderRadius: BorderRadius.circular(30),
              ),
              child: product.soldOut
                  ? Center(
                      child: Text('Sold out',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.w600)),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            color: Colors.white, size: w * 0.035),
                        SizedBox(width: w * 0.015),
                        Text('Add to cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.03,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double w;
  final int count;
  final int total;
  const _CartSummary(
      {required this.w, required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: w * 0.04),
      decoration: BoxDecoration(
        color: _kDarkRed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'View cart · $count items',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: w * 0.032),
            ),
          ),
          Text(
            'Rs $total →',
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.034,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}