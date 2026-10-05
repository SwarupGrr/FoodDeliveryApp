import 'package:flutter/material.dart';
import 'package:momo_on_clouds/pages/adminLog.dart';
import 'package:momo_on_clouds/pages/loginPage.dart';
import 'package:momo_on_clouds/pages/menuLanding.dart';
 
void main() => runApp(const MomoApp());
 
class MomoApp extends StatelessWidget {
  const MomoApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Momo on Clouds',
      theme: ThemeData(useMaterial3: true),
      home: const MenuLanding(),
    );
  }
}