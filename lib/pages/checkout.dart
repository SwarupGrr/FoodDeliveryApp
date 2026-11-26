import 'package:flutter/material.dart';

import 'orderConfirmPage.dart';

const Color _kBg = Color(0xFFFFF4E3);
const Color _kRed = Color(0xFFC8101A);
const Color _kGreen = Color(0xFF5BA35A); // Place Order button
const Color _kText = Color(0xFF2A2118);
const Color _kGrey = Color(0xFF8F867D);
const Color _kCardFill = Color(0xFFFFF8EE); // the light boxes
const Color _kCardLine = Color(0xFFEADCC6);
const Color _kDivider = Color(0xFFE7DAC5);
const Color _kSelectedFill = Color(0xFFFFEFEA);
const Color _kVisaBlue = Color(0xFF1A3C8F);

class _DeliveryType {
  final IconData icon;
  final String title;
  final String subtitle;
  const _DeliveryType(this.icon, this.title, this.subtitle);
}

const List<_DeliveryType> _deliveryTypes = [
  _DeliveryType(Icons.local_shipping_outlined, 'Standard', '1-2 days'),
  _DeliveryType(Icons.delivery_dining_outlined, 'Express', 'Same day'),
  _DeliveryType(Icons.schedule, 'Schedule', 'Choose time'),
];

// Sample data copied from the reference. Replace with the real user's data.
const String _addressName = 'Michael Anderson';
const List<String> _addressLines = [
  'Apartment 15C',
  '350 West 42nd Street,NY',
  '+1 (917) 555-0192',
];
const String _cardLast4 = '5496';

/// 1100 -> "1,100"
String _num(int v) {
  final String digits = v.abs().toString();
  final StringBuffer b = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) b.write(',');
    b.write(digits[i]);
  }
  return '${v < 0 ? '-' : ''}$b';
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
    this.itemCount = 4,
    this.subtotal = 0,
    this.deliveryFee = 100,
  });

  final int itemCount; // shown as "4 items"
  final int subtotal; // in Rs
  final int deliveryFee; // in Rs

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Index into _deliveryTypes. null = nothing selected, as in the reference.
  int? _delivery;

  int get _total => widget.subtotal + widget.deliveryFee;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: w * 0.017, bottom: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Checking out',
                        style: TextStyle(
                          color: _kRed,
                          fontSize: w * 0.058,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(height: w * 0.126),

                    // Order summary
                    _buildLabel(w, 'Order Summary'),
                    SizedBox(height: w * 0.029),
                    _buildOrderSummary(w),
                    SizedBox(height: w * 0.049),

                    // Delivery address
                    _buildLabel(w, 'Delivery Address'),
                    SizedBox(height: w * 0.032),
                    _buildAddress(w),
                    SizedBox(height: w * 0.053),

                    // Delivery type
                    _buildLabel(w, 'Delivery Type'),
                    SizedBox(height: w * 0.029),
                    _buildDeliveryTypes(w),
                    SizedBox(height: w * 0.066),

                    // Payment
                    _buildLabel(w, 'Payment Method'),
                    SizedBox(height: w * 0.032),
                    _buildPayment(w),
                    SizedBox(height: w * 0.044),

                    // Price summary
                    _buildPrices(w),
                  ],
                ),
              ),
            ),
            _buildPlaceOrder(w),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(double w, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.095),
      child: Text(
        text,
        style: TextStyle(
          color: _kText,
          fontSize: w * 0.038,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Light bordered box used by every section.
  BoxDecoration _boxDecoration(double w, {bool selected = false}) {
    return BoxDecoration(
      color: selected ? _kSelectedFill : _kCardFill,
      borderRadius: BorderRadius.circular(w * 0.03),
      border: Border.all(
        color: selected ? _kRed : _kCardLine,
        width: selected ? 1.4 : 1,
      ),
    );
  }

  Widget _buildOrderSummary(double w) {
    return GestureDetector(
      onTap: () {
        // TODO: show the items in the order (or go back to the cart)
      },
      child: Container(
        height: w * 0.106,
        margin: EdgeInsets.symmetric(horizontal: w * 0.095),
        padding: EdgeInsets.symmetric(horizontal: w * 0.027),
        decoration: _boxDecoration(w),
        child: Row(
          children: [
            Text(
              widget.itemCount == 1 ? '1 item' : '${widget.itemCount} items',
              style: TextStyle(color: _kText, fontSize: w * 0.033),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: _kText, size: w * 0.055),
          ],
        ),
      ),
    );
  }

  Widget _buildAddress(double w) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: w * 0.095),
      padding: EdgeInsets.all(w * 0.027),
      decoration: _boxDecoration(w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _addressName,
                  style: TextStyle(
                    color: _kText,
                    fontSize: w * 0.036,
                    height: 1.45,
                  ),
                ),
                for (final line in _addressLines)
                  Text(
                    line,
                    style: TextStyle(
                      color: _kText,
                      fontSize: w * 0.031,
                      height: 1.65,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // TODO: edit the address
            },
            child: Padding(
              padding: EdgeInsets.all(w * 0.01),
              child: Icon(Icons.edit_outlined, color: _kText, size: w * 0.04),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTypes(double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.095),
      child: SizedBox(
        height: w * 0.249,
        child: Row(
          children: [
            for (int i = 0; i < _deliveryTypes.length; i++) ...[
              if (i > 0) SizedBox(width: w * 0.055),
              Expanded(child: _buildDeliveryCard(w, i)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard(double w, int i) {
    final _DeliveryType t = _deliveryTypes[i];
    final bool selected = _delivery == i;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _delivery = i),
      child: Container(
        decoration: _boxDecoration(w, selected: selected),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(t.icon, color: _kText, size: w * 0.045),
            SizedBox(height: w * 0.024),
            Text(
              t.title,
              style: TextStyle(
                color: _kText,
                fontSize: w * 0.033,
                height: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: w * 0.007),
            Text(
              t.subtitle,
              style: TextStyle(color: _kText, fontSize: w * 0.026, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayment(double w) {
    return GestureDetector(
      onTap: () {
        // TODO: choose a payment method
      },
      child: Container(
        height: w * 0.106,
        margin: EdgeInsets.symmetric(horizontal: w * 0.095),
        padding: EdgeInsets.symmetric(horizontal: w * 0.027),
        decoration: _boxDecoration(w),
        child: Row(
          children: [
            // Text stand-in for the card logo; use a real logo asset if you
            // have one.
            Text(
              'VISA',
              style: TextStyle(
                color: _kVisaBlue,
                fontSize: w * 0.02,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: w * 0.025),
            Text(
              '••••  $_cardLast4',
              style: TextStyle(color: _kText, fontSize: w * 0.032),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: _kText, size: w * 0.055),
          ],
        ),
      ),
    );
  }

  Widget _buildPrices(double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.08),
      child: Column(
        children: [
          _priceRow(w, 'Subtotal', widget.subtotal),
          _priceRow(w, 'Delivery', widget.deliveryFee, valueColor: _kRed),
          _priceRow(w, 'Total', _total, isTotal: true),
        ],
      ),
    );
  }

  Widget _priceRow(
    double w,
    String label,
    int amount, {
    Color? valueColor,
    bool isTotal = false,
  }) {
    final Color base = isTotal ? _kText : _kGrey;
    final double size = isTotal ? w * 0.04 : w * 0.032;

    return Container(
      height: w * 0.109,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kDivider, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: base,
                fontSize: size,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            'Rs.',
            style: TextStyle(color: base, fontSize: isTotal ? w * 0.037 : size),
          ),
          SizedBox(width: w * 0.01),
          // Fixed-width box so the amounts line up in a column.
          SizedBox(
            width: w * 0.09,
            child: Center(
              child: Text(
                _num(amount),
                style: TextStyle(
                  color: valueColor ?? base,
                  fontSize: isTotal ? w * 0.043 : size,
                  fontWeight: isTotal ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(width: w * 0.055),
        ],
      ),
    );
  }

  Widget _buildPlaceOrder(double w) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.095, w * 0.02, w * 0.095, w * 0.055),
      child: Material(
        color: _kGreen,
        borderRadius: BorderRadius.circular(w * 0.03),
        child: InkWell(
          borderRadius: BorderRadius.circular(w * 0.03),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const orderConfirm()));
          },
          child: SizedBox(
            width: double.infinity,
            height: w * 0.106,
            child: Center(
              child: Text(
                'Place Order',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.034,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}