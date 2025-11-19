import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final String price; // mantenemos formato de string por ahora
  int quantity;
  final String? image;
  final int maxStock; // cantidad máxima disponible en inventario

  CartItem({
    required this.name, 
    required this.price, 
    this.quantity = 1, 
    this.image,
    this.maxStock = 999, // por defecto, sin límite efectivo
  });
}

class CartService {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  void addItem(CartItem item) {
    // Si existe el mismo nombre, incrementa la cantidad
    final idx = items.value.indexWhere((i) => i.name == item.name);
    if (idx >= 0) {
      final currentItem = items.value[idx];
      final newQty = currentItem.quantity + item.quantity;
      // No exceder el stock máximo
      items.value[idx].quantity = newQty > currentItem.maxStock ? currentItem.maxStock : newQty;
      // trigger notifier
      items.value = List<CartItem>.from(items.value);
    } else {
      items.value = List<CartItem>.from(items.value)..add(item);
    }
  }

  void removeItem(String itemName) {
    items.value = items.value.where((i) => i.name != itemName).toList();
  }

  void updateQuantity(String itemName, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemName);
      return;
    }
    final idx = items.value.indexWhere((i) => i.name == itemName);
    if (idx >= 0) {
      final maxStock = items.value[idx].maxStock;
      items.value[idx].quantity = newQuantity > maxStock ? maxStock : newQuantity;
      items.value = List<CartItem>.from(items.value);
    }
  }

  void incrementQuantity(String itemName) {
    final idx = items.value.indexWhere((i) => i.name == itemName);
    if (idx >= 0) {
      final item = items.value[idx];
      if (item.quantity < item.maxStock) {
        items.value[idx].quantity++;
        items.value = List<CartItem>.from(items.value);
      }
    }
  }

  void decrementQuantity(String itemName) {
    final idx = items.value.indexWhere((i) => i.name == itemName);
    if (idx >= 0) {
      if (items.value[idx].quantity > 1) {
        items.value[idx].quantity--;
        items.value = List<CartItem>.from(items.value);
      } else {
        removeItem(itemName);
      }
    }
  }

  // Verifica si se puede incrementar la cantidad (útil para deshabilitar botones)
  bool canIncrementQuantity(String itemName) {
    final idx = items.value.indexWhere((i) => i.name == itemName);
    if (idx >= 0) {
      final item = items.value[idx];
      return item.quantity < item.maxStock;
    }
    return false;
  }

  void clear() {
    items.value = [];
  }

  int get totalCount => items.value.fold(0, (p, c) => p + c.quantity);
}

