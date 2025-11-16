import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class MoneyLoaderScreen extends StatelessWidget {
  const MoneyLoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: LottieBuilder.asset('assets/Money.json'),
      ),
    );
  }
}