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
    // seed default empty info
    info.value = DistributionInfo(name: 'Punto central', address: 'Dirección por defecto', openingHours: '08:00 - 20:00', available: true);
  }
  static final DistributionService instance = DistributionService._private();

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
    info.value = current.copyWith(name: name, address: address, openingHours: openingHours, available: available);
  }
}

