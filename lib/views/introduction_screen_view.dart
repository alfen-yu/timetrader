import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:timetrader/constants/routes.dart';

class IntroductionScreenView extends StatelessWidget {
  const IntroductionScreenView({super.key});

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Padding(
          padding: const EdgeInsets.only(top: 60.0), 
          child: Center(
            child: Image.asset(
              'assets/introduction_screen_1.jpg',
            ),
          ),
        ),
        title: 'Welcome to Time Trader',
        body: "Tell us what you need, it's FREE to post.",
      ),
      PageViewModel(
        image: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Image.asset(
              'assets/introduction_screen_2.jpg',
            ),
          ),
        ),
        title: 'Review Offers',
        body: 'Receive offers from trusted Time Traders.',
      ),
      PageViewModel(
        image: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Image.asset(
              'assets/introduction_screen_3.jpg',
            ),
          ),
        ),
        title: 'Hire the right tasker',
        body: 'Choose the right person for the task',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        done: const Text(
          'Get Started',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        onDone: () {
          Navigator.of(context).pushReplacementNamed(loginRoute);
        },
        pages: getPages(),
        globalBackgroundColor: Colors.white,
        showNextButton: true,
        next: const Icon(Icons.arrow_forward),
        showSkipButton: true,
        skip: const Text('Skip', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}