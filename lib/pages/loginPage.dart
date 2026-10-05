import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'registerPage.dart';

/// ---------------------------------------------------------------------------
/// DESIGN TOKENS (measured from the 293 x 638 reference image)
/// ---------------------------------------------------------------------------
const double _refWidth = 293; // reference screen width
const double _refContentHeight = 606; // 638 minus ~32 for the status bar

const Color _cream = Color(0xFFFFF1DC);
const Color _red = Color(0xFFC30B0B);
const Color _hintGrey = Color(0xFF8E8E8E);

const String _titleFont = 'DM Serif Display'; // see pubspec.yaml

/// ---------------------------------------------------------------------------
/// PAGE
/// ---------------------------------------------------------------------------
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          bottom: false, // red panel runs to the bottom edge of the screen
          child: LayoutBuilder(
            builder: (context, box) {
              // One scale factor keeps every size proportional to the reference.
              final double rawscale = math.min(
                box.maxWidth / _refWidth,
                box.maxHeight / _refContentHeight,
              );

              final double s = rawscale.clamp(0.8, 1.5);

              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: _refWidth * s,
                  height: box.maxHeight,
                  child: Column(
                    children: [
                      SizedBox(height: 25 * s),
                      _LogoTile(s: s),
                      SizedBox(height: 19 * s),
                      _Title(s: s),
                      SizedBox(height: 12 * s),
                      Expanded(
                        child: _LoginPanel(s: s),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// TOP SECTION
/// ---------------------------------------------------------------------------
class _LogoTile extends StatelessWidget {
  const _LogoTile({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 137 * s,
      height: 129 * s,
      padding: EdgeInsets.all(8 * s),
      decoration: BoxDecoration(
        color: _red,
        borderRadius: BorderRadius.circular(32 * s),
      ),
      // ASSET #1: chef momo mascot (transparent PNG)
      child: Image.asset(
        'assets/images/momo_logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) {
    return Text(
      'momo on\nclouds',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: _titleFont,
        fontFamilyFallback: const ['serif'],
        fontSize: 25 * s,
        height: 1.03,
        fontWeight: FontWeight.w700,
        color: _red,
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// RED PANEL
/// ---------------------------------------------------------------------------
/// The red panel is a rounded rectangle that runs to the bottom of the screen. It contains the login form and buttons.
class _LoginPanel extends StatefulWidget {
  const _LoginPanel({required this.s});
  final double s;

  @override
  State<_LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<_LoginPanel> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;

    final labelStyle = TextStyle(
      color: Colors.white.withOpacity(0.92),
      fontSize: 8 * s,
      fontWeight: FontWeight.w500,
      height: 1.25,
    );

    final smallBold = TextStyle(
      color: Colors.white,
      fontSize: 8 * s,
      fontWeight: FontWeight.w700,
      height: 1.25,
    );

    return Container(
      decoration: BoxDecoration(
        color: _red,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(55 * s),
        ),
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30 * s),

            // Tagline + plate image
            Padding(
              padding: EdgeInsets.only(left: 19 * s, right: 7 * s),
              child: Row(
                children: [
                  Text(
                    'Hot and Fresh,\nDelivered',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15 * s,
                      fontWeight: FontWeight.w700,
                      height: 1.6,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 100 * s,
                    height: 87 * s,
                    // ASSET #2: momo on plate with chopsticks (transparent PNG)
                    child: const _AssetOrPlaceholder(
                      path: 'assets/images/momo_plate.png',
                      placeholderIcon: Icons.dinner_dining,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15 * s),

            // Form
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35 * s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter your email', style: labelStyle),
                  SizedBox(height: 1 * s),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3 * s),
                    child: _PillField(
                      s: s,
                      height: 25,
                      hint: 'name@gmail.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 4 * s),
                  Text('Enter your password', style: labelStyle),
                  SizedBox(height: 2 * s),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3 * s),
                    child: _PillField(
                      s: s,
                      height: 24,
                      hint: 'name12343##00',
                      controller: _passwordController,
                      obscureText: _obscure,
                      trailing: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: Icon(
                          Icons.visibility_outlined,
                          size: 14 * s,
                          color: _hintGrey,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 19 * s),
                      child: GestureDetector(
                        onTap: () {
                          // TODO: forgot-password flow
                        },
                        child: Text('Forget password', style: smallBold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 13 * s),

            // Log in button
            Center(
              child: SizedBox(
                width: 99 * s,
                height: 24 * s,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: authentication
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cream,
                    foregroundColor: _red,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * s),
                    ),
                    textStyle: TextStyle(
                      fontSize: 8 * s,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Log in'),
                ),
              ),
            ),

            SizedBox(height: 12 * s),

            // Sign-up prompt
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: Text(
                  'Dont have account\nsign up',
                  textAlign: TextAlign.center,
                  style: smallBold.copyWith(height: 1.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White, fully rounded input with a centered hint (as in the reference).
class _PillField extends StatelessWidget {
  const _PillField({
    required this.s,
    required this.height,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.trailing,
  });

  final double s;
  final double height;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular((height / 2) * s),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: _red,
            style: TextStyle(
              fontSize: 9 * s,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 9 * s,
                color: _hintGrey,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 26 * s,
              ),
            ),
          ),
          if (trailing != null)
            Positioned(
              right: 15 * s,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

/// Loads a bundled asset; shows a placeholder icon if it is missing so the
/// page still runs before the real artwork is added.
class _AssetOrPlaceholder extends StatelessWidget {
  const _AssetOrPlaceholder({
    required this.path,
    required this.placeholderIcon,
  });

  final String path;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => FittedBox(
        child: Icon(
          placeholderIcon,
          color: _cream,
        ),
      ),
    );
  }
}