import 'package:bhukk/components/ReusableCarousel.dart';
import 'package:bhukk/theme/Apptheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Delivering to',
              style: GoogleFonts.jaldi(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              // Cart functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // search bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.jaldi(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search for restaurants, dishes...',
                        hintStyle: GoogleFonts.jaldi(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.mic, color: Colors.white),
                ],
              ),
            ),
            // // Banner Section
            // Container(
            //   height: 200,
            //   margin: const EdgeInsets.symmetric(vertical: 16),
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 5, // Example banners
            //     itemBuilder: (context, index) => Container(
            //       width: MediaQuery.of(context).size.width * 0.8,
            //       margin: const EdgeInsets.symmetric(horizontal: 8),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         image: const DecorationImage(
            //           image: NetworkImage(
            //               'https://s.yimg.com/ny/api/res/1.2/bgk63rm_s6mAjI_yqWFT3A--/YXBwaWQ9aGlnaGxhbmRlcjt3PTY0MDtoPTM2MA--/https://s.yimg.com/os/creatr-uploaded-images/2023-11/fa60f910-8593-11ee-8bd7-5431bc7f2717'),
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Promotional Section
            ReusableCarousel(
              items: [
                CarouselItem(
                  imageUrl:
                      "https://cdn.thewirecutter.com/wp-content/media/2024/09/beardtrimmers-2048px-7372.jpg?auto=webp&quality=75&width=1024",
                  title: 'Special Offer!',
                  description: 'Get 50% off on your first order.',
                  buttonText: 'Shop Now',
                  onPressed: () {
                    // Navigate to shop
                  },
                ),
                CarouselItem(
                  imageUrl:
                      'https://cdn.thewirecutter.com/wp-content/media/2024/09/beardtrimmers-2048px-7372.jpg?auto=webp&quality=75&width=1024',
                  title: 'Limited Time!',
                  description: 'Buy one, get one free.',
                  buttonText: 'Grab Deal',
                  onPressed: () {
                    // Navigate to offer
                  },
                ),
              ],
            ),
            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "What's your craving?",
                style: GoogleFonts.jaldi(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8, // Example categories
                itemBuilder: (context, index) => Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(40),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://static.vecteezy.com/system/resources/previews/046/326/679/non_2x/chicken-biryani-food-png.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Biriyani',
                      style: GoogleFonts.jaldi(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 24),
            //recommended section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommendation',
                    style: GoogleFonts.jaldi(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'View all',
                    style: GoogleFonts.jaldi(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // cards with image and restauent name and price
            const SizedBox(height: 16),
            SizedBox(
              height: 250, // Total height for square cards
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Example recommended items
                itemBuilder: (context, index) => Container(
                  width: MediaQuery.of(context).size.width *
                      0.45, // Square-like width
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image with rating overlay
                      Stack(
                        children: [
                          Container(
                            height: 120, // Top half is the image
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRj4fbDzlSwNqWoBrAIR5tG2DH7S2u4I9qTg&s',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.orange, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.${index + 2}', // Example rating
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Content below image
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dish Name
                            Text(
                              'Dish Name ${index + 1}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.jaldi(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Prep Time
                            Row(
                              children: [
                                const Icon(Icons.timer,
                                    color: Colors.white70, size: 16),
                                Text(
                                  '${index + 10} min',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Price and Add Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Price
                                Text(
                                  '\$${index + 10}.00', // Price
                                  style: GoogleFonts.jaldi(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Add Button
                                ElevatedButton(
                                  onPressed: () {
                                    // Add functionality
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.all(
                                        10), // Circle button size
                                  ),
                                  child: const Icon(Icons.add,
                                      color: Colors.black, size: 26),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Nearby Restaurants Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Restaurants',
                    style: GoogleFonts.jaldi(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'View all',
                    style: GoogleFonts.jaldi(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5, // Example restaurant cards
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Image
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://b.zmtcdn.com/data/collections/96541881ed7b42d424990403ac3afdbf_1712923159.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Restaurant Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant Name
                          Text(
                            'Restaurant ${index + 1}',
                            style: GoogleFonts.jaldi(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Cuisine and Veg/Non-Veg Tag
                          Row(
                            children: [
                              // Cuisine Text
                              Expanded(
                                child: Text(
                                  'Cuisine, More Cuisine',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.jaldi(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              // Veg/Non-Veg Icon
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index % 2 == 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Distance, Price for One, and Discounts
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Distance
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.white70, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${index + 1}.5 km',
                                    style: GoogleFonts.jaldi(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              // Price for One
                              Text(
                                '₹${index + 100} for one',
                                style: GoogleFonts.jaldi(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Discounts
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '40% OFF up to ₹80',
                                  style: GoogleFonts.jaldi(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
