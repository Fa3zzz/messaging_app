import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/auth_bloc.dart';
import 'package:messaging_app/bloc/auth_event.dart';
import 'package:messaging_app/bloc/auth_state.dart';
import 'package:messaging_app/helpers/loading_screen.dart';
import 'package:messaging_app/services/auth/firebase_auth_provider.dart';
import 'package:messaging_app/views/chats_view.dart';
import 'package:messaging_app/views/forgot_password_view.dart';
import 'package:messaging_app/views/login_view.dart';
import 'package:messaging_app/views/register_view.dart';
import 'package:messaging_app/views/verify_email_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: 'Messaging App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ).secondary,
          foregroundColor: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ).onSecondary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
            ).onSecondary.withAlpha(150),
          ),
        ),
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
    ),
  );
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthEventInitialize());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state.isLoading) {
          LoadingScreen().show(
            context: context, 
            text: state.loadingText ?? 'Please wait a moment...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const ChatsView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}