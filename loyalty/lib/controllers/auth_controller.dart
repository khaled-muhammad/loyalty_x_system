import 'dart:convert';

import 'package:dio/dio.dart' show DioException;
import 'package:loyalty/consts.dart';
import 'package:loyalty/controllers/orders_controller.dart';
import 'package:loyalty/controllers/card_controller.dart';
import 'package:loyalty/models/response.dart';
import 'package:loyalty/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

class AuthController extends GetxController {
  SharedPreferences? _preferences;
  bool hasInit = false;
  Rx<User?> currentUser = Rx<User?>(null);
  Rx<String?> accessToken = Rx<String?>(null);

  RxBool processing = false.obs;

  Future initialize() async {
    if (hasInit) return;

    _preferences = await SharedPreferences.getInstance();

    final savedToken = _preferences!.getString('access_token');
    final savedUser = _preferences!.getString('user');
    Get.log(savedUser.toString());
    Get.log(savedToken.toString());
    if (savedToken != null && savedUser != null) {
      try {
        accessToken.value = savedToken;
        currentUser.value = User.fromJson(jsonDecode(savedUser));
        dio.options.headers['Authorization'] = "Bearer ${accessToken.value}";
        await fetchUser();
      } catch (e) {
        await logout();
      }
    }

    hasInit = true;
  }

  Future<ResponseStatus> login({required String username, required String password}) async {
    processing.value = true;

    try {
      final res = await dio.post('auth/login', data: {
        "username": username,
        "password": password
      });

      currentUser.value = User.fromJson(res.data);
      accessToken.value = res.data['access_token'];

      _preferences!.setString('access_token', accessToken.value!);
      _preferences!.setString('user', jsonEncode(User.toJson(currentUser.value!)));

      dio.options.headers['Authorization'] = "Bearer ${accessToken.value}";

      await initialize();

      try {
        Get.find<CardController>().fetchCards();
      } catch (_) {}

      return ResponseStatus(success: true, message: "You are logged in successfully!");
    } on DioException catch (e) {
      print(e.response?.data);
      return ResponseStatus(
        success: false,
        message: e.response!.data['error']
      );
    } finally {
      processing.value = false;
    }
  }

  Future<ResponseStatus> register({required String username, required String email, required String password}) async {
    processing.value = true;

    try {
      final res = await dio.post('auth/register', data: {
        "username": username,
        "email": email,
        "password": password,
      }).timeout(const Duration(seconds: 10));
      return ResponseStatus(success: true, message: res.data['message']);
    } on DioException catch (e) {
      return ResponseStatus(
        success: false,
        message: e.response!.data['error']
      );
    } finally {
      processing.value = false;
    }
  }

  Future logout() async {
    await _preferences!.remove('access_token');
    await _preferences!.remove('user');
    currentUser.value = null;
    accessToken.value = null;
    dio.options.headers.remove('Authorization');
    Get.offAllNamed('/welcome');
  }

  Future fetchUser() async {
    Get.log("fetching user");
    try {
      final res = await dio.get('auth/me').timeout(const Duration(seconds: 5));
      currentUser.value = User.fromJson(res.data);
      _preferences!.setString('user', jsonEncode(User.toJson(currentUser.value!)));
    } catch (_) {
      await logout();
    }
    Get.log("user fetched");
  }
}
