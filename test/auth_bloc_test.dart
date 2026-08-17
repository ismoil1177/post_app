import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/blocs/auth/auth_bloc.dart';

void main() {
  test('invalid sign in emits AuthFailure without calling Firebase', () async {
    final bloc = AuthBloc();

    final expectation = expectLater(
      bloc.stream,
      emits(const AuthFailure('Please check your email or password!')),
    );

    bloc.add(const SignInEvent(email: 'a', password: '1'));
    await expectation;
    await bloc.close();
  });

  test('invalid sign up emits AuthFailure without calling Firebase', () async {
    final bloc = AuthBloc();

    final expectation = expectLater(
      bloc.stream,
      emits(const AuthFailure('Please check your data!')),
    );

    bloc.add(
      const SignUpEvent(
        username: '',
        email: 'a',
        password: 'secret',
        prePassword: 'other',
      ),
    );
    await expectation;
    await bloc.close();
  });
}
