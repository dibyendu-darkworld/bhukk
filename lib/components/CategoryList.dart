import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableCategoryList extends StatelessWidget {
  final List<CategoryItem> categories;

  const ReusableCategoryList({Key? key, required this.categories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    image: NetworkImage(category.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: GoogleFonts.jaldi(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryItem {
  final String name;
  final String imageUrl;

  CategoryItem({
    required this.name,
    required this.imageUrl,
  });
}
