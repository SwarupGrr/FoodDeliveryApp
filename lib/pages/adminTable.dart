import 'package:flutter/material.dart';

import 'adminDashboard.dart';
import 'adminOrder.dart';

const Color _kBg = Color(0xFFFAF3E8);
const Color _kRed = Color(0xFFC8101A);

void main() {
  runApp(const AdminTable());
}

class AdminTable extends StatelessWidget {
  const AdminTable({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tables Management',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _kBg,
        fontFamily: 'Inter',
      ),
      home: const TablesPage(),
    );
  }
}

enum TableStatus { free, occupied, reserved }

class RestaurantTable {
  final String name;
  final int seats;
  TableStatus status;
  String? guestName;
  String? subtitle;
  String? amount;
  String? duration;

  RestaurantTable({
    required this.name,
    required this.seats,
    required this.status,
    this.guestName,
    this.subtitle,
    this.amount,
    this.duration,
  });

  int get tableNumber =>
      int.tryParse(name.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
}

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  int _selectedFilterIndex = 0;
  static const int _selectedNav = 2; // "Tables" active

  final List<String> _filters = const [
    'All',
    'Free',
    'Occupied',
    'Reserved',
    'Ground floor',
    'Rooftop',
  ];

  final List<RestaurantTable> _tables = [
    RestaurantTable(
      name: 'Table 1',
      seats: 2,
      status: TableStatus.free,
    ),
    RestaurantTable(
      name: 'Table 2',
      seats: 4,
      status: TableStatus.occupied,
      guestName: 'Anisha Rai',
      subtitle: 'Seated 1:48 PM',
      amount: 'Rs 940',
      duration: '27 min',
    ),
    RestaurantTable(
      name: 'Table 3',
      seats: 4,
      status: TableStatus.free,
    ),
    RestaurantTable(
      name: 'Table 4',
      seats: 6,
      status: TableStatus.reserved,
      guestName: 'Rohan Shakya',
      subtitle: 'Reserved 7:30 PM, 3 guests',
    ),
    RestaurantTable(
      name: 'Table 5',
      seats: 4,
      status: TableStatus.occupied,
      guestName: 'Sanjana Gurung',
      subtitle: 'Seated 2:05 PM',
      amount: 'Rs 720',
      duration: '10 min',
    ),
    RestaurantTable(
      name: 'Table 6',
      seats: 2,
      status: TableStatus.free,
    ),
    RestaurantTable(
      name: 'Table 7',
      seats: 6,
      status: TableStatus.occupied,
      guestName: 'Aayush Lama',
      subtitle: 'Seated 1:55 PM',
      amount: 'Rs 1,280',
      duration: '20 min',
    ),
    RestaurantTable(
      name: 'Table 9',
      seats: 4,
      status: TableStatus.reserved,
      guestName: 'Maya Karki',
      subtitle: 'Reserved 8:00 PM, 4 guests',
    ),
  ];

  List<RestaurantTable> get _filteredTables {
    switch (_selectedFilterIndex) {
      case 1:
        return _tables.where((t) => t.status == TableStatus.free).toList();
      case 2:
        return _tables.where((t) => t.status == TableStatus.occupied).toList();
      case 3:
        return _tables.where((t) => t.status == TableStatus.reserved).toList();
      default:
        return _tables;
    }
  }

  int get _freeCount =>
      _tables.where((t) => t.status == TableStatus.free).length;
  int get _occupiedCount =>
      _tables.where((t) => t.status == TableStatus.occupied).length;
  int get _reservedCount =>
      _tables.where((t) => t.status == TableStatus.reserved).length;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _TopAppBar(),
                    const SizedBox(height: 16),
                    _SummaryStatsRow(
                      freeCount: _freeCount,
                      occupiedCount: _occupiedCount,
                      reservedCount: _reservedCount,
                    ),
                    const SizedBox(height: 14),
                    _FilterChipsRow(
                      filters: _filters,
                      selectedIndex: _selectedFilterIndex,
                      onSelected: (index) {
                        setState(() => _selectedFilterIndex = index);
                      },
                    ),
                    const SizedBox(height: 16),
                    const _SectionHeaderWithLegend(),
                    const SizedBox(height: 12),
                    _TablesGrid(
                      tables: _filteredTables,
                      onSeatGuests: (table) {
                        _showSeatGuestsSheet(
                          context,
                          tableNumber: table.tableNumber,
                          maxSeats: table.seats,
                          onConfirm: (guests, guestName, phone) {
                            setState(() {
                              table.status = TableStatus.occupied;
                              table.guestName = guestName.isEmpty
                                  ? 'Walk-in ($guests guests)'
                                  : guestName;
                              table.subtitle =
                                  'Seated just now • $guests guests';
                              table.amount = 'Rs 0';
                              table.duration = '0 min';
                            });
                          },
                        );
                      },
                    ),
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

  // ---------------------------------------------------------------------------
  // BOTTOM NAV BAR
  // ---------------------------------------------------------------------------
  Widget _buildBottomNav(double w) {
    const items = [
      [Icons.grid_view_rounded, 'Dashboard'],
      [Icons.receipt_long_outlined, 'Orders'],
      [Icons.table_restaurant, 'Tables'],
      [Icons.menu_book_outlined, 'Menu'],
      [Icons.settings_outlined, 'Settings'],
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
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.025,
            vertical: w * 0.012,
          ),
          decoration: BoxDecoration(
            color: _kRed,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final bool selected = i == _selectedNav;
              final Color color =
                  selected ? const Color(0xFFFFC94D) : Colors.white;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (i == _selectedNav) return;

                    if (i == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminDashboardPage(),
                        ),
                      );
                    }
                    else if (i == 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersPage(),
                        ),
                      );
                    }
                    else if (i == 2) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TablesPage(),
                        ),
                      );
                    }
                    // else if (i == 3) {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const MenuPage(),
                    //     ),
                    //   );
                    // }
                    // else if (i == 4) {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const SettingsPage(),
                    //     ),
                    //   );
                    // }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: w * 0.012),
                    decoration: selected
                        ? BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(w * 0.035),
                          )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          items[i][0] as IconData,
                          color: color,
                          size: w * 0.055,
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
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SEAT GUESTS BOTTOM SHEET MODAL
// -----------------------------------------------------------------------------
void _showSeatGuestsSheet(
  BuildContext context, {
  required int tableNumber,
  int maxSeats = 8,
  void Function(int guests, String guestName, String phone)? onConfirm,
}) {
  int guestCount = maxSeats >= 2 ? 2 : 1;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final double w = MediaQuery.sizeOf(sheetContext).width;
      final double bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;

      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: EdgeInsets.fromLTRB(
              w * 0.055,
              w * 0.03,
              w * 0.055,
              w * 0.055 + bottomInset,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E3),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(w * 0.07),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: w * 0.11,
                      height: w * 0.011,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5C8B6),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  SizedBox(height: w * 0.045),
                  Text(
                    'Seat guests at Table $tableNumber',
                    style: TextStyle(
                      color: const Color(0xFF8E1B20),
                      fontSize: w * 0.048,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    'Create a dine-in order when guests are seated.',
                    style: TextStyle(
                      color: const Color(0xFF8A8480),
                      fontSize: w * 0.029,
                    ),
                  ),
                  SizedBox(height: w * 0.04),
                  Text(
                    'Number of guests',
                    style: TextStyle(
                      color: const Color(0xFF5E534B),
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: w * 0.018),
                  Container(
                    height: w * 0.125,
                    padding: EdgeInsets.symmetric(horizontal: w * 0.045),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(w * 0.035),
                      border: Border.all(
                        color: const Color(0xFFEBE0CE),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: guestCount > 1
                              ? () => setSheetState(() => guestCount--)
                              : null,
                          child: Padding(
                            padding: EdgeInsets.all(w * 0.02),
                            child: Icon(
                              Icons.remove,
                              color: guestCount > 1
                                  ? const Color(0xFFC8101A)
                                  : const Color(0xFFD0C7BC),
                              size: w * 0.05,
                            ),
                          ),
                        ),
                        Text(
                          '$guestCount',
                          style: TextStyle(
                            color: const Color(0xFF1F1F1F),
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: guestCount < maxSeats
                              ? () => setSheetState(() => guestCount++)
                              : null,
                          child: Padding(
                            padding: EdgeInsets.all(w * 0.02),
                            child: Icon(
                              Icons.add,
                              color: guestCount < maxSeats
                                  ? const Color(0xFFC8101A)
                                  : const Color(0xFFD0C7BC),
                              size: w * 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: w * 0.035),
                  Text(
                    'Guest name',
                    style: TextStyle(
                      color: const Color(0xFF5E534B),
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: w * 0.015),
                  _sheetTextField(
                    w,
                    controller: nameController,
                    hint: 'Optional',
                  ),
                  SizedBox(height: w * 0.032),
                  Text(
                    'Phone',
                    style: TextStyle(
                      color: const Color(0xFF5E534B),
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: w * 0.015),
                  _sheetTextField(
                    w,
                    controller: phoneController,
                    hint: 'Optional',
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: w * 0.045),
                  GestureDetector(
                    onTap: () {
                      final name = nameController.text.trim();
                      final phone = phoneController.text.trim();
                      Navigator.pop(sheetContext);
                      onConfirm?.call(guestCount, name, phone);
                    },
                    child: Container(
                      width: double.infinity,
                      height: w * 0.125,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8101A),
                        borderRadius: BorderRadius.circular(w * 0.035),
                      ),
                      child: Text(
                        'Confirm and Start Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.036,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: w * 0.025),
                  GestureDetector(
                    onTap: () => Navigator.pop(sheetContext),
                    child: Container(
                      width: double.infinity,
                      height: w * 0.12,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7E2DC),
                        borderRadius: BorderRadius.circular(w * 0.035),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: const Color(0xFF5E534B),
                          fontSize: w * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _sheetTextField(
  double w, {
  required TextEditingController controller,
  required String hint,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Container(
    height: w * 0.12,
    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(w * 0.035),
      border: Border.all(color: const Color(0xFFEBE0CE), width: 1),
    ),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: const Color(0xFFC8101A),
      style: TextStyle(
        color: const Color(0xFF1F1F1F),
        fontSize: w * 0.033,
      ),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFFA89E94),
          fontSize: w * 0.033,
        ),
      ),
    ),
  );
}

// -----------------------------------------------------------------------------
// TOP BAR & SUMMARY STATS
// -----------------------------------------------------------------------------
class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tables',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Color(0xFF9C2B2B),
            letterSpacing: -0.3,
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFC41230),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC41230).withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white, size: 17),
              SizedBox(width: 4),
              Text(
                'Add Table',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryStatsRow extends StatelessWidget {
  final int freeCount;
  final int occupiedCount;
  final int reservedCount;

  const _SummaryStatsRow({
    required this.freeCount,
    required this.occupiedCount,
    required this.reservedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: '$freeCount',
            label: 'Free',
            countColor: const Color(0xFF3E8354),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            count: '$occupiedCount',
            label: 'Occupied',
            countColor: const Color(0xFFC41230),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            count: '$reservedCount',
            label: 'Reserved',
            countColor: const Color(0xFFD67229),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String count;
  final String label;
  final Color countColor;

  const _StatCard({
    required this.count,
    required this.label,
    required this.countColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: countColor,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B6560),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _FilterChipsRow({
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFC41230) : Colors.white,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF8C3B3B),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeaderWithLegend extends StatelessWidget {
  const _SectionHeaderWithLegend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Dining room',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF231F1E),
            letterSpacing: -0.2,
          ),
        ),
        Row(
          children: [
            _LegendDot(color: Color(0xFF3E8354), label: 'Free'),
            SizedBox(width: 10),
            _LegendDot(color: Color(0xFFC41230), label: 'Occupied'),
            SizedBox(width: 10),
            _LegendDot(color: Color(0xFFD67229), label: 'Reserved'),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7D7670),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TABLES GRID & TABLE CARD
// -----------------------------------------------------------------------------
class _TablesGrid extends StatelessWidget {
  final List<RestaurantTable> tables;
  final ValueChanged<RestaurantTable> onSeatGuests;

  const _TablesGrid({
    required this.tables,
    required this.onSeatGuests,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tables.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final table = tables[index];
        return _TableCard(
          table: table,
          onSeatGuests: () => onSeatGuests(table),
        );
      },
    );
  }
}

class _TableCard extends StatelessWidget {
  final RestaurantTable table;
  final VoidCallback onSeatGuests;

  const _TableCard({
    required this.table,
    required this.onSeatGuests,
  });

  Color get _accentColor {
    switch (table.status) {
      case TableStatus.free:
        return const Color(0xFF3E8354);
      case TableStatus.occupied:
        return const Color(0xFFC41230);
      case TableStatus.reserved:
        return const Color(0xFFD67229);
    }
  }

  Color get _badgeBackground {
    switch (table.status) {
      case TableStatus.free:
        return const Color(0xFFE5F2E9);
      case TableStatus.occupied:
        return const Color(0xFFFBE6EA);
      case TableStatus.reserved:
        return const Color(0xFFFDF0E6);
    }
  }

  String get _statusText {
    switch (table.status) {
      case TableStatus.free:
        return 'Free';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.reserved:
        return 'Reserved';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _TopAccentBorderPainter(
          color: _accentColor,
          radius: 18,
          strokeWidth: 3.5,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 14, 13, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    table.name,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F1C1B),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: _badgeBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _statusText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.chair_alt_outlined,
                    size: 13,
                    color: Color(0xFF9C958E),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${table.seats} seats',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8E8780),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (table.status == TableStatus.free) ...[
                const Text(
                  'Ready for guests',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3E8354),
                  ),
                ),
                const Spacer(),
              ] else ...[
                Text(
                  table.guestName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF231F1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  table.subtitle ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF918A84),
                  ),
                ),
                if (table.status == TableStatus.occupied) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        table.amount ?? '',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFC41230),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9ECEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 11,
                              color: Color(0xFF9E4752),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              table.duration ?? '',
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7D3B44),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
              ],
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (table.status == TableStatus.free) {
      return SizedBox(
        width: double.infinity,
        height: 34,
        child: ElevatedButton(
          onPressed: onSeatGuests,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3E8354),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Seat Guests',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    final isOccupied = table.status == TableStatus.occupied;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isOccupied
                    ? const Color(0xFFC41230)
                    : const Color(0xFF3E8354),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isOccupied ? 'View Order' : 'Check in',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEBE8E4),
                foregroundColor: const Color(0xFF3A3532),
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isOccupied ? 'Free Table' : 'Cancel',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopAccentBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;

  _TopAccentBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, radius)
      ..arcToPoint(
        Offset(radius, 0),
        radius: Radius.circular(radius),
      )
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(
        Offset(size.width, radius),
        radius: Radius.circular(radius),
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TopAccentBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}