import 'package:flutter/material.dart';
import './../menuLanding.dart';
import './../homePage.dart';
import './../feedbackPage.dart';
import './../CartPage.dart';

const Color _kBg = Color(0xFFFFF4E3);
const Color _kPanel = Color(0xFFEBDFC8);
const Color _kCard = Colors.white;
const Color _kRed = Color(0xFFC8101A);
const Color _kTitleRed = Color(0xFFB3121C);
const Color _kText = Color(0xFF1A1A1A);
const Color _kGrey = Color(0xFF8A8480);
const Color _kChipGreen = Color(0xFFDDEBD2);
const Color _kChipText = Color(0xFF3C5F2F);
const Color _kLeafBg = Color(0xFFE2EBD7);
const Color _kLeafIcon = Color(0xFF2F5D2F);

// Script font for the title (see pubspec.yaml).
// Set this to null to use the default font in italic, like the dessert page.
const String? _kTitleFont = 'KaushanScript';

class _Drink {
  final String image;
  final String name;
  final String desc;
  final String size;
  final String price;
  const _Drink(this.image, this.name, this.desc, this.size, this.price);
}

const List<_Drink> _drinks = [
  _Drink(
    'assets/images/oreo_shake.png',
    'Oreo Shake',
    'Chocolate, cream, Oreo crumble',
    '350 ml',
    'Rs 350',
  ),
  _Drink(
    'assets/images/lemon_soda.png',
    'Lemon Soda',
    'Fresh lime, mint, soda',
    '300 ml',
    'Rs 180',
  ),
  _Drink(
    'assets/images/strawberry_smoothie.png',
    'Strawberry Smoothie',
    'Strawberry, berry, fresh cream',
    '240 kcal',
    'Rs 320',
  ),
  _Drink(
    'assets/images/cherry_guava.png',
    'Cherry Guava',
    'Guava, cherry, orange slice',
    '300 ml',
    'Rs 250',
  ),
  _Drink(
    'assets/images/blue_lagoon.png',
    'Blue Lagoon',
    'Blue curacao, lime, mint',
    '300 ml',
    'Rs 280',
  ),
  _Drink(
    'assets/images/tropical_blue_mojito.png',
    'Tropical Blue Mojito',
    'Blueberry, lemon, mint',
    '350 ml',
    'Rs 300',
  ),
];

class DrinksPage extends StatelessWidget {
  const DrinksPage({super.key});

  // This page is the "Menu" tab. It never changes, so it is a constant
  // instead of state (the dessert page stores it in State and never edits it).
  static const int _selectedNav = 1;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(context, w),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: w * 0.04),
                child: _buildPanel(w),
              ),
            ),
            _buildBottomNav(context, w),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, double w) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.087, w * 0.016, w * 0.062, w * 0.044),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Safe pop - prevents the "_history.isNotEmpty" crash
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                // Fallback if stack is empty
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuLanding()),
                );
              }
            },
            child: Container(
              width: w * 0.093,
              height: w * 0.093,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x26000000), // 15% black
                    blurRadius: w * 0.0125,
                    offset: Offset(0, w * 0.003),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: _kText,
                size: w * 0.04,
              ),
            ),
          ),
          SizedBox(width: w * 0.02),
          Expanded(
            // Same height as the back button, so the bar keeps its height.
            child: SizedBox(
              height: w * 0.093,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enjoy the best drinks',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: _kTitleFont,
                    color: _kTitleRed,
                    fontSize: w * 0.081,
                    height: 1.0, // script fonts have tall line boxes
                    fontStyle: _kTitleFont == null
                        ? FontStyle.italic
                        : FontStyle.normal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel(double w) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.084),
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.031,
        vertical: w * 0.025,
      ),
      decoration: BoxDecoration(
        color: _kPanel,
        borderRadius: BorderRadius.circular(w * 0.037),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cool and fresh',
                      style: TextStyle(
                        color: _kText,
                        fontSize: w * 0.045,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${_drinks.length} chilled picks',
                      style: TextStyle(
                        color: _kGrey,
                        fontSize: w * 0.0265,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: w * 0.075,
                height: w * 0.075,
                decoration: BoxDecoration(
                  color: _kLeafBg,
                  borderRadius: BorderRadius.circular(w * 0.019),
                ),
                child: Icon(Icons.eco, color: _kLeafIcon, size: w * 0.044),
              ),
            ],
          ),
          SizedBox(height: w * 0.035),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _drinks.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: w * 0.053,
              mainAxisSpacing: w * 0.05,
              childAspectRatio: 0.635,
            ),
            itemBuilder: (context, i) => _buildCard(w, _drinks[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(double w, _Drink d) {
    return Container(
      padding: EdgeInsets.all(w * 0.0125),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(w * 0.0436),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000), // 10% black
            blurRadius: w * 0.025,
            offset: Offset(0, w * 0.009),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo takes whatever height is left after the text rows.
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.031),
              child: SizedBox.expand(
                child: Image.asset(
                  d.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE6D9BF),
                    child: Icon(
                      Icons.local_drink,
                      color: _kGrey,
                      size: w * 0.09,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: w * 0.029),
          Text(
            d.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _kText,
              fontSize: w * 0.0327,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: w * 0.013),
          Text(
            d.desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: _kGrey, fontSize: w * 0.025, height: 1.2),
          ),
          SizedBox(height: w * 0.013),
          SizedBox(
            height: w * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.019),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _kChipGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    d.size,
                    style: TextStyle(
                      color: _kChipText,
                      fontSize: w * 0.025,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  d.price,
                  style: TextStyle(
                    color: _kRed,
                    fontSize: w * 0.0327,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: w * 0.0187),
          GestureDetector(
            onTap: () {
              // TODO: add this drink to the cart
            },
            child: Container(
              width: double.infinity,
              height: w * 0.084,
              decoration: BoxDecoration(
                color: _kRed,
                borderRadius: BorderRadius.circular(w * 0.025),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: w * 0.031,
                  ),
                  SizedBox(width: w * 0.012),
                  Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.0265,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, double w) {
    const items = [
      [Icons.star_border, 'Feedback'],
      [Icons.grid_view_rounded, 'Menu'],
      [Icons.home, 'Home'],
      [Icons.shopping_cart_outlined, 'Cart'],
    ];

    return Container(
      color: _kBg,
      padding: EdgeInsets.only(
        left: w * 0.08,
        right: w * 0.08,
        top: w * 0.015,
        bottom: w * 0.025,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: w * 0.012),
          decoration: BoxDecoration(
            color: _kRed,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == _selectedNav;
              final color = selected ? const Color(0xFFFFC94D) : Colors.white;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (i == _selectedNav) return;

                    if (i == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeedbackPage(),
                        ),
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
                        MaterialPageRoute(
                          builder: (context) => const Homepage(),
                        ),
                      );
                    } else if (i == 3) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Cartpage(),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i][0] as IconData,
                        color: color,
                        size: w * 0.06,
                      ),
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
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}