class User {

  User({required this.userId, required this.username, required this.email, this.points=0, this.totalMoneySpent=0});

  final String userId;
  final String username;
  final String email;
  int points;
  double totalMoneySpent;

  static User fromJson(Map data) {
    return User(
      userId: data['userId'],
      username: data['username'],
      email: data['email'],
      points: data['points'] ?? 0,
      totalMoneySpent: data['totalMoneySpent'] == null? 0:  double.tryParse(data['totalMoneySpent'].toString()) ?? 0
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'userId': user.userId,
      'username': user.username,
      'email': user.email,
      'points': user.points,
      'totalMoneySpent': user.totalMoneySpent,
    };
  }
}