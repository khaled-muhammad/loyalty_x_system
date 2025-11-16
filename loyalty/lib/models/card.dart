class Card {
  Card({
    required this.id,
    required this.userId,
    required this.cardHolderName,
    required this.cardNumber,
    required this.cardYear,
    required this.cardMonth,
    required this.cardCvv,
    this.isDefault = false,
  });

  final String id;
  final String userId;
  final String cardHolderName;
  final String cardNumber;
  final int cardYear;
  final int cardMonth;
  final String cardCvv;
  bool isDefault;

  static Card fromJson(Map<String, dynamic> data) {
    return Card(
      id: data['id'],
      cardHolderName: data['cardHolderName'],
      userId: data['userId'],
      cardNumber: data['cardNumber'],
      cardYear: data['cardYear'],
      cardMonth: data['cardMonth'],
      cardCvv: data['cardCvv'],
      isDefault: data['default'] ?? false,
    );
  }

  static Map<String, dynamic> toJson(Card card) {
    return {
      'id': card.id,
      'userId': card.userId,
      'cardHolderName': card.cardHolderName,
      'cardNumber': card.cardNumber,
      'cardYear': card.cardYear,
      'cardMonth': card.cardMonth,
      'cardCvv': card.cardCvv,
      'default': card.isDefault,
    };
  }
}
