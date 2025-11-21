import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/Servicios/product_service.dart';
import 'package:medi_express_front/Servicios/distribution_service.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';
import 'package:medi_express_front/Pantallas/Pedidos.dart';
import 'package:flutter/foundation.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Mostrar diálogo para añadir/editar productos (solo web visible)
  void _showProductAdminDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Productos (web)'),
          content: SizedBox(
            width: 700,
            child: ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: ProductService.instance.products,
              builder: (context, list, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _openProductForm(),
                      icon: Icon(Icons.add),
                      label: Text('Añadir producto'),
                    ),
                    SizedBox(height: 12),
                    if (list.isEmpty) Text('No hay productos'),
                    if (list.isNotEmpty)
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: list.length,
                          separatorBuilder: (_, __) => Divider(),
                          itemBuilder: (context, idx) {
                            final p = list[idx];
                            return ListTile(
                              title: Text(p['name_en'] ?? p['name'] ?? ''),
                              subtitle: Text(p['price'] ?? ''),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _openProductForm(editIndex: idx, initial: p),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    ProductService.instance.removeProductAt(idx);
                                  },
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar'))],
        );
      },
    );
  }

  void _openProductForm({int? editIndex, Map<String, String>? initial}) {
    final nameEs = TextEditingController(text: initial?['name_es'] ?? initial?['name'] ?? '');
    final nameEn = TextEditingController(text: initial?['name_en'] ?? initial?['name'] ?? '');
    final namePt = TextEditingController(text: initial?['name_pt'] ?? initial?['name'] ?? '');
    final price = TextEditingController(text: initial?['price'] ?? '');
    final dosage = TextEditingController(text: initial?['dosage'] ?? '');
    final description = TextEditingController(text: initial?['description'] ?? '');
    final quantity = TextEditingController(text: initial?['quantity'] ?? '');

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(editIndex == null ? 'Añadir producto' : 'Editar producto'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameEs, decoration: InputDecoration(labelText: 'Nombre (es)')),
                  TextField(controller: nameEn, decoration: InputDecoration(labelText: 'Nombre (en)')),
                  TextField(controller: namePt, decoration: InputDecoration(labelText: 'Nombre (pt)')),
                  TextField(controller: price, decoration: InputDecoration(labelText: 'Precio')),
                  TextField(controller: dosage, decoration: InputDecoration(labelText: 'Dosis')),
                  TextField(controller: quantity, decoration: InputDecoration(labelText: 'Cantidad')),
                  TextField(controller: description, decoration: InputDecoration(labelText: 'Descripción'), maxLines: 3),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final map = {
                  'name_es': nameEs.text,
                  'name_en': nameEn.text,
                  'name_pt': namePt.text,
                  'price': price.text,
                  'dosage': dosage.text,
                  'description': description.text,
                  'quantity': quantity.text,
                };
                if (editIndex == null) {
                  ProductService.instance.addProduct(map);
                } else {
                  ProductService.instance.updateProductAt(editIndex, map);
                }
                Navigator.pop(context);
                Navigator.pop(context); // cerrar listado también
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar diálogo para añadir/editar puntos de distribución (solo web visible)
  void _showDistributionAdminDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Puntos de distribución (web)'),
          content: SizedBox(
            width: 700,
            child: ValueListenableBuilder<List<DistributionInfo>>(
              valueListenable: DistributionService.instance.points,
              builder: (context, list, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _openDistributionForm(),
                      icon: Icon(Icons.add),
                      label: Text('Añadir punto'),
                    ),
                    SizedBox(height: 12),
                    if (list.isEmpty) Text('No hay puntos'),
                    if (list.isNotEmpty)
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: list.length,
                          separatorBuilder: (_, __) => Divider(),
                          itemBuilder: (context, idx) {
                            final p = list[idx];
                            return ListTile(
                              title: Text(p.name),
                              subtitle: Text(p.address),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _openDistributionForm(editIndex: idx, initial: p),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => DistributionService.instance.removePointAt(idx),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar'))],
        );
      },
    );
  }

  void _openDistributionForm({int? editIndex, DistributionInfo? initial}) {
    final name = TextEditingController(text: initial?.name ?? '');
    final address = TextEditingController(text: initial?.address ?? '');
    final hours = TextEditingController(text: initial?.openingHours ?? '');
    bool available = initial?.available ?? true;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(editIndex == null ? 'Añadir punto' : 'Editar punto'),
            content: SizedBox(
              width: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: name, decoration: InputDecoration(labelText: 'Nombre')),
                  TextField(controller: address, decoration: InputDecoration(labelText: 'Dirección')),
                  TextField(controller: hours, decoration: InputDecoration(labelText: 'Horario')),
                  Row(children: [
                    Text('Disponible'),
                    Switch(value: available, onChanged: (v) => setState(() => available = v)),
                  ])
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  final d = DistributionInfo(name: name.text, address: address.text, openingHours: hours.text, available: available);
                  if (editIndex == null) {
                    DistributionService.instance.addPoint(d);
                  } else {
                    DistributionService.instance.info.value = d; // actualizar selección temporal
                    // actualizar lista: hacer remove/add a la posición
                    final list = List<DistributionInfo>.from(DistributionService.instance.points.value);
                    if (editIndex >= 0 && editIndex < list.length) {
                      list[editIndex] = d;
                      DistributionService.instance.points.value = list;
                    }
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Guardar'),
              ),
            ],
          );
        });
      },
    );
  }

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
                label: Text(t?.pendingOrders ?? 'Pedidos pendientes'),
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

              SizedBox(height: 16),

              // Botones de administración visibles solo en web
              if (kIsWeb) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showProductAdminDialog,
                        icon: Icon(Icons.medication, color: Colors.white),
                        label: Text('Administrar productos (web)'),
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4A90E2), padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showDistributionAdminDialog,
                        icon: Icon(Icons.store, color: Colors.white),
                        label: Text('Administrar puntos (web)'),
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4A90E2), padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}
