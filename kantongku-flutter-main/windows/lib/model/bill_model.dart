class Bill {
  final String id;
  final String name;
  final int amount;
  final String dueDate;
  final String description;
  final bool isPaid;

  Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.description,
    required this.isPaid,
  });

  factory Bill.createFromJson(Map<String, dynamic> json) {
    return Bill(
      id: json["id"],
      name: json["name"],
      amount: int.parse(json["amount"]),
      dueDate: json["due_date"],
      description: json["description"],
      isPaid: json["is_paid_off"],
    );
  }
}
