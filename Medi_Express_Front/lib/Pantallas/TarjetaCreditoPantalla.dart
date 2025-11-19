import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Estado_Pedido.dart';
import '../Servicios/cart_service.dart';

// Formatter que inserta automáticamente '/' después de los dos primeros dígitos
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Normalizar solo a dígitos
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);

    String formatted;
    if (digits.isEmpty) {
      formatted = '';
    } else if (digits.length == 1) {
      formatted = digits;
    } else if (digits.length == 2) {
      // insertar la barra inmediatamente después de MM
      formatted = '$digits/';
    } else {
      formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
    }

    // Mover el cursor al final para comportamiento sencillo y predecible
    final selectionIndex = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class TarjetaCreditoPantalla extends StatefulWidget {
  const TarjetaCreditoPantalla({super.key});

  @override
  State<TarjetaCreditoPantalla> createState() => _TarjetaCreditoPantallaState();
}

class _TarjetaCreditoPantallaState extends State<TarjetaCreditoPantalla> {
  final Color azulFondo = const Color(0xFF002B68);
  final Color azulOscuro = const Color(0xFF0648A5);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  double _monto = 0.0; // monto enviado desde la pantalla anterior
  String _metodoFromArgs = 'Tarjeta Crédito';
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
    return Scaffold(
      backgroundColor: azulFondo,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // BOTÓN REGRESAR
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

              const Text(
                "Tarjeta de crédito",
                style: TextStyle(
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
                  "assets/imagenes/credito.png",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(child: Text('Tarjeta', style: TextStyle(color: Colors.black))),
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
                      _inputCampoNumeroTarjeta(),
                      const SizedBox(height: 18),
                      _inputCampoExpiry(),
                      const SizedBox(height: 18),
                      _inputCampoCVC(),
                      const SizedBox(height: 18),
                      _inputCampoNombre(),
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
                      // Validar el formulario antes de proceder
                      if (_formKey.currentState?.validate() ?? false) {
                        // Mostrar dialogo de carga
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          final numero = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
                          final expiry = _expiryController.text; // MM/AA
                          final cvc = _cvcController.text;
                          final nombre = _nameController.text.trim();

                          // DEBUG: imprimir payload
                          try {
                            print('[TarjetaCreditoPantalla] Pago simulado:');
                            print('  metodo: $_metodoFromArgs');
                            print('  monto: $_monto');
                            print('  nombre: $nombre');
                            print('  numeroTarjeta: $numero');
                            print('  cvc: $cvc');
                            print('  fecha: $expiry');
                          } catch (_) {}

                          // Simular procesamiento local (espera breve)
                          await Future.delayed(const Duration(seconds: 1));

                          // Generar resultado simulado
                          final orderId = DateTime.now().millisecondsSinceEpoch.toString();
                          final result = {
                            'orderId': orderId,
                            'status': 'Pago aprobado',
                            'mensaje': 'Pago simulado aprobado',
                            'nombre': nombre,
                            'metodo': _metodoFromArgs,
                          };

                          // Cerrar el dialogo de carga
                          if (context.mounted) Navigator.of(context).pop();

                          // Limpiar el carrito localmente porque el pago fue aprobado
                          try {
                            CartService.instance.clear();
                          } catch (_) {}

                          // Mostrar resultado breve
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${result['status']}: ${result['mensaje']}')),
                            );
                          }

                          // Navegar a la pantalla de estado con el resultado (reemplazando la pila)
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EstadoPedidoScreen(orderId: orderId, status: 'Pago aprobado'),
                              ),
                            );
                          }
                        } catch (e) {
                          // Cerrar el dialogo si hay error
                          if (context.mounted) Navigator.of(context).pop();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al procesar el pago: ${e.toString()}')),
                            );
                          }
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Corrige los errores antes de continuar')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B66FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 6,
                    ),
                    child: const Text(
                      "Pagar",
                      style: TextStyle(
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

  // Widgets de campos
  Widget _inputCampoNumeroTarjeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Número de tarjeta',
          style: TextStyle(
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
          decoration: const InputDecoration(
            hintText: '1234123412341234',
            hintStyle: TextStyle(color: Colors.white54),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (value) {
            if (value == null) return 'Número inválido';
            final digitsOnly = value.replaceAll(RegExp(r"\D"), '');
            if (digitsOnly.length != 16) return 'El número debe tener exactamente 16 dígitos';
            return null;
          },
        ),
      ],
    );
  }

  Widget _inputCampoExpiry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha de expiración (MM/AA)',
          style: TextStyle(
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
            LengthLimitingTextInputFormatter(4), // limitar a 4 dígitos (MMYY)
            ExpiryDateInputFormatter(),
          ],
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'MM/AA',
            hintStyle: TextStyle(color: Colors.white54),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Fecha requerida';
            final regex = RegExp(r'^(0[1-9]|1[0-2])/(\d{2})$');
            final match = regex.firstMatch(value);
            if (match == null) return 'Formato inválido (MM/AA)';

            final mm = int.parse(match.group(1)!);
            final yy = int.parse(match.group(2)!);

            final now = DateTime.now();
            final currentMM = now.month;
            final currentYY = now.year % 100;

            if (mm == currentMM && yy == currentYY) {
              return 'La fecha no puede ser igual al mes/año actual';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _inputCampoCVC() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Código CVC',
          style: TextStyle(
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
          decoration: const InputDecoration(
            hintText: '123',
            hintStyle: TextStyle(color: Colors.white54),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (value) {
            if (value == null) return 'Código inválido';
            final digitsOnly = value.replaceAll(RegExp(r"\D"), '');
            if (digitsOnly.length != 3) return 'El CVC debe tener exactamente 3 dígitos';
            return null;
          },
        ),
      ],
    );
  }

  Widget _inputCampoNombre() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nombre en la tarjeta',
          style: TextStyle(
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
          decoration: const InputDecoration(
            hintText: 'Como aparece en la tarjeta',
            hintStyle: TextStyle(color: Colors.white54),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Nombre requerido';
            return null;
          },
        ),
      ],
    );
  }
}
