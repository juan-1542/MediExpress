import 'package:flutter/material.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  const RegistroUsuarioScreen({Key? key}) : super(key: key);

  @override
  State<RegistroUsuarioScreen> createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registro simulado')));
      Navigator.pop(context);
    });
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
            Text('Crear cuenta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
            SizedBox(height: 12),
            Text('Regístrate para comprar más rápido y guardar tus datos', style: TextStyle(color: Color(0xFF6B7C87))),
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person, color: Color(0xFF4A90E2)),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo o teléfono',
                          prefixIcon: Icon(Icons.email, color: Color(0xFF4A90E2)),
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
                          child: _loading ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('Registrarse'),
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
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

