import 'package:bhukk/components/CardList.dart';
import 'package:bhukk/components/CategoryList.dart';
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

            // Promotional Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ReusableCarousel(
                items: [
                  CarouselItem(
                    imageUrl: "https://i.ibb.co/RvxKsfW/combo.gif",
                    title: 'Special Offer! on KFC ',
                    description: 'Get 50% off on your first order.',
                    buttonText: 'Shop Now',
                    logoimageUrl:
                        "https://upload.wikimedia.org/wikipedia/sco/thumb/b/bf/KFC_logo.svg/1024px-KFC_logo.svg.png",
                    onPressed: () {
                      // Navigate to shop
                    },
                  ),
                  CarouselItem(
                    imageUrl: 'https://i.ibb.co/P1pm5ff/pancake.png',
                    title: 'Limited Time!',
                    description: 'Buy one, get one free.',
                    buttonText: 'Grab Deal',
                    logoimageUrl:
                        "https://upload.wikimedia.org/wikipedia/en/thumb/d/d3/Starbucks_Corporation_Logo_2011.svg/1200px-Starbucks_Corporation_Logo_2011.svg.png",
                    onPressed: () {
                      // Navigate to offer
                    },
                  ),
                ],
              ),
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
            ReusableCategoryList(
              categories: [
                CategoryItem(
                  name: 'Biriyani',
                  imageUrl:
                      'https://img.freepik.com/free-psd/delicious-cheese-pizza-isolated-transparent-background_84443-1216.jpg',
                ),
                CategoryItem(
                  name: 'Pizza',
                  imageUrl:
                      'https://imgmedia.lbb.in/media/2019/07/5d242ad8e93a896e5542da0d_1562651352251.jpg',
                ),
                CategoryItem(
                  name: 'Burger',
                  imageUrl:
                      'https://img.freepik.com/free-psd/fresh-beef-burger-isolated-transparent-background_191095-9018.jpg',
                ),
                // Add more categories as needed
              ],
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
            RecommendedCardList(
              items: [
                RecommendedItem(
                  name: 'KFC Zinger Burger',
                  imageUrl:
                      'https://www.indiablooms.com/life_pic/2020/5148dabdddfb323553feea68573167e7.jpg',
                  rating: 4.5,
                  prepTime: 15,
                  price: 360.99,
                  onAdd: () {
                    print('Added Dish 1');
                  },
                ),
                RecommendedItem(
                  name: 'Mixed Noodles',
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRj4fbDzlSwNqWoBrAIR5tG2DH7S2u4I9qTg&s',
                  rating: 5.0,
                  prepTime: 20,
                  price: 200.99,
                  onAdd: () {
                    print('Added Dish 2');
                  },
                ),
                RecommendedItem(
                  name: 'Chicken BiryANI',
                  imageUrl:
                      'https://i0.wp.com/blendofspicesbysara.com/wp-content/uploads/2020/10/PXL_20201011_200951855.PORTRAIT-01.jpeg?resize=800%2C840&ssl=1',
                  rating: 4.8,
                  prepTime: 25,
                  price: 250.99,
                  onAdd: () {
                    print('Added Dish 3');
                  },
                ),
                // Add more items as needed
              ],
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
                  borderRadius: BorderRadius.circular(20),
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
