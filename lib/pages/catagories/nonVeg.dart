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

// Script font for the title and the banner (see pubspec.yaml).
// Set this to null to use the default font in italic, like the dessert page.
const String? _kScriptFont = 'KaushanScript';

class _Food {
  final String image;
  final String name;
  final String desc;
  final String price;
  final String category; // which filter chip shows this item
  const _Food(this.image, this.name, this.desc, this.price, this.category);
}

// Filter chips. 'All' shows everything.
const List<String> _filters = ['All', 'Burgers', 'Momo', 'Chicken', 'Seafood'];

// Names, descriptions and prices were read from a very small screenshot, so
// check them. The category of each item is my guess (it is not in the design).
const List<_Food> _foods = [
  _Food('assets/images/ham_burger.png', 'Ham burger', 'Juicy and cheesy',
      'Rs 350', 'Burgers'),
  _Food('assets/images/chicken_momo.png', 'Chicken momo', 'Steamed, 10 pcs',
      'Rs 220', 'Momo'),
  _Food('assets/images/buff_momo.png', 'Buff momo', 'Jhol style', 'Rs 200',
      'Momo'),
  _Food('assets/images/chicken_sandwich.png', 'Chicken sandwich',
      'Grilled and crispy', 'Rs 280', 'Chicken'),
  _Food('assets/images/fried_chicken.png', 'Fried chicken', 'Spicy, 4 pcs',
      'Rs 450', 'Chicken'),
  _Food('assets/images/chicken_biryani.png', 'Chicken biryani', 'With raita',
      'Rs 400', 'Chicken'),
  _Food('assets/images/pork_sekuwa.png', 'Pork sekuwa', 'Charcoal grilled',
      'Rs 380', 'Other'), // only appears under "All"
  _Food('assets/images/fish_fry.png', 'Fish fry', 'Crispy golden', 'Rs 420',
      'Seafood'),
];

class NonVegPage extends StatefulWidget {
  const NonVegPage({super.key});

  @override
  State<NonVegPage> createState() => _NonVegPageState();
}

class _NonVegPageState extends State<NonVegPage> {
  // This page is the "Menu" tab. It never changes, so it is a constant.
  static const int _selectedNav = 1;

  String _filter = 'All';

  List<_Food> get _visibleFoods => _filter == 'All'
      ? _foods
      : _foods.where((f) => f.category == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(w),
            _buildFilters(w),
            SizedBox(height: w * 0.02),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: w * 0.04),
                child: Column(
                  children: [
                    _buildPanel(w),
                    SizedBox(height: w * 0.035),
                    _buildBanner(w),
                  ],
                ),
              ),
            ),
            _buildBottomNav(w),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(double w) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.05, w * 0.03, w * 0.05, w * 0.025),
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
                    color: const Color(0x1F000000), // 12% black
                    blurRadius: w * 0.02,
                    offset: Offset(0, w * 0.005),
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
          Expanded(
            // Same height as the back button, so the bar keeps its height.
            child: SizedBox(
              height: w * 0.09,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Savor the best food',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: _kScriptFont,
                    color: _kTitleRed,
                    fontSize: w * 0.065,
                    height: 1.0, // script fonts have tall line boxes
                    fontStyle: _kScriptFont == null
                        ? FontStyle.italic
                        : FontStyle.normal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          // Balances the back button so the title stays centered.
          SizedBox(width: w * 0.09),
        ],
      ),
    );
  }

  // Row of outlined pills. It scrolls sideways: "Seafood" is cut off at the
  // right edge in the reference.
  Widget _buildFilters(double w) {
    return SizedBox(
      height: w * 0.087,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: w * 0.045),
        itemCount: _filters.length,
        separatorBuilder: (context, i) => SizedBox(width: w * 0.02),
        itemBuilder: (context, i) {
          final String label = _filters[i];
          final bool selected = label == _filter;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _filter = label),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              decoration: BoxDecoration(
                color: selected ? _kRed : Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: _kRed, width: 1),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : _kRed,
                  fontSize: w * 0.0385,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPanel(double w) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.045),
      padding: EdgeInsets.all(w * 0.025),
      decoration: BoxDecoration(
        color: _kPanel,
        borderRadius: BorderRadius.circular(w * 0.06),
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _visibleFoods.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: w * 0.025,
          mainAxisSpacing: w * 0.03,
          childAspectRatio: 0.673,
        ),
        itemBuilder: (context, i) => _buildCard(w, _visibleFoods[i]),
      ),
    );
  }

  Widget _buildCard(double w, _Food f) {
    return Container(
      padding: EdgeInsets.all(w * 0.012),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(w * 0.045),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000), // 10% black
            blurRadius: w * 0.025,
            offset: Offset(0, w * 0.008),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo takes whatever height is left after the text rows.
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.03),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    f.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFE6D9BF),
                      child: Icon(Icons.fastfood, color: _kGrey, size: w * 0.09),
                    ),
                  ),
                  // Small "non-veg" marker (red dot in a square), top left
                  Positioned(
                    top: w * 0.015,
                    left: w * 0.015,
                    child: Container(
                      width: w * 0.045,
                      height: w * 0.045,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(w * 0.008),
                        border: Border.all(color: _kRed, width: 0.8),
                      ),
                      child: Container(
                        width: w * 0.02,
                        height: w * 0.02,
                        decoration: const BoxDecoration(
                          color: _kRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: w * 0.03),
          Text(
            f.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _kText,
              fontSize: w * 0.038,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: w * 0.005),
          Text(
            f.desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: _kGrey, fontSize: w * 0.028, height: 1.2),
          ),
          SizedBox(height: w * 0.0075),
          Text(
            f.price,
            style: TextStyle(
              color: _kRed,
              fontSize: w * 0.035,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: w * 0.015),
          GestureDetector(
            onTap: () {
              // TODO: add this item to the cart
            },
            child: Container(
              width: double.infinity,
              height: w * 0.09,
              decoration: BoxDecoration(
                color: _kRed,
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: w * 0.032,
                  ),
                  SizedBox(width: w * 0.012),
                  Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w600,
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

  // Red promo banner: "20% off" badge, script text, round chicken photo.
  Widget _buildBanner(double w) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.045),
      child: AspectRatio(
        aspectRatio: 1.714,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(w * 0.07),
          child: Container(
            color: _kRed,
            child: LayoutBuilder(
              builder: (context, box) {
                final double h = box.maxHeight;
                return Stack(
                  children: [
                    // Round photo, touching the top, bottom and right edges
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: h,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/chicken_banner.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFE6D9BF),
                            child: Icon(
                              Icons.fastfood,
                              color: _kGrey,
                              size: w * 0.12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // "20% off" badge
                    Positioned(
                      left: w * 0.045,
                      top: w * 0.085,
                      child: Container(
                        width: w * 0.13,
                        height: w * 0.13,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '20%',
                              style: TextStyle(
                                color: _kRed,
                                fontSize: w * 0.034,
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'off',
                              style: TextStyle(
                                color: _kRed,
                                fontSize: w * 0.026,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // "On Our / Chicken"
                    Positioned(
                      left: w * 0.055,
                      bottom: w * 0.035,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'On Our',
                            style: TextStyle(
                              fontFamily: _kScriptFont,
                              color: Colors.white,
                              fontSize: w * 0.032,
                              height: 1.1,
                              fontStyle: _kScriptFont == null
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                          Text(
                            'Chicken',
                            style: TextStyle(
                              fontFamily: _kScriptFont,
                              color: Colors.white,
                              fontSize: w * 0.068,
                              height: 1.0,
                              fontWeight: FontWeight.w700,
                              fontStyle: _kScriptFont == null
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(double w) {
    const items = [
      [Icons.star_border, 'Feedback'],
      [Icons.grid_view_rounded, 'Menu'],
      [Icons.home, 'Home'],
      [Icons.shopping_cart_outlined, 'Cart'],
    ];

    return Container(
      color: _kBg,
      padding: EdgeInsets.only(
        left: w * 0.045,
        right: w * 0.045,
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