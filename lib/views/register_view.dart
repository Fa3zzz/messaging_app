import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/auth_bloc.dart';
import 'package:messaging_app/bloc/auth_event.dart';
import 'package:messaging_app/bloc/auth_state.dart';
import 'package:messaging_app/services/auth/auth_exceptions.dart';
import 'package:messaging_app/utilities/dialogs/error_dialog.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _username;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if(state.exception is WeakPasswordAuthExceptions) {
            await showErrorDialog(context, 'Weak Password');
          } else if(state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is InvalidEmailAuthException) {
            showErrorDialog(context, 'Invalid email');
          } else if(state.exception is GenericAuthExceptions) {
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _username,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: 'Username'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _password,
                autocorrect: false,
                enableSuggestions: false,
                autofocus: true,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final email = _email.text;
                  final password = _password.text;
                  final username = _username.text;
                  context.read<AuthBloc>().add(AuthEventRegister(email, password, username));
                },
                child: const Text('Register'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text(
                  'Already a user? Login',
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
