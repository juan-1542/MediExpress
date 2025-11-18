import 'package:flutter/material.dart';

class LocaleService {
  LocaleService._();
  static final LocaleService instance = LocaleService._();

  // null => usa el locale del sistema
  final ValueNotifier<Locale?> locale = ValueNotifier<Locale?>(null);

  // Lista de idiomas soportados
  static const supported = <Locale>[
    Locale('es'),
    Locale('en'),
    Locale('de'),
    Locale('fr'),
    Locale('pt'),
  ];

  void setLocale(Locale? l) {
    if (l == null) {
      locale.value = null;
    } else {
      // validar que sea soportado
      final ok = supported.any((x) => x.languageCode == l.languageCode);
      locale.value = ok ? l : null;
    }
  }
}

