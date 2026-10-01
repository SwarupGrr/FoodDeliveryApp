import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold( 
      appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
            ),

      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/momo_logo.png'),
                fit: BoxFit.cover
              )
            ),
          ),

          Center (
            child: Container(
              width: 350,
              child: Text('momo on \nclouds',
                textAlign: TextAlign.center,
                  style: GoogleFonts.gloock(
                    color: const Color(0xFFF40A0D),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
              ),
            ),
             )
          )
        ]
      ),
    );
  }
}