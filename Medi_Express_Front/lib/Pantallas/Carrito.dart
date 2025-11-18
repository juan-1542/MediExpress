import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/cart_service.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({Key? key}) : super(key: key);

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  int _parsePrice(String p) {
    final digits = p.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  String _formatPrice(int value) {
    // formato simple con separador de miles usando puntos
    final s = value.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return '\$' + buffer.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE8F9FF),
        elevation: 0,
        title: Text('Carrito', style: TextStyle(color: Color(0xFF0A365A), fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Color(0xFF4A90E2)),
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartService.instance.items,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return Center(child: Text('El carrito está vacío'));
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
                      return Material(
                        color: Colors.white,
                        elevation: 2,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(color: Color(0xFFE8F9FF), borderRadius: BorderRadius.circular(8)),
                                child: it.image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(it.image!, fit: BoxFit.cover),
                                      )
                                    : Icon(Icons.medication, color: Color(0xFF7EC8E3)),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(it.name, style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF123A5A))),
                                    SizedBox(height: 6),
                                    Text(it.price, style: TextStyle(color: Color(0xFF0077B6), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('x${it.quantity}', style: TextStyle(fontWeight: FontWeight.w600)),
                                  SizedBox(height: 6),
                                  Text(_formatPrice(subtotal), style: TextStyle(fontWeight: FontWeight.bold)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(_formatPrice(total), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0077B6))),
                  ],
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
                        child: Text('Ir a pagar'),
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                      ),
                    ),
                    SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => CartService.instance.clear(),
                      child: Text('Vaciar carrito', style: TextStyle(color: Color(0xFF4A90E2))),
                      style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
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
