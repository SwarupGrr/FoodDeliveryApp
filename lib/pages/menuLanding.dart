import 'package:flutter/material.dart';
import 'homePage.dart';
import 'feedbackPage.dart';
import 'giftPage.dart';

const Color _kRed = Color(0xFFC8101A);
const Color _kDarkRed = Color(0xFFA30D14);
const Color _kPrice = Color(0xFF9B1B1B);
const Color _kBg = Color(0xFFFFF4E3);

class _Category {
  final IconData icon;
  final String label;
  const _Category(this.icon, this.label);
}

class _Product {
  final String image;
  final String name;
  final String price;
  const _Product(this.image, this.name, this.price);
}

const List<_Category> _categories = [
  _Category(Icons.set_meal_outlined, 'Seafood'),
  _Category(Icons.lunch_dining_outlined, 'Hot dog'),
  _Category(Icons.eco_outlined, 'Vegan'),
  _Category(Icons.icecream_outlined, 'Desserts'),
  _Category(Icons.rice_bowl_outlined, 'Salads'),
];

const List<_Product> _products = [
  _Product('assets/images/coke.png', 'Cold drinks', 'Rs.150'),
  _Product('assets/images/hotdog.png', 'Cold drinks', 'Rs.150'),
  _Product('assets/images/coke.png', 'Cold drinks', 'Rs.150'),
  _Product('assets/images/burger.png', 'Cold drinks', 'Rs.150'),
];

class MenuLanding extends StatefulWidget {
  const MenuLanding({super.key});

  @override
  State<MenuLanding> createState() => _MenuLandingState();
}

class _MenuLandingState extends State<MenuLanding> {
  int _selectedCategory = 0;
  int _selectedNav = 1;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _kBg,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(w * 0.30),
        child: AppBar(
          backgroundColor: _kBg,
          elevation: 0,
          centerTitle: true,

          flexibleSpace: SafeArea(
            child: Column(
              children: [
                _buildCategories(w),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: w * 0.05),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        color: _kRed,
                        fontSize: w * 0.03,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          color: _kBg,
          image: DecorationImage(
            image: AssetImage('assets/images/menu_background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),

        child: SafeArea(
          top: false,
          bottom: false,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: _kBg,
                padding: EdgeInsets.only(
                  left: w * 0.05,
                  top: w * 0.02,
                  bottom: w * 0.01,
                ),
                child: Text(
                  'popular choices',
                  style: TextStyle(
                    color: _kRed,
                    fontSize: w * 0.034,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: w * 0.04),

                  itemCount: _products.length,

                  itemBuilder: (context, i) {
                    return _buildCard(w, _products[i]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomNav(w),
    );
  }

  Widget _buildCategories(double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.025),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_categories.length, (i) {
          final c = _categories[i];
          final selected = i == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: w * 0.13,
                  height: w * 0.13,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? _kRed : Colors.white,
                    border: Border.all(color: _kRed, width: 1.2),
                  ),
                  child: Icon(
                    c.icon,
                    size: w * 0.065,
                    color: selected ? Colors.white : _kRed,
                  ),
                ),
                SizedBox(height: w * 0.01),
                Text(
                  c.label,
                  style: TextStyle(
                    color: _kDarkRed,
                    fontSize: w * 0.026,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCard(double w, _Product p) {
    final double cardH = w * 0.62;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.025),
      child: SizedBox(
        height: cardH,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(w * 0.13),
                  gradient: const RadialGradient(
                    colors: [Color(0xFFFFE08A), Color(0xFFFFB23F)],
                    radius: 0.9,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: cardH * 0.06,
              left: w * 0.08,
              right: w * 0.08,
              height: cardH * 0.56,
              child: Image.asset(p.image, fit: BoxFit.contain),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: cardH * 0.04,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    p.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: w * 0.034,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    p.price,
                    style: TextStyle(
                      color: _kPrice,
                      fontSize: w * 0.033,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: w * 0.012),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.06,
                        vertical: w * 0.012,
                      ),
                      decoration: BoxDecoration(
                        color: _kRed,
                        borderRadius: BorderRadius.circular(w * 0.012),
                      ),
                      child: Text(
                        'Add to cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.027,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

              final color = selected ? const Color(0xFFFFC94D) : Colors.white;

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
                      MaterialPageRoute(builder: (context) => const FeedbackPage()),
                    );
                  } else if (i == 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MenuLanding(),
                      ),
                    );
                  } else if (i == 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Homepage()),
                    );
                  } else if (i == 3) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Giftpage()),
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
