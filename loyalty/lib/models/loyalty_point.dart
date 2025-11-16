class LoyaltyPoint {
  LoyaltyPoint({
    required this.id,
    required this.orderId,
    required this.pointsEarned,
  });

  final String id;
  final String orderId;
  final int pointsEarned;

  static LoyaltyPoint fromJson(Map<String, dynamic> data) {
    return LoyaltyPoint(
      id: data['id'],
      orderId: data['orderId'],
      pointsEarned: data['pointsEarned'],
    );
  }

  static Map<String, dynamic> toJson(LoyaltyPoint lp) {
    return {
      'id': lp.id,
      'orderId': lp.orderId,
      'pointsEarned': lp.pointsEarned,
    };
  }
}
