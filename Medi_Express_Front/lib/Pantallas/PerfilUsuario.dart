
import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'Login.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  final dynamic usuario;
  const PerfilUsuarioScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {

  @override
  Widget build(BuildContext context) {
    final background = Color(0xFFF4F7FB);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF7EC8E3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Perfil del Usuario', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 48, color: Color(0xFF4A90E2)),
                    ),
                    const SizedBox(height: 16),
                    Text(widget.usuario.nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF123A5A))),
                    const SizedBox(height: 8),
                    Text(widget.usuario.email, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: Offset(0, 8))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cédula: ${widget.usuario.cedula}', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 6),
                        Text('Teléfono: ${widget.usuario.telefono}', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 6),
                        Text('Dirección: ${widget.usuario.direccion}', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {/* TODO: Implementar editar perfil */},
                                icon: Icon(Icons.edit),
                                label: Text('Editar'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: Color(0xFF4A90E2),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {/* TODO: Implementar cerrar sesión */},
                                icon: Icon(Icons.logout),
                                label: Text('Cerrar sesión'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
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
