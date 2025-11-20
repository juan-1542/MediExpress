import 'package:flutter/material.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';
import 'package:medi_express_front/Servicios/order_service.dart';
import 'package:medi_express_front/Servicios/distribution_service.dart';

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
                                return InkWell(
                                  onTap: () async {
                                    final status = o['status'] ?? 'pendiente';
                                    // Solo permitir asignar si está pendiente
                                    if (status != 'pendiente') {
                                      if (status == 'en camino') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pedido en camino. Usa "Pedido entregado" para marcar como finalizado.')));
                                      }
                                      return;
                                    }

                                    final points = DistributionService.instance.points.value;
                                    if (points.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No hay puntos de despacho disponibles')));
                                      return;
                                    }

                                    // Lista de repartidores: solo el repartidor de prueba.
                                    final List<String> couriers = ['Repartidor Demo'];

                                    String? selectedPoint;
                                    String? selectedCourier;

                                    final dispatched = await showDialog<bool?>(
                                      context: context,
                                      builder: (ctx) {
                                        return StatefulBuilder(builder: (ctx2, setStateSB) {
                                          return AlertDialog(
                                            title: Text('Asignar punto y repartidor'),
                                            content: SizedBox(
                                              width: double.maxFinite,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx2).size.height * 0.7),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Punto de despacho', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      const SizedBox(height: 6),
                                                      ...points.map((p) {
                                                        return ListTile(
                                                          title: Text(p.name),
                                                          subtitle: Text(p.address),
                                                          leading: selectedPoint == p.name ? Icon(Icons.store, color: Color(0xFF34C759)) : Icon(Icons.store_outlined),
                                                          onTap: () => setStateSB(() => selectedPoint = p.name),
                                                        );
                                                      }).toList(),
                                                      const SizedBox(height: 8),
                                                      Text('Repartidor', style: TextStyle(fontWeight: FontWeight.bold)),
                                                      const SizedBox(height: 6),
                                                      // Mostrar solo la opción 'Repartidor Demo'
                                                      ...couriers.map((c) {
                                                        return ListTile(
                                                          title: Text(c),
                                                          leading: selectedCourier == c ? Icon(Icons.person, color: Color(0xFF34C759)) : Icon(Icons.person_outline),
                                                          onTap: () => setStateSB(() => selectedCourier = c),
                                                        );
                                                      }).toList(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.of(ctx2).pop(false), child: Text('Cancelar')),
                                              ElevatedButton(
                                                onPressed: (selectedPoint != null && selectedCourier != null)
                                                    ? () => Navigator.of(ctx2).pop(true)
                                                    : null,
                                                child: Text('Despachar'),
                                              )
                                            ],
                                          );
                                        });
                                      },
                                    );

                                    if (dispatched == true && selectedPoint != null && selectedCourier != null) {
                                      OrderService.instance.updateOrder(o['id'] ?? '', {
                                        'status': 'en camino',
                                        'courier': selectedCourier!,
                                        'dispatchPoint': selectedPoint!,
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pedido despachado a $selectedCourier desde $selectedPoint')));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [Colors.white, Color(0xFFFAFDFF)]),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
                                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: Offset(0, 3))],
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      leading: CircleAvatar(radius: 18, backgroundColor: Color(0xFFEEF7FF), child: Icon(Icons.person, color: Color(0xFF4A90E2), size: 16)),
                                      title: Text('Pedido #${o['id']}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF123A5A), fontSize: 13)),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('${o['customer']} • ${o['items']}', style: TextStyle(fontSize: 11.0), softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis),
                                          SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Flexible(fit: FlexFit.loose, child: Text('Total: ${o['total']}', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                              SizedBox(width: 6),
                                              Flexible(fit: FlexFit.loose, child: Text('${o['status'] ?? 'pendiente'}' + (o['courier'] != null && o['courier']!.isNotEmpty ? ' • ${o['courier']}' : ''), style: TextStyle(fontSize: 10, color: Colors.grey[700]), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: SizedBox(
                                        height: 48,
                                        width: 90,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // Badge de estado con ancho fijo
                                            Container(
                                              width: 56,
                                              height: 18,
                                              padding: EdgeInsets.symmetric(horizontal: 4),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: o['status'] == 'en camino' ? [Color(0xFF34C759), Color(0xFF28A745)] : (o['status'] == 'finalizado' ? [Color(0xFF6C757D), Color(0xFF495057)] : [Color(0xFFFFA726), Color(0xFFF4511E)])),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                o['status'] == 'en camino' ? 'En camino' : (o['status'] == 'finalizado' ? 'Finalizado' : 'Pendiente'),
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            if (o['status'] == 'en camino')
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: BoxConstraints(minWidth: 28, minHeight: 28),
                                                icon: Icon(Icons.check_circle, color: Color(0xFF34C759), size: 20),
                                                tooltip: 'Marcar como entregado',
                                                onPressed: () {
                                                  OrderService.instance.updateOrder(o['id'] ?? '', {'status': 'finalizado'});
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pedido #${o['id']} marcado como entregado.')));
                                                },
                                              ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                                              icon: Icon(Icons.chevron_right, color: Color(0xFF4A90E2), size: 18),
                                              onPressed: () {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Abrir pedido #${o['id']}')));
                                              },
                                            )
                                          ],
                                        ),
                                      ),
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
