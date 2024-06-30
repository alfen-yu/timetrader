import 'package:flutter/material.dart';
import 'package:timetrader/constants/routes.dart';
import 'package:timetrader/services/auth/auth_service.dart';
import 'package:timetrader/views/dashboard/dashboard_view.dart';
import 'package:timetrader/views/dashboard/tasks_views/crud_task.dart';
import 'package:timetrader/views/introduction_screen_view.dart';
import 'package:timetrader/views/login_view.dart';
import 'package:timetrader/views/register_view.dart';
import 'package:timetrader/views/verify_email_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Trader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        introductionScreenRoute: (context) => const IntroductionScreenView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        dashboardRoute: (context) => const DashboardView(),
        crudTaskViewRoute: (context) => const CRUDTaskView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // While waiting for initialization
        } else {
          final user = AuthService.firebase().currentUser;
          if (user != null) {
            if (user.isEmailVerified) {
              return const DashboardView();
            } else {
              return const VerifyEmailView();
            }
          } else {
            return const IntroductionScreenView();
          }
        }
      },
    );
  }
}
