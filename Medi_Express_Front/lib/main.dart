import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Pantallas/Login.dart';
import 'Pantallas/Pago.dart';
import 'Pantallas/TarjetaCreditoPantalla.dart';
import 'Pantallas/TarjetaDebitoPantalla.dart';
import 'Pantallas/EfectivoPantalla.dart';
import 'Pantallas/Estado_Pedido.dart';
import 'Servicios/locale_service.dart';
import 'widgets/language_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocaleService.instance.locale,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'MediExpress',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFE8F3FF),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFE8F9FF),
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFF4A90E2)),
            ),
          ),
          locale: locale,
          supportedLocales: const [
            Locale('es'),
            Locale('en'),
            Locale('de'),
            Locale('fr'),
            Locale('pt'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            // Overlay de selector de idioma siempre visible en la parte superior derecha
            return Stack(
              children: [
                if (child != null) child,
                // Panel flotante superior derecha
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0, right: 6.0)
                    ),
                  ),
                ),
              ],
            );
          },
          home: const LoginScreen(),
          routes: {
            '/pago': (ctx) => const PagoPantalla(),
            '/tarjeta_credito': (ctx) => const TarjetaCreditoPantalla(),
            '/tarjeta_debito': (ctx) => const TarjetaDebitoPantalla(),
            '/efectivo': (ctx) => const EfectivoPantalla(),
            '/estado': (ctx) {
              final args = ModalRoute.of(ctx)?.settings.arguments;
              if (args is Map) {
                final orderId = args['orderId']?.toString() ?? (args['orderId'] != null ? args['orderId'].toString() : DateTime.now().millisecondsSinceEpoch.toString());
                final status = args['status']?.toString() ?? 'Estado';
                return EstadoPedidoScreen(orderId: orderId, status: status);
              }
              // Fallback
              return EstadoPedidoScreen(orderId: DateTime.now().millisecondsSinceEpoch.toString(), status: 'Estado del pedido');
            },
          },
        );
      },
    );
  }
}
