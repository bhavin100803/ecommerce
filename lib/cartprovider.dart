import 'package:flutter/material.dart';
import 'carditem_modal.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get total =>
      _items.fold(0, (sum, item) => sum + item.product['price'] * item.quantity);

  void addToCart(dynamic product) {
    final index = _items.indexWhere((item) => item.product['id'] == product['id']);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(dynamic product) {
    _items.removeWhere((item) => item.product['id'] == product['id']);
    notifyListeners();
  }

  void increaseQuantity(dynamic product) {
    final index = _items.indexWhere((item) => item.product['id'] == product['id']);
    _items[index].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(dynamic product) {
    final index = _items.indexWhere((item) => item.product['id'] == product['id']);
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      removeFromCart(product);
    }
    notifyListeners();
  }
}
