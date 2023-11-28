class Transaction {
  final String id;
  final String? savingId;
  final String? budgetId;
  final String category;
  final int amount;
  final String dateTime;
  final String description;

  Transaction({
    required this.id,
    required this.savingId,
    required this.budgetId,
    required this.category,
    required this.amount,
    required this.dateTime,
    required this.description,
  });

  factory Transaction.createFromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"],
      savingId: json["saving_id"],
      budgetId: json["budget_id"],
      category: json["category"],
      amount: int.parse(json["amount"]),
      dateTime: json["date_time"],
      description: json["description"],
    );
  }
}
