import 'package:flutter/material.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        backgroundColor: Colors.lightBlueAccent, // Main color: light blue
        foregroundColor: Colors.white, // Font color: white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We've sent you an email verification link. Please verify your email.",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              "If you haven't received the verification email, you can resend it by pressing the button below.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'If the email verification link has expired, click the button below to resend it.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.lightBlueAccent, // Button background color: light blue
                foregroundColor: Colors.white, // Button font color: white
              ),
              child: const Text('Resend Verification Email'),
            ),
            const SizedBox(height: 32),
            const Text(
              "If you have already verified your email, you can proceed to login.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await AuthService.firebase().logout();
                if (!context.mounted) return; // Prevents navigation if the widget is disposed
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent, // Button background color: light blue
                foregroundColor: Colors.white, // Button font color: white
              ),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
