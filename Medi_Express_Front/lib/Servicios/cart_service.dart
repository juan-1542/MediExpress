import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final String price; // mantenemos formato de string por ahora
  int quantity;
  final String? image;

  CartItem({required this.name, required this.price, this.quantity = 1, this.image});
}

class CartService {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  void addItem(CartItem item) {
    // Si existe el mismo nombre, incrementa la cantidad
    final idx = items.value.indexWhere((i) => i.name == item.name);
    if (idx >= 0) {
      items.value[idx].quantity += item.quantity;
      // trigger notifier
      items.value = List<CartItem>.from(items.value);
    } else {
      items.value = List<CartItem>.from(items.value)..add(item);
    }
  }

  void clear() {
    items.value = [];
  }

  int get totalCount => items.value.fold(0, (p, c) => p + c.quantity);
}

