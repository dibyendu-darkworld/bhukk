import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableCategoryList extends StatelessWidget {
  final List<CategoryItem> categories;

  const ReusableCategoryList({super.key, required this.categories});

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

class CategoryList extends StatelessWidget {
  final String categoryName;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryList({
    super.key,
    required this.categoryName,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              categoryName,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.orange : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
