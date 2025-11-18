import 'package:flutter/foundation.dart';

/// Servicio simple en memoria para productos. Expone un ValueNotifier para que la UI
/// pueda reaccionar a cambios (añadir/eliminar/limpiar/actualizar).
class ProductService {
  ProductService._private() {
    _seedDefaults();
  }
  static final ProductService instance = ProductService._private();

  final ValueNotifier<List<Map<String, String>>> products = ValueNotifier<List<Map<String, String>>>([]);

  void _seedDefaults() {
    // Productos por defecto que antes estaban en Home
    final defaults = [
      {'name': 'Paracetamol', 'dosage': '500 mg', 'price': '15000', 'description': 'Use según indicación del profesional de la salud.'},
      {'name': 'Ibuprofeno', 'dosage': '200 mg', 'price': '18000', 'description': 'Use según indicación del profesional de la salud.'},
      {'name': 'Amoxicilina', 'dosage': '250 mg', 'price': '21000', 'description': 'Use según indicación del profesional de la salud.'},
      {'name': 'Lorazepam', 'dosage': '1 mg', 'price': '15000', 'description': 'Use según indicación del profesional de la salud.'},
    ];
    products.value = defaults;
  }

  void addProduct(Map<String, String> p) {
    final list = List<Map<String, String>>.from(products.value);
    list.add(p);
    products.value = list;
  }

  void removeProductAt(int index) {
    final list = List<Map<String, String>>.from(products.value);
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      products.value = list;
    }
  }

  void clearProducts() {
    products.value = [];
  }

  void updateProductAt(int index, Map<String, String> updated) {
    final list = List<Map<String, String>>.from(products.value);
    if (index >= 0 && index < list.length) {
      list[index] = updated;
      products.value = list;
    }
  }
}

