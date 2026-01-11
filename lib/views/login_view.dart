import 'package:flutter/material.dart';
import 'package:messaging_app/views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        title: const Text('Login',),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              autocorrect: false,
              enableSuggestions: false,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Enter Username'),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              enableSuggestions: false,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Enter Password'),
            ),
            SizedBox(height: 16.0,),
            ElevatedButton(onPressed: () {
             print('User would like to login');
            }, 
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            ),
            SizedBox(height: 16.0,),
            TextButton(onPressed: () {
               Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegisterView(),  
                ),
              );
            }, 
            child: const Text(
              'Not registered yet? register now',
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