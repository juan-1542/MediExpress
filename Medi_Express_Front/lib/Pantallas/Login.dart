import 'package:flutter/material.dart';
import 'package:medi_express_front/Pantallas/Registro_Usuario.dart';
import 'package:medi_express_front/Pantallas/Home.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
      // Reemplazamos la pantalla actual por HomeScreen después de iniciar sesión
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo y título mejorado
                SizedBox(height: 40),
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(seconds: 1),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(-5, -5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.local_pharmacy, color: Color(0xFF667EEA), size: 50),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFF0F8FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'MediExpress',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                        Shadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 12,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'Tu farmacia en minutos',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Título del formulario
                Align(
                  alignment: Alignment.centerLeft,
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white, Color(0xFFE0E7FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'Accede para ver tus pedidos y descuentos',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Formulario mejorado
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.85)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 25,
                          offset: Offset(0, 15),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 15,
                          offset: Offset(-5, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userController,
                          decoration: InputDecoration(
                            labelText: 'Correo o teléfono',
                            labelStyle: TextStyle(color: Color(0xFF4A90E2)),
                            prefixIcon: Icon(Icons.person, color: Color(0xFF4A90E2)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Color(0xFF4A90E2).withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa correo o teléfono' : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(color: Color(0xFF4A90E2)),
                            prefixIcon: Icon(Icons.lock, color: Color(0xFF4A90E2)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Color(0xFF4A90E2).withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Ingresa la contraseña' : null,
                        ),
                        SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: Color(0xFF4A90E2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 6,
                              shadowColor: Color(0xFF4A90E2).withOpacity(0.4),
                            ),
                            child: _loading
                                ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Text('Iniciar sesión', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => RegistroUsuarioScreen()));
                          },
                          child: Text(
                            '¿No tienes cuenta? Regístrate',
                            style: TextStyle(
                              color: Color(0xFF0077B6),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Bloque de credenciales demo (si existen)
                        if (AuthService.instance.demoCredentials.isNotEmpty) ...[
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Credenciales de demo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF123A5A),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Column(
                            children: AuthService.instance.demoCredentials.map((c) {
                              final login = c['login'] ?? '';
                              final pw = c['password'] ?? '';
                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F9FB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Color(0xFF4A90E2).withOpacity(0.2)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '$login  •••  $pw',
                                          style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => _useDemoCredential(c, submit: false),
                                        child: Text('Usar', style: TextStyle(color: Color(0xFF0077B6), fontWeight: FontWeight.w600)),
                                      ),
                                      TextButton(
                                        onPressed: () => _useDemoCredential(c, submit: true),
                                        child: Text('Entrar', style: TextStyle(color: Color(0xFF0077B6), fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
