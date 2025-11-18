import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/Servicios/product_service.dart';
import 'package:medi_express_front/Servicios/distribution_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Punto de distribución (estado en memoria)
  String _address = '';
  String _openingHours = '';
  bool _available = true;
  String _pointName = '';

  // Controllers para formulario de producto
  final _productNameCtrl = TextEditingController();
  final _productDosageCtrl = TextEditingController();
  final _productPriceCtrl = TextEditingController();
  final _productDescCtrl = TextEditingController();
  final _productQtyCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Formulario para añadir locales
  final _localFormKey = GlobalKey<FormState>();
  final _locNameCtrl = TextEditingController();
  final _locAddressCtrl = TextEditingController();
  final _locHoursCtrl = TextEditingController();
  bool _locAvailable = true;

  @override
  void dispose() {
    _productNameCtrl.dispose();
    _productDosageCtrl.dispose();
    _productPriceCtrl.dispose();
    _productDescCtrl.dispose();
    _productQtyCtrl.dispose();
    _locNameCtrl.dispose();
    _locAddressCtrl.dispose();
    _locHoursCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final d = DistributionService.instance.info.value;
    if (d != null) {
      _pointName = d.name;
      _address = d.address;
      _openingHours = d.openingHours;
      _available = d.available;
    }
  }

  void _addProduct() {
    if (!_formKey.currentState!.validate()) return;
    final qtyText = _productQtyCtrl.text.trim();
    final qty = int.tryParse(qtyText) ?? 0;
    final p = {
      'name': _productNameCtrl.text.trim(),
      'dosage': _productDosageCtrl.text.trim(),
      'price': _productPriceCtrl.text.trim(),
      'description': _productDescCtrl.text.trim(),
      'quantity': qty.toString(),
    };
    ProductService.instance.addProduct(p);
    _productNameCtrl.clear();
    _productDosageCtrl.clear();
    _productPriceCtrl.clear();
    _productDescCtrl.clear();
    _productQtyCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto añadido')));
  }

  void _addLocal() {
    if (!_localFormKey.currentState!.validate()) return;
    final d = DistributionInfo(
      name: _locNameCtrl.text.trim(),
      address: _locAddressCtrl.text.trim(),
      openingHours: _locHoursCtrl.text.trim(),
      available: _locAvailable,
    );
    DistributionService.instance.addPoint(d);
    _locNameCtrl.clear();
    _locAddressCtrl.clear();
    _locHoursCtrl.clear();
    _locAvailable = true;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Local añadido')));
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = AuthService.instance.currentUser.value?.isAdmin ?? false;
    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text('Admin')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 56, color: Colors.grey),
                SizedBox(height: 12),
                Text('Acceso denegado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Solo los usuarios con rol de administrador pueden acceder a esta pantalla.'),
                SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Volver'),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Panel de administración')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Añadir producto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _productNameCtrl,
                      decoration: InputDecoration(labelText: 'Nombre del producto'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el nombre' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _productDosageCtrl,
                      decoration: InputDecoration(labelText: 'Dosis'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _productPriceCtrl,
                      decoration: InputDecoration(labelText: 'Precio (ej. 15000)'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _productQtyCtrl,
                      decoration: InputDecoration(labelText: 'Cantidad (ej. 10)'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Ingresa la cantidad';
                        final n = int.tryParse(v.trim());
                        if (n == null || n < 0) return 'Cantidad inválida';
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _productDescCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: 'Descripción'),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _addProduct,
                            child: Text('Añadir producto'),
                          ),
                        ),
                        SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              // _products.clear();
                            });
                          },
                          child: Text('Limpiar productos'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Divider(),

              Text('Gestión del punto de distribución', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                initialValue: _pointName,
                decoration: InputDecoration(labelText: 'Nombre del punto de distribución'),
                onChanged: (v) => setState(() => _pointName = v),
              ),
              SizedBox(height: 8),
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(labelText: 'Dirección'),
                onChanged: (v) => setState(() => _address = v),
              ),
              SizedBox(height: 8),
              TextFormField(
                initialValue: _openingHours,
                decoration: InputDecoration(labelText: 'Horario de atención'),
                onChanged: (v) => setState(() => _openingHours = v),
              ),
              SizedBox(height: 8),
              SwitchListTile(
                title: Text('Disponibilidad de medicamentos'),
                value: _available,
                onChanged: (v) => setState(() => _available = v),
              ),

              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Guardar en DistributionService
                  DistributionService.instance.update(name: _pointName, address: _address, openingHours: _openingHours, available: _available);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Datos de punto de distribución guardados')));
                },
                child: Text('Guardar punto de distribución'),
              ),

              SizedBox(height: 20),
              Divider(),

              // Añadir locales
              Text('Añadir local', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Form(
                key: _localFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _locNameCtrl,
                      decoration: InputDecoration(labelText: 'Nombre del local'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el nombre del local' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _locAddressCtrl,
                      decoration: InputDecoration(labelText: 'Dirección'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa una dirección' : null,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _locHoursCtrl,
                      decoration: InputDecoration(labelText: 'Horario de atención'),
                    ),
                    SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Disponible'),
                      value: _locAvailable,
                      onChanged: (v) => setState(() => _locAvailable = v),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: _addLocal,
                        child: Text('Añadir local'),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Divider(),

              Text('Productos añadidos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              // Mostrar la lista de productos desde ProductService
              ValueListenableBuilder<List<Map<String, String>>>(
                valueListenable: ProductService.instance.products,
                builder: (context, list, _) {
                  if (list.isEmpty) return Center(child: Text('No hay productos añadidos'));
                  return Column(
                    children: List.generate(list.length, (idx) {
                      final p = list[idx];
                      return Card(
                        child: ListTile(
                          title: Text(p['name'] ?? ''),
                          subtitle: Text('${p['dosage'] ?? ''} • ${p['price'] ?? ''} • Cantidad: ${p['quantity'] ?? '0'}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              ProductService.instance.removeProductAt(idx);
                            },
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),

              SizedBox(height: 20),
              Divider(),
              Text('Locales añadidos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ValueListenableBuilder<List<DistributionInfo>>(
                valueListenable: DistributionService.instance.points,
                builder: (context, points, _) {
                  if (points.isEmpty) return Center(child: Text('No hay locales añadidos'));
                  final selected = DistributionService.instance.info.value?.name;
                  return Column(
                    children: List.generate(points.length, (idx) {
                      final p = points[idx];
                      return Card(
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text(p.name)),
                              if (p.available)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                                  child: const Text('Disponible', style: TextStyle(color: Colors.green, fontSize: 12)),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                                  child: const Text('No disponible', style: TextStyle(color: Colors.red, fontSize: 12)),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dirección: ${p.address}'),
                              Text('Horario: ${p.openingHours}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Seleccionar como activo',
                                icon: Icon(Icons.check_circle, color: p.name == selected ? Colors.blue : Colors.grey),
                                onPressed: () {
                                  DistributionService.instance.setInfo(p);
                                  setState(() {
                                    _pointName = p.name;
                                    _address = p.address;
                                    _openingHours = p.openingHours;
                                    _available = p.available;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () {
                                  DistributionService.instance.removePointAt(idx);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
