import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';


class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: FutureBuilder(
        future: cart.fetchCart(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          final items = cart.items;

          if (items.isEmpty) return Center(child: Text("Cart is empty"));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return ListTile(
                      title: Text("${item['name']} x${item['quantity']}"),
                      subtitle: Text("\$${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => cart.remove(item['id']),
                      ),
                    );
                  },
                ),
              ),
              Text("Total: \$${cart.total.toStringAsFixed(2)}"),
              ElevatedButton(onPressed: cart.clear, child: Text("Clear Cart")),
            ],
          );
        },
      ),
    );
  }
}
