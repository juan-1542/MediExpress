import 'package:flutter/foundation.dart';

class AppUser {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String role; // 'admin' or 'cliente'
  final String? avatarUrl;

  AppUser({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    this.avatarUrl,
    this.role = 'cliente',
  });

  bool get isAdmin => role.toLowerCase() == 'admin';
}

class _StoredUser {
  final AppUser user;
  final String password;
  _StoredUser(this.user, this.password);
}

class AuthService {
  AuthService._private() {
    // Sembrar usuarios de demostración sólo en modo debug para evitar exponer
    // credenciales en builds de producción.
    if (kDebugMode) {
      _seedDemoUsers();
    }
  }
  static final AuthService instance = AuthService._private();

  /// Credenciales demo (útiles para mostrar en la UI de login)
  /// Cada entrada tiene {'login': '<email o phone>', 'password': '<password>'}
  final List<Map<String, String>> demoCredentials = <Map<String, String>>[];

  // ValueNotifier para que la UI pueda reaccionar a cambios de usuario
  final ValueNotifier<AppUser?> currentUser = ValueNotifier<AppUser?>(null);

  // Simple store en memoria: email -> _StoredUser
  final Map<String, _StoredUser> _store = {};

  void _seedDemoUsers() {
    // Datos simulados — ajustar o ampliar según sea necesario.
    final demo = [
      {
        'fullName': 'Admin Demo',
        'email': 'admin@demo.com',
        'phone': '+573000000001',
        'address': 'Calle Demo 1',
        'password': 'admin123',
        'role': 'admin'
      },
      {
        'fullName': 'Cliente Demo',
        'email': 'cliente@demo.com',
        'phone': '+573000000002',
        'address': 'Calle Demo 2',
        'password': 'cliente123',
        'role': 'cliente'
      },
      {
        'fullName': 'Repartidor Demo',
        'email': 'repartidor@demo.com',
        'phone': '+573000000003',
        'address': 'Calle Repartidor 1',
        'password': 'repartidor123',
        'role': 'repartidor'
      },
      {
        'fullName': 'Usuario Teléfono',
        'email': 'userphone@demo.com',
        'phone': '+573001234567',
        'address': 'Calle Demo 3',
        'password': 'telefono123',
        'role': 'cliente'
      },
    ];

    for (final d in demo) {
      final user = AppUser(
        fullName: d['fullName']!,
        email: d['email']!,
        phone: d['phone']!,
        address: d['address']!,
        avatarUrl: null,
        role: d['role'] ?? 'cliente',
      );
      // Guardar en el store (la llave sigue siendo el email en minúsculas)
      _store[user.email.trim().toLowerCase()] = _StoredUser(user, d['password']!);
      // Exponer credenciales para la UI. Usamos el email como login, pero la autenticación
      // también acepta teléfono; la UI puede mostrar ambos si lo desea.
      demoCredentials.add({'login': user.email, 'password': d['password']!});
    }
  }

  /// Registra un usuario en memoria. Retorna true si se registró, false si ya existe.
  bool register(AppUser user, String password) {
    final key = user.email.trim().toLowerCase();
    if (_store.containsKey(key)) return false;
    _store[key] = _StoredUser(user, password);
    return true;
  }

  /// Intenta iniciar sesión con credenciales. Retorna true si son válidas y establece currentUser.
  bool loginWithCredentials(String emailOrPhone, String password) {
    final key = emailOrPhone.trim().toLowerCase();
    // Primero intentar por email
    final storedByEmail = _store[key];
    if (storedByEmail != null) {
      if (storedByEmail.password == password) {
        currentUser.value = storedByEmail.user;
        return true;
      }
      return false;
    }

    // Si no coincide por email, intentar buscar por teléfono
    final normPhone = _normalizePhone(emailOrPhone);
    for (final s in _store.values) {
      if (_normalizePhone(s.user.phone) == normPhone && s.password == password) {
        currentUser.value = s.user;
        return true;
      }
    }
    return false;
  }

  /// Cambia la contraseña de un usuario identificado por email o teléfono.
  /// Retorna true si el cambio tuvo éxito.
  bool changePassword(String emailOrPhone, String oldPassword, String newPassword) {
    final key = emailOrPhone.trim().toLowerCase();
    // intentar por email
    final stored = _store[key];
    if (stored != null) {
      if (stored.password != oldPassword) return false;
      _store[key] = _StoredUser(stored.user, newPassword);
      return true;
    }

    // intentar por teléfono
    final normPhone = _normalizePhone(emailOrPhone);
    for (final entry in _store.entries) {
      if (_normalizePhone(entry.value.user.phone) == normPhone) {
        if (entry.value.password != oldPassword) return false;
        _store[entry.key] = _StoredUser(entry.value.user, newPassword);
        return true;
      }
    }
    return false;
  }

  /// Actualiza los datos del usuario en el store; si cambió la clave actualiza la clave.
  /// Si el usuario no estaba registrado en el store, añade una entrada con la password especificada (si se pasa),
  /// o no la añade si no se encuentra registro previo.
  void updateUser(AppUser updated, {String? oldEmail, String? password}) {
    final newKey = updated.email.trim().toLowerCase();
    if (oldEmail != null) {
      final oldKey = oldEmail.trim().toLowerCase();
      final existing = _store.remove(oldKey);
      if (existing != null) {
        // si se pasó password, úsalo; si no, reutilizar el anterior
        final pw = password ?? existing.password;
        _store[newKey] = _StoredUser(updated, pw);
      } else {
        // no existía por oldEmail; si pasaron password, crear nuevo registro
        if (password != null) {
          _store[newKey] = _StoredUser(updated, password);
        }
      }
    } else {
      // no se proporcionó oldEmail; si existe, actualizar; si no y password dado, crear
      final existing = _store[newKey];
      if (existing != null) {
        _store[newKey] = _StoredUser(updated, password ?? existing.password);
      } else if (password != null) {
        _store[newKey] = _StoredUser(updated, password);
      }
    }
    // actualizar currentUser si corresponde
    if (currentUser.value != null && currentUser.value!.email.trim().toLowerCase() == newKey) {
      currentUser.value = updated;
    }
  }

  /// Forzar login con objeto AppUser (útil después de registro)
  void login(AppUser user) {
    currentUser.value = user;
  }

  void logout() {
    currentUser.value = null;
  }

  bool get isLoggedIn => currentUser.value != null;

  /// True si el usuario actual es admin
  bool get currentUserIsAdmin => currentUser.value?.isAdmin ?? false;

  String _normalizePhone(String p) {
    return p.replaceAll(RegExp(r'[^0-9+]'), '');
  }
}
