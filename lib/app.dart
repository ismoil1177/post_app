import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_app/blocs/auth/auth_bloc.dart';
import 'package:post_app/blocs/post/post_bloc.dart';
import 'package:post_app/pages/home_page.dart';
import 'package:post_app/pages/sign_in_page.dart';
import 'package:post_app/services/auth_service.dart';

import 'blocs/main/main_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<PostBloc>(create: (_) => PostBloc()),
        BlocProvider<MainBloc>(create: (_) => MainBloc()),
      ],
      child: MaterialApp(
        // themeMode: RCService.mode ? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData.light(useMaterial3: true),

        home: StreamBuilder<User?>(
          initialData: null,
          stream: AuthService.auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return const HomePage();
            } else {
              return SignInPage();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
