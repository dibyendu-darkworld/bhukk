import 'package:bhukk/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with black opacity
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/bg1.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          // Main content
          Column(
            children: [
              SizedBox(height: screenHeight * 0.1), // Top padding
              // Top Text
              Text(
                'Bhukk',
                style: GoogleFonts.jaldi(
                  fontSize: screenWidth * 0.1, // Responsive font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(), // Pushes the rest of the content to the bottom
              // Bottom Text and Button Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Got that Bhukk?',
                          style: GoogleFonts.jaldi(
                            fontSize: screenWidth * 0.08,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'ORDER in ',
                      style: GoogleFonts.jaldi(
                        fontSize: screenWidth * 0.15,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      'or BOOK a table nearby!',
                      style: GoogleFonts.jaldi(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Spacing
                    GestureDetector(
                      onTap: () {
                        // Add your onTap code here!
                        Get.offAllNamed(Routes.home);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.jaldi(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.08), // Bottom padding
            ],
          ),
        ],
      ),
    );
  }
}
