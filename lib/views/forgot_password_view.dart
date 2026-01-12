import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/auth_bloc.dart';
import 'package:messaging_app/bloc/auth_event.dart';
import 'package:messaging_app/bloc/auth_state.dart';
import 'package:messaging_app/utilities/dialogs/error_dialog.dart';
import 'package:messaging_app/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {


  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if(state is AuthStateForgotPassword) {
          if(state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context, 'Could not process the request, please make sure you are a registered user');
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(title: const Text('Forgot Password')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Please enter the email you have registered with and we will send you a reset link',
              ),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Your email..'),
              ),
              SizedBox(height: 16.0,),
              ElevatedButton(
                onPressed: () {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(AuthEventForgotPassword(email: email));
                },
                child: const Text('Send password reset link'),
              ),
              TextButton(onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              }, child: const Text(
                'Back to login',
                style: TextStyle(color: Colors.lightBlueAccent),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
