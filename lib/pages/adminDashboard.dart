import 'package:flutter/material.dart';

import 'adminTable.dart';
import 'adminOrder.dart';

const Color _kBg = Color(0xFFFFF4E3);
const Color _kCard = Colors.white;
const Color _kRed = Color(0xFFC8101A);
const Color _kTitleRed = Color(0xFFB3121C);
const Color _kDarkRed = Color(0xFF8E1B20);
const Color _kText = Color(0xFF1F1F1F);
const Color _kGrey = Color(0xFF8A8480);
const Color _kLine = Color(0xFFEBE0CE);

const Color _kGreenText = Color(0xFF2E7D32);
const Color _kGreenBg = Color(0xFFE3F2E6);

const Color _kOrangeText = Color(0xFFD97724);
const Color _kOrangeBg = Color(0xFFFDECE0);

const Color _kRedText = Color(0xFFC8101A);
const Color _kRedBg = Color(0xFFFCE4E6);

const Color _kPurpleText = Color(0xFF6B4EFF);
const Color _kPurpleBg = Color(0xFFECE8FF);

const String? _kScriptFont = 'KaushanScript';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  static const int _selectedNav = 0;

  bool _isWeek = true;

  // Weekly & Monthly bar data (Sun - Sat)
  final List<String> _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<double> _weekValues = [0.45, 0.62, 0.52, 0.80, 0.68, 1.00, 0.84];
  final List<double> _monthValues = [0.70, 0.55, 0.85, 0.60, 0.92, 0.78, 0.95];

  // Table statuses: 0 = Free (green), 1 = Occupied (red), 2 = Reserved (orange)
  final List<int> _tableStatus = [
    1, 0, 2, 1, 0, 1, // T1 - T6
    0, 2, 1, 0, 1, 0, // T7 - T12
  ];

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
                padding: EdgeInsets.fromLTRB(
                  w * 0.045,
                  w * 0.01,
                  w * 0.045,
                  w * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKpiGrid(w),
                    SizedBox(height: w * 0.035),
                    _buildOrdersByType(w),
                    SizedBox(height: w * 0.035),
                    _buildSalesChart(w),
                    SizedBox(height: w * 0.035),
                    _buildTablesCard(w),
                    SizedBox(height: w * 0.035),
                    _buildTopItemsCard(w),
                    SizedBox(height: w * 0.035),
                    _buildAttentionBanner(w),
                    SizedBox(height: w * 0.035),
                    _buildRecentOrdersCard(w),
                    SizedBox(height: w * 0.04),
                    _buildQuickActions(w),
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
  // TOP BAR
  // ---------------------------------------------------------------------------
  Widget _buildTopBar(double w) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.045, w * 0.03, w * 0.045, w * 0.025),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontFamily: _kScriptFont,
                    color: _kTitleRed,
                    fontSize: w * 0.068,
                    height: 1.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: w * 0.008),
                Text(
                  'Good morning, Admin',
                  style: TextStyle(
                    color: _kGrey,
                    fontSize: w * 0.03,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: w * 0.095,
                height: w * 0.095,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x14000000),
                      blurRadius: w * 0.015,
                      offset: Offset(0, w * 0.004),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: _kRed,
                  size: w * 0.05,
                ),
              ),
              Positioned(
                right: -w * 0.005,
                top: -w * 0.005,
                child: Container(
                  width: w * 0.04,
                  height: w * 0.04,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _kRed,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '4',
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
          SizedBox(width: w * 0.025),
          // AD Avatar
          Container(
            width: w * 0.095,
            height: w * 0.095,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _kDarkRed,
              shape: BoxShape.circle,
            ),
            child: Text(
              'AD',
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.03,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2x2 KPI GRID
  // ---------------------------------------------------------------------------
  Widget _buildKpiGrid(double w) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _kpiCard(
                w,
                title: 'Total Sales',
                value: 'Rs 48,500',
                badgeText: '+12% vs yesterday',
                badgeColor: _kGreenText,
                badgeBg: _kGreenBg,
                icon: Icons.trending_up_rounded,
                iconColor: _kGreenText,
                iconBg: _kGreenBg,
              ),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: _kpiCard(
                w,
                title: 'Total Orders',
                value: '62',
                badgeText: '8 today',
                badgeColor: _kDarkRed,
                badgeBg: _kRedBg,
                icon: Icons.receipt_outlined,
                iconColor: _kDarkRed,
                iconBg: _kRedBg,
              ),
            ),
          ],
        ),
        SizedBox(height: w * 0.03),
        Row(
          children: [
            Expanded(
              child: _kpiCard(
                w,
                title: 'Active Orders',
                value: '9',
                badgeText: 'In progress',
                badgeColor: _kOrangeText,
                badgeBg: _kOrangeBg,
                icon: Icons.access_time_rounded,
                iconColor: _kOrangeText,
                iconBg: _kOrangeBg,
              ),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: _kpiCard(
                w,
                title: 'Cancelled /\nRejected',
                value: '3',
                badgeText: '4.8% of orders',
                badgeColor: _kRedText,
                badgeBg: _kRedBg,
                icon: Icons.cancel_outlined,
                iconColor: _kRedText,
                iconBg: _kRedBg,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _kpiCard(
    double w, {
    required String title,
    required String value,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBg,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    return Container(
      padding: EdgeInsets.all(w * 0.035),
      decoration: _cardDecoration(w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _kGrey,
                    fontSize: w * 0.028,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: w * 0.068,
                height: w * 0.068,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(w * 0.018),
                ),
                child: Icon(icon, color: iconColor, size: w * 0.038),
              ),
            ],
          ),
          SizedBox(height: w * 0.02),
          Text(
            value,
            style: TextStyle(
              color: _kText,
              fontSize: w * 0.048,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: w * 0.02),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.022,
              vertical: w * 0.008,
            ),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: badgeColor,
                fontSize: w * 0.023,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ORDERS BY TYPE
  // ---------------------------------------------------------------------------
  Widget _buildOrdersByType(double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: _cardDecoration(w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Orders by type', style: _sectionTitleStyle(w)),
          SizedBox(height: w * 0.035),
          Row(
            children: [
              SizedBox(
                width: w * 0.28,
                child: Column(
                  children: [
                    Text(
                      '62',
                      style: TextStyle(
                        color: _kText,
                        fontSize: w * 0.052,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'orders',
                      style: TextStyle(
                        color: _kGrey,
                        fontSize: w * 0.025,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _orderTypeRow(w, _kRed, 'Delivery', '28 • 45%'),
                    SizedBox(height: w * 0.02),
                    _orderTypeRow(w, _kGreenText, 'Dine-in', '22 • 35%'),
                    SizedBox(height: w * 0.02),
                    _orderTypeRow(w, _kOrangeText, 'Takeaway', '12 • 20%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderTypeRow(double w, Color dot, String label, String stat) {
    return Row(
      children: [
        Container(
          width: w * 0.018,
          height: w * 0.018,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        SizedBox(width: w * 0.02),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: _kText,
              fontSize: w * 0.029,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          stat,
          style: TextStyle(
            color: _kText,
            fontSize: w * 0.029,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SALES THIS WEEK BAR CHART
  // ---------------------------------------------------------------------------
  Widget _buildSalesChart(double w) {
    final values = _isWeek ? _weekValues : _monthValues;
    final double maxBarH = w * 0.26;

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: _cardDecoration(w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Sales this week', style: _sectionTitleStyle(w)),
              ),
              Container(
                padding: EdgeInsets.all(w * 0.008),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3ECE0),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    _toggleChip(w, 'Week', _isWeek, () {
                      setState(() => _isWeek = true);
                    }),
                    _toggleChip(w, 'Month', !_isWeek, () {
                      setState(() => _isWeek = false);
                    }),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.04),
          SizedBox(
            height: maxBarH + w * 0.06,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ['12k', '8k', '4k', '0']
                      .map(
                        (t) => Padding(
                          padding: EdgeInsets.only(bottom: w * 0.03),
                          child: Text(
                            t,
                            style: TextStyle(
                              color: _kGrey,
                              fontSize: w * 0.022,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(width: w * 0.025),
                // Bars
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(_days.length, (i) {
                      final bool isPeak = i == 5; // Fri highlighted
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: w * 0.072,
                            height: maxBarH * values[i],
                            decoration: BoxDecoration(
                              color: isPeak
                                  ? _kRed
                                  : _kRed.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(w * 0.015),
                              ),
                            ),
                          ),
                          SizedBox(height: w * 0.015),
                          Text(
                            _days[i],
                            style: TextStyle(
                              color: isPeak ? _kText : _kGrey,
                              fontSize: w * 0.023,
                              fontWeight:
                                  isPeak ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleChip(
      double w, String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.028,
          vertical: w * 0.01,
        ),
        decoration: BoxDecoration(
          color: selected ? _kRed : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : _kGrey,
            fontSize: w * 0.024,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TABLES GRID
  // ---------------------------------------------------------------------------
  Widget _buildTablesCard(double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: _cardDecoration(w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Tables', style: _sectionTitleStyle(w))),
              Text(
                '5 of 12 occupied',
                style: TextStyle(color: _kGrey, fontSize: w * 0.025),
              ),
            ],
          ),
          SizedBox(height: w * 0.03),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: w * 0.018,
              mainAxisSpacing: w * 0.018,
              childAspectRatio: 1.35,
            ),
            itemBuilder: (context, i) {
              final int status = _tableStatus[i];
              final Color bg = status == 1
                  ? _kRed
                  : (status == 2 ? _kOrangeBg : _kGreenBg);
              final Color fg = status == 1
                  ? Colors.white
                  : (status == 2 ? _kOrangeText : _kGreenText);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _tableStatus[i] = (_tableStatus[i] + 1) % 3;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(w * 0.02),
                  ),
                  child: Text(
                    'T${i + 1}',
                    style: TextStyle(
                      color: fg,
                      fontSize: w * 0.026,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: w * 0.03),
          Row(
            children: [
              _legendDot(w, _kGreenText, 'Free'),
              SizedBox(width: w * 0.025),
              _legendDot(w, _kRed, 'Occupied'),
              SizedBox(width: w * 0.025),
              _legendDot(w, _kOrangeText, 'Reserved'),
              const Spacer(),
              Text(
                'View all tables',
                style: TextStyle(
                  color: _kRed,
                  fontSize: w * 0.025,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(double w, Color color, String label) {
    return Row(
      children: [
        Container(
          width: w * 0.016,
          height: w * 0.016,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: w * 0.01),
        Text(
          label,
          style: TextStyle(color: _kGrey, fontSize: w * 0.023),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TOP ITEMS TODAY
  // ---------------------------------------------------------------------------
  Widget _buildTopItemsCard(double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: _cardDecoration(w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top items today', style: _sectionTitleStyle(w)),
          SizedBox(height: w * 0.03),
          _topItemRow(w, 'assets/images/chicken_momo.png', 'Steam Momo',
              '24 sold', 0.92),
          SizedBox(height: w * 0.025),
          _topItemRow(
              w, 'assets/images/buff_momo.png', 'Jhol Momo', '18 sold', 0.70),
          SizedBox(height: w * 0.025),
          _topItemRow(
              w, 'assets/images/oreo_shake.png', 'Oreo Shake', '11 sold', 0.45),
        ],
      ),
    );
  }

  Widget _topItemRow(
    double w,
    String imagePath,
    String name,
    String soldText,
    double progress,
  ) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(w * 0.022),
          child: Image.asset(
            imagePath,
            width: w * 0.1,
            height: w * 0.1,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: w * 0.1,
              height: w * 0.1,
              color: const Color(0xFFE6D9BF),
              child: Icon(Icons.fastfood, color: _kGrey, size: w * 0.05),
            ),
          ),
        ),
        SizedBox(width: w * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: _kText,
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    soldText,
                    style: TextStyle(color: _kGrey, fontSize: w * 0.024),
                  ),
                ],
              ),
              SizedBox(height: w * 0.015),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: w * 0.014,
                  backgroundColor: _kLine,
                  valueColor: const AlwaysStoppedAnimation<Color>(_kRed),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // NEEDS ATTENTION BANNER
  // ---------------------------------------------------------------------------
  Widget _buildAttentionBanner(double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF1C8),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: const Color(0xFFE8D894)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Needs attention',
                  style: TextStyle(
                    color: const Color(0xFF8C6D1F),
                    fontSize: w * 0.031,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: w * 0.01),
                Text(
                  'Low stock: Oreo Shake, Choco Donuts\n2 orders waiting for acceptance',
                  style: TextStyle(
                    color: const Color(0xFF7A6530),
                    fontSize: w * 0.024,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: w * 0.02),
          GestureDetector(
            onTap: () {
              // TODO: Open pending attention items
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.035,
                vertical: w * 0.018,
              ),
              decoration: BoxDecoration(
                color: _kRed,
                borderRadius: BorderRadius.circular(w * 0.022),
              ),
              child: Text(
                'Review',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.026,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RECENT ORDERS
  // ---------------------------------------------------------------------------
  Widget _buildRecentOrdersCard(double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: _cardDecoration(w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Recent orders', style: _sectionTitleStyle(w)),
              ),
              Text(
                'See all',
                style: TextStyle(
                  color: _kRed,
                  fontSize: w * 0.026,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.025),
          _recentOrderRow(
            w,
            id: '#1042',
            type: 'Delivery',
            typeColor: _kRedText,
            typeBg: _kRedBg,
            amount: 'Rs 850',
            status: 'New',
            statusColor: _kGreenText,
            statusBg: _kGreenBg,
          ),
          Divider(color: _kLine, height: w * 0.04),
          _recentOrderRow(
            w,
            id: '#1041',
            type: 'Dine-in',
            typeColor: _kGreenText,
            typeBg: _kGreenBg,
            amount: 'Rs 720',
            status: 'Preparing',
            statusColor: _kOrangeText,
            statusBg: _kOrangeBg,
          ),
          Divider(color: _kLine, height: w * 0.04),
          _recentOrderRow(
            w,
            id: '#1039',
            type: 'Takeaway',
            typeColor: _kOrangeText,
            typeBg: _kOrangeBg,
            amount: 'Rs 1,050',
            status: 'Ready',
            statusColor: _kPurpleText,
            statusBg: _kPurpleBg,
          ),
        ],
      ),
    );
  }

  Widget _recentOrderRow(
    double w, {
    required String id,
    required String type,
    required Color typeColor,
    required Color typeBg,
    required String amount,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Row(
      children: [
        SizedBox(
          width: w * 0.14,
          child: Text(
            id,
            style: TextStyle(
              color: _kText,
              fontSize: w * 0.028,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: w * 0.01),
            decoration: BoxDecoration(
              color: typeBg,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              type,
              style: TextStyle(
                color: typeColor,
                fontSize: w * 0.024,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: w * 0.03),
        Text(
          amount,
          style: TextStyle(
            color: _kRed,
            fontSize: w * 0.028,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: w * 0.025),
        Container(
          width: w * 0.16,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: w * 0.01),
          decoration: BoxDecoration(
            color: statusBg,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: w * 0.023,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // QUICK ACTIONS
  // ---------------------------------------------------------------------------
  Widget _buildQuickActions(double w) {
    final actions = [
      [Icons.add, 'Add item'],
      [Icons.people_outline_rounded, 'Staff'],
      [Icons.bar_chart_rounded, 'Reports'],
      [Icons.settings_outlined, 'Settings'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick actions', style: _sectionTitleStyle(w)),
        SizedBox(height: w * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions.map((item) {
            return GestureDetector(
              onTap: () {
                // TODO: Handle quick action tap
              },
              child: Column(
                children: [
                  Container(
                    width: w * 0.13,
                    height: w * 0.13,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x14000000),
                          blurRadius: w * 0.02,
                          offset: Offset(0, w * 0.005),
                        ),
                      ],
                    ),
                    child: Icon(
                      item[0] as IconData,
                      color: _kDarkRed,
                      size: w * 0.055,
                    ),
                  ),
                  SizedBox(height: w * 0.015),
                  Text(
                    item[1] as String,
                    style: TextStyle(
                      color: _kDarkRed,
                      fontSize: w * 0.025,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
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
                    //       builder: (context) => const SettingsPage(),
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

  // ---------------------------------------------------------------------------
  // SHARED HELPERS
  // ---------------------------------------------------------------------------
  BoxDecoration _cardDecoration(double w) {
    return BoxDecoration(
      color: _kCard,
      borderRadius: BorderRadius.circular(w * 0.045),
      boxShadow: [
        BoxShadow(
          color: const Color(0x0F000000),
          blurRadius: w * 0.02,
          offset: Offset(0, w * 0.006),
        ),
      ],
    );
  }

  TextStyle _sectionTitleStyle(double w) {
    return TextStyle(
      color: _kText,
      fontSize: w * 0.034,
      fontWeight: FontWeight.w700,
    );
  }
}