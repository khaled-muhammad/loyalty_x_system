import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:loyalty/consts.dart';
import 'package:loyalty/models/card.dart';
import 'package:loyalty/models/response.dart';

class CardController extends GetxController {
  RxList<Card> cards    = <Card>[].obs;
  Rx<Card?> defaultCard = Rx<Card?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCards();
  }

  Future fetchCards() async {
    try {
      final res = await dio.get('cards/');
      cards.clear();
      cards.addAll((res.data as List).map((c) {
        Card card = Card.fromJson(c);

        if (card.isDefault) {
          defaultCard.value = card;
        } else {
          print(card.isDefault);
        }

        return card;
      }).toList());
    } on DioException catch (e) {
      print(e);
      print(e.response?.data);
    } catch (e) {
      print(e);
    }
  }

  Future<ResponseStatus> createCard({
    required String cardHolderName,
    required String cardNumber,
    required int cardYear,
    required int cardMonth,
    required String cardCvv,
  }) async {
    try {
      final res = await dio.post(
        'cards/',
        data: {
          'cardHolderName': cardHolderName,
          'cardNumber': cardNumber,
          'cardYear': cardYear,
          'cardMonth': cardMonth,
          'cardCvv': cardCvv,
        },
      );

      final cardData = res.data['data'];
      Card newCard = Card.fromJson(cardData);

      cards.add(newCard);
      if (newCard.isDefault) {
        defaultCard.value = newCard;
      }

      return ResponseStatus(
        success: true,
        message: res.data['message'] ?? 'Card added successfully',
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

  Future<ResponseStatus> setDefault(String cardId) async {
    try {
      final res = await dio.put(
        'cards/$cardId',
      );

      fetchCards();

      return ResponseStatus(
        success: true,
        message: res.data['message'] ?? 'Card has been set as default successfully',
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

  Future<ResponseStatus> delete(String cardId) async {
    try {
      final res = await dio.delete(
        'cards/$cardId',
      );

      fetchCards();

      return ResponseStatus(
        success: true,
        message: res.data['message'] ?? 'Card has been deleted successfully',
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