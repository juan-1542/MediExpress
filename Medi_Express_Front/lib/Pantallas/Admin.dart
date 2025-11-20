import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/Servicios/product_service.dart';
import 'package:medi_express_front/Servicios/distribution_service.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';
import 'package:medi_express_front/Pantallas/Pedidos.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAdmin = AuthService.instance.currentUser.value?.isAdmin ?? false;

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text(t?.adminPanelTitle ?? 'Admin')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 56, color: Colors.grey),
                SizedBox(height: 12),
                Text(t?.adminAccessDeniedTitle ?? 'Acceso denegado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(t?.adminAccessDeniedMessage ?? 'Solo administradores.'),
                SizedBox(height: 18),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(t?.back ?? 'Volver'))
              ],
            ),
          ),
        ),
      );
    }

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
              child: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white, size: 28), onPressed: () => Navigator.pop(context)),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)])),
                      child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 8),
                    Text(t?.adminPanelTitle ?? 'Panel de administración', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                Text(t?.adminSubtitle ?? 'Gestión', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // Perfil administrador
              ValueListenableBuilder(
                valueListenable: AuthService.instance.currentUser,
                builder: (context, user, _) {
                  if (user == null) return SizedBox.shrink();
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFEEF7FF), Color(0xFFDCEEFF)]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: Offset(0, 6))],
                    ),
                    child: Row(children: [
                      CircleAvatar(radius: 30, backgroundColor: Color(0xFF4A90E2), child: (user.avatarUrl ?? '').isNotEmpty ? ClipOval(child: Image.network(user.avatarUrl!, width: 56, height: 56, fit: BoxFit.cover)) : Icon(Icons.admin_panel_settings, color: Colors.white)),
                      SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(user.fullName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF123A5A))),
                        SizedBox(height: 4),
                        Text(user.email, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                      ])),
                    ]),
                  );
                },
              ),

              // Botón pedidos pendientes (mantiene estética)
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PedidosScreen())),
                icon: Icon(Icons.receipt_long, color: Colors.white),
                label: Text('Pedidos pendientes'),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4A90E2), padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),

              SizedBox(height: 20),

              // Resto del panel (resumen compacto)
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: Offset(0, 4))]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t?.adminAddedProducts ?? 'Productos añadidos', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                  SizedBox(height: 8),
                  ValueListenableBuilder<List<Map<String, String>>>(
                    valueListenable: ProductService.instance.products,
                    builder: (context, list, _) {
                      if (list.isEmpty) return Text(t?.adminNoProducts ?? 'No hay productos', style: TextStyle(color: Colors.grey[600]));
                      return Column(children: list.take(3).map((p) => ListTile(leading: Icon(Icons.medication, color: Color(0xFF4A90E2)), title: Text(p['name'] ?? ''), subtitle: Text('${p['price'] ?? ''}'))).toList());
                    },
                  ),
                ]),
              ),

              SizedBox(height: 16),

              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: Offset(0, 4))]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t?.adminAddedStores ?? 'Locales añadidos', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                  SizedBox(height: 8),
                  ValueListenableBuilder<List<DistributionInfo>>(
                    valueListenable: DistributionService.instance.points,
                    builder: (context, points, _) {
                      if (points.isEmpty) return Text(t?.adminNoStores ?? 'No hay locales', style: TextStyle(color: Colors.grey[600]));
                      return Column(children: points.take(3).map((p) => ListTile(leading: Icon(Icons.store, color: Color(0xFF4A90E2)), title: Text(p.name), subtitle: Text(p.address))).toList());
                    },
                  ),
                ]),
              ),

              SizedBox(height: 30),

            ]),
          ),
        ),
      ),
    );
  }
}
