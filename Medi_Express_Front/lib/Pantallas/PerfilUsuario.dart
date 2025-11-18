import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'Login.dart';
import 'EditProfile.dart';
import 'ChangePassword.dart';

// Pantalla: Perfil del Usuario
// StatefulWidget que muestra datos del usuario recibidos desde un objeto User simulado.

// Ahora usamos AppUser desde AuthService
class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({Key? key}) : super(key: key);

  @override
  _PerfilUsuarioScreenState createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  AppUser? user;

  @override
  void initState() {
    super.initState();
    // Suscribirse al currentUser para actualizar la UI automáticamente
    user = AuthService.instance.currentUser.value;
    AuthService.instance.currentUser.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    AuthService.instance.currentUser.removeListener(_onUserChanged);
    super.dispose();
  }

  void _onUserChanged() {
    setState(() {
      user = AuthService.instance.currentUser.value;
    });
  }

  void _onEditProfile() {
    // Abrir pantalla de edición pasando el usuario actual
    Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(initialUser: user))).then((v) {
      if (v == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil actualizado')));
      }
    });
  }

  void _onChangePassword() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePasswordScreen())).then((v) {
      if (v == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contraseña actualizada')));
      }
    });
  }

  void _onLogout() {
    AuthService.instance.logout();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sesión cerrada')));
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue.shade700),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = Color(0xFFF4F7FB);
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Usuario'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: user == null ? _buildLoggedOutView(context) : Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage: user!.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                      child: user!.avatarUrl == null
                          ? Text(
                              _initials(user!.fullName),
                              style: TextStyle(fontSize: 28, color: Colors.blue.shade700, fontWeight: FontWeight.w700),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(user!.fullName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(user!.email, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Información en Cards/ListTiles
              if (user != null) ...[
                _buildInfoCard(Icons.email_outlined, 'Correo electrónico', user!.email),
                _buildInfoCard(Icons.phone_android_outlined, 'Teléfono', user!.phone),
                _buildInfoCard(Icons.location_on_outlined, 'Dirección', user!.address),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.edit_outlined),
                          label: const Text('Editar perfil'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _onEditProfile,
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.lock_outline),
                          label: const Text('Cambiar contraseña'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            side: BorderSide(color: Colors.blue.shade100),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _onChangePassword,
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          icon: Icon(Icons.exit_to_app, color: Colors.redAccent),
                          label: const Text('Cerrar sesión', style: TextStyle(color: Colors.redAccent)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: _onLogout,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        Text('No has iniciado sesión', style: TextStyle(fontSize: 16, color: Colors.black54)),
        SizedBox(height: 12),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              // Navegar al login
              final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              // Si el login setea un usuario, el listener actualizará la UI
            },
            child: Text('Iniciar sesión'),
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
