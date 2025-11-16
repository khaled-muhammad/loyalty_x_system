import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty/controllers/orders_controller.dart';
import '../controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();

    if (auth.accessToken.value == null) {
      return const RouteSettings(name: '/welcome');
    } else {
      Get.put(OrderController(), permanent: true);
    }

    return null;
  }
}
