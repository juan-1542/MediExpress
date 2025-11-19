import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/cart_service.dart';
import 'package:medi_express_front/Pantallas/Carrito.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';

class ProductScreen extends StatefulWidget {
  final Map<String, String> product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _quantity = 1;

  int _availableStock = 0;

  // Productos sugeridos
  final List<Map<String, String>> _otherProducts = [
    {
      'name': 'Aspirina',
      'price': '\$12.000',
      'image': 'https://via.placeholder.com/160x90.png?text=Aspirina',
      'quantity': '15',
      'dosage': '500 mg'
    },
    {
      'name': 'Vitamina C',
      'price': '\$20.000',
      'image': 'https://via.placeholder.com/160x90.png?text=Vitamina+C',
      'quantity': '8',
      'dosage': '1 g'
    },
    {
      'name': 'Antigripal',
      'price': '\$8.000',
      'image': 'https://via.placeholder.com/160x90.png?text=Antigripal',
      'quantity': '0',
      'dosage': 'Tabletas'
    },
  ];

  void _increment() => setState(() {
        if (_availableStock <= 0) return; // no stock
        if (_quantity < _availableStock) {
          _quantity++;
        } else {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.insufficientStock)));
        }
      });
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  // Tarjeta de sugerencia (vertical)
  Widget _buildSuggestionCard(Map<String, String> item) {
    final l10n = AppLocalizations.of(context)!;
    final imageUrl = item['image'] ?? '';
    final qty = int.tryParse(item['quantity'] ?? '0') ?? 0;
    return GestureDetector(
      onTap: () {
        if (qty > 0) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen(product: item)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.productOutOfStock)));
        }
      },
      child: Container
(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 110,
                height: 90,
                child: imageUrl.isEmpty
                    ? _fallbackImage()
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => _fallbackImage(error: error),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          final expected = loadingProgress.expectedTotalBytes;
                          final loaded = loadingProgress.cumulativeBytesLoaded;
                          return Container(
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                value: expected != null ? loaded / expected : null,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF123A5A), fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['price'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0077B6), fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.viewDetails,
                      style: const TextStyle(color: Color(0xFF4A90E2), fontSize: 13, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget reutilizable de fallback para imagen
  Widget _fallbackImage({Object? error}) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image, color: Colors.grey, size: 40),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(l10n.imageUnavailable, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            )
        ],
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.productUnavailable)));
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = widget.product;
    final name = p['name'] ?? l10n.defaultProductName;
    final dosage = p['dosage'] ?? '';
    final price = p['price'] ?? '';
    final description = p['description'] ?? l10n.descriptionUnavailable;
    final isAdmin = AuthService.instance.currentUser.value?.isAdmin ?? false;

    // recalcular stock
    _availableStock = int.tryParse(p['quantity'] ?? '0') ?? _availableStock;

    final addButtonEnabled = _availableStock > 0 && _quantity > 0 && _quantity <= _availableStock;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A90E2)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(name, style: const TextStyle(color: Color(0xFF0A365A), fontWeight: FontWeight.bold)),
        actions: [
          ValueListenableBuilder<List<CartItem>>(
            valueListenable: CartService.instance.items,
            builder: (context, value, _) {
              final count = CartService.instance.totalCount;
              return IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CarritoScreen())),
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: count > 0 ? const Color(0xFF0077B6) : const Color(0xFF4A90E2)),
                    if (count > 0)
                      Positioned(
                        right: 0,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Center(child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10))),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Color(0xFF4A90E2)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom + 88),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 6))],
                ),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFBEEFFB), Color(0xFF7EC8E3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Icon(Icons.medication, color: Color(0xFF4A90E2), size: 40)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                          const SizedBox(height: 6),
                          Text(dosage, style: TextStyle(color: Colors.grey[800], fontSize: 14)),
                          const SizedBox(height: 8),
                          Text(price, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0077B6))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(l10n.productUsageTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF123A5A))),
              const SizedBox(height: 8),
              Text(description, style: TextStyle(color: Colors.grey[800], height: 1.4, fontSize: 14)),
              const SizedBox(height: 16),
              Text(l10n.productDetailsTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF123A5A))),
              const SizedBox(height: 8),
              Text('${l10n.adminProductDosage}: $dosage', style: TextStyle(color: Colors.grey[800], fontSize: 14)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(l10n.quantityLabel, style: const TextStyle(fontSize: 16, color: Color(0xFF123A5A))),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                    child: Row(
                      children: [
                        IconButton(onPressed: _decrement, icon: const Icon(Icons.remove, color: Color(0xFF4A90E2))),
                        Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(onPressed: _increment, icon: const Icon(Icons.add, color: Color(0xFF4A90E2))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_availableStock <= 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(l10n.productUnavailable, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                )
              else if (isAdmin)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(l10n.availableStock(_availableStock), style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w600)),
                ),
              const SizedBox(height: 18),
              Text(l10n.alsoBuyTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF123A5A))),
              const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  final suggestions = _otherProducts
                      .where((item) => (item['name'] ?? '') != name)
                      .where((item) => (int.tryParse(item['quantity'] ?? '0') ?? 0) > 0)
                      .toList();
                  if (suggestions.isEmpty) {
                    return Text(l10n.noSuggestions, style: const TextStyle(color: Colors.grey));
                  }
                  return Column(
                    children: suggestions.map((item) => _buildSuggestionCard(item)).toList(),
                  );
                },
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 88),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)], borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: addButtonEnabled
                      ? () {
                          CartService.instance.addItem(CartItem(name: name, price: price, quantity: _quantity, image: p['image']));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.addedToCartItems(_quantity, name))));
                        }
                      : null,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text(l10n.addToCart),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: Text(l10n.back, style: const TextStyle(color: Color(0xFF4A90E2))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
