import 'package:flutter/material.dart';
import 'dart:async';
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
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _search = '';
  int? _minPrice;
  int? _maxPrice;
  late MotionTabBarController _motionTabBarController;
  late TextEditingController _searchController;
  Timer? _searchDebounce;
  String? _activeFilter;
  List<String> _suggestions = [];
  bool _showSuggestions = false;
  late FocusNode _searchFocusNode;
  bool _searchFocused = false;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
    _searchController = TextEditingController(text: _search);
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      setState(() {
        _searchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchDebounce?.cancel();
    _searchFocusNode.removeListener(() {});
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // update UI for clear button
    setState(() {});
    // debounce actual search to avoid frequent rebuilds
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      setState(() {
        _search = _searchController.text;
      });
    });
    // update suggestions immediately (light operation)
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    final all = ProductService.instance.products.value;
    final matches = <String>{};
    for (final m in all) {
      final name = (m['name'] ?? '').toLowerCase();
      if (name.contains(q)) matches.add(m['name'] ?? '');
    }
    setState(() {
      _suggestions = matches.where((s) => s.isNotEmpty).take(6).toList();
      _showSuggestions = _suggestions.isNotEmpty;
    });
  }


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
    // Guardar el contexto del widget (padre) para usarlo después de cerrar el modal
    final parentContext = context;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              Container(width: 50, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3))),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.person_outline, color: Color(0xFF4A90E2)),
                title: Text('Mi perfil', style: TextStyle(fontWeight: FontWeight.w600)),
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
                  leading: Icon(Icons.admin_panel_settings, color: Color(0xFF4A90E2)),
                  title: Text('Panel Admin', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AdminScreen()));
                  },
                ),
              // Mostrar 'Cerrar sesión' si hay usuario logueado, o 'Iniciar Sesión' si no
              ValueListenableBuilder(
                valueListenable: AuthService.instance.currentUser,
                builder: (context, user, _) {
                  if (user != null) {
                    return ListTile(
                      leading: Icon(Icons.logout, color: Colors.redAccent),
                      title: Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.w600)),
                      onTap: () {
                        // Cerrar sesión en el servicio
                        AuthService.instance.logout();
                        // Cerrar el modal (context aquí es el del modal)
                        Navigator.pop(context);
                        // Navegar a Login reemplazando la pantalla actual (usar el contexto padre)
                        Navigator.pushReplacement(parentContext, MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                    );
                  }
                  return ListTile(
                    leading: Icon(Icons.login, color: Color(0xFF4A90E2)),
                    title: Text('Iniciar Sesión', style: TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Color(0xFF4A90E2)),
                title: Text('Configuraciones', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  // navegar a configuraciones
                },
              ),
              SizedBox(height: 16),
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
                color: Colors.black.withOpacity(0.2),
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
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: Icon(Icons.person, color: Color(0xFF1E3A8A)),
                  onPressed: _openProfileSlide,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    SizedBox(width: 8),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.white, Color(0xFFF0F8FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text('MediExpress',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ])),
                    ),
                  ],
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text('Tu farmacia en minutos',
                      style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: Colors.white, size: 28),
                onPressed: () {},
              ),
              ValueListenableBuilder<List<CartItem>>(
                valueListenable: CartService.instance.items,
                builder: (context, value, _) {
                  final count = CartService.instance.totalCount;
                  return IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CarritoScreen())),
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                        if (count > 0)
                          Positioned(
                            right: 0,
                            top: 6,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.redAccent, Colors.red],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                              child: Center(child: Text('$count', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _selectedIndex == 2 ? _buildLocalesView() : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern animated search field
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                gradient: _searchFocused
                    ? LinearGradient(colors: [Color(0xFFEEF7FF), Color(0xFFDCEEFF)])
                    : null,
                color: _searchFocused ? null : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(_searchFocused ? 0.08 : 0.04), blurRadius: _searchFocused ? 18 : 10, offset: Offset(0, 8)),
                ],
                border: Border.all(color: _searchFocused ? Color(0xFFBEE1FF) : Colors.transparent),
              ),
              child: Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 280),
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: _searchFocused ? Color(0xFFEEF7FF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(Icons.search, color: _searchFocused ? Color(0xFF1976D2) : Color(0xFF4A90E2)),
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      focusNode: _searchFocusNode,
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Buscar medicamento, dosis o marca',
                        hintStyle: TextStyle(color: Color(0xFF9BB7D8)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                splashRadius: 18,
                                icon: Icon(Icons.close, color: Colors.grey[600]),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _search = '';
                                    _suggestions = [];
                                    _showSuggestions = false;
                                  });
                                },
                              )
                            : null,
                      ),
                      onSubmitted: (_) => setState(() {}),
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
            SizedBox(height: 8),
            // Quick filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todos', () {
                    setState(() {
                      _minPrice = null;
                      _maxPrice = null;
                      _activeFilter = 'Todos';
                    });
                  }),
                  _buildFilterChip('Con stock', () {
                    setState(() {
                      _minPrice = null;
                      _maxPrice = null;
                      _activeFilter = 'Con stock';
                    });
                  }),
                  _buildFilterChip('Sin stock', () {
                    setState(() {
                      _minPrice = null;
                      _maxPrice = null;
                      _activeFilter = 'Sin stock';
                    });
                  }),
                  _buildFilterChip('<15K', () {
                    setState(() {
                      _minPrice = null;
                      _maxPrice = 15000;
                      _activeFilter = '<15K';
                    });
                  }),
                  _buildFilterChip('15-30K', () {
                    setState(() {
                      _minPrice = 15000;
                      _maxPrice = 30000;
                      _activeFilter = '15-30K';
                    });
                  }),
                  _buildFilterChip('>30K', () {
                    setState(() {
                      _minPrice = 30001;
                      _maxPrice = null;
                      _activeFilter = '>30K';
                    });
                  }),
                ].map<Widget>((w) => Padding(padding: const EdgeInsets.only(right: 8.0), child: w)).toList(),
              ),
            ),
            // Suggestions dropdown
            if (_showSuggestions && _suggestions.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 180),
                child: Card(
                  margin: EdgeInsets.only(top: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, idx) {
                      final s = _suggestions[idx];
                      return ListTile(
                        title: Text(s),
                        leading: Icon(Icons.medication, color: Color(0xFF4A90E2)),
                        onTap: () {
                          _searchController.text = s;
                          _searchController.selection = TextSelection.fromPosition(TextPosition(offset: s.length));
                          setState(() {
                            _search = s;
                            _showSuggestions = false;
                            _suggestions = [];
                          });
                        },
                      );
                    },
                  ),
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
                      return _buildMedicationCard(m['name'] ?? '', m['dosage'] ?? '', m['price'] ?? '', m['quantity'] ?? '0', index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Inicio",
        labels: const ["Inicio", "Estado", "Locales", "Perfil"],
        icons: const [
          Icons.home,
          Icons.info_outline,
          Icons.location_on,
          Icons.person,
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.white.withOpacity(0.7),
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Colors.white,
        tabIconSelectedColor: Color.fromARGB(255, 46, 87, 199),
        tabBarColor: Color.fromARGB(255, 47, 96, 230),
        onTabItemSelected: (int value) {
          setState(() {
            _selectedIndex = value;
          });
          _onItemTapped(value);
        },
      ),
    );
  }

  Widget _buildMedicationCard(String name, String dosage, String price, String quantity, int index) {
    final q = int.tryParse(quantity.toString()) ?? 0;
    final isAdmin = AuthService.instance.currentUser.value?.isAdmin ?? false;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index.clamp(0, 10) * 40)),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) {
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - v)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: Offset(0, 8))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (q <= 0 && !isAdmin) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto no disponible')));
                return;
              }
              final item = {
                'name': name,
                'dosage': dosage,
                'price': price,
                'quantity': quantity,
                'description': 'Use según indicación del profesional de la salud. Mantener fuera del alcance de los niños.'
              };
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: item)));
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              child: Row(
                children: [
                  // Image / icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Color(0xFF9FE8FF), Color(0xFF67C8E8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: Offset(0, 6))],
                    ),
                    child: Center(
                      child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'M', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 14),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF123A5A))),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(child: Text(dosage, style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
                            if (q <= 0)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                                child: Text('Sin stock', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                              )
                            else if (isAdmin)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                                child: Text('Cantidad: $q', style: TextStyle(color: Colors.green[700], fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Price + add button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Color(0xFFEEF7FF), borderRadius: BorderRadius.circular(10)),
                        child: Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0077B6))),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          if (q <= 0 && !isAdmin) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto sin stock')));
                            return;
                          }
                          CartService.instance.addItem(CartItem(name: name, price: price, quantity: 1));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agregado al carrito')));
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Color(0xFF4A90E2), borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    final selected = _activeFilter == label;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Color(0xFF1E3A8A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.transparent : Colors.grey.withOpacity(0.2)),
          boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: Offset(0,4))] : [],
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : Color(0xFF123A5A), fontWeight: FontWeight.w600)),
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
