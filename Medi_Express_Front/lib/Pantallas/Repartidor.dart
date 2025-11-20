import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/Servicios/order_service.dart';
import 'package:medi_express_front/Pantallas/Login.dart';

class RepartidorScreen extends StatefulWidget {
  const RepartidorScreen({super.key});

  @override
  State<RepartidorScreen> createState() => _RepartidorScreenState();
}

class _RepartidorScreenState extends State<RepartidorScreen> {
  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser.value;
    if (user == null || user.role.toLowerCase() != 'repartidor') {
      Future.microtask(() => Navigator.of(context).popUntil((r) => r.isFirst));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser.value;
    final t = user?.fullName ?? 'Repartidor';
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
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15, offset: Offset(0, 6))],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      AuthService.instance.logout();
                      // Reemplazar la pila de rutas y llevar al login
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(value: 'logout', child: Row(children: [Icon(Icons.logout, size: 18), SizedBox(width: 8), Text('Cerrar sesión')])),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(Icons.person, color: Color(0xFF1E3A8A)),
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(colors: [Colors.white, Color(0xFFF0F8FF)]).createShader(bounds),
                  child: Text('Área Repartidor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Text(user?.fullName ?? '', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  AuthService.instance.logout();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text('Pedidos asignados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                SizedBox(height: 12),
                Expanded(
                  child: ValueListenableBuilder<List<Map<String, String>>>(
                    valueListenable: OrderService.instance.pendingOrders,
                    builder: (_, orders, __) {
                      final assigned = orders.where((o) => (o['courier'] ?? '') == (user?.fullName ?? 'Repartidor Demo')).toList();
                      if (assigned.isEmpty) return Center(child: Text('No hay pedidos asignados'));
                      return ListView.separated(
                        itemCount: assigned.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemBuilder: (context, idx) {
                          final o = assigned[idx];
                          final arrived = o['arrived'] == 'true';
                          return Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: Offset(0,3))]),
                            child: ListTile(
                              title: Text('Pedido #${o['id']}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 6),
                                  Text('Cliente: ${o['customer'] ?? ''}'),
                                  Text('Total: ${o['total'] ?? ''}'),
                                  Text('Punto: ${o['dispatchPoint'] ?? ''}'),
                                ],
                              ),
                              trailing: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 140, maxHeight: 80),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // estilo compartido para ambos botones: garantiza el mismo tamaño
                                    Builder(builder: (ctx) {
                                      final buttonStyle = ElevatedButton.styleFrom(
                                        minimumSize: Size(120, 36),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      );
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: arrived
                                                ? null
                                                : () {
                                                    OrderService.instance.updateOrder(o['id'] ?? '', {'arrived': 'true'});
                                                  },
                                            icon: Icon(Icons.location_on, size: 18),
                                            label: Text(arrived ? 'Ya llegué' : 'Marcar llegada', style: TextStyle(fontSize: 12)),
                                            style: buttonStyle,
                                          ),
                                          SizedBox(height: 6),
                                          ElevatedButton.icon(
                                            onPressed: arrived
                                                ? () {
                                                    OrderService.instance.updateOrder(o['id'] ?? '', {'status': 'finalizado'});
                                                  }
                                                : null,
                                            icon: Icon(Icons.check, size: 18),
                                            label: Text('Pedido entregado', style: TextStyle(fontSize: 12)),
                                            style: buttonStyle,
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
