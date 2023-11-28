import 'package:intl/intl.dart';

class TransactionEachCategory {
  final String category;
  final int total;
  final int amount;
  final String text;

  TransactionEachCategory({
    required this.category,
    required this.total,
    required this.amount,
    required this.text,
  });

  factory TransactionEachCategory.createFromJson(Map<String, dynamic> json) {
    return TransactionEachCategory(
      category: json['category'],
      total: json['total'],
      amount: json['amount'],
      text:
          '${json['category']} \n Rp ${NumberFormat('#,##0', 'ID').format(json['amount'])} \n(${json['total']} kali)',
    );
  }
}
