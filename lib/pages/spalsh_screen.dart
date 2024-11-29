import 'package:bhukk/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhukk/pages/get_started_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed(Routes.getstarted);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Bhukk',
          style: GoogleFonts.jaldi(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
      ),
    );
  }
}
