import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:loyalty/controllers/auth_controller.dart';
import 'package:loyalty/tabs/home_tab.dart';
import 'package:loyalty/tabs/profile_tab.dart';
import 'package:loyalty/tabs/settings_tab.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTab      = 1;
  late int _targetPage = int.parse(_currentTab.toString());
  bool _userScrolling  = false;

  late final PageController _pageController = PageController(initialPage: _currentTab);

  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(() => _authController.currentUser.value == null? const SizedBox.shrink() : Text(
            "Hi, ${_authController.currentUser.value!.username}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                title: "Are you sure?",
                text: "you want to logout",
                confirmBtnText: "Logout",
                confirmBtnColor: const Color.fromARGB(255, 141, 33, 25),
                showConfirmBtn: true,
                showCancelBtn: true,
                onConfirmBtnTap: _authController.logout
              );
            },
            icon: Icon(LucideIcons.logOut)
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            _userScrolling = notification.direction != ScrollDirection.idle;
          }
          return false;
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (_userScrolling) {
              setState(() {
                _currentTab = index;
              });
            } else {
              if (index == _targetPage) {
                setState(() {
                  _currentTab = index;
                });
              }
            }
          },
          children: [
            ProfileTab(),
            HomeTab(),
            SettingsTab(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: const Color.fromARGB(255, 128, 230, 180),
        index: _currentTab,
        items: [
          CurvedNavigationBarItem(
            child: Icon(LucideIcons.user),
            label: 'Profile',
          ),
          CurvedNavigationBarItem(
            child: Icon(LucideIcons.house),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(LucideIcons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          _targetPage = index;
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
      ),
    );
  }


}