import 'package:flutter/foundation.dart';

class DistributionInfo {
  final String name;
  final String address;
  final String openingHours;
  final bool available;

  DistributionInfo({
    required this.name,
    required this.address,
    required this.openingHours,
    required this.available,
  });

  DistributionInfo copyWith({String? name, String? address, String? openingHours, bool? available}) {
    return DistributionInfo(
      name: name ?? this.name,
      address: address ?? this.address,
      openingHours: openingHours ?? this.openingHours,
      available: available ?? this.available,
    );
  }
}

class DistributionService {
  DistributionService._private() {
    // Sembrar locales por defecto
    final defaults = [
      DistributionInfo(name: 'Punto central', address: 'Cra 10 # 20-30', openingHours: '08:00 - 20:00', available: true),
      DistributionInfo(name: 'Punto norte', address: 'Av. 7 Norte # 120-15', openingHours: '09:00 - 18:00', available: true),
      DistributionInfo(name: 'Punto sur', address: 'Cll 30 Sur # 45-12', openingHours: '07:00 - 19:00', available: true),
      // Nuevos locales por defecto
      DistributionInfo(name: 'Punto occidente', address: 'Av. 4 Oeste # 12-34', openingHours: '09:00 - 19:00', available: true),
      DistributionInfo(name: 'Punto oriente', address: 'Cll 50 Este # 8-20', openingHours: '08:30 - 18:30', available: true),
      DistributionInfo(name: 'Centro Comercial A', address: 'CC A, Local 215', openingHours: '10:00 - 21:00', available: true),
      DistributionInfo(name: 'Campus Universitario', address: 'Cra 1 # 70-50', openingHours: '08:00 - 17:00', available: false),
      DistributionInfo(name: 'Estación Central', address: 'Av. Principal # 1-99', openingHours: '06:00 - 22:00', available: true),
    ];
    points.value = defaults;
    info.value = defaults.first;
  }
  static final DistributionService instance = DistributionService._private();

  // Lista de locales disponibles
  final ValueNotifier<List<DistributionInfo>> points = ValueNotifier<List<DistributionInfo>>([]);

  // Local seleccionado actualmente (compatibilidad con código existente)
  final ValueNotifier<DistributionInfo?> info = ValueNotifier<DistributionInfo?>(null);

  void setInfo(DistributionInfo d) {
    info.value = d;
  }

  void update({String? name, String? address, String? openingHours, bool? available}) {
    final current = info.value;
    if (current == null) {
      info.value = DistributionInfo(
        name: name ?? '',
        address: address ?? '',
        openingHours: openingHours ?? '',
        available: available ?? false,
      );
      return;
    }
    final updated = current.copyWith(name: name, address: address, openingHours: openingHours, available: available);
    info.value = updated;

    // actualizar también en la lista
    final list = List<DistributionInfo>.from(points.value);
    final idx = list.indexWhere((p) => p.name == current.name);
    if (idx >= 0) {
      list[idx] = updated;
      points.value = list;
    }
  }

  // Selección por nombre
  void selectPointByName(String name) {
    final list = points.value;
    if (list.isEmpty) return;
    final found = list.firstWhere((p) => p.name == name, orElse: () => list.first);
    info.value = found;
  }

  // Añadir nuevo local
  void addPoint(DistributionInfo d) {
    final list = List<DistributionInfo>.from(points.value)..add(d);
    points.value = list;
    // si no hay seleccionado, seleccionarlo
    info.value ??= d;
  }

  // Eliminar local por índice (para panel admin)
  void removePointAt(int index) {
    final list = List<DistributionInfo>.from(points.value);
    if (index < 0 || index >= list.length) return;
    final removed = list.removeAt(index);
    points.value = list;
    // Si el eliminado era el seleccionado, seleccionar el primero disponible
    if (info.value?.name == removed.name) {
      info.value = list.isNotEmpty ? list.first : null;
    }
  }
}
