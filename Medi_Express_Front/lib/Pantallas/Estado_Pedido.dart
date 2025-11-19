import 'package:flutter/material.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';

class EstadoPedidoScreen extends StatelessWidget {
  final String orderId;
  final String status; // p. ej. 'Pago aprobado'

  const EstadoPedidoScreen({super.key, required this.orderId, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE8F9FF),
        elevation: 0,
        title: Text(l10n.orderStatusTitle, style: TextStyle(color: Color(0xFF0A365A), fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Color(0xFF4A90E2)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            // Icono de estado con animación y gradiente
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, v, child) {
                return Opacity(
                  opacity: v,
                  child: Transform.scale(
                    scale: 0.85 + 0.15 * v,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFDFF6FF), Color(0xFFBEEFFB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(48),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 16, offset: Offset(0, 8))],
                ),
                child: Center(child: Icon(Icons.check_circle, color: Color(0xFF0077B6), size: 56)),
              ),
            ),
            SizedBox(height: 20),
            Text(status, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF123A5A), letterSpacing: 0.2)),
            SizedBox(height: 12),
            Text(l10n.orderLabel(orderId), style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500)),
            SizedBox(height: 20),
            // Card con gradiente y sombra
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: Offset(0, 8))],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.summaryTitle, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF123A5A))),
                      SizedBox(height: 8),
                      Text(l10n.paymentProcessed, style: TextStyle(fontSize: 15)),
                      SizedBox(height: 8),
                      Text(l10n.willNotify, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                ),
                child: Text(l10n.backToHome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
