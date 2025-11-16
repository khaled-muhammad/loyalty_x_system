import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty/controllers/auth_controller.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _authController.currentUser.value == null? const SizedBox.shrink() : Container(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 22,
          ),
          child: Column(
            children: [
              Text(
                "Profile",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Username: "),
                  Text(_authController.currentUser.value!.username)
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Email: "),
                  Text(_authController.currentUser.value!.email)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}