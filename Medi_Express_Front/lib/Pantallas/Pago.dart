import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';

// Uso opcional de servicio del proyecto para datos simulados (fallback)
import '../Servicios/product_service.dart';
import '../Servicios/cart_service.dart';
import '../Servicios/distribution_service.dart';

class PagoPantalla extends StatefulWidget {
  const PagoPantalla({super.key});

  @override
  State<PagoPantalla> createState() => _PagoPantallaState();
}

class _PagoPantallaState extends State<PagoPantalla> {
  final List<Map<String, dynamic>> _articulos = [];
  String? _metodoSeleccionado;
  bool _inited = false;

  // Método de entrega y selección de punto
  String _deliveryMethod = 'domicilio'; // 'domicilio' | 'presencial'
  String? _selectedPickupName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inited) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List<Map<String, dynamic>>) {
      _articulos.addAll(args);
    } else {
      // Fallback: intentar tomar datos simulados desde ProductService si existe
      try {
        final all = ProductService.instance.products.value;
        if (all.isNotEmpty) {
          for (var p in all.take(4)) {
            // Mapear campos comunes sin crear nuevas clases (usar _safeGet que maneja Map u objetos)
            final m = <String, dynamic>{
              'name': _safeGet(p, ['name', 'title', 'nombre']) ?? '',
              'description': _safeGet(p, ['description', 'descripcion']) ?? '',
              'price': _safeGet(p, ['price', 'precio', 'valor']) ?? 0,
              'image': _safeGet(p, ['image', 'img', 'imagen']) ?? '',
            };
            _articulos.add(m);
          }
        }
      } catch (_) {}
    }
    // Selección por defecto de punto para retiro presencial (si existe)
    try {
      final list = DistributionService.instance.points.value;
      if (list.isNotEmpty) {
        _selectedPickupName = DistributionService.instance.info.value?.name ?? list.first.name;
      }
    } catch (_) {}

    _inited = true;
  }

  static dynamic _safeGet(dynamic obj, List<String> keys) {
    try {
      for (final k in keys) {
        if (obj == null) break;
        if (obj is Map && obj.containsKey(k)) return obj[k];
        // intentamos acceder por propiedad
        final value = _tryGetProperty(obj, k);
        if (value != null) return value;
      }
    } catch (_) {}
    return null;
  }

  static dynamic _tryGetProperty(dynamic obj, String name) {
    try {
      final v = obj.toJson is Function ? obj.toJson()[name] : null;
      if (v != null) return v;
    } catch (_) {}
    try {
      final value = (obj as dynamic)[name];
      return value;
    } catch (_) {}
    return null;
  }

  int _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is int) return price;
    if (price is double) return price.toInt();
    final s = price.toString();
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  String _formatCurrency(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    return NumberFormat.currency(locale: l10n.localeName, symbol: '\$', decimalDigits: 0).format(value);
  }

  int get _total => _articulos.fold(0, (s, a) => s + _parsePrice(a['price'] ?? a['precio'] ?? a['valor'] ?? 0));
  int get _deliveryFee => _deliveryMethod == 'domicilio' ? 3500 : 0;
  int get _grandTotal => _total + _deliveryFee;

  Widget _buildPaymentTile({
    required String id,
    required String title,
    IconData? icon,
    String? assetImage,
    String? subtitle,
  }) {
    final bool selected = _metodoSeleccionado == id;
    const Color azul = Color(0xFF002B68);

    return GestureDetector(
      onTap: () => setState(() => _metodoSeleccionado = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))],
          border: Border.all(color: selected ? Colors.blue.shade300 : Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: assetImage != null
                  ? Image.asset(
                      assetImage,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(icon ?? Icons.payment, size: 28, color: selected ? azul : Colors.black87),
                    )
                  : Icon(icon ?? Icons.payment, size: 28, color: selected ? azul : Colors.black87),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ]
                ],
              ),
            ),
            SizedBox(width: 36, child: Icon(selected ? Icons.check_circle : Icons.radio_button_unchecked, color: selected ? const Color(0xFF002B68) : Colors.grey, size: 28)),
          ],
        ),
      ),
    );
  }

  String _normalizeMetodo(String? label) {
    if (label == null) return '';
    final l = label.toLowerCase();
    if (l.contains('credito')) return 'tarjeta';
    if (l.contains('debito') || l.contains('débito')) return 'debito';
    if (l.contains('pse')) return 'pse';
    if (l.contains('efectivo')) return 'efectivo';
    return label;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const azulFondo = Color(0xFF002B68);

    return Scaffold(
      backgroundColor: azulFondo,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Encabezado con logo y back
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/imagenes/upperblanco.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Text(l10n.appTitle, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),
              Text(
                l10n.paymentMethodTitle,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(l10n.selectPaymentMethodPrompt, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),

                    _buildPaymentTile(
                      id: 'Efectivo',
                      title: l10n.paymentCashTitle,
                      icon: Icons.attach_money,
                      subtitle: l10n.paymentCashSubtitle,
                    ),
                    _buildPaymentTile(
                      id: 'Tarjeta Débito',
                      title: l10n.paymentDebitTitle,
                      icon: Icons.payment,
                      assetImage: 'assets/imagenes/tarjetadebito.webp',
                      subtitle: l10n.paymentDebitSubtitle,
                    ),
                    _buildPaymentTile(
                      id: 'Tarjeta Crédito',
                      title: l10n.paymentCreditTitle,
                      icon: Icons.credit_card,
                      assetImage: 'assets/imagenes/tarjetacredito.jpg',
                      subtitle: l10n.paymentCreditSubtitle,
                    ),

                    const SizedBox(height: 16),
                    const Divider(),

                    // Método de entrega
                    const SizedBox(height: 8),
                    Text(l10n.deliveryMethodTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            value: 'domicilio',
                            groupValue: _deliveryMethod,
                            onChanged: (v) => setState(() => _deliveryMethod = v ?? 'domicilio'),
                            title: Text(l10n.deliveryHome),
                            subtitle: Text(l10n.deliveryHomeSubtitle(_formatCurrency(context, 3500))),
                          ),
                          const Divider(height: 1),
                          RadioListTile<String>(
                            value: 'presencial',
                            groupValue: _deliveryMethod,
                            onChanged: (v) {
                              setState(() {
                                _deliveryMethod = v ?? 'presencial';
                                // al cambiar a presencial, aseguremos una selección por defecto
                                if (_selectedPickupName == null) {
                                  final list = DistributionService.instance.points.value;
                                  if (list.isNotEmpty) _selectedPickupName = list.first.name;
                                }
                              });
                            },
                            title: Text(l10n.pickupInStore),
                            subtitle: Text(l10n.pickupNoCharge),
                          ),
                        ],
                      ),
                    ),

                    // Panel de locales si se elige presencial
                    if (_deliveryMethod == 'presencial') ...[
                      const SizedBox(height: 8),
                      Text(l10n.selectPickupStore, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<List<DistributionInfo>>(
                        valueListenable: DistributionService.instance.points,
                        builder: (context, points, _) {
                          if (points.isEmpty) {
                            return Text(l10n.noStoresAvailableNow);
                          }
                          // Filtrar por disponibles
                          final visibles = points.where((p) => p.available).toList();
                          if (visibles.isEmpty) {
                            return Text(l10n.noStoresWithAvailability);
                          }
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                            child: Column(
                              children: List.generate(visibles.length, (idx) {
                                final p = visibles[idx];
                                return Column(
                                  children: [
                                    RadioListTile<String>(
                                      value: p.name,
                                      groupValue: _selectedPickupName,
                                      onChanged: (v) {
                                        setState(() {
                                          _selectedPickupName = v;
                                          // actualizamos el servicio seleccionado para consistencia
                                          if (v != null) DistributionService.instance.selectPointByName(v);
                                        });
                                      },
                                      title: Text(p.name),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${l10n.addressLabel}: ${p.address}'),
                                          Text('${l10n.scheduleLabel}: ${p.openingHours}'),
                                        ],
                                      ),
                                    ),
                                    if (idx != visibles.length - 1) const Divider(height: 1),
                                  ],
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 12),
                    const Divider(),

                    // Resumen de compra
                    Text(l10n.summaryWithCount(_articulos.length), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    if (_articulos.isEmpty)
                      Center(child: Text(l10n.noItemsToPay))
                    else ..._articulos.map((a) => ListTile(
                          leading: SizedBox(width: 56, child: a['image'] != null && a['image'].toString().isNotEmpty ? Image.network(a['image'], fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)) : const Icon(Icons.medication)),
                          title: Text(a['name'] ?? a['title'] ?? a['nombre'] ?? l10n.cashUnnamedItem),
                          subtitle: Text(a['description'] ?? a['descripcion'] ?? ''),
                          trailing: Text(_formatCurrency(context, _parsePrice(a['price'] ?? a['precio'] ?? a['valor'] ?? 0))),
                        )),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.subtotal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Text(_formatCurrency(context, _total), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_deliveryMethod == 'domicilio' ? l10n.deliveryHome : l10n.pickupInStore, style: const TextStyle(fontSize: 16)),
                        Text(_deliveryMethod == 'domicilio' ? _formatCurrency(context, _deliveryFee) : l10n.free),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.cartTotal, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(_formatCurrency(context, _grandTotal), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF002B68))),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF002B68),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                        ),
                        onPressed: _metodoSeleccionado == null || _articulos.isEmpty || (_deliveryMethod == 'presencial' && (_selectedPickupName == null || _selectedPickupName!.isEmpty))
                            ? null
                            : () {
                                final metodoEnviar = _normalizeMetodo(_metodoSeleccionado);
                                // DEBUG: imprimir lo que vamos a enviar / navegar
                                try {
                                  print('[PagoPantalla] Continuar pressed. metodoSeleccionado: $_metodoSeleccionado');
                                  print('[PagoPantalla] Normalized metodo: $metodoEnviar, subtotal: $_total, fee: $_deliveryFee, total: $_grandTotal, articulos: ${_articulos.length}');
                                  print('[PagoPantalla] Delivery: $_deliveryMethod, pickup: $_selectedPickupName');
                                } catch (_) {}

                                final args = {
                                  'metodo': metodoEnviar,
                                  'monto': _grandTotal,
                                  'subtotal': _total,
                                  'deliveryMethod': _deliveryMethod,
                                  'deliveryFee': _deliveryFee,
                                  'pickupPoint': _selectedPickupName,
                                  'articulos': _articulos,
                                };

                                if (_metodoSeleccionado == 'Tarjeta Crédito') {
                                  Navigator.pushNamed(context, '/tarjeta_credito', arguments: args);
                                } else if (_metodoSeleccionado == 'Tarjeta Débito') {
                                  Navigator.pushNamed(context, '/tarjeta_debito', arguments: args);
                                } else if (_metodoSeleccionado == 'Efectivo') {
                                  // Navegar a pantalla de efectivo para ingresar la cantidad recibida
                                  Navigator.pushNamed(context, '/efectivo', arguments: args);
                                } else {
                                  // Limpiar el carrito localmente porque el pago fue aprobado/simulado
                                  try {
                                    CartService.instance.clear();
                                  } catch (_) {}

                                  // Navegar a pantalla de estado pasando articulos y metodo
                                  Navigator.pushNamed(
                                    context,
                                    '/estado',
                                    arguments: args,
                                  );
                                }
                              },
                        child: Text(l10n.continueLabel, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
