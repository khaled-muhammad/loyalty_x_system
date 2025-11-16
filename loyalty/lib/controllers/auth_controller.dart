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
    // if (hasInit) {
    //   return;
    // }
    _preferences = await SharedPreferences.getInstance();

    if (accessToken.value != null) {
      dio.options.headers['Authorization'] = "Bearer $accessToken";
      await fetchUser();
    } else if (_preferences!.containsKey('access_token')) {
      accessToken.value = _preferences!.getString('access_token');
      currentUser.value = User.fromJson(jsonDecode(_preferences!.getString('user')!));

      dio.options.headers['Authorization'] = "Bearer $accessToken";

      await fetchUser();
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
      
      _preferences!.setString('access_token', res.data['access_token']);
      _preferences!.setString('user', jsonEncode(User.toJson(currentUser.value!)));
      await initialize();
      
      try {
        Get.find<CardController>().fetchCards();
      } catch (e) {}
      return ResponseStatus(success: true, message: "You are logged in successfully!");
    } on DioException catch (e) {
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
      });
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
    try {
      dio.options.headers.remove('Authorization');
    } catch (e) {
      
    }
    Get.offAllNamed('/welcome');
  }

  Future fetchUser() async {
    final res = await dio.get('auth/me');
    currentUser.value = User.fromJson(res.data);
    _preferences!.setString('user', jsonEncode(User.toJson(currentUser.value!)));
  }
}
