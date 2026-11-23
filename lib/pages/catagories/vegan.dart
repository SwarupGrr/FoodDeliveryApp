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
const Color _kVegGreen = Color(0xFF2F6B35); // small marker on each photo

// Script font for the title (see pubspec.yaml).
// Set this to null to use the default font in italic, like the dessert page.
const String? _kTitleFont = 'KaushanScript';

// The reference screenshot is tiny, so these two proportions are estimates.
// Tune them here if the cards or the banner look too tall or too short.
const double _kCardAspect = 0.66; // card width / card height
const double _kBannerAspect = 0.91; // banner width / banner height

class _Dish {
  final String image;
  final String name;
  final String desc;
  final String kcal;
  final String price;
  const _Dish(this.image, this.name, this.desc, this.kcal, this.price);
}

// Names are from the reference. Descriptions, kcal and prices were too small
// to read, so they are placeholders: replace them with your real data.
const List<_Dish> _dishes = [
  _Dish(
    'assets/images/buddha_bowl.png',
    'Buddha bowl',
    'Quinoa, chickpeas, greens',
    '320 kcal',
    'Rs 260',
  ),
  _Dish(
    'assets/images/avocado_sandwich.png',
    'Avocado sandwich',
    'Avocado, tomato, multigrain',
    '280 kcal',
    'Rs 280',
  ),
  _Dish(
    'assets/images/veggie_wrap.png',
    'Veggie wrap',
    'Grilled veg, hummus, wrap',
    '260 kcal',
    'Rs 220',
  ),
  _Dish(
    'assets/images/tofu_salad.png',
    'Tofu salad',
    'Sesame tofu, greens',
    '240 kcal',
    'Rs 230',
  ),
  _Dish(
    'assets/images/green_smoothie.png',
    'Green smoothie',
    'Spinach, apple, banana',
    '180 kcal',
    'Rs 220',
  ),
  _Dish(
    'assets/images/lentil_soup.png',
    'Lentil soup',
    'Red lentil, herbs, lemon',
    '210 kcal',
    'Rs 230',
  ),
];

class VeganPage extends StatelessWidget {
  const VeganPage({super.key});

  // This page is the "Menu" tab. It never changes, so it is a constant
  // instead of state.
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
                child: Column(
                  children: [
                    _buildPanel(w),
                    SizedBox(height: w * 0.04),
                    _buildBanner(w),
                  ],
                ),
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
      padding: EdgeInsets.fromLTRB(w * 0.05, w * 0.03, w * 0.05, w * 0.03),
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
              width: w * 0.09,
              height: w * 0.09,
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
          SizedBox(width: w * 0.05),
          Expanded(
            // Same height as the back button, so the bar keeps its height.
            child: SizedBox(
              height: w * 0.09,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  // The capital O in "yOu" is how it is drawn in the reference.
                  'vegan choices for yOu',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: _kTitleFont,
                    color: _kTitleRed,
                    fontSize: w * 0.078,
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
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: _kPanel,
        borderRadius: BorderRadius.circular(w * 0.05),
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
                      'Good food, naturally',
                      style: TextStyle(
                        color: _kText,
                        fontSize: w * 0.045,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${_dishes.length} plant-based picks',
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
            itemCount: _dishes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: w * 0.04,
              mainAxisSpacing: w * 0.04,
              childAspectRatio: _kCardAspect,
            ),
            itemBuilder: (context, i) => _buildCard(w, _dishes[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(double w, _Dish d) {
    return Container(
      padding: EdgeInsets.all(w * 0.015),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(w * 0.04),
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    d.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFD9E6CC),
                      child: Icon(Icons.eco, color: _kGrey, size: w * 0.09),
                    ),
                  ),
                  // Small green "plant-based" marker, top left of the photo
                  Positioned(
                    top: w * 0.012,
                    left: w * 0.012,
                    child: Container(
                      width: w * 0.05,
                      height: w * 0.05,
                      decoration: const BoxDecoration(
                        color: _kVegGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.eco,
                        color: Colors.white,
                        size: w * 0.03,
                      ),
                    ),
                  ),
                ],
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
                    d.kcal,
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
              // TODO: add this dish to the cart
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

  // Large photo under the panel (the salad bowl in the reference).
  Widget _buildBanner(double w) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.075),
      child: AspectRatio(
        aspectRatio: _kBannerAspect,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(w * 0.03),
          child: Image.asset(
            'assets/images/vegan_banner.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFD9E6CC),
              child: Icon(Icons.eco, color: _kGrey, size: w * 0.15),
            ),
          ),
        ),
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