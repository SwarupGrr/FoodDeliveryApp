import 'package:flutter/material.dart';
 
import 'pages/loginPage.dart';
import 'pages/adminLog.dart';
 
void main() => runApp(const MomoApp());
 
class MomoApp extends StatelessWidget {
  const MomoApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Momo on Clouds',
      theme: ThemeData(useMaterial3: true),
      home: const AdminLog(),
    );
  }
}