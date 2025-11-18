import 'package:flutter/material.dart';
import 'package:medi_express_front/Pantallas/Registro_Usuario.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() => _loading = false);
      final email = _userController.text.trim();
      final password = _passwordController.text;
      final ok = AuthService.instance.loginWithCredentials(email, password);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Credenciales inválidas o usuario no registrado')));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Inicio de sesión correcto')));
      Navigator.pop(context, true);
    });
  }

  void _useDemoCredential(Map<String, String> cred, {bool submit = false}) {
    _userController.text = cred['login'] ?? '';
    _passwordController.text = cred['password'] ?? '';
    if (submit) _submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE8F9FF),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 18,
                  decoration: BoxDecoration(color: Color(0xFF7EC8E3), borderRadius: BorderRadius.circular(9)),
                ),
                SizedBox(width: 8),
                Text('MediExpress', style: TextStyle(color: Color(0xFF0A365A), fontWeight: FontWeight.bold)),
              ],
            ),
            Text('Tu farmacia en minutos', style: TextStyle(fontSize: 12, color: Color(0xFF6B7C87))),
          ],
        ),
        iconTheme: IconThemeData(color: Color(0xFF4A90E2)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Iniciar sesión', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
            SizedBox(height: 12),
            Text('Accede para ver tus pedidos y descuentos', style: TextStyle(color: Color(0xFF6B7C87))),
            SizedBox(height: 18),

            Material(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _userController,
                        decoration: InputDecoration(
                          labelText: 'Correo o teléfono',
                          prefixIcon: Icon(Icons.person, color: Color(0xFF4A90E2)),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa correo o teléfono' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock, color: Color(0xFF4A90E2)),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Ingresa la contraseña' : null,
                      ),
                      SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('Iniciar sesión'),
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => RegistroUsuarioScreen()));
                        },
                        child: Text('¿No tienes cuenta? Regístrate', style: TextStyle(color: Color(0xFF0077B6))),
                      ),
                      // Bloque de credenciales demo (si existen)
                      if (AuthService.instance.demoCredentials.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Credenciales de demo', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                        ),
                        SizedBox(height: 6),
                        Column(
                          children: AuthService.instance.demoCredentials.map((c) {
                            final login = c['login'] ?? '';
                            final pw = c['password'] ?? '';
                            return Card(
                              color: Color(0xFFF5F9FB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('$login  •••  $pw', style: TextStyle(color: Color(0xFF4A90E2)))),
                                    TextButton(
                                      onPressed: () => _useDemoCredential(c, submit: false),
                                      child: Text('Usar', style: TextStyle(color: Color(0xFF0077B6))),
                                    ),
                                    TextButton(
                                      onPressed: () => _useDemoCredential(c, submit: true),
                                      child: Text('Entrar', style: TextStyle(color: Color(0xFF0077B6))),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 6),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
