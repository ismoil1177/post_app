import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_app/blocs/auth/auth_bloc.dart';
import 'package:post_app/pages/sign_in_page.dart';
import 'package:post_app/services/strings.dart';

void main() {
  testWidgets('sign in page shows form fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => AuthBloc(),
          child: SignInPage(),
        ),
      ),
    );

    expect(find.text(I18N.signin), findsWidgets);
    expect(find.text(I18N.email), findsOneWidget);
    expect(find.text(I18N.password), findsOneWidget);
  });

  testWidgets('invalid sign in shows an error snackbar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => AuthBloc(),
          child: SignInPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'a');
    await tester.enterText(find.byType(TextField).at(1), '1');
    await tester.tap(find.widgetWithText(ElevatedButton, I18N.signin));
    await tester.pump();

    expect(
      find.text('Please check your email or password!'),
      findsOneWidget,
    );
  });
}
