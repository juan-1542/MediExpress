import 'package:flutter_test/flutter_test.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';

void main() {
  test('Registro y login de repartidor', () {
    final auth = AuthService.instance;
    final user = AppUser(
      fullName: 'Test Repartidor',
      email: 'testrepartidor@example.com',
      phone: '+573210000000',
      address: 'Calle Test 1',
      role: 'repartidor',
    );
    final pw = 'repartidorTest123';

    // Registrar
    final registered = auth.register(user, pw);
    expect(registered, isTrue);

    // Intentar login
    final ok = auth.loginWithCredentials(user.email, pw);
    expect(ok, isTrue);
    expect(auth.currentUser.value, isNotNull);
    expect(auth.currentUser.value!.role.toLowerCase(), equals('repartidor'));
  });
}

