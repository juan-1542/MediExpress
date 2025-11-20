import 'package:flutter/foundation.dart';

class OrderService {
  OrderService._private();
  static final OrderService instance = OrderService._private();

  /// Lista de pedidos pendientes expuesta como ValueNotifier para que la UI
  /// pueda reaccionar automáticamente a cambios.
  final ValueNotifier<List<Map<String, String>>> pendingOrders = ValueNotifier(<Map<String, String>>[]);

  /// ID del último pedido creado (útil para que la pantalla de estado muestre
  /// el pedido más reciente aunque el usuario cierre sesión). Nullable.
  final ValueNotifier<String?> latestOrderId = ValueNotifier<String?>(null);

  /// Añade un pedido al listado de pendientes (al inicio por defecto)
  /// Normaliza la estructura para incluir 'status' y 'courier'.
  void addOrder(Map<String, String> order, {bool atStart = true}) {
    final normalized = Map<String, String>.from(order);
    normalized['status'] = normalized['status'] ?? 'pendiente';
    normalized['courier'] = normalized['courier'] ?? '';
    // Si el pedido tiene id, actualizar latestOrderId para que la pantalla de estado
    // pueda mostrar el último pedido incluso después de logout.
    if (normalized['id'] != null && normalized['id']!.isNotEmpty) {
      latestOrderId.value = normalized['id'];
    }

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
    // Si se actualiza el último pedido, refrescar latestOrderId (no cambia el valor
    // pero garantiza que cualquier escucha lo pueda usar). No es estrictamente
    // necesario, pero lo dejamos por coherencia.
    if (latestOrderId.value == id) latestOrderId.value = id;
    return true;
  }

  /// Recupera un pedido por id o null si no existe
  Map<String, String>? getOrderById(String id) {
    final list = pendingOrders.value;
    final idx = list.indexWhere((p) => p['id'] == id);
    if (idx < 0) return null;
    return Map<String, String>.from(list[idx]);
  }

  /// Eliminar un pedido por id
  bool removeOrderById(String id) {
    final list = List<Map<String, String>>.from(pendingOrders.value);
    final initialLength = list.length;
    list.removeWhere((p) => p['id'] == id);
    final removed = list.length < initialLength;
    pendingOrders.value = list;
    return removed;
  }

  /// Limpia todos los pedidos pendientes (útil para pruebas)
  void clear() {
    pendingOrders.value = <Map<String, String>>[];
  }
}
