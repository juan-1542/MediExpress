import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/Pantallas/Home.dart';
import 'package:medi_express_front/Pantallas/Repartidor.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  const RegistroUsuarioScreen({super.key});

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
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    // Simular petición de registro
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() => _loading = false);
      // Construir AppUser desde el formulario
      final user = AppUser(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _telefonoController.text.trim().isNotEmpty ? _telefonoController.text.trim() : '+57 300 000 0000',
        address: _direccionController.text.trim().isNotEmpty ? _direccionController.text.trim() : l10n.registeredAddressFallback,
        avatarUrl: null,
        role: _tipoUsuario,
      );

      final password = _passwordController.text;
      final registered = AuthService.instance.register(user, password);
      if (!registered) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.userAlreadyExists)));
        return;
      }

      // Si se registró correctamente, hacemos login automático
      AuthService.instance.login(user);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.registrationAndLoginSuccess)));
      // Redirigir según rol (si es repartidor, al área de repartidor)
      if (user.role.toLowerCase() == 'repartidor') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RepartidorScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F9FF),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 18,
                  decoration: BoxDecoration(color: const Color(0xFF7EC8E3), borderRadius: BorderRadius.circular(9)),
                ),
                const SizedBox(width: 8),
                Text(l10n.appTitle, style: const TextStyle(color: Color(0xFF0A365A), fontWeight: FontWeight.bold)),
              ],
            ),
            Text(l10n.homeSubtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C87))),
          ],
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4A90E2)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.registerTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
            const SizedBox(height: 12),
            Text(l10n.registerSubtitle, style: const TextStyle(color: Color(0xFF6B7C87))),
            const SizedBox(height: 18),

            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 8))],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.fullNameLabel,
                          prefixIcon: const Icon(Icons.person, color: Color(0xFF4A90E2)),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? l10n.nameRequired : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cedulaController,
                        decoration: InputDecoration(
                          labelText: l10n.nationalIdLabel,
                          prefixIcon: const Icon(Icons.badge, color: Color(0xFF4A90E2)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.trim().isEmpty) ? l10n.idRequired : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _telefonoController,
                        decoration: InputDecoration(
                          labelText: l10n.phoneLabel,
                          prefixIcon: const Icon(Icons.phone, color: Color(0xFF4A90E2)),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty) ? l10n.phoneRequired : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: l10n.emailLabel,
                          prefixIcon: const Icon(Icons.email, color: Color(0xFF4A90E2)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return l10n.emailRequired;
                          if (!RegExp(r"^[\w.-]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(v)) return l10n.invalidEmail;
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _direccionController,
                        decoration: InputDecoration(
                          labelText: l10n.addressLabel,
                          prefixIcon: const Icon(Icons.location_on, color: Color(0xFF4A90E2)),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? l10n.addressRequired : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _tipoUsuario,
                        decoration: InputDecoration(
                          labelText: l10n.userTypeLabel,
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF4A90E2)),
                        ),
                        items: [
                          DropdownMenuItem(value: 'cliente', child: Text(l10n.userTypeClient)),
                          DropdownMenuItem(value: 'admin', child: Text(l10n.userTypeAdmin)),
                          // Añadido: opción para registrar como repartidor
                          DropdownMenuItem(value: 'repartidor', child: Text('Repartidor')),
                        ],
                        onChanged: (v) => setState(() => _tipoUsuario = v ?? 'cliente'),
                        validator: (v) => (v == null || v.isEmpty) ? l10n.userTypeRequired : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF4A90E2)),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? l10n.passwordRequired : null,
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                          ),
                          child: _loading
                              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text(l10n.registerButton, style: const TextStyle(fontWeight: FontWeight.bold)),
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
