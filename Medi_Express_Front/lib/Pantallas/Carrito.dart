import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/cart_service.dart';
import 'package:medi_express_front/Servicios/currency_service.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';

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
    return CurrencyService.instance.formatPrice(value.toDouble(), context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 41, 87, 212), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, Colors.white.withValues(alpha: 0.9)],
          ).createShader(bounds),
          child: Text(
            l10n.cartTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartService.instance.items,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                builder: (context, v, child) {
                  return Opacity(
                    opacity: v,
                    child: Transform.scale(
                      scale: 0.8 + (0.2 * v),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF4A90E2).withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            l10n.cartEmpty,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF123A5A),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Agrega productos para comenzar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          final total = items.fold<int>(0, (sum, it) => sum + (_parsePrice(it.price) * it.quantity));

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, v, child) {
              return Opacity(
                opacity: v,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - v)),
                  child: Padding(
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
                                            Text(it.name, style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF123A5A), fontSize: 15)),
                                            SizedBox(height: 4),
                                            Text(_formatPrice(context, unit), style: TextStyle(color: Color(0xFF0077B6), fontWeight: FontWeight.bold, fontSize: 13)),
                                            SizedBox(height: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)]),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        child: InkWell(
                                                          borderRadius: BorderRadius.circular(8),
                                                          onTap: () => CartService.instance.decrementQuantity(it.name),
                                                          child: Container(
                                                            width: 32,
                                                            height: 32,
                                                            alignment: Alignment.center,
                                                            child: Icon(Icons.remove, color: Colors.white, size: 18),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[100],
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: Colors.grey[300]!, width: 1),
                                                      ),
                                                      child: Text(
                                                        '${it.quantity}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Color(0xFF123A5A),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 12),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        gradient: it.quantity >= it.maxStock 
                                                          ? LinearGradient(colors: [Colors.grey[400]!, Colors.grey[500]!])
                                                          : LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)]),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        child: InkWell(
                                                          borderRadius: BorderRadius.circular(8),
                                                          onTap: it.quantity >= it.maxStock 
                                                            ? null 
                                                            : () => CartService.instance.incrementQuantity(it.name),
                                                          child: Container(
                                                            width: 32,
                                                            height: 32,
                                                            alignment: Alignment.center,
                                                            child: Icon(Icons.add, color: Colors.white, size: 18),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (it.maxStock < 999) // Solo mostrar si hay límite real
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 6, left: 4),
                                                    child: Text(
                                                      'Stock: ${it.maxStock}',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: it.quantity >= it.maxStock 
                                                          ? Colors.red[400] 
                                                          : Colors.grey[600],
                                                        fontWeight: it.quantity >= it.maxStock 
                                                          ? FontWeight.bold 
                                                          : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                  title: Text('Eliminar producto', style: TextStyle(fontWeight: FontWeight.bold)),
                                                  content: Text('¿Deseas eliminar "${it.name}" del carrito?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(ctx),
                                                      child: Text('Cancelar', style: TextStyle(color: Colors.grey[600])),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        CartService.instance.removeItem(it.name);
                                                        Navigator.pop(ctx);
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red[400],
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                      ),
                                                      child: Text('Eliminar'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            padding: EdgeInsets.all(8),
                                            constraints: BoxConstraints(),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [Color(0xFFEEF7FF), Color(0xFFDCEEFF)]),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              _formatPrice(context, subtotal),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Color(0xFF0077B6),
                                              ),
                                            ),
                                          ),
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
                              child: ElevatedButton.icon(
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
                                icon: Icon(Icons.payment),
                                label: Text(l10n.cartCheckout, style: TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4A90E2),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () => CartService.instance.clear(),
                              icon: Icon(Icons.delete_outline),
                              label: Text(l10n.cartClear),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(0xFF4A90E2),
                                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                side: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
