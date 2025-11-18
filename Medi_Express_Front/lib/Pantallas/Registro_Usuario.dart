import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/Pantallas/Home.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  const RegistroUsuarioScreen({Key? key}) : super(key: key);

  @override
  State<RegistroUsuarioScreen> createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _tipoUsuario = 'cliente';
  bool _loading = false;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    // Simular petición de registro
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() => _loading = false);
      // Construir AppUser desde el formulario
      final user = AppUser(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _telefonoController.text.trim().isNotEmpty ? _telefonoController.text.trim() : '+57 300 000 0000',
        address: _direccionController.text.trim().isNotEmpty ? _direccionController.text.trim() : 'Dirección registrada',
        avatarUrl: null,
        role: _tipoUsuario,
      );

      final password = _passwordController.text;
      final registered = AuthService.instance.register(user, password);
      if (!registered) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ya existe un usuario con ese correo')));
        return;
      }

      // Si se registró correctamente, hacemos login automático
      AuthService.instance.login(user);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registro y login realizados con éxito')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
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
                        controller: _cedulaController,
                        decoration: InputDecoration(
                          labelText: 'Cédula',
                          prefixIcon: Icon(Icons.badge, color: Color(0xFF4A90E2)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa la cédula' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _telefonoController,
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: Icon(Icons.phone, color: Color(0xFF4A90E2)),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el teléfono' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo',
                          prefixIcon: Icon(Icons.email, color: Color(0xFF4A90E2)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Ingresa el correo';
                          if (!RegExp(r"^[\w.-]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(v)) return 'Ingresa un correo válido';
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _direccionController,
                        decoration: InputDecoration(
                          labelText: 'Dirección',
                          prefixIcon: Icon(Icons.location_on, color: Color(0xFF4A90E2)),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa la dirección' : null,
                      ),
                      SizedBox(height: 12),
                      // Selector tipo_usuario (Dropdown con dos opciones: cliente/admin)
                      DropdownButtonFormField<String>(
                        initialValue: _tipoUsuario,
                        decoration: InputDecoration(
                          labelText: 'Tipo de usuario',
                          prefixIcon: Icon(Icons.person_outline, color: Color(0xFF4A90E2)),
                        ),
                        items: [
                          DropdownMenuItem(value: 'cliente', child: Text('Cliente')),
                          DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        ],
                        onChanged: (v) => setState(() => _tipoUsuario = v ?? 'cliente'),
                        validator: (v) => (v == null || v.isEmpty) ? 'Selecciona el tipo de usuario' : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Clave',
                          prefixIcon: Icon(Icons.lock, color: Color(0xFF4A90E2)),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Ingresa la clave' : null,
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
