import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bhukk/models/carousel_item_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReusableCarousel extends StatelessWidget {
  final List<dynamic> items;
  final double carouselHeight;
  final bool useNetworkImage;
  final Function(String?)? onItemTap;

  const ReusableCarousel({
    Key? key,
    required this.items,
    this.carouselHeight = 180,
    this.useNetworkImage = false,
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: carouselHeight,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: items.map((item) {
        return Builder(
          builder: (BuildContext context) {
            String? imageUrl;
            String? redirectUrl;

            if (item is CarouselItem) {
              imageUrl = item.imageUrl;
              redirectUrl = item.redirectUrl;
            } else if (item is String) {
              imageUrl = item;
            }

            return GestureDetector(
              onTap: () {
                if (onItemTap != null) {
                  onItemTap!(redirectUrl);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: useNetworkImage && imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.broken_image, size: 50),
                          ),
                        )
                      : Image(
                          image: AssetImage(
                              imageUrl ?? 'assets/images/placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
