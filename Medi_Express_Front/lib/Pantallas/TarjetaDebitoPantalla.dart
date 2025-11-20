import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Estado_Pedido.dart';
import '../Servicios/cart_service.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';
import 'package:medi_express_front/Servicios/order_service.dart';

// Formatter que inserta automáticamente '/' después de los dos primeros dígitos
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    String formatted;
    if (digits.isEmpty) {
      formatted = '';
    } else if (digits.length == 1) {
      formatted = digits;
    } else if (digits.length == 2) {
      formatted = '$digits/';
    } else {
      formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
    }
    final selectionIndex = formatted.length;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class TarjetaDebitoPantalla extends StatefulWidget {
  const TarjetaDebitoPantalla({super.key});

  @override
  State<TarjetaDebitoPantalla> createState() => _TarjetaDebitoPantallaState();
}

class _TarjetaDebitoPantallaState extends State<TarjetaDebitoPantalla> {
  final Color azulFondo = const Color(0xFF002B68);
  final Color azulOscuro = const Color(0xFF0648A5);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  double _monto = 0.0;
  String _metodoFromArgs = 'Tarjeta Débito';
  bool _initedArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initedArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        if (args.containsKey('monto')) {
          final m = args['monto'];
          if (m is int) {
            _monto = m.toDouble();
          } else if (m is double) _monto = m;
          else if (m is String) {
            final parsed = double.tryParse(m);
            if (parsed != null) _monto = parsed;
          }
        }
        if (args.containsKey('metodo')) {
          _metodoFromArgs = args['metodo']?.toString() ?? _metodoFromArgs;
        }
      }
      _initedArgs = true;
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _nameController.dispose();
    super.dispose();
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

              const SizedBox(height: 4),
              Text(
                l10n.paymentDebitTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22),

              Container(
                width: 350,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  "assets/imagenes/tarjetadebito.webp",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(child: Text(l10n.creditCardImageFallback, style: const TextStyle(color: Colors.black))),
                ),
              ),

              const SizedBox(height: 24),

              Form(
                key: _formKey,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 22),
                  padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
                  decoration: BoxDecoration(
                    color: azulOscuro,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _inputCampoNumeroTarjeta(l10n),
                      const SizedBox(height: 18),
                      _inputCampoExpiry(l10n),
                      const SizedBox(height: 18),
                      _inputCampoCVC(l10n),
                      const SizedBox(height: 18),
                      _inputCampoNombre(l10n),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 62,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          final numero = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
                          final expiry = _expiryController.text;
                          final cvc = _cvcController.text;
                          final nombre = _nameController.text.trim();

                          // DEBUG
                          try {
                            print('[TarjetaDebitoPantalla] Pago simulado:');
                            print('  metodo: $_metodoFromArgs');
                            print('  monto: $_monto');
                            print('  nombre: $nombre');
                            print('  numeroTarjeta: $numero');
                            print('  cvc: $cvc');
                            print('  fecha: $expiry');
                          } catch (_) {}

                          // Simular procesamiento local
                          await Future.delayed(const Duration(seconds: 1));

                          // Generar resultado simulado
                          final orderId = DateTime.now().millisecondsSinceEpoch.toString();
                          final result = {
                            'orderId': orderId,
                            'status': l10n.cashPaymentApprovedStatus,
                            'mensaje': l10n.paymentSimulatedApproved,
                            'nombre': nombre,
                            'metodo': _metodoFromArgs,
                          };

                          // Añadir pedido a pendientes (sin asignar courier por defecto)
                          try {
                            OrderService.instance.addOrder({
                              'id': orderId,
                              'customer': nombre,
                              'items': '',
                              'total': _monto.toString(),
                            });
                          } catch (_) {}

                          // Cerrar diálogo
                          if (context.mounted) Navigator.of(context).pop();

                          // Limpiar carrito
                          try {
                            CartService.instance.clear();
                          } catch (_) {}

                          // Mostrar snackbar
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${result['status']}: ${result['mensaje']}')),
                            );
                          }

                          // Navegar a estado
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EstadoPedidoScreen(orderId: orderId, status: l10n.cashPaymentApprovedStatus),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) Navigator.of(context).pop();
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cashErrorProcessing(e.toString()))));
                        }
                      } else {
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.fixErrorsBeforeContinue)));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B66FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      l10n.payButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputCampoNumeroTarjeta(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cardNumberLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: l10n.cardNumberHint,
            hintStyle: const TextStyle(color: Colors.white54),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (value) {
            if (value == null) return l10n.cardNumberInvalid;
            final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
            if (digitsOnly.length != 16) return l10n.cardNumberExact16;
            return null;
          },
        ),
      ],
    );
  }

  Widget _inputCampoExpiry(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.expiryLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _expiryController,
          keyboardType: TextInputType.datetime,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
            ExpiryDateInputFormatter(),
          ],
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: l10n.expiryHint,
            hintStyle: const TextStyle(color: Colors.white54),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return l10n.expiryRequired;
            final regex = RegExp(r'^(0[1-9]|1[0-2])/(\d{2})$');
            final match = regex.firstMatch(value);
            if (match == null) return l10n.expiryInvalidFormat;
            final mm = int.parse(match.group(1)!);
            final yy = int.parse(match.group(2)!);
            final now = DateTime.now();
            final currentMM = now.month;
            final currentYY = now.year % 100;
            if (mm == currentMM && yy == currentYY) {
              return l10n.expirySameAsCurrent;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _inputCampoCVC(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cvcLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _cvcController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: l10n.cvcHint,
            hintStyle: const TextStyle(color: Colors.white54),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (value) {
            if (value == null) return l10n.cvcInvalid;
            final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
            if (digitsOnly.length != 3) return l10n.cvcExact3;
            return null;
          },
        ),
      ],
    );
  }

  Widget _inputCampoNombre(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.nameOnCardLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: l10n.nameOnCardHint,
            hintStyle: const TextStyle(color: Colors.white54),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) return l10n.nameOnCardRequired;
            return null;
          },
        ),
      ],
    );
  }
}
