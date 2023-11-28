class Budget {
  final String id;
  final String category;
  final String title;
  final int spendTotal;
  final int limit;
  final String date;
  final String description;

  Budget({
    required this.id,
    required this.category,
    required this.title,
    required this.spendTotal,
    required this.limit,
    required this.date,
    required this.description,
  });

  factory Budget.createFromJson(Map<String, dynamic> json) {
    return Budget(
      id: json["id"],
      category: json["category"],
      title: json["title"],
      spendTotal: int.parse(json["spend_total"]),
      limit: int.parse(json["limit"]),
      date: json["date"],
      description: json["description"],
    );
  }
}
