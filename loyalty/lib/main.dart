import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loyalty/controllers/auth_controller.dart';
import 'package:loyalty/middlewares/auth_middleware.dart';
import 'package:loyalty/screens/auth/register_screen.dart';
import 'package:loyalty/screens/cards_screen.dart';
import 'package:loyalty/screens/dashboard_screen.dart';
import 'package:loyalty/screens/loaders/money_loader_screen.dart';
import 'package:loyalty/screens/loaders/splash_screen.dart';
import 'package:loyalty/screens/make_order_screen.dart';
import 'package:loyalty/screens/payments_screen.dart';
import 'package:loyalty/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final authCtx = AuthController();
  Get.put(authCtx, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Loyalty System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 255, 248),
        filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 30
          )
        )),
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
        ),
        fontFamily: 'StackSansNotch',
      ),
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/welcome',
          page: () => const WelcomeScreen(),
        ),
        GetPage(
          name: '/auth/register',
          page: () => const RegisterScreen(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => const DashboardScreen(),
          middlewares: [
            AuthMiddleware(),
          ]
        ),
        GetPage(
          name: '/cards',
          page: () => const CardsScreen(),
        ),
        GetPage(
          name: '/payments',
          page: () => const PaymentsScreen(),
        ),
        GetPage(
          name: '/add_order_screen',
          page: () => const MakeOrderScreen(),
        ),
        GetPage(
          name: '/loaders/money',
          page: () => const MoneyLoaderScreen(),
          transition: Transition.fade,
          opaque: false,
          popGesture: false,
          fullscreenDialog: true,
        ),
      ],
      initialRoute: '/splash',
    );
  }
}