import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:loyalty/controllers/orders_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MakeOrderScreen extends StatefulWidget {
  const MakeOrderScreen({super.key});

  @override
  State<MakeOrderScreen> createState() => _MakeOrderScreenState();
}

class _MakeOrderScreenState extends State<MakeOrderScreen> {
  int points    = 0;
  double amount = 0;
  final OrderController _orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Make New Order"),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(LucideIcons.chevronLeft)
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              if(!isKeyboardVisible)
              SizedBox(
                width: double.infinity,
                height: 250,
                child: LottieBuilder.asset('assets/receive_order.json'),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color.fromARGB(255, 212, 255, 162),
                    border: Border.all(
                      color: Colors.lightGreen,
                      width: 2
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            label: Text("Enter Amount of Money"),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              amount = double.tryParse(value) ?? 0;
                              points = (amount / 10).round();
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 22,
                            bottom: 16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 233, 255, 208),
                              borderRadius: BorderRadius.circular(16)
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4
                            ),
                            child: Text(
                              "$points Pts",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: SizedBox(
              width: double.infinity,
              child: GradientElevatedButton(
                onPressed: amount < 1? null : () {
                  _orderController.makeOrder(amount).then((res) {
                    if (res.success) {
                      Get.back();
                      Get.back();
                      if(mounted) {
                        showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.success(
                              message: res.message,
                            ),
                        );
                      }
                    } else {
                      if(mounted) {
                        showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                              message: res.message,
                            ),
                        );
                        Get.back();
                        Get.back();
                      }
                    }
                  });
                  Get.toNamed('/loaders/money');
                },
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20
                  ),
                  child: Text(
                    'PAY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}