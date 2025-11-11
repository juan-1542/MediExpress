import 'package:flutter/material.dart';

class EstadoPedidoScreen extends StatelessWidget {
  final String orderId;
  final String status; // p. ej. 'Pago aprobado'

  const EstadoPedidoScreen({Key? key, required this.orderId, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE8F9FF),
        elevation: 0,
        title: Text('Estado del pedido', style: TextStyle(color: Color(0xFF0A365A), fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Color(0xFF4A90E2)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: Color(0xFFDFF6FF), borderRadius: BorderRadius.circular(48)),
              child: Center(child: Icon(Icons.check_circle, color: Color(0xFF0077B6), size: 56)),
            ),
            SizedBox(height: 20),
            Text(status, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
            SizedBox(height: 12),
            Text('Pedido #$orderId', style: TextStyle(color: Colors.grey[800])),
            SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resumen', style: TextStyle(fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    Text('Tu pago se ha procesado correctamente y tu pedido está en preparación.'),
                    SizedBox(height: 8),
                    Text('Te enviaremos una notificación cuando sea despachado.', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Volver al inicio (podemos limpiar la pila para evitar volver al carrito)
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Volver al inicio'),
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

