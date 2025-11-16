import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10
        ),
        child: Column(
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Theme Mode",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text("Light")
                ],
              ),
              Switch.adaptive(
                value: false,
                onChanged: (value) {
                  showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.info(
                        message: "Sorry, I didn't find enough time to implement themes!",
                      ),
                  );
                },
              )
            ],
           ),
           const SizedBox(height: 100),
           Center(
            child: Text(
              "More settings coming soon ...",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.black54,
              ),
            ),
           ),
          ],
        ),
      ),
    );
  }
}