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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _productNameCtrl.dispose();
    _productDosageCtrl.dispose();
    _productPriceCtrl.dispose();
    _productDescCtrl.dispose();
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
    final p = {
      'name': _productNameCtrl.text.trim(),
      'dosage': _productDosageCtrl.text.trim(),
      'price': _productPriceCtrl.text.trim(),
      'description': _productDescCtrl.text.trim(),
    };
    ProductService.instance.addProduct(p);
    _productNameCtrl.clear();
    _productDosageCtrl.clear();
    _productPriceCtrl.clear();
    _productDescCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto añadido')));
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
                          subtitle: Text('${p['dosage'] ?? ''} • ${p['price'] ?? ''}'),
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
            ],
          ),
        ),
      ),
    );
  }
}
