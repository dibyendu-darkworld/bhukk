import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableCarousel extends StatelessWidget {
  final List<CarouselItem> items;

  const ReusableCarousel({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return CarouselSlider(
      options: CarouselOptions(
        height: 240,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        viewportFraction: 1.0, // Full width for each item
      ),
      items: items.map((item) {
        return Container(
          width: screenWidth, // Ensure the container spans full width
          margin:
              const EdgeInsets.symmetric(vertical: 16), // No horizontal margin
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.jaldi(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //logo
                        const Spacer(),
                        Image.network(
                          item.logoimageUrl,
                          height: 40,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: GoogleFonts.jaldi(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: item.onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        item.buttonText,
                        style: GoogleFonts.jaldi(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class CarouselItem {
  final String imageUrl;
  final String logoimageUrl;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  CarouselItem({
    required this.imageUrl,
    required this.logoimageUrl,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });
}
