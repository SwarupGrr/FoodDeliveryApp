import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'homePage.dart';
import 'CartPage.dart';
import 'feedbackSent.dart';
// TODO: change this to the real file name of your MenuLanding page.
import 'menuLanding.dart';

/// ---------------------------------------------------------------------------
/// DESIGN TOKENS (measured from the 287 x 623 reference image)
/// ---------------------------------------------------------------------------
const double _refWidth = 287; // reference screen width
// 623 minus ~27 (status bar) minus ~75 (bottom strip, now the nav bar).
const double _refBodyHeight = 521;

const Color _red = Color(0xFFC9281E);
const Color _peach = Color(0xFFFFF4EF); // page background under the header
const Color _fieldFill = Color(0xFFFFEEE9);
const Color _fieldBorder = Color(0xFFF6D8D1);
const Color _hintPink = Color(0xFFD2A39B);
const Color _starPink = Color(0xFFE8A8A0);
const Color _ink = Color(0xFF2A1A16); // labels and typed text
const Color _mutedText = Color(0xFF8A7F7B);
const Color _footerText = Color(0xFFB8A9A4);
const Color _divider = Color(0xFFF4E4DF);

// Translucent whites written as ARGB hex (alpha first).
const Color _white85 = Color(0xD9FFFFFF); // 85% white
const Color _white12 = Color(0x1FFFFFFF); // 12% white

// Bottom-nav colours, copied from MenuLanding so both pages match.
const Color _navRed = Color(0xFFC8101A);
const Color _navBg = Color(0xFFFFF4E3);
const Color _navSelected = Color(0xFFFFC94D);

/// ---------------------------------------------------------------------------
/// PAGE
/// ---------------------------------------------------------------------------
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;
    final double w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: _peach,
      // The keyboard is allowed to cover the nav bar instead of pushing it up.
      // The page handles the keyboard itself (see the scroll view below).
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Column(
          children: [
            // The reference shows a white status-bar band above the header.
            Container(height: topInset, color: Colors.white),
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) {
                  // One scale factor keeps every size proportional to the
                  // reference, measured on the space left above the nav bar.
                  final double s = math.min(
                    box.maxWidth / _refWidth,
                    box.maxHeight / _refBodyHeight,
                  );
                  final double keyboard = MediaQuery.viewInsetsOf(context).bottom;

                  // Looks identical to the reference. It only scrolls when the
                  // keyboard is open and covers part of the form.
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: keyboard),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: _refWidth * s,
                        height: _refBodyHeight * s,
                        child: _PageContent(s: s),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(w: w, selected: 0), // 0 = Feedback
    );
  }
}

/// Backgrounds + header + floating card + footer, stacked.
class _PageContent extends StatelessWidget {
  const _PageContent({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: header + peach body (103 + 418 = 521).
        Column(
          children: [
            _Header(s: s),
            Container(height: 418 * s, color: _peach),
          ],
        ),

        // Layer 2: small footer text under the card.
        Positioned(
          top: 500.5 * s,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'FAST FOOD TRAIL',
              style: TextStyle(
                fontSize: 6.5 * s,
                letterSpacing: 0.5 * s,
                height: 1.2,
                color: _footerText,
              ),
            ),
          ),
        ),

        // Layer 3: the white card, overlapping the bottom of the header.
        Positioned(
          top: 95 * s,
          left: 14 * s,
          right: 14 * s,
          child: _FeedbackCard(s: s),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// HEADER
/// ---------------------------------------------------------------------------
class _Header extends StatelessWidget {
  const _Header({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94 * s,
      color: _red,
      // Stack clips its children by default, so the circles are cut off at
      // the header edges, as in the reference.
      child: Stack(
        children: [
          Positioned(
            top: -30 * s,
            right: -23 * s,
            child: _Circle(diameter: 96 * s),
          ),
          Positioned(
            top: 65 * s,
            left: -18 * s,
            child: _Circle(diameter: 52 * s),
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: 28 * s),
                Text(
                  'MOMO ON CLOUDS',
                  style: TextStyle(
                    fontSize: 8.5 * s,
                    letterSpacing: 1.2 * s,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: _white85,
                  ),
                ),
                SizedBox(height: 4 * s),
                Text(
                  'Share Your Experience',
                  style: TextStyle(
                    fontSize: 18 * s,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 1 * s),
                Text(
                  'Every bite of feedback counts',
                  style: TextStyle(
                    fontSize: 8.5 * s,
                    height: 1.2,
                    color: _white85,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.diameter});
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(color: _white12, shape: BoxShape.circle),
    );
  }
}

/// ---------------------------------------------------------------------------
/// WHITE CARD
/// ---------------------------------------------------------------------------
class _FeedbackCard extends StatefulWidget {
  const _FeedbackCard({required this.s});
  final double s;

  @override
  State<_FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<_FeedbackCard> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();
  int _rating = 0; // 0 = nothing selected, so all five stars look empty

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final double keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(15 * s, 27 * s, 15 * s, 18 * s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10 * s),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000), // 10% black
            blurRadius: 24 * s,
            offset: Offset(0, 8 * s),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Star rating
          SizedBox(
            height: 30 * s,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final bool filled = i < _rating;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _rating = i + 1),
                  child: SizedBox(
                    width: 34.5 * s,
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 30 * s,
                      color: filled ? _red : _starPink,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 2 * s),
          Text(
            'HOW WOULD YOU RATE US?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8.5 * s,
              letterSpacing: 0.6 * s,
              height: 1.2,
              color: _mutedText,
            ),
          ),
          SizedBox(height: 16 * s),
          Container(height: 1 * s, color: _divider),
          SizedBox(height: 14 * s),

          // Name
          _FieldLabel(s: s, text: 'YOUR NAME'),
          SizedBox(height: 6 * s),
          _InputBox(
            s: s,
            height: 33,
            hint: 'Enter your name',
            controller: _nameController,
            keyboardType: TextInputType.name,
            keyboardInset: keyboard,
          ),
          SizedBox(height: 15 * s),

          // Email
          _FieldLabel(s: s, text: 'EMAIL ADDRESS'),
          SizedBox(height: 6 * s),
          _InputBox(
            s: s,
            height: 33,
            hint: 'name@gmail.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            keyboardInset: keyboard,
          ),
          SizedBox(height: 15 * s),

          // Feedback (tall box)
          _FieldLabel(s: s, text: 'YOUR FEEDBACK'),
          SizedBox(height: 6 * s),
          _InputBox(
            s: s,
            height: 76,
            hint: 'Tell us what you think...',
            controller: _feedbackController,
            keyboardType: TextInputType.multiline,
            keyboardInset: keyboard,
            multiline: true,
          ),
          SizedBox(height: 20 * s),

          _SubmitButton(
            s: s,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackSentPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.s, required this.text});
  final double s;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 8.5 * s,
        letterSpacing: 0.3 * s,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: _ink,
      ),
    );
  }
}

/// Rounded, tinted input used for all three fields.
class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.s,
    required this.height,
    required this.hint,
    required this.controller,
    required this.keyboardType,
    required this.keyboardInset,
    this.multiline = false,
  });

  final double s;
  final double height; // in reference units
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final double keyboardInset; // current keyboard height
  final bool multiline;

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12 * s),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * s,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: multiline ? null : TextInputAction.next,
        expands: true, // fill the SizedBox exactly
        maxLines: null,
        minLines: null,
        // The page is not resized by the keyboard, so tell the field to scroll
        // itself above the keyboard when it gains focus.
        scrollPadding: EdgeInsets.fromLTRB(20, 20, 20, 20 + keyboardInset),
        textAlignVertical:
            multiline ? TextAlignVertical.top : TextAlignVertical.center,
        cursorColor: _red,
        style: TextStyle(fontSize: 10.5 * s, color: _ink),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: _fieldFill,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 10.5 * s, color: _hintPink),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12 * s,
            vertical: multiline ? 11 * s : 0,
          ),
          enabledBorder: _border(_fieldBorder, 1),
          focusedBorder: _border(_red, 1.2),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.s, required this.onTap});
  final double s;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(13 * s);

    return Container(
      height: 35 * s,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: const Color(0x59C9281E), // red at ~35%
            blurRadius: 10 * s,
            offset: Offset(0, 4 * s),
          ),
        ],
      ),
      child: Material(
        color: _red,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Submit Feedback',
                  style: TextStyle(
                    fontSize: 10 * s,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2 * s,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 6 * s),
                Icon(Icons.send_outlined, size: 12 * s, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// BOTTOM NAV (same look and sizes as the one in MenuLanding)
/// ---------------------------------------------------------------------------
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.w, required this.selected});

  final double w; // screen width; the nav sizes itself from it
  final int selected; // index of the highlighted tab

  static const List<_NavItem> _items = [
    _NavItem(Icons.star_border, 'Feedback'),
    _NavItem(Icons.grid_view_rounded, 'Menu'),
    _NavItem(Icons.home, 'Home'),
    _NavItem(Icons.shopping_cart_outlined, 'Cart'),
  ];

  void _go(BuildContext context, int i) {
    if (i == selected) return;

    final Widget page;
    if (i == 0) {
      page = const FeedbackPage();
    } else if (i == 1) {
      page = const MenuLanding();
    } else if (i == 2) {
      page = const Homepage();
    } else {
      page = const Cartpage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _navBg,
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
            color: _navRed,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final bool isSelected = i == selected;
              final Color color = isSelected ? _navSelected : Colors.white;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _go(context, i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_items[i].icon, color: color, size: w * 0.06),
                      SizedBox(height: w * 0.004),
                      Text(
                        _items[i].label,
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