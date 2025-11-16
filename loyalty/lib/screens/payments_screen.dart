import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyalty/controllers/auth_controller.dart';
import 'package:loyalty/controllers/orders_controller.dart';
import 'package:loyalty/models/order.dart';
import 'package:loyalty/utils/currency_utils.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final AuthController _authController   = Get.find();
  final OrderController _orderController = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(LucideIcons.chevronLeft)
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 22
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal,
                    Colors.lightGreen,
                  ],
                  begin: AlignmentGeometry.topLeft,
                  end: AlignmentGeometry.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22)
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 30,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Obx(() => Text(
                          "${formatCurrency(_authController.currentUser.value!.totalMoneySpent)} \$",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Text("Total Spent", style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                itemCount: _orderController.orders.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text("${_orderController.orders[i].totalAmount} EGP Paid"),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_orderController.orders[i].loyaltyPoints?.pointsEarned} Pts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Align(
                        alignment: AlignmentGeometry.bottomRight,
                        child: Text(
                          DateFormat("dd, MMM yyyy").format(_orderController.orders[i].createdAt),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () => showPaymentInfo(_orderController.orders[i]),
                    icon: Icon(LucideIcons.view)
                  ),
                  isThreeLine: true,
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPaymentInfo(Order order) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            18,
            18,
            18,
            MediaQuery.of(Get.context!).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Order Details",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Icon(LucideIcons.receipt, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Order ID: ${order.id}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),

              Row(
                children: [
                  Icon(LucideIcons.wallet, size: 22),
                  SizedBox(width: 10),
                  Text(
                    "Total: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "${order.totalAmount.toStringAsFixed(2)} EGP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(height: 14),

              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.creditCard, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.card.cardHolderName,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "**** **** **** ${order.card.cardNumber.substring(order.card.cardNumber.length - 4)}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),

              if (order.loyaltyPoints != null) ...[
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Color(0xfff7ffe8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.badgeCheck, size: 22, color: Colors.green),
                      SizedBox(width: 10),
                      Text(
                        "+${order.loyaltyPoints!.pointsEarned} Points Earned",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],

              // DATE
              Row(
                children: [
                  Icon(LucideIcons.calendar, size: 22),
                  SizedBox(width: 10),
                  Text(
                    "Purchased on: ${order.createdAt.toString().split(' ')[0]}",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),

      isScrollControlled: true,
      elevation: 8,
      enableDrag: true,
    );
  }
}