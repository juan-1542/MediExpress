import 'package:flutter/foundation.dart';

class OrderService {
  OrderService._private();
  static final OrderService instance = OrderService._private();

  /// Lista de pedidos pendientes expuesta como ValueNotifier para que la UI
  /// pueda reaccionar automáticamente a cambios.
  final ValueNotifier<List<Map<String, String>>> pendingOrders = ValueNotifier(<Map<String, String>>[]);

  /// Añade un pedido al listado de pendientes (al inicio por defecto)
  /// Normaliza la estructura para incluir 'status' y 'courier'.
  void addOrder(Map<String, String> order, {bool atStart = true}) {
    final normalized = Map<String, String>.from(order);
    normalized['status'] = normalized['status'] ?? 'pendiente';
    normalized['courier'] = normalized['courier'] ?? '';

    final list = List<Map<String, String>>.from(pendingOrders.value);
    if (atStart) list.insert(0, normalized);
    else list.add(normalized);
    pendingOrders.value = list;
  }

  /// Actualiza un pedido existente por su id. Merge de campos proporcionados.
  /// Retorna true si se actualizó algún pedido.
  bool updateOrder(String id, Map<String, String> updates) {
    final list = List<Map<String, String>>.from(pendingOrders.value);
    final idx = list.indexWhere((p) => p['id'] == id);
    if (idx < 0) return false;
    final existing = Map<String, String>.from(list[idx]);
    updates.forEach((k, v) {
      existing[k] = v;
    });
    list[idx] = existing;
    pendingOrders.value = list;
    return true;
  }

  /// Recupera un pedido por id o null si no existe
  Map<String, String>? getOrderById(String id) {
    return pendingOrders.value.firstWhere((p) => p['id'] == id, orElse: () => <String, String>{})?.isEmpty == true ? null : pendingOrders.value.firstWhere((p) => p['id'] == id, orElse: () => {});
  }

  /// Eliminar un pedido por id
  bool removeOrderById(String id) {
    final list = List<Map<String, String>>.from(pendingOrders.value);
    final removed = list.removeWhere((p) => p['id'] == id);
    // removeWhere returns void; recompute presence
    final exists = list.any((p) => p['id'] == id);
    pendingOrders.value = list;
    return !exists;
  }

  /// Limpia todos los pedidos pendientes (útil para pruebas)
  void clear() {
    pendingOrders.value = <Map<String, String>>[];
  }
}
