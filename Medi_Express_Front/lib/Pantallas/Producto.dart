import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/cart_service.dart';
import 'package:medi_express_front/Pantallas/Carrito.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';

class ProductScreen extends StatefulWidget {
  final Map<String, String> product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _quantity = 1;

  int _availableStock = 0;

  // Productos sugeridos: ahora incluyen una URL de imagen, nombre y precio
  final List<Map<String, String>> _otherProducts = [
    {
      'name': 'Aspirina',
      'price': '\$12.000',
      'image': 'https://via.placeholder.com/160x90.png?text=Aspirina'
    },
    {
      'name': 'Vitamina C',
      'price': '\$20.000',
      'image': 'https://via.placeholder.com/160x90.png?text=Vitamina+C'
    },
    {
      'name': 'Antigripal',
      'price': '\$8.000',
      'image': 'https://via.placeholder.com/160x90.png?text=Antigripal'
    },
  ];

  void _increment() => setState(() {
    if (_availableStock <= 0) return; // no stock
    if (_quantity < _availableStock) {
      _quantity++;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay suficiente stock')));
    }
  });
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  Widget _buildSuggestionCard(Map<String, String> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: item)));
      },
      child: Container(
        width: 150,
        height: 140,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['image'] ?? 'https://via.placeholder.com/160x90.png?text=Producto',
                width: double.infinity,
                height: 78,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            // nombre
            Text(
              item['name'] ?? '',
              style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF123A5A), fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6),
            // precio
            Text(item['price'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0077B6), fontSize: 13)),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Determinar stock si viene en el producto
    final qtyStr = widget.product['quantity'] ?? '0';
    _availableStock = int.tryParse(qtyStr) ?? 0;

    // Si no hay stock y el usuario no es admin, cerramos la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isAdmin = AuthService.instance.currentUser.value?.isAdmin ?? false;
      if (_availableStock <= 0 && !isAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto no disponible')));
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final name = p['name'] ?? 'Producto';
    final dosage = p['dosage'] ?? '';
    final price = p['price'] ?? '';
    final description = p['description'] ?? 'Descripción no disponible para este producto.';
    final isAdmin = AuthService.instance.currentUser.value?.isAdmin ?? false;

    // recalcular stock en build en caso de que el producto provenga de otra fuente
    _availableStock = int.tryParse(p['quantity'] ?? '0') ?? _availableStock;

    final addButtonEnabled = _availableStock > 0 && _quantity > 0 && _quantity <= _availableStock;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE8F9FF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF4A90E2)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(name, style: TextStyle(color: Color(0xFF0A365A), fontWeight: FontWeight.bold)),
        actions: [
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
        ],
        iconTheme: IconThemeData(color: Color(0xFF4A90E2)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom + 88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: Offset(0, 6))],
                ),
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFFBEEFFB), Color(0xFF7EC8E3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: Icon(Icons.medication, color: Color(0xFF4A90E2), size: 40)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                          SizedBox(height: 6),
                          Text(dosage, style: TextStyle(color: Colors.grey[800], fontSize: 14)),
                          SizedBox(height: 8),
                          Text(price, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0077B6))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Indicaciones de uso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF123A5A))),
              SizedBox(height: 8),
              Text(description, style: TextStyle(color: Colors.grey[800], height: 1.4, fontSize: 14)),
              SizedBox(height: 16),
              Text('Detalles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF123A5A))),
              SizedBox(height: 8),
              Text('- Dosis: $dosage', style: TextStyle(color: Colors.grey[800], fontSize: 14)),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Cantidad', style: TextStyle(fontSize: 16, color: Color(0xFF123A5A))),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                    child: Row(
                      children: [
                        IconButton(onPressed: _decrement, icon: Icon(Icons.remove, color: Color(0xFF4A90E2))),
                        Text('$_quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(onPressed: _increment, icon: Icon(Icons.add, color: Color(0xFF4A90E2))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Mostrar disponibilidad para admin o mensaje para usuarios
              if (_availableStock <= 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text('Producto no disponible', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                )
              else if (isAdmin)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text('Stock disponible: $_availableStock', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600)),
                ),
              SizedBox(height: 18),
              // Sección: También puedes comprar
              Text('También puedes comprar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF123A5A))),
              SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _otherProducts.length,
                  itemBuilder: (context, index) {
                    final item = _otherProducts[index];
                    if ((item['name'] ?? '') == name) return SizedBox.shrink();
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: Offset(0, 4))],
                      ),
                      margin: EdgeInsets.only(right: 10),
                      child: _buildSuggestionCard(item),
                    );
                  },
                ),
              ),
              SizedBox(height: 12),
              // espacio para la barra inferior fija (botones)
              SizedBox(height: 88),
              // padding extra al final para evitar overflow por pocos pixeles
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)], borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: addButtonEnabled ? () {
                    // añadir al servicio de carrito
                    CartService.instance.addItem(CartItem(name: name, price: price, quantity: _quantity, image: p['image']));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Añadido $_quantity x $name al carrito')));
                  } : null,
                  icon: Icon(Icons.add_shopping_cart),
                  label: Text('Añadir al carrito'),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
              SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                child: Text('Volver', style: TextStyle(color: Color(0xFF4A90E2))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
