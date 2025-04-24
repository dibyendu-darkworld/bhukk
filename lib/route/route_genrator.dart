import 'package:bhukk/models/order_model.dart';
import 'package:bhukk/models/restaurant_model.dart';
import 'package:bhukk/pages/auth_screen.dart';
import 'package:bhukk/pages/checkout_screen.dart';
import 'package:bhukk/pages/get_started_screen.dart';
import 'package:bhukk/pages/home_screen.dart';
import 'package:bhukk/pages/orders_screen.dart';
import 'package:bhukk/pages/profile_screen.dart';
import 'package:bhukk/pages/restaurant_details_screen.dart';
import 'package:bhukk/pages/spalsh_screen.dart';
import 'package:bhukk/route/routes.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget widgetScreen;
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        widgetScreen = const SplashScreen();
        break;

      case Routes.getstarted:
        widgetScreen = const GetStartedScreen();
        break;

      case Routes.home:
        widgetScreen = const HomeScreen();
        break;

      case Routes.auth:
      case Routes.login:
      case Routes.register:
        widgetScreen = const AuthScreen();
        break;

      case Routes.restaurantDetails:
        if (args is Restaurant) {
          widgetScreen = RestaurantDetailsScreen(restaurant: args);
        } else {
          widgetScreen =
              _errorRoute('Restaurant details require a restaurant object');
        }
        break;

      case Routes.checkout:
        widgetScreen = const CheckoutScreen();
        break;

      case Routes.orders:
        widgetScreen = const OrdersScreen();
        break;

      case Routes.orderDetails:
        if (args is Order) {
          widgetScreen = Scaffold(
            appBar: AppBar(title: Text('Order #${args.id}')),
            body: const Center(
                child: Text('Order details screen to be implemented')),
          );
        } else {
          widgetScreen = _errorRoute('Order details require an order object');
        }
        break;

      case Routes.orderConfirmation:
        widgetScreen = Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 100, color: Colors.green),
                const SizedBox(height: 24),
                const Text(
                  'Order Confirmed!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Your order has been placed successfully'),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.of(
                    navigatorKey.currentContext!,
                  ).pushReplacementNamed(Routes.orders),
                  child: const Text('Track Your Order'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(
                    navigatorKey.currentContext!,
                  ).pushReplacementNamed(Routes.home),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        );
        break;

      case Routes.profile:
        widgetScreen = const ProfileScreen();
        break;

      case Routes.editProfile:
      case Routes.personalInfo:
      case Routes.paymentMethods:
      case Routes.addresses:
      case Routes.favorites:
      case Routes.preferences:
      case Routes.support:
        // Placeholder screens for features to be implemented
        final title = _getTitleFromRouteName(settings.name ?? '');
        widgetScreen = Scaffold(
          appBar: AppBar(title: Text(title)),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction, size: 80, color: Colors.orange),
                SizedBox(height: 16),
                Text(
                  'Coming Soon',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('This feature is under development'),
              ],
            ),
          ),
        );
        break;

      default:
        widgetScreen = _errorRoute('Route not found');
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => widgetScreen,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static Widget _errorRoute(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static String _getTitleFromRouteName(String routeName) {
    final name = routeName.replaceAll('/', '').replaceAll('-', ' ');
    return name
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  // Global navigator key for accessing navigator from anywhere
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
