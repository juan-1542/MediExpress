import 'package:flutter/foundation.dart';

class OrderService {
  OrderService._private();
  static final OrderService instance = OrderService._private();

  /// Lista de pedidos pendientes expuesta como ValueNotifier para que la UI
  /// pueda reaccionar automáticamente a cambios.
  final ValueNotifier<List<Map<String, String>>> pendingOrders = ValueNotifier(<Map<String, String>>[]);

  /// Añade un pedido al listado de pendientes (al inicio por defecto)
  void addOrder(Map<String, String> order, {bool atStart = true}) {
    final list = List<Map<String, String>>.from(pendingOrders.value);
    if (atStart) list.insert(0, order); else list.add(order);
    pendingOrders.value = list;
  }

  /// Limpia todos los pedidos pendientes (útil para pruebas)
  void clear() {
    pendingOrders.value = <Map<String, String>>[];
  }
}
