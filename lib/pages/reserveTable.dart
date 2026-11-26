import 'dart:math' as math;
import 'reserveConfirm.dart';
import 'HomePage.dart';

import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// DESIGN TOKENS (measured from the 302 x 772 reference image)
/// ---------------------------------------------------------------------------
const double _refWidth = 302;
const double _refBodyHeight = 738; // 772 minus ~28 for the status bar, minus ~6

// true  = the whole page is scaled to fit the screen, like the reference.
// false = scale by screen width only; the page scrolls (fills the width).
const bool _fitToHeight = true;

const Color _bg = Color(0xFFFFF4E3);
const Color _red = Color(0xFFC8102E);
const Color _ink = Color(0xFF2A2118);
const Color _grey = Color(0xFF9A8F84);
const Color _hint = Color(0xFFBDB3A6);
const Color _line = Color(0xFFEBDDC8); // thin outlines on white shapes
const Color _beige = Color(0xFFE9D8C0); // minus button
const Color _beigeIcon = Color(0xFF8A6D4B);
const Color _summaryFill = Color(0xFFF0E2CB);
const Color _summaryLine = Color(0xFFE5D3B5);
const Color _summaryLabel = Color(0xFF8F8272);
const Color _disabledFill = Color(0xFFF1E6D4);
const Color _disabledText = Color(0xFFBDB3A5);

// Script font for the title (see pubspec.yaml).
const String _titleFont = 'KaushanScript';

/// ---------------------------------------------------------------------------
/// DATA
/// ---------------------------------------------------------------------------
const List<String> _weekdays = [
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', //
];
const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

// First day of the date strip. The reference shows Mon 5 Oct 2026.
// In the real app, use DateTime.now() so the strip shows upcoming days.
final DateTime _firstDay = DateTime(2026, 10, 5);
final List<DateTime> _days = List.generate(
  7,
  (i) => DateTime(_firstDay.year, _firstDay.month, _firstDay.day + i),
);

const List<String> _times = [
  '6:00 PM', '6:30 PM', '7:00 PM', //
  '7:30 PM', '8:00 PM', '8:30 PM',
];
// Indexes of fully booked slots (8:00 PM in the reference).
const Set<int> _unavailable = {4};

const List<String> _seatings = ['Any', 'Indoor', 'Outdoor'];

const int _maxGuests = 8;

/// ---------------------------------------------------------------------------
/// PAGE
/// ---------------------------------------------------------------------------
class ReservePage extends StatefulWidget {
  const ReservePage({super.key});

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  // Defaults match the reference: Sat 10, 7:00 PM, 2 guests, Indoor.
  int _day = 5;
  int _time = 2;
  int _guests = 2;
  int _seating = 1;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String get _summaryTitle {
    final d = _days[_day];
    return '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]}'
        ' · ${_times[_time]}';
  }

  String get _summaryDetail {
    final guests = _guests == 1 ? '1 guest' : '$_guests guests';
    final seating = _seating == 0 ? 'Any seating' : _seatings[_seating];
    return '$guests · $seating · Momo on Clouds, Talchowk';
  }

  @override
  Widget build(BuildContext context) {
    // sizeOf / paddingOf do not change when the keyboard opens, so the scale
    // stays stable while the user types.
    final Size screen = MediaQuery.sizeOf(context);
    final EdgeInsets inset = MediaQuery.paddingOf(context);
    final double widthScale = screen.width / _refWidth;
    final double heightScale =
        (screen.height - inset.top - inset.bottom) / _refBodyHeight;
    final double s =
        _fitToHeight ? math.min(widthScale, heightScale) : widthScale;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        // Looks identical to the reference. It only scrolls when the keyboard
        // opens, or when _fitToHeight is false.
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: _refWidth * s,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15 * s, 22 * s, 15 * s, 20 * s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(s: s),
                    SizedBox(height: 14.5 * s),
                    Text(
                      'Dining with us? Pick a date, time and party size.',
                      style: TextStyle(
                        fontSize: 10 * s,
                        height: 1.2,
                        color: _grey,
                      ),
                    ),
                    SizedBox(height: 18 * s),

                    // Date
                    _SectionLabel(s: s, text: 'Date'),
                    SizedBox(height: 9.5 * s),
                    SizedBox(
                      height: 47 * s,
                      child: Row(
                        children: [
                          for (int i = 0; i < _days.length; i++) ...[
                            if (i > 0) SizedBox(width: 6 * s),
                            Expanded(
                              child: _DayChip(
                                s: s,
                                weekday: _weekdays[_days[i].weekday - 1],
                                day: _days[i].day,
                                selected: i == _day,
                                onTap: () => setState(() => _day = i),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16.5 * s),

                    // Time
                    _SectionLabel(s: s, text: 'Time'),
                    SizedBox(height: 8 * s),
                    Text(
                      'Dinner',
                      style: TextStyle(
                        fontSize: 8.5 * s,
                        height: 1.2,
                        color: _grey,
                      ),
                    ),
                    SizedBox(height: 10.3 * s),
                    _timeRow(s, 0),
                    SizedBox(height: 9 * s),
                    _timeRow(s, 3),
                    SizedBox(height: 18 * s),

                    // Guests
                    _GuestsCard(
                      s: s,
                      guests: _guests,
                      onMinus: _guests > 1
                          ? () => setState(() => _guests--)
                          : null,
                      onPlus: _guests < _maxGuests
                          ? () => setState(() => _guests++)
                          : null,
                    ),
                    SizedBox(height: 16.5 * s),

                    // Seating
                    _SectionLabel(s: s, text: 'Seating'),
                    SizedBox(height: 8.5 * s),
                    SizedBox(
                      height: 31 * s,
                      child: Row(
                        children: [
                          for (int i = 0; i < _seatings.length; i++) ...[
                            if (i > 0) SizedBox(width: 8 * s),
                            Expanded(
                              child: _Choice(
                                s: s,
                                label: _seatings[i],
                                selected: i == _seating,
                                radius: 16,
                                fontSize: 10,
                                onTap: () => setState(() => _seating = i),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16.5 * s),

                    // Special request
                    _SectionLabel(s: s, text: 'Special request'),
                    SizedBox(height: 8.5 * s),
                    _NotesField(s: s, controller: _notesController),
                    SizedBox(height: 18 * s),

                    // Live summary
                    _SummaryCard(
                      s: s,
                      title: _summaryTitle,
                      detail: _summaryDetail,
                    ),
                    SizedBox(height: 17 * s),

                    // Confirm
                    _ConfirmButton(
                      s: s,
                      onTap: () {
                        // TODO: send _days[_day], _times[_time], _guests,
                        // _seatings[_seating] and the notes to your backend.
                      },
                    ),
                    SizedBox(height: 17.7 * s),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Free cancellation up to 2 hours before your booking.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8 * s,
                          height: 1.3,
                          color: _grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeRow(double s, int start) {
    return SizedBox(
      height: 32 * s,
      child: Row(
        children: [
          for (int i = start; i < start + 3; i++) ...[
            if (i > start) SizedBox(width: 8 * s),
            Expanded(
              child: _Choice(
                s: s,
                label: _times[i],
                selected: i == _time,
                enabled: !_unavailable.contains(i),
                radius: 10,
                fontSize: 10.5,
                onTap: () => setState(() => _time = i),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// HEADER: back button + script title
/// ---------------------------------------------------------------------------
class _Header extends StatelessWidget {
  const _Header({required this.s});
  final double s;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32 * s,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => const Homepage()))),
            child: Container(
              width: 32 * s,
              height: 32 * s,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1F000000), // 12% black
                    blurRadius: 5 * s,
                    offset: Offset(0, 2 * s),
                  ),
                ],
              ),
              child: Icon(Icons.chevron_left, size: 18 * s, color: _ink),
            ),
          ),
          SizedBox(width: 12 * s),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'reserve a table',
                maxLines: 1,
                style: TextStyle(
                  fontFamily: _titleFont,
                  fontFamilyFallback: const ['cursive'],
                  fontSize: 21 * s,
                  height: 1.0, // script fonts have tall line boxes
                  fontWeight: FontWeight.w700,
                  color: _red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.s, required this.text});
  final double s;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.5 * s,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: _ink,
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// DATE CHIP
/// ---------------------------------------------------------------------------
class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.s,
    required this.weekday,
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final double s;
  final String weekday;
  final int day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? _red : Colors.white,
          borderRadius: BorderRadius.circular(12 * s),
          border: Border.all(color: selected ? _red : _line, width: 1),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0x4DC8102E), // red at ~30%
                    blurRadius: 6 * s,
                    offset: Offset(0, 3 * s),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekday,
              style: TextStyle(
                fontSize: 8 * s,
                height: 1.2,
                color: selected ? const Color(0xE6FFFFFF) : _grey,
              ),
            ),
            SizedBox(height: 2 * s),
            Text(
              '$day',
              style: TextStyle(
                fontSize: 14 * s,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: selected ? Colors.white : _ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CHOICE: used for the time slots and the seating pills
/// ---------------------------------------------------------------------------
class _Choice extends StatelessWidget {
  const _Choice({
    required this.s,
    required this.label,
    required this.selected,
    required this.radius,
    required this.fontSize,
    required this.onTap,
    this.enabled = true,
  });

  final double s;
  final String label;
  final bool selected;
  final bool enabled; // false = fully booked (greyed out, struck through)
  final double radius;
  final double fontSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color fill =
        !enabled ? _disabledFill : (selected ? _red : Colors.white);
    final Color border =
        !enabled ? _line : (selected ? _red : _line);
    final Color text =
        !enabled ? _disabledText : (selected ? Colors.white : _ink);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(radius * s),
          border: Border.all(color: border, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize * s,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            decoration: enabled ? null : TextDecoration.lineThrough,
            decorationColor: _disabledText,
            color: text,
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// GUESTS CARD
/// ---------------------------------------------------------------------------
class _GuestsCard extends StatelessWidget {
  const _GuestsCard({
    required this.s,
    required this.guests,
    required this.onMinus,
    required this.onPlus,
  });

  final double s;
  final int guests;
  final VoidCallback? onMinus; // null = disabled
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51 * s,
      padding: EdgeInsets.fromLTRB(13 * s, 0, 15 * s, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * s),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000), // 8% black
            blurRadius: 8 * s,
            offset: Offset(0, 3 * s),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guests',
                  style: TextStyle(
                    fontSize: 11 * s,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: _ink,
                  ),
                ),
                SizedBox(height: 3 * s),
                Text(
                  'Tables seat up to $_maxGuests',
                  style: TextStyle(fontSize: 8 * s, height: 1.2, color: _grey),
                ),
              ],
            ),
          ),
          _RoundButton(
            s: s,
            icon: Icons.remove,
            fill: _beige,
            iconColor: _beigeIcon,
            onTap: onMinus,
          ),
          SizedBox(
            width: 31 * s,
            child: Center(
              child: Text(
                '$guests',
                style: TextStyle(
                  fontSize: 14 * s,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
            ),
          ),
          _RoundButton(
            s: s,
            icon: Icons.add,
            fill: _red,
            iconColor: Colors.white,
            onTap: onPlus,
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.s,
    required this.icon,
    required this.fill,
    required this.iconColor,
    required this.onTap,
  });

  final double s;
  final IconData icon;
  final Color fill;
  final Color iconColor;
  final VoidCallback? onTap; // null = disabled, drawn faded

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1,
        child: Container(
          width: 26 * s,
          height: 26 * s,
          decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
          child: Icon(icon, size: 13 * s, color: iconColor),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// SPECIAL REQUEST FIELD
/// ---------------------------------------------------------------------------
class _NotesField extends StatelessWidget {
  const _NotesField({required this.s, required this.controller});
  final double s;
  final TextEditingController controller;

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12 * s),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 57 * s,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        expands: true, // fill the SizedBox exactly
        maxLines: null,
        minLines: null,
        textAlignVertical: TextAlignVertical.top,
        cursorColor: _red,
        style: TextStyle(fontSize: 9.5 * s, color: _ink),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintText: 'Birthday, high chair, window view...',
          hintStyle: TextStyle(fontSize: 9.5 * s, color: _hint),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12 * s, vertical: 12 * s),
          enabledBorder: _border(_line),
          focusedBorder: _border(_red),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// SUMMARY CARD (updates as the choices change)
/// ---------------------------------------------------------------------------
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.s,
    required this.title,
    required this.detail,
  });

  final double s;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 74 * s,
      padding: EdgeInsets.fromLTRB(13 * s, 12 * s, 13 * s, 0),
      decoration: BoxDecoration(
        color: _summaryFill,
        borderRadius: BorderRadius.circular(14 * s),
        border: Border.all(color: _summaryLine, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR RESERVATION',
            style: TextStyle(
              fontSize: 7.5 * s,
              letterSpacing: 0.8 * s,
              height: 1.2,
              color: _summaryLabel,
            ),
          ),
          SizedBox(height: 4 * s),
          Text(
            title,
            style: TextStyle(
              fontSize: 15 * s,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: _red,
            ),
          ),
          SizedBox(height: 5.5 * s),
          // Shrinks slightly instead of overflowing with wider fonts.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              detail,
              maxLines: 1,
              style: TextStyle(
                fontSize: 9.5 * s,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: _ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CONFIRM BUTTON
/// ---------------------------------------------------------------------------
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.s, required this.onTap});
  final double s;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20.5 * s);

    return Container(
      width: double.infinity,
      height: 41 * s,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: const Color(0x4DC8102E), // red at ~30%
            blurRadius: 10 * s,
            offset: Offset(0, 5 * s),
          ),
        ],
      ),
      child: Material(
        color: _red,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: () { Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const reserveConfirm()));
          },
          child: Center(
            child: Text(
              'Confirm Reservation',
              style: TextStyle(
                fontSize: 12 * s,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}