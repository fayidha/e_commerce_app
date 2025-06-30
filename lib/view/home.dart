import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/cart_provider.dart';
import 'cart.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  // Products with images from assets
  final products = [
    {"name": "Phone", "price": 300.0, "image": "assets/phone.avif"},
    {"name": "Headphones", "price": 150.0, "image": "assets/img1.avif"},
  ];

  // Logout and clear shared preferences
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.fetchCart();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(8),
        children: products.map((p) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  p['image'] as String,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8),
                Text(
                  p['name'] as String,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('\$${(p['price'] as double).toStringAsFixed(2)}'),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    cart.add({
                      "name": p['name'] as String,
                      "price": p['price'] as double,
                      "quantity": 1,
                    });
                  },
                  child: Text("Add to Cart"),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
