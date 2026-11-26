import 'package:flutter/material.dart';

import 'adminDashboard.dart';
import 'adminTable.dart';

const Color _kBg = Color(0xFFFAF3E8);
const Color _kCard = Colors.white;
const Color _kRed = Color(0xFFC8101A);
const Color _kTitleRed = Color(0xFF9C2B2B);
const Color _kText = Color(0xFF1F1C1B);
const Color _kGrey = Color(0xFF8A8480);
const Color _kLine = Color(0xFFEBE0CE);

const Color _kGreenText = Color(0xFF3E8354);
const Color _kGreenBg = Color(0xFFE5F2E9);

const Color _kOrangeText = Color(0xFFD67229);
const Color _kOrangeBg = Color(0xFFFDF0E6);

const Color _kRedText = Color(0xFFC41230);
const Color _kRedBg = Color(0xFFFBE6EA);

const Color _kPurpleText = Color(0xFF6B4EFF);
const Color _kPurpleBg = Color(0xFFECE8FF);

enum OrderType { delivery, dineIn, takeaway }

enum OrderStage { newOrder, preparing, ready, served }

class AdminOrder {
  final String id;
  final String time;
  final OrderType type;
  final String customerName;
  final String subInfo; // phone number or "Table order"
  final String itemsSummary;
  final String? extraItemsTag;
  final String locationOrTable; // address, table pill, or pickup time
  final String? tableDetails; // e.g., "3 guests  Seated at 2:05 PM"
  final String? rightMeta; // e.g., "Delivery fee Rs 100" or "Ready at counter"
  final String paymentMethod;
  final bool isPaid;
  final String amount;
  OrderStage stage;

  AdminOrder({
    required this.id,
    required this.time,
    required this.type,
    required this.customerName,
    required this.subInfo,
    required this.itemsSummary,
    this.extraItemsTag,
    required this.locationOrTable,
    this.tableDetails,
    this.rightMeta,
    required this.paymentMethod,
    required this.isPaid,
    required this.amount,
    required this.stage,
  });
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  static const int _selectedNav = 1; // "Orders" active

  int _selectedTypeIndex = 0; // 0 = All, 1 = Delivery, 2 = Dine-in, 3 = Takeaway
  int _selectedStageIndex = 0; // 0 = New, 1 = Preparing, 2 = Ready, 3 = Served / Out for delivery

  final List<String> _stageTabs = const [
    'New',
    'Preparing',
    'Ready',
    'Served / Out for delivery',
    'Completed',
  ];

  final List<AdminOrder> _orders = [
    AdminOrder(
      id: '#1042',
      time: '2:15 PM',
      type: OrderType.delivery,
      customerName: 'Aarav Shrestha',
      subInfo: '9841 245 879',
      itemsSummary: '2x Steam Momo, 1x Oreo Shake',
      extraItemsTag: '+2 more',
      locationOrTable: 'Jhamsikhel Road, Lalitpur',
      rightMeta: 'Delivery fee Rs 100',
      paymentMethod: 'eSewa',
      isPaid: true,
      amount: 'Rs 850',
      stage: OrderStage.newOrder,
    ),
    AdminOrder(
      id: '#1041',
      time: '2:10 PM',
      type: OrderType.dineIn,
      customerName: 'Sanjana Rai',
      subInfo: 'Table order',
      itemsSummary: '1x Chilli Momo, 2x Lemon Soda',
      locationOrTable: 'Table 5',
      tableDetails: '3 guests  Seated at 2:05 PM',
      paymentMethod: 'Cash',
      isPaid: true,
      amount: 'Rs 720',
      stage: OrderStage.preparing,
    ),
    AdminOrder(
      id: '#1038',
      time: '1:40 PM',
      type: OrderType.takeaway,
      customerName: 'Pratik Gurung',
      subInfo: '9803 110 425',
      itemsSummary: '3x Fried Momo, 1x Choco Donuts',
      locationOrTable: 'Pickup at 2:25 PM',
      rightMeta: 'Ready at counter',
      paymentMethod: 'Khalti',
      isPaid: true,
      amount: 'Rs 1,050',
      stage: OrderStage.ready,
    ),
    AdminOrder(
      id: '#1039',
      time: '1:48 PM',
      type: OrderType.dineIn,
      customerName: 'Nimesh Thapa',
      subInfo: 'Table order',
      itemsSummary: '2x Jhol Momo, 1x Blue Lagoon',
      locationOrTable: 'Table 2',
      tableDetails: '2 guests  Seated at 1:35 PM',
      paymentMethod: 'Cash',
      isPaid: false,
      amount: 'Rs 940',
      stage: OrderStage.served,
    ),
  ];

  List<AdminOrder> get _filteredOrders {
    return _orders.where((o) {
      if (_selectedTypeIndex == 1 && o.type != OrderType.delivery) return false;
      if (_selectedTypeIndex == 2 && o.type != OrderType.dineIn) return false;
      if (_selectedTypeIndex == 3 && o.type != OrderType.takeaway) return false;
      return true;
    }).toList();
  }

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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      w * 0.042,
                      w * 0.015,
                      w * 0.042,
                      w * 0.18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTypeFilterRow(w),
                        SizedBox(height: w * 0.03),
                        _buildStageChipsRow(w),
                        SizedBox(height: w * 0.04),
                        _buildSectionHeader(w),
                        SizedBox(height: w * 0.03),
                        for (int i = 0; i < _filteredOrders.length; i++) ...[
                          if (i > 0) SizedBox(height: w * 0.032),
                          _buildOrderCard(w, _filteredOrders[i]),
                        ],
                      ],
                    ),
                  ),
                  // Floating "+ New Order" button
                  Positioned(
                    right: w * 0.045,
                    bottom: w * 0.03,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Open New Order modal
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.042,
                          vertical: w * 0.028,
                        ),
                        decoration: BoxDecoration(
                          color: _kRed,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: _kRed.withValues(alpha: 0.3),
                              blurRadius: w * 0.025,
                              offset: Offset(0, w * 0.008),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: w * 0.045),
                            SizedBox(width: w * 0.012),
                            Text(
                              'New Order',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.031,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomNav(w),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------------------------
  Widget _buildTopBar(double w) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.045, w * 0.025, w * 0.045, w * 0.02),
      child: SizedBox(
        height: w * 0.11,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboardPage(),
                      ),
                    );
                  }
                },
              ),
            ),
            Text(
              'Orders',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: w * 0.065,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: _kTitleRed,
                letterSpacing: -0.3,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: w * 0.105,
                    height: w * 0.105,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: w * 0.02,
                          offset: Offset(0, w * 0.006),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: _kRed,
                      size: w * 0.052,
                    ),
                  ),
                  Positioned(
                    right: -w * 0.004,
                    top: -w * 0.004,
                    child: Container(
                      width: w * 0.042,
                      height: w * 0.042,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: _kRed,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.022,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ORDER TYPE FILTER TABS (All 12, Delivery 3, Dine-in 4, Takeaway 5)
  // ---------------------------------------------------------------------------
  Widget _buildTypeFilterRow(double w) {
    final tabs = [
      ['All', '12'],
      ['Delivery', '3'],
      ['Dine-in', '4'],
      ['Takeaway', '5'],
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final bool selected = i == _selectedTypeIndex;
          return Padding(
            padding: EdgeInsets.only(right: w * 0.02),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTypeIndex = i),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.032,
                  vertical: w * 0.018,
                ),
                decoration: BoxDecoration(
                  color: selected ? _kRed : Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: w * 0.015,
                      offset: Offset(0, w * 0.004),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tabs[i][0],
                      style: TextStyle(
                        color: selected ? Colors.white : _kText,
                        fontSize: w * 0.028,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: w * 0.015),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.016,
                        vertical: w * 0.004,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.white.withValues(alpha: 0.25)
                            : _kOrangeBg,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        tabs[i][1],
                        style: TextStyle(
                          color: selected ? Colors.white : _kOrangeText,
                          fontSize: w * 0.023,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ORDER STAGE FILTER CHIPS (New, Preparing, Ready, Served...)
  // ---------------------------------------------------------------------------
  Widget _buildStageChipsRow(double w) {
    return SizedBox(
      height: w * 0.082,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: _stageTabs.length,
        separatorBuilder: (_, __) => SizedBox(width: w * 0.02),
        itemBuilder: (context, index) {
          final bool selected = index == _selectedStageIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedStageIndex = index),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.038),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF7D2E2E) : Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: w * 0.015,
                    offset: Offset(0, w * 0.004),
                  ),
                ],
              ),
              child: Text(
                _stageTabs[index],
                style: TextStyle(
                  fontSize: w * 0.028,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : const Color(0xFF7D2E2E),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LIVE ORDERS HEADER
  // ---------------------------------------------------------------------------
  Widget _buildSectionHeader(double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live orders',
              style: TextStyle(
                color: _kText,
                fontSize: w * 0.04,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: w * 0.004),
            Text(
              'Updated just now',
              style: TextStyle(
                color: _kGrey,
                fontSize: w * 0.025,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.028,
            vertical: w * 0.012,
          ),
          decoration: BoxDecoration(
            color: _kRedBg,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            '12 orders',
            style: TextStyle(
              color: _kRedText,
              fontSize: w * 0.025,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ORDER CARD
  // ---------------------------------------------------------------------------
  Widget _buildOrderCard(double w, AdminOrder order) {
    return Container(
      padding: EdgeInsets.all(w * 0.038),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(w * 0.045),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: w * 0.025,
            offset: Offset(0, w * 0.008),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Order ID + Time + Type Badge
          Row(
            children: [
              Text(
                order.id,
                style: TextStyle(
                  color: _kTitleRed,
                  fontSize: w * 0.038,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: w * 0.02),
              Text(
                order.time,
                style: TextStyle(
                  color: _kGrey,
                  fontSize: w * 0.026,
                ),
              ),
              const Spacer(),
              _buildTypeBadge(w, order.type),
            ],
          ),
          SizedBox(height: w * 0.018),

          // Row 2: Customer Name & Phone / Table order
          Text(
            order.customerName,
            style: TextStyle(
              color: _kText,
              fontSize: w * 0.034,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: w * 0.004),
          Text(
            order.subInfo,
            style: TextStyle(
              color: _kGrey,
              fontSize: w * 0.026,
            ),
          ),
          SizedBox(height: w * 0.024),

          // Row 3: Items box
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.03,
              vertical: w * 0.022,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6F0),
              borderRadius: BorderRadius.circular(w * 0.025),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    order.itemsSummary,
                    style: TextStyle(
                      color: _kText,
                      fontSize: w * 0.027,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (order.extraItemsTag != null)
                  Text(
                    order.extraItemsTag!,
                    style: TextStyle(
                      color: _kRedText,
                      fontSize: w * 0.025,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: w * 0.024),

          // Row 4: Address / Table Pill / Pickup time
          Row(
            children: [
              if (order.type == OrderType.dineIn) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.024,
                    vertical: w * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: _kGreenBg,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    order.locationOrTable,
                    style: TextStyle(
                      color: _kGreenText,
                      fontSize: w * 0.024,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: w * 0.02),
                Text(
                  order.tableDetails ?? '',
                  style: TextStyle(
                    color: _kGrey,
                    fontSize: w * 0.024,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Text(
                    order.locationOrTable,
                    style: TextStyle(
                      color: _kText,
                      fontSize: w * 0.026,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (order.rightMeta != null)
                  Text(
                    order.rightMeta!,
                    style: TextStyle(
                      color: _kGrey,
                      fontSize: w * 0.024,
                    ),
                  ),
              ],
            ],
          ),
          SizedBox(height: w * 0.025),
          Divider(color: _kLine, height: 1),
          SizedBox(height: w * 0.025),

          // Row 5: Payment Method + Paid/Unpaid Badge + Total Price
          Row(
            children: [
              Text(
                order.paymentMethod,
                style: TextStyle(
                  color: _kText,
                  fontSize: w * 0.028,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: w * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.022,
                  vertical: w * 0.006,
                ),
                decoration: BoxDecoration(
                  color: order.isPaid ? _kGreenBg : _kRedBg,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  order.isPaid ? 'Paid' : 'Unpaid',
                  style: TextStyle(
                    color: order.isPaid ? _kGreenText : _kRedText,
                    fontSize: w * 0.023,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                order.amount,
                style: TextStyle(
                  color: _kRed,
                  fontSize: w * 0.038,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.028),

          // Row 6: Stage Controls & Action Buttons
          _buildOrderActions(w, order),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(double w, OrderType type) {
    late final Color bg;
    late final Color fg;
    late final IconData icon;
    late final String label;

    switch (type) {
      case OrderType.delivery:
        bg = _kRed;
        fg = Colors.white;
        icon = Icons.delivery_dining_rounded;
        label = 'Delivery';
        break;
      case OrderType.dineIn:
        bg = _kGreenBg;
        fg = _kGreenText;
        icon = Icons.restaurant_rounded;
        label = 'Dine-in';
        break;
      case OrderType.takeaway:
        bg = _kOrangeBg;
        fg = _kOrangeText;
        icon = Icons.shopping_bag_outlined;
        label = 'Takeaway';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.026,
        vertical: w * 0.012,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: w * 0.034),
          SizedBox(width: w * 0.012),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: w * 0.025,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderActions(double w, AdminOrder order) {
    if (order.stage == OrderStage.newOrder) {
      return Row(
        children: [
          _statusDropdownChip(w, 'New', _kGreenBg, _kGreenText),
          SizedBox(width: w * 0.02),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => order.stage = OrderStage.preparing),
              child: Container(
                height: w * 0.088,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _kGreenText,
                  borderRadius: BorderRadius.circular(w * 0.022),
                ),
                child: Text(
                  'Accept',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: w * 0.02),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _orders.remove(order)),
              child: Container(
                height: w * 0.088,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBE8E4),
                  borderRadius: BorderRadius.circular(w * 0.022),
                ),
                child: Text(
                  'Reject',
                  style: TextStyle(
                    color: const Color(0xFF3A3532),
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    late final String chipText;
    late final Color chipBg;
    late final Color chipFg;
    late final String ctaText;
    late final OrderStage nextStage;

    switch (order.stage) {
      case OrderStage.preparing:
        chipText = 'Preparing';
        chipBg = _kOrangeBg;
        chipFg = _kOrangeText;
        ctaText = 'Mark Ready';
        nextStage = OrderStage.ready;
        break;
      case OrderStage.ready:
        chipText = 'Ready';
        chipBg = _kRedBg;
        chipFg = _kRedText;
        ctaText = order.type == OrderType.takeaway
            ? 'Complete Pickup'
            : 'Mark Served';
        nextStage = OrderStage.served;
        break;
      default:
        chipText = 'Served';
        chipBg = _kPurpleBg;
        chipFg = _kPurpleText;
        ctaText = 'Complete & Print Bill';
        nextStage = OrderStage.served;
        break;
    }

    return Row(
      children: [
        _statusDropdownChip(w, chipText, chipBg, chipFg),
        SizedBox(width: w * 0.022),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (order.stage == OrderStage.served) {
                  _orders.remove(order);
                } else {
                  order.stage = nextStage;
                }
              });
            },
            child: Container(
              height: w * 0.088,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _kRed,
                borderRadius: BorderRadius.circular(w * 0.022),
              ),
              child: Text(
                ctaText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.028,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusDropdownChip(double w, String label, Color bg, Color fg) {
    return Container(
      height: w * 0.088,
      padding: EdgeInsets.symmetric(horizontal: w * 0.028),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(w * 0.022),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: w * 0.026,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: w * 0.008),
          Icon(Icons.keyboard_arrow_down_rounded, color: fg, size: w * 0.04),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------------
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
                    } else if (i == 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersPage(),
                        ),
                      );
                    } else if (i == 2) {
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
                    //       builder: (context) => const AdminMenuPage(),
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