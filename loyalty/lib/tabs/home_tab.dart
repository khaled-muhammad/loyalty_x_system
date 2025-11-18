import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:loyalty/controllers/auth_controller.dart';
import 'package:loyalty/utils/currency_utils.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => _authController.currentUser.value == null? SizedBox.shrink() : Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: LottieBuilder.asset('assets/wallet.json', repeat: false,),
            ),
            Text("Total Spent"),
            Text(
              formatCurrency(_authController.currentUser.value!.totalMoneySpent),
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 100,
              child: Divider(
                color: Colors.green,
              ),
            ),
            Text("Points"),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(61, 131, 241, 134),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10
                ),
                child: Obx(() => Text(
                    "${_authController.currentUser.value!.points} Pts",
                    style: TextStyle(
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                spacing: 20,
                children: [
                  Column(
                    children: [
                      FilledButton(
                        onPressed: () => Get.toNamed('/points_summary'),
                        style: FilledButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(14)
                        ),
                        child: Icon(
                          LucideIcons.star,
                          size: 26,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Points")
                    ],
                  ),
                  Column(
                    children: [
                      FilledButton(
                        onPressed: () => Get.toNamed('/add_order_screen'), //makeOrderBottomSheet,
                        style: FilledButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(14)
                        ),
                        child: Icon(
                          LucideIcons.shoppingBag,
                          size: 26,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Make Order")
                    ],
                  ),
                  Column(
                    children: [
                      FilledButton(
                        onPressed: () => Get.toNamed('/payments'),
                        style: FilledButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(14)
                        ),
                        child: Icon(
                          LucideIcons.dollarSign,
                          size: 26,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Payments")
                    ],
                  ),
                  Column(
                    children: [
                      FilledButton(
                        onPressed: () {
                          Get.toNamed('/cards');
                        },
                        style: FilledButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(14)
                        ),
                        child: Icon(
                          LucideIcons.creditCard,
                          size: 26,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Cards")
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void makeOrderBottomSheet() {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Order",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text("Price")
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: FilledButton(
                  onPressed: () {
                
                  },
                  child: Text("Purchase")
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}