import 'package:dio/dio.dart' show DioException;
import 'package:get/get.dart';
import 'package:loyalty/consts.dart';
import 'package:loyalty/controllers/auth_controller.dart';
import 'package:loyalty/models/loyalty_point.dart';
import 'package:loyalty/models/order.dart';
import 'package:loyalty/models/response.dart';

class OrderController extends GetxController {
  RxList<Order> orders = <Order>[].obs;
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();

    fetchOrders();
  }

  Future fetchOrders() async {
    try {
      final res = await dio.get('orders/');
      orders.clear();
      print(res.data);
      orders.addAll((res.data as List).map((o) => Order.fromJson(o)).toList());
    } on DioException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future makeOrder(double amount) async {
    try {
      // final res = await dio.post(
      //   'orders/',
      //   data: {
      //     'totalAmount': amount,
      //   },
      // );
      // To follow task SPEC (Not secure but to follow exact spec)
      final res = await dio.post(
        'loyalty/add',
        data: {
          'user_id': _authController.currentUser.value!.userId,
          'order_total': amount,
        },
      );
      print(res.data);
      Order newOrder = Order.fromJson(res.data['data']);
      // newOrder.loyaltyPoints = LoyaltyPoint.fromJson(res.data['loyaltyPoint']);
      orders.add(newOrder);
      _authController.fetchUser();
      return ResponseStatus(
        success: true,
        message: res.data['message'] ?? 'Order made successfully',
      );
    } on DioException catch (e) {
      print(e);

      return ResponseStatus(
        success: false,
        message: e.response?.data['error'] ?? e.message,
      );
    } catch (e) {
      print(e);
      return ResponseStatus(
        success: false,
        message: e.toString(),
      );
    }
  }
}