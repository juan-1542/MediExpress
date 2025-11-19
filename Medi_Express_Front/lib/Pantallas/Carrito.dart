import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/cart_service.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  int _parsePrice(String p) {
    final digits = p.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  String _formatPrice(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(locale: l10n.localeName, symbol: '\$', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE8F9FF),
        elevation: 0,
        title: Text(l10n.cartTitle, style: TextStyle(color: Color(0xFF0A365A), fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Color(0xFF4A90E2)),
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartService.instance.items,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.cartEmpty));
          }

          final total = items.fold<int>(0, (sum, it) => sum + (_parsePrice(it.price) * it.quantity));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final it = items[index];
                      final unit = _parsePrice(it.price);
                      final subtotal = unit * it.quantity;
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: Offset(0, 6))],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xFFBEEFFB), Color(0xFF7EC8E3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: it.image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(it.image!, fit: BoxFit.cover),
                                      )
                                    : Icon(Icons.medication, color: Color(0xFF4A90E2)),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(it.name, style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF123A5A))),
                                    SizedBox(height: 6),
                                    Text(_formatPrice(context, unit), style: TextStyle(color: Color(0xFF0077B6), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('x${it.quantity}', style: TextStyle(fontWeight: FontWeight.w600)),
                                  SizedBox(height: 6),
                                  Text(_formatPrice(context, subtotal), style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFEEF7FF), Color(0xFFDCEEFF)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.cartTotal, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                      Text(_formatPrice(context, total), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0077B6))),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navegar a la pantalla de Pago pasando los artículos del carrito
                          final args = items.map((it) => {
                            'name': it.name,
                            'price': it.price,
                            'quantity': it.quantity,
                            'image': it.image ?? '',
                          }).toList();

                          Navigator.pushNamed(context, '/pago', arguments: args);
                        },
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                        child: Text(l10n.cartCheckout),
                      ),
                    ),
                    SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => CartService.instance.clear(),
                      style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                      child: Text(l10n.cartClear, style: TextStyle(color: Color(0xFF4A90E2))),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
