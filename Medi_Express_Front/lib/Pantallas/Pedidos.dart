import 'package:flutter/material.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';
import 'package:medi_express_front/Servicios/order_service.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  // Ahora leemos los pedidos pendientes desde OrderService

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 41, 87, 212), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.receipt_long, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 8),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.white, Color(0xFFF0F8FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(t?.pendingOrders ?? 'Pedidos',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ])),
                    ),
                  ],
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white.withValues(alpha: 0.9), Colors.white.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(t?.pendingOrders ?? 'Pedidos pendientes', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t?.pendingOrders ?? 'Pedidos pendientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                SizedBox(height: 12),
                Flexible(
                  fit: FlexFit.loose,
                  child: ValueListenableBuilder<List<Map<String, String>>>(
                    valueListenable: OrderService.instance.pendingOrders, // Escuchamos los pedidos pendientes
                    builder: (context, _orders, _) {
                      return _orders.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),
                                  SizedBox(height: 12),
                                  Text(t?.pendingOrders ?? 'No hay pedidos pendientes', style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            )
                          : ListView.separated(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 16),
                              itemCount: _orders.length,
                              separatorBuilder: (_, __) => SizedBox(height: 8),
                              itemBuilder: (context, idx) {
                                final o = _orders[idx];
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Colors.white, Color(0xFFFAFDFF)]),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
                                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: Offset(0, 3))],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    leading: CircleAvatar(backgroundColor: Color(0xFFEEF7FF), child: Icon(Icons.person, color: Color(0xFF4A90E2))),
                                    title: Text('Pedido #${o['id']}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 4),
                                        Text('${o['customer']} • ${o['items']}', style: TextStyle(fontSize: 12.5), softWrap: true),
                                        SizedBox(height: 4),
                                        Text('Total: ${o['total']}', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [Color(0xFFFFA726), Color(0xFFF4511E)]),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text('Pendiente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                                        ),
                                        SizedBox(height: 2),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                                          icon: Icon(Icons.chevron_right, color: Color(0xFF4A90E2), size: 16),
                                          onPressed: () {
                                            // Se puede añadir navegación a detalle del pedido aquí
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Abrir pedido #${o['id']}')));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
