import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat('#,##0.00', 'en_EG');
  return formatter.format(amount);
}