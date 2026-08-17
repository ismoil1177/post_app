import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/services/util_service.dart';

void main() {
  group('Util.validateRegistration', () {
    test('accepts complete matching credentials', () {
      expect(
        Util.validateRegistration(
          'alice',
          'alice@example.com',
          'secret',
          'secret',
        ),
        isTrue,
      );
    });

    test('rejects empty username or mismatched passwords', () {
      expect(
        Util.validateRegistration('', 'alice@example.com', 'secret', 'secret'),
        isFalse,
      );
      expect(
        Util.validateRegistration('alice', 'alice@example.com', 'secret', 'nope'),
        isFalse,
      );
    });
  });

  group('Util.validateSingIn', () {
    test('accepts a long enough email and password', () {
      expect(Util.validateSingIn('user@example.com', '1234'), isTrue);
    });

    test('rejects short email or password', () {
      expect(Util.validateSingIn('a@b.c', '1234'), isFalse);
      expect(Util.validateSingIn('user@example.com', '123'), isFalse);
    });
  });
}
