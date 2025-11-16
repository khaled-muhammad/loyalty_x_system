import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty/controllers/card_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:u_credit_card/u_credit_card.dart';
import 'package:loyalty/models/card.dart' as cc;

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final CardController _cardController = Get.put(CardController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cards"),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(LucideIcons.chevronLeft)
        ),
      ),
      body: Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _cardController.defaultCard.value == null? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("No cards have been added yet!"),
                const SizedBox(height: 20),
                Icon(LucideIcons.braces, size: 80, color: Colors.green.shade100,)
              ],
            ),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12
                ),
                child: Text(
                  "Default Card",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 8
                ),
                child: CreditCardUi(
                  cardHolderFullName: _cardController.defaultCard.value!.cardHolderName,
                  cardNumber: _cardController.defaultCard.value!.cardNumber,
                  validThru: '${_cardController.defaultCard.value!.cardMonth}/${_cardController.defaultCard.value!.cardYear}',
                  topLeftColor: Colors.teal,
                  bottomRightColor: Colors.green,
                  cvvNumber: _cardController.defaultCard.value!.cardCvv
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _cardController.cards.length,
                  itemBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showCardBottomSheet(_cardController.cards[i]);
                      },
                      child: CreditCardUi(
                        cardHolderFullName: _cardController.cards[i].cardHolderName,
                        cardNumber: _cardController.cards[i].cardNumber,
                        validThru: '${_cardController.cards[i].cardMonth}/${_cardController.cards[i].cardYear}',
                        topLeftColor: Colors.teal,
                        bottomRightColor: Colors.green,
                        enableFlipping: true,
                        cvvNumber: _cardController.cards[i].cardCvv
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewCardBottomSheet,
        child: Icon(LucideIcons.plus),
      ),
    );
  }

  void showCardBottomSheet(cc.Card card) {
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
                "Card Settings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CreditCardUi(
                    cardHolderFullName: card.cardHolderName,
                    cardNumber: card.cardNumber,
                    validThru: '${card.cardMonth}/${card.cardYear}',
                    topLeftColor: Colors.teal,
                    bottomRightColor: Colors.green,
                    cvvNumber: card.cardCvv
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: card.isDefault? null : () {
                        _cardController.setDefault(card.id).then((res) {
                          if (res.success) {
                            if(mounted) {
                              showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    message: res.message,
                                  ),
                              );
                            }
                            Get.back();
                          } else {
                            if(mounted) {
                              showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    message: res.message,
                                  ),
                              );
                            }
                          }
                        }).catchError((err) {
                          print(err);
                          if(mounted) {
                            showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                  message: "Unknown error happened!",
                                ),
                            );
                          }
                        });
                      },
                      child: Text("Make Default")
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 130, 30, 23)
                      ),
                      onPressed: () {
                        _cardController.delete(card.id).then((res) {
                          if (res.success) {
                            if(mounted) {
                              showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    message: res.message,
                                  ),
                              );
                            }
                            Get.back();
                          } else {
                            if(mounted) {
                              showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    message: res.message,
                                  ),
                              );
                            }
                          }
                        }).catchError((err) {
                          print(err);
                          if(mounted) {
                            showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                  message: "Unknown error happened!",
                                ),
                            );
                          }
                        });
                      },
                      child: Text("Delete")
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void addNewCardBottomSheet() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController monthController = TextEditingController();
    final TextEditingController yearController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Card",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 16),

              // Card Holder Name
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Card Holder Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Card Number",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: monthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Month",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: yearController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Year",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "CVV",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final number = numberController.text.trim();
                    final month = int.tryParse(monthController.text.trim()) ?? 0;
                    final year = int.tryParse(yearController.text.trim()) ?? 0;
                    final cvv = cvvController.text.trim();

                    if (name.isEmpty || number.isEmpty || month == 0 || year == 0 || cvv.isEmpty) {
                      Get.snackbar("Error", "Please fill all fields");
                      return;
                    }

                    final res = await _cardController.createCard(
                      cardHolderName: name,
                      cardNumber: number,
                      cardMonth: month,
                      cardYear: year,
                      cardCvv: cvv,
                    );

                    if (res.success) {
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
                      }
                    }
                  },
                  child: Text("Add Card"),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}