import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';
import '../Servicios/cart_service.dart';
import 'Estado_Pedido.dart';

class EfectivoPantalla extends StatefulWidget {
  const EfectivoPantalla({super.key});

  @override
  State<EfectivoPantalla> createState() => _EfectivoPantallaState();
}

class _EfectivoPantallaState extends State<EfectivoPantalla> {
  final Color azulFondo = const Color(0xFF002B68);
  final Color azulOscuro = const Color(0xFF0648A5);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  int _monto = 0; // total a pagar (en COP, entero)
  List<dynamic> _articulos = [];
  bool _initedArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initedArgs) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final m = args['monto'];
      try {
        if (m is int) {
          _monto = m;
        } else if (m is double) _monto = (m).toInt();
        else if (m is String) _monto = int.tryParse(m.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      } catch (_) {}
      final arts = args['articulos'];
      if (arts is List) _articulos = arts;
    }
    _initedArgs = true;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int _parseInput(String s) {
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  String _formatCurrency(BuildContext context, int value) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(locale: l10n.localeName, symbol: '\$', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: azulFondo,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(l10n.cashTitle, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 22),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.cashTotalToPay, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(_formatCurrency(context, _monto), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: azulFondo)),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(l10n.cashAmountReceived, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
                            decoration: InputDecoration(hintText: l10n.cashEnterAmountHint, border: const UnderlineInputBorder()),
                            validator: (value) {
                              final entered = _parseInput(value ?? '');
                              if (entered <= 0) return l10n.cashEnterValidAmount;
                              if (entered < _monto) return l10n.cashAmountLessThanTotal;
                              return null;
                            },
                            onChanged: (_) => setState(() {}),
                          ),

                          const SizedBox(height: 12),

                          // Mostrar botón 'Necesitaré cambio' solo si ingresado > monto
                          Builder(builder: (ctx) {
                            final entered = _parseInput(_amountController.text);
                            final needChangeVisible = entered > _monto;
                            final changeAmount = (entered > _monto) ? entered - _monto : 0;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (needChangeVisible) ...[
                                  Text(l10n.cashNeedChange(_formatCurrency(context, changeAmount)), style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // validar y procesar como pago aprobado
                                      if (!(_formKey.currentState?.validate() ?? false)) {
                                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l10n.cashFixEnteredAmount)));
                                        return;
                                      }
                                      await _procesarPago(entered);
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: azulFondo),
                                    child: Text(l10n.cashNeedChangeButton),
                                  ),
                                  const SizedBox(height: 10),
                                ],

                                // Botón aceptar pago (también usado si exacto)
                                ElevatedButton(
                                  onPressed: () async {
                                    if (!(_formKey.currentState?.validate() ?? false)) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l10n.cashFixEnteredAmount)));
                                      return;
                                    }
                                    final entered2 = _parseInput(_amountController.text);
                                    await _procesarPago(entered2);
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: azulFondo),
                                  child: Text(l10n.cashAcceptPayment),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 12),
                          // Opcional: mostrar resumen de artículos
                          Text(l10n.cashSummaryWithCount(_articulos.length), style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          if (_articulos.isEmpty)
                            Text(l10n.cashNoItems)
                          else
                            ..._articulos.map((a) {
                              final name = a['name'] ?? a['title'] ?? a['nombre'] ?? l10n.cashUnnamedItem;
                              final price = a['price'] ?? a['precio'] ?? a['valor'] ?? 0;
                              final parsedPrice = (price is int) ? price : int.tryParse(price.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                              return ListTile(
                                leading: const Icon(Icons.medication),
                                title: Text(name),
                                trailing: Text(_formatCurrency(context, parsedPrice)),
                              );
                            }),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _procesarPago(int recibido) async {
    final l10n = AppLocalizations.of(context)!;
    // Mostrar loader
    if (context.mounted) {
      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    }

    try {
      // Simular procesamiento
      await Future.delayed(const Duration(seconds: 1));

      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Limpiar carrito
      try {
        CartService.instance.clear();
      } catch (_) {}

      // Cerrar loader
      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        final changeText = _formatCurrency(context, (recibido - _monto));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cashPaymentApproved(changeText))));

        // Navegar a estado
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EstadoPedidoScreen(orderId: orderId, status: l10n.cashPaymentApprovedStatus)));
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cashErrorProcessing(e.toString()))));
    }
  }
}
