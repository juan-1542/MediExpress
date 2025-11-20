import 'package:flutter_test/flutter_test.dart';
import 'package:medi_express_front/Servicios/auth_service.dart';

void main() {
  test('demo users seeded', () {
    final creds = AuthService.instance.demoCredentials;
    bool found = creds.any((c) => c['login'] == 'repartidor@demo.com' && c['password'] == 'repartidor123');
    expect(found, true, reason: 'Repartidor demo should be seeded');
  });
}

