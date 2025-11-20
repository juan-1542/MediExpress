import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/Servicios/order_service.dart';
import 'package:medi_express_front/Pantallas/Login.dart';
import 'dart:math' as math;

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
                      // Mostrar solo pedidos asignados a este repartidor y que no estén finalizados
                      final assigned = orders.where((o) {
                        final courier = (o['courier'] ?? '');
                        final status = (o['status'] ?? '');
                        return courier == (user?.fullName ?? 'Repartidor Demo') && status != 'finalizado';
                      }).toList();
                      if (assigned.isEmpty) return Center(child: Text('No hay pedidos asignados'));
                      final bottomPad = math.max(MediaQuery.of(context).viewPadding.bottom, kBottomNavigationBarHeight);
                      return ListView.separated(
                        padding: EdgeInsets.only(bottom: bottomPad + 24),
                        itemCount: assigned.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemBuilder: (context, idx) {
                          final o = assigned[idx];
                          final arrived = o['arrived'] == 'true';
                          return Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: Offset(0,3))]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left: title + details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Pedido #${o['id']}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                                        SizedBox(height: 6),
                                        Text('Cliente: ${o['customer'] ?? ''}'),
                                        Text('Total: ${o['total'] ?? ''}'),
                                        Text('Punto: ${o['dispatchPoint'] ?? ''}'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  // Right: action buttons column
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _gradientActionButton(
                                        context,
                                        icon: Icons.location_on,
                                        label: arrived ? 'Ya llegué' : 'Marcar llegada',
                                        enabled: !arrived,
                                        onTap: () {
                                          if (!arrived) OrderService.instance.markArrived(o['id'] ?? '');
                                        },
                                      ),
                                      SizedBox(height: 6),
                                      _gradientActionButton(
                                        context,
                                        icon: Icons.check,
                                        label: 'Pedido entregado',
                                        enabled: arrived,
                                        onTap: () {
                                          if (arrived) OrderService.instance.markDelivered(o['id'] ?? '');
                                        },
                                      ),
                                    ],
                                  ),
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

  // Helper para crear botones con estética de Home (gradiente, sombra, ripple)
  Widget _gradientActionButton(BuildContext context, {required IconData icon, required String label, required bool enabled, required VoidCallback onTap}) {
    final colors = enabled ? [Color(0xFF4A90E2), Color(0xFF3B82F6)] : [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.2)];
    final textColor = enabled ? Colors.white : Colors.grey[700];
    return Container(
      width: 120,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(8),
        boxShadow: enabled ? [BoxShadow(color: Color(0xFF4A90E2).withOpacity(0.25), blurRadius: 6, offset: Offset(0,3))] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: textColor, size: 14),
                SizedBox(width: 6),
                Flexible(child: Text(label, style: TextStyle(color: textColor, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
