import 'package:flutter/material.dart';

const Color _kBg = Color(0xFFFFF4E3);
const Color _kField = Color(0xFFFFF8EE);
const Color _kRed = Color(0xFFC8101A);
const Color _kText = Color(0xFF1A1A1A);
const Color _kBorder = Color(0x1F000000);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _name =
      TextEditingController(text: 'Melissa Peters');
  final TextEditingController _email =
      TextEditingController(text: 'melpeters@gmail.com');
  final TextEditingController _password =
      TextEditingController(text: '************');

  String _dob = '23/05/1995';
  String _country = 'Nigeria';

  static const List<String> _countries = ['Nigeria', 'Nepal', 'India'];

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 5, 23),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob = '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, c) {
          final double w = c.maxWidth;
          return Column(
            children: [
              _buildTopBar(w),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: w * 0.03),
                      Center(child: _buildAvatar(w)),
                      SizedBox(height: w * 0.05),
                      _label(w, 'Name'),
                      _textField(w, _name),
                      SizedBox(height: w * 0.04),
                      _label(w, 'Email'),
                      _textField(w, _email),
                      SizedBox(height: w * 0.05),
                      _label(w, 'Password'),
                      _textField(w, _password, obscure: true),
                      SizedBox(height: w * 0.05),
                      _label(w, 'Date of Birth'),
                      _selectField(w, _dob, _pickDate),
                      SizedBox(height: w * 0.035),
                      _label(w, 'Country/Region'),
                      _countryField(w),
                      SizedBox(height: w * 0.05),
                    ],
                  ),
                ),
              ),
              _buildSaveButton(w),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: w * 0.03),
      child: SizedBox(
        height: w * 0.1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.maybePop(context),
                child: Icon(Icons.arrow_back_ios_new,
                    color: _kText, size: w * 0.06),
              ),
            ),
            Text(
              'Edit Profile',
              style: TextStyle(
                color: _kText,
                fontSize: w * 0.05,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(double w) {
    final double size = w * 0.38;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black87, width: 1),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/profile.png',
                fit: BoxFit.cover,
                width: size,
                height: size,
              ),
            ),
          ),
          Positioned(
            right: size * 0.02,
            bottom: size * 0.5 - size * 0.08,
            child: Container(
              padding: EdgeInsets.all(size * 0.03),
              decoration: BoxDecoration(
                color: const Color(0xFF3B4558),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.photo_camera,
                  color: Colors.white70, size: size * 0.11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(double w, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.02),
      child: Text(
        text,
        style: TextStyle(
          color: _kText,
          fontSize: w * 0.037,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  BoxDecoration _fieldDecoration() {
    return BoxDecoration(
      color: _kField,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: _kBorder),
    );
  }

  Widget _textField(double w, TextEditingController controller,
      {bool obscure = false}) {
    return Container(
      height: w * 0.1,
      width: double.infinity,
      decoration: _fieldDecoration(),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        obscuringCharacter: '*',
        textAlign: TextAlign.center,
        style: TextStyle(color: _kText, fontSize: w * 0.032),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
        ),
      ),
    );
  }

  Widget _selectField(double w, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: w * 0.1,
        width: double.infinity,
        decoration: _fieldDecoration(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(value,
                style: TextStyle(color: _kText, fontSize: w * 0.032)),
            Positioned(
              right: w * 0.02,
              child: Icon(Icons.keyboard_arrow_down,
                  color: _kText, size: w * 0.06),
            ),
          ],
        ),
      ),
    );
  }

  Widget _countryField(double w) {
    return Container(
      height: w * 0.1,
      width: double.infinity,
      decoration: _fieldDecoration(),
      padding: EdgeInsets.symmetric(horizontal: w * 0.02),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _country,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: _kText, size: w * 0.06),
          dropdownColor: _kField,
          alignment: Alignment.center,
          style: TextStyle(color: _kText, fontSize: w * 0.032),
          items: _countries
              .map((c) => DropdownMenuItem<String>(
                    value: c,
                    alignment: Alignment.center,
                    child: Text(c),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _country = v);
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton(double w) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.1, w * 0.02, w * 0.1, w * 0.06),
      child: Center(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: w * 0.5,
            padding: EdgeInsets.symmetric(vertical: w * 0.035),
            decoration: BoxDecoration(
              color: _kRed,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              'Save changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.043,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}