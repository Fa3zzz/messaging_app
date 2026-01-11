import 'package:flutter/material.dart';
import 'package:messaging_app/views/verify_email_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              enableSuggestions: false,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            SizedBox(height: 16.0,),
            TextField(
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
            SizedBox(height: 16.0,),
            TextField(
              autocorrect: false,
              enableSuggestions: false,
              autofocus: true,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
            SizedBox(height: 16.0,),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder:(context) => const VerifyEmailView(),)
              );
            }, 
            child: const Text('Register'),
          ),
          SizedBox(height: 16.0,),
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const Text(
            'Already a user? Login',
            style: TextStyle(
              color: Colors.lightBlueAccent
            ),
          ),
          ),
          ],
        ),
      ),
    );
  }
}