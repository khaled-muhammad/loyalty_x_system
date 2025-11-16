// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:loyalty/screens/auth/register_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 20
              ),
              child: Text(
                "Welcome!",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Hero(
              tag: 'logo',
              child: Image.asset('assets/logo.png', width: 120,),
            ),
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Lottie.asset('assets/collect_money.json'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                "Save & Grow\nPoints",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text.rich(
              TextSpan(
                text: "Earn points with ",
                style: TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  TextSpan(
                    text: "Loyalty X",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 33, 106, 35),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20
                    ),
                  ),
                  TextSpan(
                    text: " by making orders.",
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      bottom: 8
                    ),
                    child: Hero(
                      tag: 'reg-btn',
                      child: GradientElevatedButton.icon(
                        label: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        icon: Icon(
                          LucideIcons.userRoundPlus,
                          color: Colors.white,
                        ),
                        onPressed: () => Get.toNamed('/auth/register', arguments: {'authMode': AuthMode.register}),
                        style: GradientElevatedButton.styleFrom(
                          backgroundGradient: const LinearGradient(
                            colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(12)
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: const Color.fromARGB(167, 41, 104, 10),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => Get.toNamed('/auth/register', arguments: {'authMode': AuthMode.login}),
                          icon: Icon(LucideIcons.logIn),
                          label: Text("Login"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}