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
    // Primero verificar si ya hay productos
    if (products.value.isNotEmpty) {
      ensureAllProductsHaveLanguageNames();
      return;
    }
    
    // Productos por defecto con nombres en múltiples idiomas
    final defaults = [
      {
        'name': 'Paracetamol',
        'name_es': 'Paracetamol',
        'name_en': 'Paracetamol',
        'name_pt': 'Paracetamol',
        'name_fr': 'Paracétamol',
        'name_ja': 'パラセタモール',
        'dosage': '500 mg',
        'price': '15000',
        'description': 'Use según indicación del profesional de la salud.',
        'quantity': '10'
      },
      {
        'name': 'Ibuprofeno',
        'name_es': 'Ibuprofeno',
        'name_en': 'Ibuprofen',
        'name_pt': 'Ibuprofeno',
        'name_fr': 'Ibuprofène',
        'name_ja': 'イブプロフェン',
        'dosage': '200 mg',
        'price': '18000',
        'description': 'Use según indicación del profesional de la salud.',
        'quantity': '8'
      },
      {
        'name': 'Amoxicilina',
        'name_es': 'Amoxicilina',
        'name_en': 'Amoxicillin',
        'name_pt': 'Amoxicilina',
        'name_fr': 'Amoxicilline',
        'name_ja': 'アモキシシリン',
        'dosage': '250 mg',
        'price': '21000',
        'description': 'Use según indicación del profesional de la salud.',
        'quantity': '5'
      },
      {
        'name': 'Lorazepam',
        'name_es': 'Lorazepam',
        'name_en': 'Lorazepam',
        'name_pt': 'Lorazepam',
        'name_fr': 'Lorazépam',
        'name_ja': 'ロラゼパム',
        'dosage': '1 mg',
        'price': '15000',
        'description': 'Use según indicación del profesional de la salud.',
        'quantity': '12'
      },
      {
        'name': 'Aspirina',
        'name_es': 'Aspirina',
        'name_en': 'Aspirin',
        'name_pt': 'Aspirina',
        'name_fr': 'Aspirine',
        'name_ja': 'アスピリン',
        'dosage': '30mg',
        'price': '15000',
        'description': 'Use según indicación del profesional de la salud.',
        'quantity': '20'
      },
    ];
    products.value = defaults;
  }

  /// Obtiene el nombre del producto según el idioma especificado
  String getProductName(Map<String, String> product, String languageCode) {
    final nameKey = 'name_$languageCode';
    return product[nameKey] ?? product['name'] ?? 'Unknown';
  }

  /// Asegura que todos los productos tengan campos de nombre para todos los idiomas
  void ensureAllProductsHaveLanguageNames() {
    final updatedProducts = <Map<String, String>>[];
    for (final product in products.value) {
      final updated = Map<String, String>.from(product);
      final baseName = product['name'] ?? 'Unknown';
      
      // Si faltan campos de idioma, usar el nombre base
      if (!updated.containsKey('name_es') || updated['name_es']!.isEmpty) {
        updated['name_es'] = baseName;
      }
      if (!updated.containsKey('name_en') || updated['name_en']!.isEmpty) {
        updated['name_en'] = baseName;
      }
      if (!updated.containsKey('name_pt') || updated['name_pt']!.isEmpty) {
        updated['name_pt'] = baseName;
      }
      if (!updated.containsKey('name_fr') || updated['name_fr']!.isEmpty) {
        updated['name_fr'] = baseName;
      }
      if (!updated.containsKey('name_ja') || updated['name_ja']!.isEmpty) {
        updated['name_ja'] = baseName;
      }
      
      updatedProducts.add(updated);
    }
    products.value = updatedProducts;
  }

  void addProduct(Map<String, String> p) {
    final list = List<Map<String, String>>.from(products.value);
    // Asegurar que el producto tenga todos los campos de idioma
    final product = Map<String, String>.from(p);
    final baseName = product['name'] ?? 'Unknown';
    product['name_es'] ??= baseName;
    product['name_en'] ??= baseName;
    product['name_pt'] ??= baseName;
    product['name_fr'] ??= baseName;
    product['name_ja'] ??= baseName;
    list.add(product);
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

