import 'package:flutter/material.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';

/// Servicio para gestionar conversiones y formatos de divisas
class CurrencyService {
  CurrencyService._();
  static final CurrencyService instance = CurrencyService._();

  // Tasas de cambio base (COP como referencia)
  static const Map<String, double> exchangeRates = {
    'COP': 1.0,      // Peso colombiano (base)
    'USD': 0.00025,  // Dólar estadounidense
    'BRL': 0.0012,   // Real brasileño
    'EUR': 0.00023,  // Euro
    'JPY': 0.037,    // Yen japonés
  };

  /// Obtiene el símbolo de divisa según el locale actual
  String getCurrencySymbol(BuildContext context) {
    final t = AppLocalizations.of(context);
    return t?.currencySymbol ?? '\$';
  }

  /// Obtiene el código de divisa según el locale actual
  String getCurrencyCode(BuildContext context) {
    final t = AppLocalizations.of(context);
    return t?.currency ?? 'COP';
  }

  /// Convierte un precio de COP a la divisa del locale actual
  double convertFromCOP(double priceInCOP, BuildContext context) {
    final currencyCode = getCurrencyCode(context);
    final rate = exchangeRates[currencyCode] ?? 1.0;
    return priceInCOP * rate;
  }

  /// Formatea un precio en COP a la divisa y formato del locale actual
  String formatPrice(double priceInCOP, BuildContext context) {
    final currencyCode = getCurrencyCode(context);
    final symbol = getCurrencySymbol(context);
    final convertedPrice = convertFromCOP(priceInCOP, context);

    // Formato específico por divisa
    switch (currencyCode) {
      case 'JPY':
        // Yen no usa decimales
        return '$symbol${convertedPrice.round()}';
      case 'EUR':
        // Euro usa coma como separador decimal y va después
        return '${convertedPrice.toStringAsFixed(2).replaceAll('.', ',')}$symbol';
      case 'BRL':
        // Real brasileño usa coma como separador decimal
        return '$symbol ${convertedPrice.toStringAsFixed(2).replaceAll('.', ',')}';
      case 'USD':
        return '$symbol${convertedPrice.toStringAsFixed(2)}';
      case 'COP':
      default:
        // Peso colombiano sin decimales
        return '$symbol${convertedPrice.round().toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}.',
            )}';
    }
  }

  /// Formatea un precio con separadores de miles
  String formatWithThousands(double price, BuildContext context) {
    final currencyCode = getCurrencyCode(context);
    
    switch (currencyCode) {
      case 'JPY':
        return price.round().toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            );
      case 'EUR':
      case 'BRL':
        return price.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}.',
            );
      default:
        return price.toStringAsFixed(2).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            );
    }
  }
}
