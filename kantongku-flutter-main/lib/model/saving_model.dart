class Saving {
  final String id;
  final String title;
  final int currentBalance;
  final int goalAmount;
  final String description;
  final bool isAchieved;

  Saving({
    required this.id,
    required this.title,
    required this.currentBalance,
    required this.goalAmount,
    required this.description,
    required this.isAchieved,
  });

  factory Saving.createFromJson(Map<String, dynamic> json) {
    return Saving(
      id: json["id"],
      title: json["title"],
      currentBalance: json["current_balance"],
      goalAmount: json["goal_amount"],
      description: json["description"],
      isAchieved: json["is_achieved"],
    );
  }
}
