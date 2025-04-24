import 'package:bhukk/models/menu_item_model.dart';
import 'package:bhukk/models/restaurant_model.dart';
import 'package:bhukk/services/restaurant_service.dart';
import 'package:bhukk/theme/Apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with SingleTickerProviderStateMixin {
  final RestaurantService _restaurantService = RestaurantService();
  late TabController _tabController;
  List<MenuItem> _menuItems = [];
  Map<String, List<MenuItem>> _categorizedMenu = {};
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isTableBooking = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 19, minute: 0);
  int _selectedPeople = 2;

  // For cart items
  final Map<int, int> _cartItems = {}; // menuItemId -> quantity
  double _cartTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMenuItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMenuItems() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final menuItems =
          await _restaurantService.getRestaurantMenuItems(widget.restaurant.id);

      // Group menu items by category
      final categorizedMenu = <String, List<MenuItem>>{};
      for (var item in menuItems) {
        if (!categorizedMenu.containsKey(item.category)) {
          categorizedMenu[item.category] = [];
        }
        categorizedMenu[item.category]!.add(item);
      }

      setState(() {
        _menuItems = menuItems;
        _categorizedMenu = categorizedMenu;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load menu items'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _addToCart(MenuItem item) {
    if (!item.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This item is currently unavailable'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      if (_cartItems.containsKey(item.id)) {
        _cartItems[item.id] = (_cartItems[item.id] ?? 0) + 1;
      } else {
        _cartItems[item.id] = 1;
      }
      _cartTotal += item.price;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _removeFromCart(MenuItem item) {
    setState(() {
      if (_cartItems.containsKey(item.id)) {
        if (_cartItems[item.id]! > 1) {
          _cartItems[item.id] = _cartItems[item.id]! - 1;
        } else {
          _cartItems.remove(item.id);
        }
        _cartTotal -= item.price;
      }
    });
  }

  int _getItemQuantity(int itemId) {
    return _cartItems[itemId] ?? 0;
  }

  Widget _buildMenuItemCard(MenuItem item) {
    final quantity = _getItemQuantity(item.id);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Food image placeholder or actual image
            Hero(
              tag: 'menu_item_${item.id}',
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/images/pancake.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Menu item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.jaldi(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹${item.price.toStringAsFixed(2)}',
                        style: GoogleFonts.jaldi(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Add/Remove buttons
            if (!item.isAvailable)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  'Out of Stock',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else if (quantity > 0)
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _removeFromCart(item),
                      icon: const Icon(Icons.remove,
                          color: AppTheme.primaryColor),
                      iconSize: 20,
                      constraints:
                          const BoxConstraints(maxWidth: 32, minWidth: 32),
                      padding: EdgeInsets.zero,
                    ),
                    Container(
                      width: 30,
                      alignment: Alignment.center,
                      child: Text(
                        '$quantity',
                        style: GoogleFonts.jaldi(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _addToCart(item),
                      icon: const Icon(Icons.add, color: AppTheme.primaryColor),
                      iconSize: 20,
                      constraints:
                          const BoxConstraints(maxWidth: 32, minWidth: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              )
            else
              ElevatedButton(
                onPressed: () => _addToCart(item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(40, 32),
                ),
                child: const Text('Add'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load menu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadMenuItems,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading menu...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBookingView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book a Table',
            style: GoogleFonts.jaldi(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),

          // Date Picker
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppTheme.primaryColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time Picker
          InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppTheme.primaryColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (time != null) {
                setState(() {
                  _selectedTime = time;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Number of People
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Number of People',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 1; i <= 6; i++) _buildPeopleButton(i),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Notes field
          TextField(
            decoration: InputDecoration(
              labelText: 'Special Requests (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Any special requests for your booking...',
              floatingLabelStyle: const TextStyle(color: AppTheme.primaryColor),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          // Book Table Button
          ElevatedButton(
            onPressed: () {
              // Implement booking functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Table booking requested! We will notify you when confirmed.'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Book Table',
              style: GoogleFonts.jaldi(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleButton(int number) {
    final bool isSelected = number == _selectedPeople;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPeople = number;
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
          shape: BoxShape.circle,
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            '$number',
            style: GoogleFonts.jaldi(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppTheme.textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with restaurant image header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.restaurant.name,
                style: GoogleFonts.jaldi(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'restaurant_image_${widget.restaurant.id}',
                    child: Image.network(
                      widget.restaurant.imageUrl ??
                          'https://via.placeholder.com/400x200',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/bg1.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Sharing restaurant details...')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to favorites!')),
                  );
                },
              ),
            ],
          ),

          // Restaurant Info Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.restaurant.rating}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.restaurant.distance?.toStringAsFixed(1) ?? "?"} km away',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade700),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.restaurant.isOpen ?? true
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.restaurant.isOpen ?? true
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                          ),
                        ),
                        child: Text(
                          widget.restaurant.isOpen ?? true ? 'Open' : 'Closed',
                          style: TextStyle(
                            color: widget.restaurant.isOpen ?? true
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.restaurant.cuisineType,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.restaurant.openingTime} - ${widget.restaurant.closingTime}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.map, size: 16, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.restaurant.address ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.restaurant.description ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverToBoxAdapter(
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primaryColor,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Menu'),
                Tab(text: 'Book Table'),
              ],
              onTap: (index) {
                setState(() {
                  _isTableBooking = index == 1;
                });
              },
            ),
          ),

          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Menu Tab
                _isLoading
                    ? _buildLoadingView()
                    : _hasError
                        ? _buildErrorView()
                        : _menuItems.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.restaurant_menu,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No menu items available',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: _categorizedMenu.length,
                                itemBuilder: (context, index) {
                                  final category =
                                      _categorizedMenu.keys.elementAt(index);
                                  final items = _categorizedMenu[category]!;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 16, 8, 12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            category,
                                            style: GoogleFonts.jaldi(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...items.map(
                                          (item) => _buildMenuItemCard(item)),
                                      const SizedBox(height: 8),
                                    ],
                                  );
                                },
                              ),

                // Book Table Tab
                SingleChildScrollView(child: _buildTableBookingView()),
              ],
            ),
          ),
        ],
      ),

      // Bottom cart bar
      bottomNavigationBar: _cartItems.isEmpty || _isTableBooking
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _cartItems.isNotEmpty
                              ? '${_cartItems.values.reduce((a, b) => a + b)} items'
                              : '0 items',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          '₹${_cartTotal.toStringAsFixed(2)}',
                          style: GoogleFonts.jaldi(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to checkout screen
                          Get.toNamed('/checkout', arguments: {
                            'restaurant': widget.restaurant,
                            'cartItems': _cartItems,
                            'menuItems': _menuItems,
                            'total': _cartTotal,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'View Cart & Checkout',
                          style: GoogleFonts.jaldi(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
