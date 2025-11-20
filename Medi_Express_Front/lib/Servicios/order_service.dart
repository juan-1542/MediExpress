import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
    _persist();
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
    _persist();
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
    _persist();
    return removed;
  }

  // Persistencia local: serializamos la lista y latestOrderId en SharedPreferences
  static const _kOrdersKey = 'medi_express_pending_orders_v1';
  static const _kLatestKey = 'medi_express_latest_order_id_v1';

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(pendingOrders.value);
      await prefs.setString(_kOrdersKey, jsonStr);
      if (latestOrderId.value != null) {
        await prefs.setString(_kLatestKey, latestOrderId.value!);
      }
    } catch (e) {
      if (kDebugMode) print('OrderService: persist error: $e');
    }
  }

  /// Marca un pedido como 'arrived' y persiste el cambio.
  bool markArrived(String id) {
    final updated = updateOrder(id, {'arrived': 'true'});
    if (updated) {
      // Asegurar que latestOrderId referencia este pedido para priorizarlo
      latestOrderId.value = id;
      // Persistir el latestOrderId adicional (updateOrder ya llamó a _persist, pero
      // forzamos persistencia adicional por si hay timing)
      _persist();
    }
    return updated;
  }

  /// Marca un pedido como entregado ('finalizado') y persiste el cambio.
  bool markDelivered(String id) {
    return updateOrder(id, {'status': 'finalizado'});
  }

  /// Carga los pedidos guardados en el almacenamiento local. Debe llamarse
  /// una vez al iniciar la app (por ejemplo desde Home.initState).
  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final s = prefs.getString(_kOrdersKey);
      if (s != null && s.isNotEmpty) {
        final decoded = jsonDecode(s) as List<dynamic>;
        final List<Map<String, String>> restored = decoded.map<Map<String, String>>((e) {
          final m = Map<String, dynamic>.from(e as Map);
          return m.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
        }).toList();
        pendingOrders.value = restored;
      }
      final latest = prefs.getString(_kLatestKey);
      if (latest != null && latest.isNotEmpty) latestOrderId.value = latest;
    } catch (e) {
      if (kDebugMode) print('OrderService: load error: $e');
    }
  }

  /// Limpia todos los pedidos pendientes (útil para pruebas)
  void clear() {
    pendingOrders.value = <Map<String, String>>[];
    _persist();
  }
}
