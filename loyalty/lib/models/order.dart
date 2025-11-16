import 'card.dart';
import 'loyalty_point.dart';

class Order {
  Order({
    required this.id,
    required this.card,
    required this.totalAmount,
    required this.createdAt,
    this.loyaltyPoints,
  });

  final String id;
  final Card card;
  final double totalAmount;
  LoyaltyPoint? loyaltyPoints;
  DateTime createdAt;

  static Order fromJson(Map<String, dynamic> data) {
    return Order(
      id: data['id'],
      card: Card.fromJson(data['card']),
      totalAmount: (data['totalAmount'] as num).toDouble(),
      loyaltyPoints: data['loyaltyPoint'] != null
          ? LoyaltyPoint.fromJson(data['loyaltyPoint'])
          : null,
      createdAt: DateTime.parse(data['createdAt'])
    );
  }

  static Map<String, dynamic> toJson(Order order) {
    return {
      'id': order.id,
      'card': Card.toJson(order.card),
      'totalAmount': order.totalAmount,
      'loyaltyPoints':
          order.loyaltyPoints != null ? LoyaltyPoint.toJson(order.loyaltyPoints!) : null,
      'createdAt': order.createdAt,
    };
  }
}
