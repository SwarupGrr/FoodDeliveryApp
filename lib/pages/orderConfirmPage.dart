import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'homePage.dart';

/// ---------------------------------------------------------------------------
/// DESIGN TOKENS (measured from the 327 x 676 reference image)
/// ---------------------------------------------------------------------------
const double _refWidth = 327;
const double _refHeight = 676;

const Color _bg = Color(0xFFFFF1DE); // cream behind the food pattern
const Color _red = Color(0xFFC8101A); // same red as the menu pages
const Color _glowEdge = Color(0xFFF3A6A6); // pink at the card's outer edge
const Color _glowShadow = Color(0x40E57373); // soft pink shadow around the card
const Color _halo = Color(0xFFD3F5E0); // light green ring behind the tick
const Color _titleGreen = Color(0xFF4C9F5A);
const Color _ink = Color(0xFF1A1A1A);

// Confetti colours around the icon
const Color _confettiPink = Color(0xFFF8C9D4);
const Color _confettiGreen = Color(0xFFBFEBCF);
const Color _confettiYellow = Color(0xFFFBE3A8);
const Color _confettiBlue = Color(0xFFC9E0F5);

/// ---------------------------------------------------------------------------
/// PAGE
/// ---------------------------------------------------------------------------
class orderConfirm extends StatelessWidget {
  const orderConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        // No SafeArea on purpose: the pattern runs behind the status bar
        // in the reference.
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ASSET: line-art food pattern (burgers, donuts, fries).
            // If the file is missing you just see the plain cream background.
            Image.asset(
              'assets/images/food_pattern.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            LayoutBuilder(
              builder: (context, box) {
                // One scale factor keeps every size proportional to the
                // reference.
                final double s = math.min(
                  box.maxWidth / _refWidth,
                  box.maxHeight / _refHeight,
                );
                return Align(
                  // 0.4845 = card centre (327.5) / page height (676), so the
                  // card sits where it does in the reference.
                  alignment: const Alignment(0, 2 * 0.4845 - 1),
                  child: _GlowCard(s: s),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CARD: white centre fading into pink at the edges
/// ---------------------------------------------------------------------------
class _GlowCard extends StatelessWidget {
  const _GlowCard({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) {
    final double radius = 72 * s;
    const double edge = 12; // reference units of solid pink before the fade

    return Container(
      width: 277 * s,
      height: 535 * s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(color: _glowShadow, blurRadius: 18 * s),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Flutter has no "inner shadow", so a pink slab is covered with a
            // blurred white slab. The blur makes the pink fade in at the edges.
            const ColoredBox(color: _glowEdge),
            Padding(
              padding: EdgeInsets.all(edge * s),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 8 * s, sigmaY: 8 * s),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radius - edge * s),
                  ),
                ),
              ),
            ),
            _CardContent(s: s),
          ],
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 105 * s),

        // Success icon (drawn with a painter, no image needed)
        Semantics(
          label: 'Success',
          child: CustomPaint(
            size: Size(160 * s, 130 * s),
            painter: _SuccessIconPainter(s),
          ),
        ),

        SizedBox(height: 51 * s),
        Text(
          'Your Order is Confirmed !',
          style: TextStyle(
            fontSize: 19 * s,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: _titleGreen,
          ),
        ),
        SizedBox(height: 15 * s),
        Text(
          'Your order is being packed and will arrive soon.\nFruits and Veggies coming right up!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11 * s,
            height: 1.3,
            color: _ink,
          ),
        ),

        const Spacer(),
        _HomeButton(s: s),
        SizedBox(height: 47 * s),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// BUTTON
/// ---------------------------------------------------------------------------
class _HomeButton extends StatelessWidget {
  const _HomeButton({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10 * s);

    return Container(
      width: 153 * s,
      height: 41 * s,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000), // 20% black
            blurRadius: 4 * s,
            offset: Offset(0, 2 * s),
          ),
        ],
      ),
      child: Material(
        color: _red,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: () {
            // Clear the whole stack so Back from Home does not return here.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
              (route) => false,
            );
          },
          child: Center(
            child: Text(
              'Back to Home',
              style: TextStyle(
                fontSize: 13 * s,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// SUCCESS ICON: green ring, red disc, white tick, pastel confetti
/// Everything is measured in reference units from the centre of the icon.
/// ---------------------------------------------------------------------------
class _SuccessIconPainter extends CustomPainter {
  _SuccessIconPainter(this.s);
  final double s;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = size.center(Offset.zero);
    Offset p(double x, double y) => c + Offset(x * s, y * s);

    // Ring + disc
    canvas.drawCircle(c, 47 * s, Paint()..color = _halo);
    canvas.drawCircle(c, 36 * s, Paint()..color = _red);

    // Tick
    final Path tick = Path()
      ..moveTo(p(-14, 1).dx, p(-14, 1).dy)
      ..lineTo(p(-4, 11).dx, p(-4, 11).dy)
      ..lineTo(p(15, -11).dx, p(15, -11).dy);
    canvas.drawPath(
      tick,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Confetti
    void dot(double x, double y, double r, Color color) {
      canvas.drawCircle(p(x, y), r * s, Paint()..color = color);
    }

    void arc(double x, double y, double r, double start, double sweep,
        Color color) {
      canvas.drawArc(
        Rect.fromCircle(center: p(x, y), radius: r * s),
        start,
        sweep,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * s
          ..strokeCap = StrokeCap.round,
      );
    }

    void dash(double x1, double y1, double x2, double y2, Color color) {
      canvas.drawLine(
        p(x1, y1),
        p(x2, y2),
        Paint()
          ..color = color
          ..strokeWidth = 2.5 * s
          ..strokeCap = StrokeCap.round,
      );
    }

    dot(-43, -25, 3.5, _confettiBlue);
    dot(-41, 40, 3.5, _confettiYellow);
    dot(62, -10, 3, _confettiYellow);
    dot(49, 57, 3, _confettiPink);
    dot(-58, -2, 2.5, _confettiPink);
    arc(54, -40, 6, math.pi, math.pi * 1.2, _confettiPink);
    arc(66, 35, 7, -math.pi / 2, math.pi * 1.2, _confettiBlue);
    arc(-13, 53, 7, 0, math.pi * 1.2, _confettiGreen);
    dash(-70, 12, -62, 15, _confettiBlue);
    dash(-3, -56, 1, -50, _confettiGreen);
    dash(40, 48, 44, 56, _confettiPink);
  }

  @override
  bool shouldRepaint(_SuccessIconPainter old) => old.s != s;
}