import 'package:flutter/material.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';
import 'package:medi_express_front/Servicios/product_service.dart';
import 'package:medi_express_front/Servicios/distribution_service.dart';
import 'package:medi_express_front/l10n/app_localizations.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Punto de distribución (estado en memoria)
  String _address = '';
  String _openingHours = '';
  bool _available = true;
  String _pointName = '';

  // Controllers para formulario de producto
  final _productNameCtrl = TextEditingController();
  final _productNameEsCtrl = TextEditingController();
  final _productNameEnCtrl = TextEditingController();
  final _productNamePtCtrl = TextEditingController();
  final _productNameFrCtrl = TextEditingController();
  final _productNameJaCtrl = TextEditingController();
  final _productDosageCtrl = TextEditingController();
  final _productPriceCtrl = TextEditingController();
  final _productDescCtrl = TextEditingController();
  final _productQtyCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Formulario para añadir locales
  final _localFormKey = GlobalKey<FormState>();
  final _locNameCtrl = TextEditingController();
  final _locAddressCtrl = TextEditingController();
  final _locHoursCtrl = TextEditingController();
  bool _locAvailable = true;

  @override
  void dispose() {
    _productNameCtrl.dispose();
    _productNameEsCtrl.dispose();
    _productNameEnCtrl.dispose();
    _productNamePtCtrl.dispose();
    _productNameFrCtrl.dispose();
    _productNameJaCtrl.dispose();
    _productDosageCtrl.dispose();
    _productPriceCtrl.dispose();
    _productDescCtrl.dispose();
    _productQtyCtrl.dispose();
    _locNameCtrl.dispose();
    _locAddressCtrl.dispose();
    _locHoursCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final d = DistributionService.instance.info.value;
    if (d != null) {
      _pointName = d.name;
      _address = d.address;
      _openingHours = d.openingHours;
      _available = d.available;
    }
  }

  void _addProduct() {
    if (!_formKey.currentState!.validate()) return;
    final qtyText = _productQtyCtrl.text.trim();
    final qty = int.tryParse(qtyText) ?? 0;
    final baseName = _productNameCtrl.text.trim();
    final p = {
      'name': baseName,
      'name_es': _productNameEsCtrl.text.trim().isEmpty ? baseName : _productNameEsCtrl.text.trim(),
      'name_en': _productNameEnCtrl.text.trim().isEmpty ? baseName : _productNameEnCtrl.text.trim(),
      'name_pt': _productNamePtCtrl.text.trim().isEmpty ? baseName : _productNamePtCtrl.text.trim(),
      'name_fr': _productNameFrCtrl.text.trim().isEmpty ? baseName : _productNameFrCtrl.text.trim(),
      'name_ja': _productNameJaCtrl.text.trim().isEmpty ? baseName : _productNameJaCtrl.text.trim(),
      'dosage': _productDosageCtrl.text.trim(),
      'price': _productPriceCtrl.text.trim(),
      'description': _productDescCtrl.text.trim(),
      'quantity': qty.toString(),
    };
    ProductService.instance.addProduct(p);
    _productNameCtrl.clear();
    _productNameEsCtrl.clear();
    _productNameEnCtrl.clear();
    _productNamePtCtrl.clear();
    _productNameFrCtrl.clear();
    _productNameJaCtrl.clear();
    _productDosageCtrl.clear();
    _productPriceCtrl.clear();
    _productDescCtrl.clear();
    _productQtyCtrl.clear();
    final t = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t?.adminProductAdded ?? 'Producto añadido')));
  }

  void _addLocal() {
    if (!_localFormKey.currentState!.validate()) return;
    final d = DistributionInfo(
      name: _locNameCtrl.text.trim(),
      address: _locAddressCtrl.text.trim(),
      openingHours: _locHoursCtrl.text.trim(),
      available: _locAvailable,
    );
    DistributionService.instance.addPoint(d);
    _locNameCtrl.clear();
    _locAddressCtrl.clear();
    _locHoursCtrl.clear();
    _locAvailable = true;
    setState(() {});
    final t = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t?.adminStoreAdded ?? 'Local añadido')));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAdmin = AuthService.instance.currentUser.value?.isAdmin ?? false;
    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: Text(t?.adminPanelTitle ?? 'Admin')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 56, color: Colors.grey),
                SizedBox(height: 12),
                Text(t?.adminAccessDeniedTitle ?? 'Acceso denegado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(t?.adminAccessDeniedMessage ?? 'Solo los usuarios con rol de administrador pueden acceder a esta pantalla.'),
                SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(t?.back ?? 'Volver'),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 41, 87, 212), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 8),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.white, Color(0xFFF0F8FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(t?.adminPanelTitle ?? 'Panel de administración',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ])),
                    ),
                  ],
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white.withValues(alpha: 0.9), Colors.white.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(t?.adminSubtitle ?? 'Gestión de productos y locales',
                      style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tarjeta de perfil del administrador
                ValueListenableBuilder(
                  valueListenable: AuthService.instance.currentUser,
                  builder: (context, user, _) {
                    if (user == null) return SizedBox.shrink();
                    
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      builder: (context, v, child) {
                        return Opacity(
                          opacity: v,
                          child: Transform.scale(
                            scale: 0.9 + (0.1 * v),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 24),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFEEF7FF), Color(0xFFDCEEFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF4A90E2).withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                                    ? ClipOval(
                                        child: Image.network(
                                          user.avatarUrl!,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(Icons.admin_panel_settings, size: 36, color: Colors.white),
                                        ),
                                      )
                                    : Icon(Icons.admin_panel_settings, size: 36, color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 16),
                            // Información del usuario
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          user.fullName,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF123A5A),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.verified, color: Colors.white, size: 14),
                                            SizedBox(width: 4),
                                            Text(
                                              'Admin',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (user.phone.isNotEmpty) ...[
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, size: 14, color: Color(0xFF4A90E2)),
                                        SizedBox(width: 4),
                                        Text(
                                          user.phone,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Card: Añadir producto
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, child) {
                    return Opacity(
                      opacity: v,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - v)),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: Offset(0, 8))],
                    ),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.add_box, color: Colors.white, size: 24),
                              ),
                              SizedBox(width: 12),
                              Text(t?.adminAddProduct ?? 'Añadir producto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                            ],
                          ),
                          SizedBox(height: 16),
                          Form(
                            key: _formKey,
                            child: Column(
                          children: [
                            TextFormField(
                              controller: _productNameCtrl,
                              decoration: InputDecoration(
                                labelText: '${t?.adminProductName ?? 'Nombre del producto'} (Base)',
                                hintText: 'Nombre genérico del producto',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                  ).createShader(bounds),
                                  child: Icon(Icons.medication, color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? (t?.adminEnterProductName ?? 'Ingresa el nombre') : null,
                            ),
                            SizedBox(height: 16),
                            Text('Nombres en otros idiomas (opcional):', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF123A5A))),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _productNameEsCtrl,
                              decoration: InputDecoration(
                                labelText: '🇪🇸 Español',
                                hintText: 'Nombre en español',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _productNameEnCtrl,
                              decoration: InputDecoration(
                                labelText: '🇬🇧 English',
                                hintText: 'Name in English',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _productNamePtCtrl,
                              decoration: InputDecoration(
                                labelText: '🇵🇹 Português',
                                hintText: 'Nome em português',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _productNameFrCtrl,
                              decoration: InputDecoration(
                                labelText: '🇫🇷 Français',
                                hintText: 'Nom en français',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _productNameJaCtrl,
                              decoration: InputDecoration(
                                labelText: '🇯🇵 日本語',
                                hintText: '日本語での名前',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[50],
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _productDosageCtrl,
                              decoration: InputDecoration(
                                labelText: t?.adminProductDosage ?? 'Dosis',
                                hintText: 'Ej: 500mg',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                  ).createShader(bounds),
                                  child: Icon(Icons.science, color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _productPriceCtrl,
                              decoration: InputDecoration(
                                labelText: t?.adminProductPriceHint ?? 'Precio (ej. 15000)',
                                hintText: '15000',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                  ).createShader(bounds),
                                  child: Icon(Icons.attach_money, color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _productQtyCtrl,
                              decoration: InputDecoration(
                                labelText: t?.adminProductQuantityHint ?? 'Cantidad (ej. 10)',
                                hintText: '10',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                  ).createShader(bounds),
                                  child: Icon(Icons.inventory, color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return t?.adminEnterQuantity ?? 'Ingresa la cantidad';
                                final n = int.tryParse(v.trim());
                                if (n == null || n < 0) return t?.adminInvalidQuantity ?? 'Cantidad inválida';
                                return null;
                              },
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _productDescCtrl,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: t?.adminDescription ?? 'Descripción',
                                hintText: 'Descripción detallada del producto',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(bottom: 40),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                    ).createShader(bounds),
                                    child: Icon(Icons.description, color: Colors.white),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _addProduct,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF4A90E2),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 4,
                                    ),
                                    child: Text(t?.adminAddProduct ?? 'Añadir producto', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                SizedBox(width: 12),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      // _products.clear();
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    side: BorderSide(color: Color(0xFF4A90E2)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(t?.adminClearProducts ?? 'Limpiar productos', style: TextStyle(color: Color(0xFF4A90E2))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

              // Card: Gestión del punto de distribución
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, v, child) {
                  return Opacity(
                    opacity: v,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - v)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: Offset(0, 8))],
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.local_shipping, color: Colors.white, size: 24),
                            ),
                            SizedBox(width: 12),
                            Expanded(child: Text(t?.adminDistributionSection ?? 'Gestión del punto de distribución', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A)))),
                          ],
                        ),
                        SizedBox(height: 16),
                      TextFormField(
                        initialValue: _pointName,
                        decoration: InputDecoration(
                          labelText: t?.adminDistributionPointName ?? 'Nombre del punto de distribución',
                          hintText: 'Centro de distribución principal',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                            ).createShader(bounds),
                            child: Icon(Icons.business, color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                          ),
                        ),
                        onChanged: (v) => setState(() => _pointName = v),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        initialValue: _address,
                        decoration: InputDecoration(
                          labelText: t?.addressLabel ?? 'Dirección',
                          hintText: 'Calle 123 #45-67',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                            ).createShader(bounds),
                            child: Icon(Icons.location_on, color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                          ),
                        ),
                        onChanged: (v) => setState(() => _address = v),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        initialValue: _openingHours,
                        decoration: InputDecoration(
                          labelText: t?.scheduleLabel ?? 'Horario',
                          hintText: 'Lun-Vie: 8:00-18:00',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                            ).createShader(bounds),
                            child: Icon(Icons.access_time, color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                          ),
                        ),
                        onChanged: (v) => setState(() => _openingHours = v),
                      ),
                      SizedBox(height: 8),
                      SwitchListTile(
                        title: Text(t?.adminMedicinesAvailability ?? 'Disponibilidad de medicamentos'),
                        value: _available,
                        onChanged: (v) => setState(() => _available = v),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          DistributionService.instance.update(name: _pointName, address: _address, openingHours: _openingHours, available: _available);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t?.adminDistributionSaved ?? 'Datos de punto de distribución guardados')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A90E2),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                        child: Text(t?.adminSaveDistributionPoint ?? 'Guardar punto de distribución', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ],
                    ),
                  ),
                ),
              ),

              // Card: Añadir local
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                builder: (context, v, child) {
                  return Opacity(
                    opacity: v,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - v)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: Offset(0, 8))],
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.store, color: Colors.white, size: 24),
                            ),
                            SizedBox(width: 12),
                            Text(t?.adminAddStore ?? 'Añadir local', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                          ],
                        ),
                        SizedBox(height: 16),
                      Form(
                        key: _localFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _locNameCtrl,
                              decoration: InputDecoration(
                                labelText: t?.adminStoreName ?? 'Nombre del local',
                                hintText: 'Farmacia Central',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                  ).createShader(bounds),
                                  child: Icon(Icons.store, color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? (t?.adminEnterStoreName ?? 'Ingresa el nombre del local') : null,
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _locAddressCtrl,
                              decoration: InputDecoration(
                                labelText: t?.addressLabel ?? 'Dirección',
                                hintText: 'Av. Principal #123',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                  ).createShader(bounds),
                                  child: Icon(Icons.location_on, color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? (t?.adminEnterAddress ?? 'Ingresa una dirección') : null,
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _locHoursCtrl,
                              decoration: InputDecoration(
                                labelText: t?.scheduleLabel ?? 'Horario',
                                hintText: '24 horas',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                  ).createShader(bounds),
                                  child: Icon(Icons.schedule, color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(t?.available ?? 'Disponible'),
                              value: _locAvailable,
                              onChanged: (v) => setState(() => _locAvailable = v),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                onPressed: _addLocal,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4A90E2),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                ),
                                child: Text(t?.adminAddStore ?? 'Añadir local', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Card: Productos añadidos
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, v, child) {
                  return Opacity(
                    opacity: v,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - v)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: Offset(0, 8))],
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.inventory, color: Colors.white, size: 24),
                            ),
                            SizedBox(width: 12),
                            Text(t?.adminAddedProducts ?? 'Productos añadidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                          ],
                        ),
                        SizedBox(height: 16),
                        ValueListenableBuilder<List<Map<String, String>>>(
                          valueListenable: ProductService.instance.products,
                          builder: (context, list, _) {
                            if (list.isEmpty) {
                              return Container(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),
                                      SizedBox(height: 12),
                                      Text(t?.adminNoProducts ?? 'No hay productos añadidos', style: TextStyle(color: Colors.grey[600])),
                                    ],
                                  ),
                                ),
                              );
                            }
                            final currentLocale = Localizations.localeOf(context).languageCode;
                            return Column(
                              children: List.generate(list.length, (idx) {
                                final p = list[idx];
                                final productName = ProductService.instance.getProductName(p, currentLocale);
                                return Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Colors.white, Color(0xFFFAFDFF)]),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.03),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xFFEEF7FF),
                                      child: Icon(Icons.medication, color: Color(0xFF4A90E2), size: 20),
                                    ),
                                    title: Text(productName, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                                    subtitle: Text('${p['dosage'] ?? ''} • ${p['price'] ?? ''} • ${(t != null) ? t.quantityTag(p['quantity'] ?? '0') : 'Cantidad: ${p['quantity'] ?? '0'}'}', style: TextStyle(fontSize: 13)),
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                        onPressed: () {
                                          ProductService.instance.removeProductAt(idx);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Card: Locales añadidos
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, v, child) {
                  return Opacity(
                    opacity: v,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - v)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFF8FBFF), Color(0xFFFAFEFF)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: Offset(0, 8))],
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF4A90E2), Color(0xFF3B82F6)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF4A90E2).withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.location_city, color: Colors.white, size: 24),
                            ),
                            SizedBox(width: 12),
                            Text(t?.adminAddedStores ?? 'Locales añadidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF123A5A))),
                          ],
                        ),
                        SizedBox(height: 16),
                        ValueListenableBuilder<List<DistributionInfo>>(
                          valueListenable: DistributionService.instance.points,
                          builder: (context, points, _) {
                            if (points.isEmpty) {
                              return Container(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.store_mall_directory_outlined, size: 48, color: Colors.grey[400]),
                                      SizedBox(height: 12),
                                      Text(t?.adminNoStores ?? 'No hay locales añadidos', style: TextStyle(color: Colors.grey[600])),
                                    ],
                                  ),
                                ),
                              );
                            }
                            final selected = DistributionService.instance.info.value?.name;
                            return Column(
                              children: List.generate(points.length, (idx) {
                                final p = points[idx];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Colors.white, Color(0xFFFAFDFF)]),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: p.name == selected 
                                        ? Color(0xFF4A90E2).withValues(alpha: 0.5)
                                        : Colors.grey.withValues(alpha: 0.1),
                                      width: p.name == selected ? 2 : 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: p.name == selected 
                                          ? Color(0xFF4A90E2).withValues(alpha: 0.1)
                                          : Colors.black.withValues(alpha: 0.03),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: p.name == selected ? Color(0xFF4A90E2) : Color(0xFFEEF7FF),
                                              child: Icon(Icons.store, color: p.name == selected ? Colors.white : Color(0xFF4A90E2), size: 20),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(child: Text(p.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF123A5A)))),
                                            if (p.available)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)]),
                                                  borderRadius: BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.green.withValues(alpha: 0.3),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(t?.available ?? 'Disponible', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                              )
                                            else
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(colors: [Color(0xFFF44336), Color(0xFFEF5350)]),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(t?.notAvailable ?? 'No disponible', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                                            SizedBox(width: 6),
                                            Expanded(child: Text('${p.address}', style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                                            SizedBox(width: 6),
                                            Expanded(child: Text('${p.openingHours}', style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: p.name == selected ? Color(0xFF4A90E2).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: IconButton(
                                                tooltip: t?.adminSelectAsActive ?? 'Seleccionar como activo',
                                                icon: Icon(Icons.check_circle, color: p.name == selected ? Color(0xFF4A90E2) : Colors.grey, size: 22),
                                                onPressed: () {
                                                  DistributionService.instance.setInfo(p);
                                                  setState(() {
                                                    _pointName = p.name;
                                                    _address = p.address;
                                                    _openingHours = p.openingHours;
                                                    _available = p.available;
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: IconButton(
                                                icon: Icon(Icons.delete, color: Colors.redAccent, size: 22),
                                                onPressed: () {
                                                  DistributionService.instance.removePointAt(idx);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
