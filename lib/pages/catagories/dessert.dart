import 'package:flutter/material.dart';
import './../menuLanding.dart';
import './../homePage.dart';
import './../feedbackPage.dart';
import './../CartPage.dart';

const Color _kBg = Color(0xFFFFF4E3);
const Color _kPanel = Color(0xFFEBDFC8);
const Color _kCard = Colors.white;
const Color _kRed = Color(0xFFC8101A);
const Color _kDarkRed = Color(0xFF8E1B1B);
const Color _kPink = Color(0xFFF9D6DA);
const Color _kAccent = Color(0xFFFFC94D);
const Color _kText = Color(0xFF1A1A1A);
const Color _kGrey = Color(0xFF8A8480);

class _Dessert {
  final String image;
  final String name;
  final String desc;
  final String kcal;
  final String price;
  const _Dessert(this.image, this.name, this.desc, this.kcal, this.price);
}

const List<_Dessert> _desserts = [
  _Dessert(
    'assets/images/brownie_sundae.png',
    'Brownie Sundae',
    'Warm brownie, vanilla ice cream',
    '420 kcal',
    'Rs 350',
  ),
  _Dessert(
    'assets/images/macarons.png',
    'Macarons',
    'Assorted flavors, 4 pieces',
    '280 kcal',
    'Rs 300',
  ),
  _Dessert(
    'assets/images/strawberry_cake.png',
    'Strawberry Cake',
    'Fresh cream, strawberry layers',
    '320 kcal',
    'Rs 380',
  ),
  _Dessert(
    'assets/images/chocolate_dessert.png',
    'Chocolate Dessert',
    'Wafer, berry sauce, cream',
    '360 kcal',
    'Rs 340',
  ),
  _Dessert(
    'assets/images/red_velvet_cake.png',
    'Red Velvet Cake',
    'Cream cheese frosting, raspberry',
    '280 kcal',
    'Rs 400',
  ),
  _Dessert(
    'assets/images/choco_donuts.png',
    'Choco Donuts',
    'Chocolate glaze, rainbow sprinkles',
    '310 kcal',
    'Rs 150',
  ),
];

class DessertsPage extends StatefulWidget {
  const DessertsPage({super.key});

  @override
  State<DessertsPage> createState() => _DessertsPageState();
}

class _DessertsPageState extends State<DessertsPage> {
  int _selectedNav = 1;
  bool _liked = true;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(w),
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
            _buildBottomNav(w),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(double w) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.05, w * 0.03, w * 0.05, w * 0.03),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: w * 0.09,
              height: w * 0.09,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
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
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Enjoy the best desserts',
                style: TextStyle(
                  color: _kDarkRed,
                  fontSize: w * 0.065,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: w * 0.09),
        ],
      ),
    );
  }

  Widget _buildPanel(double w) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.04),
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: _kPanel,
        borderRadius: BorderRadius.circular(22),
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
                      'Sweet and Fresh',
                      style: TextStyle(
                        color: _kText,
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '6 dessert picks',
                      style: TextStyle(color: _kGrey, fontSize: w * 0.026),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _liked = !_liked),
                child: Container(
                  width: w * 0.08,
                  height: w * 0.08,
                  decoration: const BoxDecoration(
                    color: _kPink,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _liked ? Icons.favorite : Icons.favorite_border,
                    color: _kRed,
                    size: w * 0.045,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.03),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _desserts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: w * 0.035,
              mainAxisSpacing: w * 0.035,
              childAspectRatio: 0.74,
            ),
            itemBuilder: (context, i) => _buildCard(w, _desserts[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(double w, _Dessert d) {
    return Container(
      padding: EdgeInsets.all(w * 0.015),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox.expand(
                child: Image.asset(d.image, fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(height: w * 0.012),
          Text(
            d.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _kText,
              fontSize: w * 0.032,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            d.desc,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: _kGrey, fontSize: w * 0.024),
          ),
          SizedBox(height: w * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.02,
                  vertical: w * 0.005,
                ),
                decoration: BoxDecoration(
                  color: _kPink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  d.kcal,
                  style: TextStyle(color: _kDarkRed, fontSize: w * 0.021),
                ),
              ),
              Text(
                d.price,
                style: TextStyle(
                  color: _kRed,
                  fontSize: w * 0.03,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.012),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: w * 0.02),
              decoration: BoxDecoration(
                color: _kRed,
                borderRadius: BorderRadius.circular(8),
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
                      fontSize: w * 0.027,
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

  Widget _buildBanner(double w) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.04),
      child: AspectRatio(
        aspectRatio: 2.0,
        child: Container(
          decoration: BoxDecoration(
            color: _kRed,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0.55, 0),
                child: FractionallySizedBox(
                  widthFactor: 0.62,
                  heightFactor: 0.72,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE88A97),
                      borderRadius: BorderRadius.circular(w),
                    ),
                    padding: EdgeInsets.all(w * 0.03),
                    child: Image.asset(
                      'assets/images/donut.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w * 0.03,
                top: w * 0.03,
                child: Container(
                  padding: EdgeInsets.all(w * 0.025),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFA30D14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '20% off',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w * 0.04,
                top: w * 0.2,
                child: Text(
                  'On Our Donuts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.03,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
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
