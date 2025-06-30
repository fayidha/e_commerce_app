import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final cartRef = FirebaseFirestore.instance.collection('cart');

  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  double get total => _items.fold(0, (sum, item) => sum + item['price'] * item['quantity']);

  Future<void> fetchCart() async {
    final snapshot = await cartRef.get();
    _items = snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    notifyListeners();
  }

  Future<void> add(Map<String, dynamic> item) async {
    final existing = _items.firstWhere((i) => i['name'] == item['name'], orElse: () => {});
    if (existing.isNotEmpty) {
      await cartRef.doc(existing['id']).update({'quantity': existing['quantity'] + 1});
    } else {
      await cartRef.add(item);
    }
    await fetchCart();
  }

  Future<void> remove(String id) async {
    await cartRef.doc(id).delete();
    await fetchCart();
  }

  Future<void> clear() async {
    final batch = FirebaseFirestore.instance.batch();
    for (var item in _items) {
      batch.delete(cartRef.doc(item['id']));
    }
    await batch.commit();
    await fetchCart();
  }
}
