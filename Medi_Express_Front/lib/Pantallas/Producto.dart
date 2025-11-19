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
    final currentLocale = Localizations.localeOf(context).languageCode;
    final nameKey = 'name_$currentLocale';
    final itemName = item[nameKey] ?? item['name'] ?? '';
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
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 4))],
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
                      itemName,
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
    final currentLocale = Localizations.localeOf(context).languageCode;
    final nameKey = 'name_$currentLocale';
    final name = p[nameKey] ?? p['name'] ?? l10n.defaultProductName;
    final dosage = p['dosage'] ?? '';
    final price = p['price'] ?? '';
    final description = p['description'] ?? l10n.descriptionUnavailable;

    // recalcular stock
    _availableStock = int.tryParse(p['quantity'] ?? '0') ?? _availableStock;

    final addButtonEnabled = _availableStock > 0 && _quantity > 0 && _quantity <= _availableStock;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 41, 87, 212), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, Colors.white.withValues(alpha: 0.9)],
          ).createShader(bounds),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
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
                    Icon(Icons.shopping_cart, color: Colors.white),
                    if (count > 0)
                      Positioned(
                        right: 0,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.5),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Center(child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom + 88),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, v, child) {
              return Opacity(
                opacity: v,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - v)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 8))],
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.medication_liquid, color: Colors.white, size: 50),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF123A5A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [Color(0xFFEEF7FF), Color(0xFFDCEEFF)]),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.science, size: 16, color: Color(0xFF0077B6)),
                                            SizedBox(width: 6),
                                            Text(
                                              dosage,
                                              style: TextStyle(
                                                color: Color(0xFF0077B6),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        price,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0077B6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (_availableStock > 0) ...[
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _availableStock <= 5 
                                      ? [Colors.orange[50]!, Colors.orange[100]!]
                                      : [Colors.green[50]!, Colors.green[100]!],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _availableStock <= 5 
                                      ? Colors.orange[300]! 
                                      : Colors.green[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _availableStock <= 5 ? Icons.warning_amber : Icons.check_circle,
                                      size: 18,
                                      color: _availableStock <= 5 
                                        ? Colors.orange[700] 
                                        : Colors.green[700],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      l10n.availableStock(_availableStock),
                                      style: TextStyle(
                                        color: _availableStock <= 5 
                                          ? Colors.orange[700] 
                                          : Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.red[300]!, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.cancel, size: 18, color: Colors.red[700]),
                                    SizedBox(width: 8),
                                    Text(
                                      l10n.productUnavailable,
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: Offset(0, 6))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.info_outline, color: Colors.white, size: 20),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  l10n.productUsageTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF123A5A),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.grey[800],
                                height: 1.5,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: Offset(0, 6))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  l10n.quantityLabel,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF123A5A),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Color(0xFFEEF7FF), Color(0xFFDCEEFF)]),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(12),
                                          onTap: _decrement,
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Icon(Icons.remove, color: Color(0xFF4A90E2), size: 20),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                        child: Text(
                                          '$_quantity',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF123A5A),
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(12),
                                          onTap: _quantity >= _availableStock ? null : _increment,
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Icon(
                                              Icons.add,
                                              color: _quantity >= _availableStock 
                                                ? Colors.grey[400] 
                                                : Color(0xFF4A90E2),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.recommend, color: Colors.white, size: 20),
                          ),
                          SizedBox(width: 12),
                          Text(
                            l10n.alsoBuyTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF123A5A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Builder(
                        builder: (context) {
                          final suggestions = _otherProducts
                              .where((item) => (item['name'] ?? '') != name)
                              .where((item) => (int.tryParse(item['quantity'] ?? '0') ?? 0) > 0)
                              .toList();
                          if (suggestions.isEmpty) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  l10n.noSuggestions,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: suggestions.map((item) => _buildSuggestionCard(item)).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 88),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white, Color(0xFFF8FBFF)]),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: addButtonEnabled
                      ? () {
                          CartService.instance.addItem(CartItem(name: name, price: price, quantity: _quantity, image: p['image'], maxStock: _availableStock));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 12),
                                  Expanded(child: Text(l10n.addedToCartItems(_quantity, name))),
                                ],
                              ),
                              backgroundColor: Colors.green[600],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.add_shopping_cart, size: 22),
                  label: Text(l10n.addToCart, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, size: 20),
                label: Text(l10n.back),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFF4A90E2),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  side: BorderSide(color: Color(0xFF4A90E2), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
