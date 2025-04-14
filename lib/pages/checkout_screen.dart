import 'package:bhukk/models/menu_item_model.dart';
import 'package:bhukk/models/restaurant_model.dart';
import 'package:bhukk/services/order_service.dart';
import 'package:bhukk/theme/Apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderService _orderService = OrderService();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instructionsController = TextEditingController();

  // Delivery options
  final List<Map<String, dynamic>> _deliveryOptions = [
    {
      'id': 'home_delivery',
      'name': 'Home Delivery',
      'icon': Icons.delivery_dining
    },
    {'id': 'takeaway', 'name': 'Takeaway', 'icon': Icons.shopping_bag},
  ];
  String _selectedDeliveryOption = 'home_delivery';

  // Payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'cod', 'name': 'Cash on Delivery', 'icon': Icons.money},
    {'id': 'card', 'name': 'Card', 'icon': Icons.credit_card},
    {'id': 'upi', 'name': 'UPI', 'icon': Icons.account_balance_wallet},
  ];
  String _selectedPaymentMethod = 'cod';

  // State variables
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  Restaurant? _restaurant;
  Map<int, int>? _cartItems; // menuItemId -> quantity
  List<MenuItem>? _menuItems;
  double _total = 0.0;
  final double _deliveryFee = 40.0;
  final double _taxRate = 0.05; // 5% tax

  @override
  void initState() {
    super.initState();
    _loadCheckoutData();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _loadCheckoutData() {
    final args = Get.arguments;
    if (args != null) {
      setState(() {
        _restaurant = args['restaurant'];
        _cartItems = Map<int, int>.from(args['cartItems']);
        _menuItems = List<MenuItem>.from(args['menuItems']);
        _total = args['total'];
      });
    }
  }

  double get subtotal => _total;
  double get tax => subtotal * _taxRate;
  double get deliveryFee =>
      _selectedDeliveryOption == 'home_delivery' ? _deliveryFee : 0.0;
  double get grandTotal => subtotal + tax + deliveryFee;

  MenuItem _getMenuItem(int id) {
    return _menuItems!.firstWhere((item) => item.id == id);
  }

  Future<void> _placeOrder() async {
    if (_cartItems == null || _cartItems!.isEmpty || _restaurant == null) {
      _showErrorSnackBar('Your cart is empty');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return; // Form validation failed
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      // Prepare order items for API
      final List<Map<String, dynamic>> orderItems = [];
      _cartItems!.forEach((menuItemId, quantity) {
        orderItems.add({
          'menu_item_id': menuItemId,
          'quantity': quantity,
          'unit_price': _getMenuItem(menuItemId).price,
        });
      });

      // Create order via API
      final order = await _orderService.createOrder(
        restaurantId: _restaurant!.id,
        orderItems: orderItems,
        phoneNumber: _phoneController.text,
        deliveryType: _selectedDeliveryOption,
        paymentMethod: _selectedPaymentMethod,
        deliveryAddress: _selectedDeliveryOption == 'home_delivery'
            ? _addressController.text
            : null,
        deliveryInstructions: _instructionsController.text.isNotEmpty
            ? _instructionsController.text
            : null,
      );

      // Show success and navigate
      _showSuccessSnackBar('Order placed successfully!');

      // Navigate to order confirmation or orders list
      Get.offAllNamed('/orders', arguments: {'newOrder': order});
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
      _showErrorSnackBar('Failed to place order: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_restaurant == null || _cartItems == null || _menuItems == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Checkout'),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No checkout data available',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Return to Restaurant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.jaldi(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Processing your order...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error message if any
                    if (_hasError)
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppTheme.errorColor.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: AppTheme.errorColor),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: TextStyle(color: AppTheme.errorColor),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Restaurant info
                    Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: _restaurant!.imageUrl != null &&
                                          _restaurant!.imageUrl!.isNotEmpty
                                      ? NetworkImage(_restaurant!.imageUrl!)
                                          as ImageProvider
                                      : AssetImage('assets/images/bg1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order from',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    _restaurant!.name,
                                    style: GoogleFonts.jaldi(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  Text(
                                    _restaurant!.address,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Order items list
                    Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Order',
                              style: GoogleFonts.jaldi(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor,
                              ),
                            ),
                            SizedBox(height: 16),
                            ..._cartItems!.entries.map((entry) {
                              final menuItem = _getMenuItem(entry.key);
                              final itemTotal = menuItem.price * entry.value;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${entry.value}x',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            menuItem.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.textColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                          if (menuItem.description.isNotEmpty)
                                            Text(
                                              menuItem.description,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '₹${itemTotal.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                            Divider(height: 24, color: Colors.grey.shade200),

                            // Order summary
                            _buildOrderSummaryRow('Subtotal', subtotal),
                            SizedBox(height: 8),
                            _buildOrderSummaryRow('Tax (5%)', tax),
                            SizedBox(height: 8),
                            _buildOrderSummaryRow('Delivery Fee', deliveryFee,
                                footnote: _selectedDeliveryOption == 'takeaway'
                                    ? 'Free for takeaway'
                                    : null),

                            Divider(height: 24, color: Colors.grey.shade200),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: GoogleFonts.jaldi(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                Text(
                                  '₹${grandTotal.toStringAsFixed(2)}',
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
                    ),

                    // Delivery options
                    Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Options',
                              style: GoogleFonts.jaldi(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor,
                              ),
                            ),
                            SizedBox(height: 16),
                            ...List.generate(
                              _deliveryOptions.length,
                              (index) {
                                final option = _deliveryOptions[index];
                                final bool isSelected =
                                    _selectedDeliveryOption == option['id'];

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedDeliveryOption = option['id'];
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                              .withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.grey.shade300,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          option['icon'],
                                          color: isSelected
                                              ? AppTheme.primaryColor
                                              : Colors.grey.shade600,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          option['name'],
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? AppTheme.primaryColor
                                                : AppTheme.textColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Spacer(),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: AppTheme.primaryColor,
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Delivery details
                    if (_selectedDeliveryOption == 'home_delivery')
                      Card(
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery Details',
                                style: GoogleFonts.jaldi(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                  labelText: 'Delivery Address',
                                  prefixIcon: Icon(Icons.location_on),
                                  hintText: 'Enter your full address',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your delivery address';
                                  }
                                  if (value.length < 10) {
                                    return 'Please enter a complete address';
                                  }
                                  return null;
                                },
                                maxLines: 2,
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  prefixIcon: Icon(Icons.phone),
                                  hintText: 'For delivery updates',
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (value.length < 10) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _instructionsController,
                                decoration: InputDecoration(
                                  labelText: 'Delivery Instructions (Optional)',
                                  prefixIcon: Icon(Icons.message),
                                  hintText:
                                      'E.g. Leave at the door, call when arriving, etc.',
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Phone number for takeaway
                    if (_selectedDeliveryOption == 'takeaway')
                      Card(
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Information',
                                style: GoogleFonts.jaldi(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  prefixIcon: Icon(Icons.phone),
                                  hintText: 'For order updates',
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (value.length < 10) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _instructionsController,
                                decoration: InputDecoration(
                                  labelText: 'Special Instructions (Optional)',
                                  prefixIcon: Icon(Icons.message),
                                  hintText: 'E.g. Preferred pickup time, etc.',
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Payment methods
                    Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Method',
                              style: GoogleFonts.jaldi(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor,
                              ),
                            ),
                            SizedBox(height: 16),
                            ...List.generate(
                              _paymentMethods.length,
                              (index) {
                                final method = _paymentMethods[index];
                                final bool isSelected =
                                    _selectedPaymentMethod == method['id'];

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedPaymentMethod = method['id'];
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                              .withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.primaryColor
                                            : Colors.grey.shade300,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          method['icon'],
                                          color: isSelected
                                              ? AppTheme.primaryColor
                                              : Colors.grey.shade600,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          method['name'],
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? AppTheme.primaryColor
                                                : AppTheme.textColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Spacer(),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: AppTheme.primaryColor,
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 80), // Space for bottom button
                  ],
                ),
              ),
            ),
      bottomNavigationBar:
          _restaurant == null || _cartItems == null || _menuItems == null
              ? null
              : Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Processing...',
                                  style: GoogleFonts.jaldi(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Place Order - ₹${grandTotal.toStringAsFixed(2)}',
                              style: GoogleFonts.jaldi(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildOrderSummaryRow(String label, double amount,
      {String? footnote}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
            if (footnote != null)
              Text(
                footnote,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }
}
