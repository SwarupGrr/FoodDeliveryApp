import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/placeholder.avif',
        height: 2000,
        width: 200,),
        centerTitle: true,
      ),

      body: Center(
        child: Text('momo on clouds',
          style: GoogleFonts.konkhmerSleokchher(
            color: const Color(0xFFF40A0D),
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        ), 
    );
  }
}
