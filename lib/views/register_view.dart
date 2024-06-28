import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/services/auth/auth_exceptions.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Screen'),
        backgroundColor: Colors.lightBlueAccent, // Main color: light blue
        foregroundColor: Colors.white, // Font color: white
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().createUser(email: email, password: password);
                  AuthService.firebase().sendEmailVerification();
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(context, 'Email account already in use.');
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, 'Your email address is invalid!');
                } on WeakPasswordAuthException {
                  await showErrorDialog(context, 'Please enter a strong password!');
                } on GenericAuthException {
                  await showErrorDialog(context, 'An unexpected error occurred.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent, 
                foregroundColor: Colors.white,
              ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 16.0),
            const Text('Already Registered?', textAlign: TextAlign.center),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightBlueAccent, // Font color: light blue
              ),
              child: const Text('Login Here'),
            ),
          ],
        ),
      ),
    );
  }
}
