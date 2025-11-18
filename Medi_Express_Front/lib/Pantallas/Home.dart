import 'package:flutter/material.dart';
import 'package:medi_express_front/Pantallas/Login.dart';
import 'package:medi_express_front/Pantallas/Producto.dart';
import 'package:medi_express_front/Pantallas/Admin.dart';
import 'package:medi_express_front/Pantallas/EditProfile.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/Servicios/cart_service.dart';
import 'package:medi_express_front/Pantallas/Carrito.dart';
import 'package:medi_express_front/Pantallas/Estado_Pedido.dart';
import 'package:medi_express_front/Servicios/product_service.dart';
import 'package:medi_express_front/Servicios/distribution_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _search = '';
  int? _minPrice;
  int? _maxPrice;

  // Ahora usamos ProductService para obtener los productos dinámicamente
  List<Map<String, String>> get _filteredMedications {
    final all = ProductService.instance.products.value;
    if (_search.trim().isEmpty && _minPrice == null && _maxPrice == null) return all;
    final q = _search.toLowerCase();
    return all.where((m) {
      final name = (m['name'] ?? '').toLowerCase();
      final dosage = (m['dosage'] ?? '').toLowerCase();
      final matchesText = _search.trim().isEmpty ? true : (name.contains(q) || dosage.contains(q));

      // Parse price like "15000" or "\$15.000" -> 15000
      int parsePrice(String? priceStr) {
        if (priceStr == null) return 0;
        final digits = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(digits) ?? 0;
      }

      final price = parsePrice(m['price']);
      final matchesMin = _minPrice == null ? true : price >= _minPrice!;
      final matchesMax = _maxPrice == null ? true : price <= _maxPrice!;

      return matchesText && matchesMin && matchesMax;
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Si el usuario toca el botón Estado (índice 1), navegar a la pantalla de estado de pedido
    if (index == 1) {
      // Si no hay pedido reciente mostramos un estado por defecto
      Navigator.push(context, MaterialPageRoute(builder: (_) => EstadoPedidoScreen(orderId: '0', status: 'Sin pedidos')));
    }
    // Si el usuario toca Perfil (índice 3), navegar a la pantalla de perfil
    else if (index == 3) {
      final user = AuthService.instance.currentUser.value;
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(initialUser: user)));
      } else {
        Navigator.pushNamed(context, '/perfil');
      }
    }
  }

  void _openProfileSlide() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Mi perfil'),
                onTap: () {
                  Navigator.pop(context);
                  final user = AuthService.instance.currentUser.value;
                  if (user != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(initialUser: user)));
                  } else {
                    Navigator.pushNamed(context, '/perfil');
                  }
                },
              ),
              // Mostrar acceso al panel admin solo si el usuario actual es admin
              if (AuthService.instance.currentUser.value?.isAdmin ?? false)
                ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Panel Admin'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminScreen()));
                  },
                ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Iniciar Sesión'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuraciones'),
                onTap: () {
                  Navigator.pop(context);
                  // navegar a configuraciones
                },
              ),
              SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _openFilterSheet() {
    final minController = TextEditingController(text: _minPrice?.toString());
    final maxController = TextEditingController(text: _maxPrice?.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filtrar por precio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Precio mínimo (ej. 15000)'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: maxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Precio máximo (ej. 25000)'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _minPrice = null;
                            _maxPrice = null;
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Limpiar filtro'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _minPrice = int.tryParse(minController.text);
                            _maxPrice = int.tryParse(maxController.text);
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Aplicar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE8F9FF), // muy claro para integrar con el fondo
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.person, color: Color(0xFF4A90E2)),
              onPressed: _openProfileSlide,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // pequeño decorativo tipo switch (según la imagen)
                Container(
                  width: 36,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Color(0xFF7EC8E3),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                SizedBox(width: 8),
                Text('MediExpress',
                    style: TextStyle(
                        color: Color(0xFF0A365A), fontWeight: FontWeight.bold)),
              ],
            ),
            Text('Tu farmacia en minutos',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7C87))),
          ],
        ),
        actions: [
          // Icono de notificaciones (si lo deseas conservar)
          IconButton(
            icon: Icon(Icons.notifications_none, color: Color(0xFF4A90E2)),
            onPressed: () {},
          ),
          // Icono de carrito con badge reactivo
          ValueListenableBuilder<List<CartItem>>(
            valueListenable: CartService.instance.items,
            builder: (context, value, _) {
              final count = CartService.instance.totalCount;
              return IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CarritoScreen())),
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: count > 0 ? Color(0xFF0077B6) : Color(0xFF4A90E2)),
                    if (count > 0)
                      Positioned(
                        right: 0,
                        top: 6,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Center(child: Text('$count', style: TextStyle(color: Colors.white, fontSize: 10))),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _selectedIndex == 2 ? _buildLocalesView() : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de búsqueda
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: InputDecoration(
                        hintText: 'Buscar medicamento, dosis o marca',
                        hintStyle: TextStyle(color: Color(0xFF9BB7D8)),
                        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(14)),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(Icons.search, color: Color(0xFF4A90E2)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      tooltip: 'Filtrar por precio',
                      icon: Icon(Icons.filter_list, color: (_minPrice != null || _maxPrice != null) ? Color(0xFF0077B6) : Color(0xFF4A90E2)),
                      onPressed: _openFilterSheet,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
            // Título
            Text(
              'Catálogo de medicamentos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A)),
            ),
            SizedBox(height: 12),
            // Lista (escucha cambios en ProductService)
            Expanded(
              child: ValueListenableBuilder<List<Map<String, String>>>(
                valueListenable: ProductService.instance.products,
                builder: (context, _, __) {
                  final list = _filteredMedications;
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final m = list[index];
                      return _buildMedicationCard(m['name'] ?? '', m['dosage'] ?? '', m['price'] ?? '');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF0077B6),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Estado'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Locales'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(String name, String dosage, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            // navegar a la pantalla de producto pasando los datos
            final item = {'name': name, 'dosage': dosage, 'price': price, 'description': 'Use según indicación del profesional de la salud. Mantener fuera del alcance de los niños.'};
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: item)));
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F9FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.medication, color: Color(0xFF7EC8E3), size: 28),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF123A5A))),
                      SizedBox(height: 4),
                      Text(dosage, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                    ],
                  ),
                ),
                Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0077B6))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocalesView() {
    return ValueListenableBuilder(
      valueListenable: DistributionService.instance.info,
      builder: (context, info, _) {
        if (info == null) return Center(child: Text('No hay información de locales'));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Locales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
            SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(info.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Dirección: ${info.address}'),
                    SizedBox(height: 4),
                    Text('Horario: ${info.openingHours}'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Disponibilidad: '),
                        Icon(info.available ? Icons.check_circle : Icons.cancel, color: info.available ? Colors.green : Colors.red),
                        SizedBox(width: 8),
                        Text(info.available ? 'Disponible' : 'No disponible'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
