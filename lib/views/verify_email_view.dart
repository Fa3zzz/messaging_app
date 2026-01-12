import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/bloc/auth_bloc.dart';
import 'package:messaging_app/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "we've sent you a verification email, please check your mail and follow the steps to verify.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),  
            ),
            SizedBox(height: 16.0,),
            Text(
              "If you can't find it, please check your spam folder, and if you haven't recevied it:",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: 16.0,),
            ElevatedButton(onPressed: () {
              context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
            }, 
            child: Text(
              'Resend Verification Email',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),  
            ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              }, 
              child: const Text(
                'Restart',
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}