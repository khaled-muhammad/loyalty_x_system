import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authCtx = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    initialize();
    
  }

  Future<void> initialize() async {
    print("initialzing the auth ctrl ...");
    await authCtx.initialize();
    print("auth ctrl initialized");
    if (authCtx.currentUser.value != null) {
      Get.offAllNamed('/dashboard');
    } else {
      Get.offAllNamed('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}