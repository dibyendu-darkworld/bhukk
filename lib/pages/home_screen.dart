import 'package:bhukk/components/CardList.dart';
import 'package:bhukk/components/CategoryList.dart';
import 'package:bhukk/components/ReusableCarousel.dart';
import 'package:bhukk/components/Restaurent.dart';
import 'package:bhukk/models/restaurant_model.dart';
import 'package:bhukk/services/restaurant_service.dart';
import 'package:bhukk/theme/Apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bhukk/route/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  List<Restaurant> _nearbyRestaurants = [];
  List<Restaurant> _allRestaurants = [];
  bool _isLoading = true;
  bool _isNearbyLoading = false;
  bool _isLocationEnabled = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  // Images for carousel
  final List<String> _carouselItems = [
    'assets/images/combo.gif',
    'assets/images/pancake.png',
    'assets/images/burgeradd.png',
  ];

  // Food categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.restaurant},
    {'name': 'Italian', 'icon': Icons.local_pizza},
    {'name': 'Indian', 'icon': Icons.dinner_dining},
    {'name': 'Chinese', 'icon': Icons.rice_bowl},
    {'name': 'Fast Food', 'icon': Icons.fastfood},
    {'name': 'Desserts', 'icon': Icons.icecream},
    {'name': 'Healthy', 'icon': Icons.eco},
  ];

  @override
  void initState() {
    super.initState();
    // Load restaurants without checking location first
    _loadRestaurants();
    // Check location permission after initial setup
    _initializeLocationServices();

    // Setup scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMoreData &&
          !_isLoading) {
        _loadMoreRestaurants();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocationServices() async {
    // Give the app a moment to initialize plugins
    Future.delayed(Duration(milliseconds: 500), () {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLocationEnabled = false;
        });
        return;
      }

      // Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLocationEnabled = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLocationEnabled = false;
        });
        return;
      }

      setState(() {
        _isLocationEnabled = true;
      });
      _loadNearbyRestaurants();
    } catch (e) {
      print('Error checking location permission: $e');
      setState(() {
        _isLocationEnabled = false;
      });
    }
  }

  Future<void> _loadRestaurants() async {
    if (_isLoading && _currentPage > 0) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final restaurants = await _restaurantService.getAllRestaurants(
        skip: _currentPage * 10,
        limit: 10,
      );

      setState(() {
        if (_currentPage == 0) {
          _allRestaurants = restaurants;
        } else {
          _allRestaurants.addAll(restaurants);
        }
        _isLoading = false;
        _hasError = false;
        _hasMoreData = restaurants.length == 10;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load restaurants: ${e.toString()}';
      });
    }
  }

  Future<void> _loadMoreRestaurants() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    await _loadRestaurants();

    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _currentPage = 0;
    });
    await _loadRestaurants();
    if (_isLocationEnabled) {
      await _loadNearbyRestaurants();
    }
  }

  Future<void> _loadNearbyRestaurants() async {
    if (!_isLocationEnabled) return;

    setState(() {
      _isNearbyLoading = true;
    });

    try {
      final position = await Geolocator.getCurrentPosition();
      final nearbyRestaurants = await _restaurantService.getNearbyRestaurants(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: 10.0,
      );

      setState(() {
        _nearbyRestaurants = nearbyRestaurants;
        _isNearbyLoading = false;
      });
    } catch (e) {
      print('Error getting nearby restaurants: $e');
      setState(() {
        _isNearbyLoading = false;
      });
    }
  }

  List<Restaurant> get _filteredRestaurants {
    if (_selectedCategory == 'All') {
      return _allRestaurants;
    }

    return _allRestaurants
        .where((restaurant) =>
            restaurant.cuisineType.toLowerCase() ==
            _selectedCategory.toLowerCase())
        .toList();
  }

  void _navigateToRestaurantDetails(Restaurant restaurant) {
    Get.toNamed(Routes.restaurantDetails, arguments: restaurant);
  }

  void _navigateToSearch() {
    // Implement search navigation
    Get.toNamed(Routes.search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: Text(
          'Bhukk',
          style: GoogleFonts.jaldi(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: _navigateToSearch,
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => Get.toNamed(Routes.profile),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.primaryColor,
        child: _hasError ? _buildErrorView() : _buildMainContent(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: AppTheme.errorColor,
          ),
          SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return _isLoading && _currentPage == 0
        ? _buildLoadingView()
        : SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location header
                _buildLocationHeader(),

                // Promotions carousel
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ReusableCarousel(
                    items: _carouselItems,
                    carouselHeight: 180,
                  ),
                ),

                // Categories section
                _buildCategoriesSection(),

                // Nearby restaurants section
                _buildNearbyRestaurantsSection(),

                // All/filtered restaurants section
                _buildFilteredRestaurantsSection(),

                // Loading more indicator
                if (_isLoadingMore)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor),
                      ),
                    ),
                  ),

                SizedBox(height: 16),
              ],
            ),
          );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            'Loading restaurants...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.primaryColor,
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _isLocationEnabled
                  ? 'Delivering to your current location'
                  : 'Location services disabled',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_isLocationEnabled)
            TextButton(
              onPressed: () {
                // Navigate to change location screen
              },
              child: Text(
                'Change',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Categories',
            style: GoogleFonts.jaldi(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return CategoryList(
                categoryName: category['name'],
                icon: category['icon'],
                isSelected: _selectedCategory == category['name'],
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyRestaurantsSection() {
    if (_nearbyRestaurants.isEmpty && !_isNearbyLoading) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Restaurants',
                style: GoogleFonts.jaldi(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_nearbyRestaurants.length > 5)
                TextButton(
                  onPressed: () {
                    // View all nearby restaurants
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        _isNearbyLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                ),
              )
            : SizedBox(
                height: 220,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _nearbyRestaurants.length,
                  itemBuilder: (context, index) {
                    return Restaurent(
                      restaurant: _nearbyRestaurants[index],
                      onTap: () => _navigateToRestaurantDetails(
                          _nearbyRestaurants[index]),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildFilteredRestaurantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            _selectedCategory == 'All'
                ? 'All Restaurants'
                : '$_selectedCategory Restaurants',
            style: GoogleFonts.jaldi(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _filteredRestaurants.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'No restaurants found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _filteredRestaurants.length,
                itemBuilder: (context, index) {
                  return CardList(
                    restaurant: _filteredRestaurants[index],
                    onTap: () => _navigateToRestaurantDetails(
                        _filteredRestaurants[index]),
                  );
                },
              ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        // Handle bottom navigation
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            // Navigate to search
            _navigateToSearch();
            break;
          case 2:
            // Navigate to orders
            Get.toNamed(Routes.orders);
            break;
          case 3:
            // Navigate to profile
            Get.toNamed(Routes.profile);
            break;
        }
      },
    );
  }
}
