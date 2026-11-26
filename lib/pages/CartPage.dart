import 'package:flutter/material.dart';
import 'menuLanding.dart';
import 'homePage.dart';
import 'feedbackPage.dart';
import 'checkout.dart';

// Colours of the bottom nav, kept exactly as on your other pages.
const Color _kBg = Color(0xFFFFF4E3);
const Color _kRed = Color(0xFFC8101A);

// Colours measured from the cart reference. The reference uses a darker
// brick red than the nav, so they are kept separate.
const Color _kBrick = Color(0xFFA82B2D); // prices, trash, Apply, "+"
const Color _kPill = Color(0xFFF3D6D6); // "4 items" pill
const Color _kGreen = Color(0xFF426B12); // checkout button
const Color _kText = Color(0xFF1F1F1F);
const Color _kGrey = Color(0xFF8A8480);
const Color _kLabel = Color(0xFF5E534B); // summary labels
const Color _kCapsule = Color(0xFFF4EBDC); // behind the quantity stepper
const Color _kLine = Color(0xFFEBE0CE);

class _CartItem {
  final String image;
  final String name;
  final String desc;
  final int price; // in Rs, per item
  int qty;
  _CartItem(this.image, this.name, this.desc, this.price, [this.qty = 1]);
}

/// 1100 -> "Rs 1,100"
String _money(int v) {
  final String digits = v.abs().toString();
  final StringBuffer b = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) b.write(',');
    b.write(digits[i]);
  }
  return 'Rs ${v < 0 ? '-' : ''}$b';
}

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  // This page is the "Cart" tab. It never changes, so it is a constant.
  static const int _selectedNav = 3;

  static const int _deliveryFee = 100;
  int _discount = 0; // TODO: set this when a promo code is applied

  // Sample data copied from the reference. A real cart needs state that is
  // shared with the "Add to cart" buttons on the other pages.
  final List<_CartItem> _items = [
    _CartItem('assets/images/ham_burger.png', 'Ham burger', 'Extra cheese', 350),
    _CartItem(
        'assets/images/veggie_sandwich.png', 'Sandwich', 'Grilled veggie', 250),
    _CartItem('assets/images/oreo_shake.png', 'Oreo shake', 'Large', 280),
    _CartItem('assets/images/momo.png', 'Momo', 'Steamed, 10 pcs', 220),
  ];

  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  int get _subtotal =>
      _items.fold(0, (sum, item) => sum + item.price * item.qty);
  int get _itemCount => _items.fold(0, (sum, item) => sum + item.qty);
  int get _total => _subtotal + _deliveryFee - _discount;

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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: w * 0.04),
                child: _items.isEmpty
                    ? _buildEmpty(w)
                    : Column(
                        children: [
                          _buildItems(w),
                          SizedBox(height: w * 0.027),
                          _buildPromo(w),
                          SizedBox(height: w * 0.034),
                          _buildSummary(w),
                          SizedBox(height: w * 0.034),
                          _buildCheckout(w),
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
      padding: EdgeInsets.fromLTRB(w * 0.055, w * 0.03, w * 0.044, w * 0.04),
      child: SizedBox(
        height: w * 0.1,
        // Stack so the title stays exactly centered, whatever the pill's width.
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  // Safe pop - prevents the "_history.isNotEmpty" crash
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    // Fallback if stack is empty
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Homepage(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: w * 0.1,
                  height: w * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1F000000), // 12% black
                        blurRadius: w * 0.015,
                        offset: Offset(0, w * 0.004),
                      ),
                    ],
                  ),
                  child: Icon(Icons.chevron_left, color: _kText, size: w * 0.06),
                ),
              ),
            ),
            Text(
              'My cart',
              style: TextStyle(
                color: _kText,
                fontSize: w * 0.047,
                fontWeight: FontWeight.w600,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.032,
                  vertical: w * 0.016,
                ),
                decoration: BoxDecoration(
                  color: _kPill,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  _itemCount == 1 ? '1 item' : '$_itemCount items',
                  style: TextStyle(
                    color: _kBrick,
                    fontSize: w * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Only shown after every item has been deleted (not in the reference).
  Widget _buildEmpty(double w) {
    return Padding(
      padding: EdgeInsets.only(top: w * 0.3),
      child: Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(color: _kGrey, fontSize: w * 0.04),
        ),
      ),
    );
  }

  Widget _buildItems(double w) {
    return Column(
      children: [
        for (int i = 0; i < _items.length; i++) ...[
          if (i > 0) SizedBox(height: w * 0.02),
          _buildCard(w, _items[i]),
        ],
      ],
    );
  }

  Widget _buildCard(double w, _CartItem item) {
    final double imageSize = w * 0.175;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.054),
      padding: EdgeInsets.all(w * 0.024),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.047),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0F000000), // 6% black
            blurRadius: w * 0.02,
            offset: Offset(0, w * 0.006),
          ),
        ],
      ),
      child: SizedBox(
        height: imageSize,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.03),
              child: Image.asset(
                item.image,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: imageSize,
                  height: imageSize,
                  color: const Color(0xFFE6D9BF),
                  child: Icon(Icons.fastfood, color: _kGrey, size: w * 0.07),
                ),
              ),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _kText,
                      fontSize: w * 0.037,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: w * 0.005),
                  Text(
                    item.desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _kGrey,
                      fontSize: w * 0.027,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: w * 0.012),
                    child: Text(
                      _money(item.price),
                      style: TextStyle(
                        color: _kBrick,
                        fontSize: w * 0.036,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _items.remove(item)),
                  child: Padding(
                    padding: EdgeInsets.all(w * 0.008),
                    child: Icon(
                      Icons.delete_outline,
                      color: _kBrick,
                      size: w * 0.04,
                    ),
                  ),
                ),
                _buildStepper(w, item),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(double w, _CartItem item) {
    return Container(
      height: w * 0.068,
      padding: EdgeInsets.all(w * 0.007),
      decoration: BoxDecoration(
        color: _kCapsule,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _kLine, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _roundButton(
            w,
            icon: Icons.remove,
            fill: Colors.white,
            iconColor: _kLabel,
            onTap: item.qty > 1 ? () => setState(() => item.qty--) : null,
          ),
          SizedBox(
            width: w * 0.09,
            child: Center(
              child: Text(
                '${item.qty}',
                style: TextStyle(
                  color: _kText,
                  fontSize: w * 0.032,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          _roundButton(
            w,
            icon: Icons.add,
            fill: _kBrick,
            iconColor: Colors.white,
            onTap: () => setState(() => item.qty++),
          ),
        ],
      ),
    );
  }

  Widget _roundButton(
    double w, {
    required IconData icon,
    required Color fill,
    required Color iconColor,
    required VoidCallback? onTap, // null = disabled, drawn faded
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.45 : 1,
        child: Container(
          width: w * 0.054,
          height: w * 0.054,
          decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
          child: Icon(icon, size: w * 0.03, color: iconColor),
        ),
      ),
    );
  }

  Widget _buildPromo(double w) {
    final double height = w * 0.108;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.054),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(w * 0.04),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_offer_outlined, size: w * 0.04, color: _kGrey),
                  SizedBox(width: w * 0.025),
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      cursorColor: _kBrick,
                      style: TextStyle(fontSize: w * 0.032, color: _kText),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Enter promo code',
                        hintStyle: TextStyle(
                          fontSize: w * 0.032,
                          color: const Color(0xFFA89E94),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: w * 0.027),
          GestureDetector(
            onTap: () {
              // TODO: check _promoController.text and set _discount
            },
            child: Container(
              width: w * 0.203,
              height: height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _kBrick,
                borderRadius: BorderRadius.circular(w * 0.04),
              ),
              child: Text(
                'Apply',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.034,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(double w) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: w * 0.054),
      padding: EdgeInsets.fromLTRB(w * 0.044, w * 0.034, w * 0.044, w * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.047),
      ),
      child: Column(
        children: [
          _summaryRow(w, 'Subtotal', _money(_subtotal)),
          SizedBox(height: w * 0.013),
          _summaryRow(w, 'Delivery fee', _money(_deliveryFee)),
          SizedBox(height: w * 0.013),
          _summaryRow(w, 'Discount', _money(_discount)),
          SizedBox(height: w * 0.02),
          Container(height: 1, color: _kLine),
          SizedBox(height: w * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: _kText,
                  fontSize: w * 0.035,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _money(_total),
                style: TextStyle(
                  color: _kBrick,
                  fontSize: w * 0.035,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(double w, String label, String value) {
    final style = TextStyle(color: _kLabel, fontSize: w * 0.029, height: 1.2);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style.copyWith(color: _kText)),
      ],
    );
  }

  Widget _buildCheckout(double w) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CheckoutPage()));
      },
      child: Container(
        width: double.infinity,
        height: w * 0.122,
        margin: EdgeInsets.symmetric(horizontal: w * 0.054),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _kGreen,
          borderRadius: BorderRadius.circular(w * 0.04),
        ),
        child: Text(
          'Go to checkout  •  ${_money(_total)}',
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.036,
            fontWeight: FontWeight.w500,
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