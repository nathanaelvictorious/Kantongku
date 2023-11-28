class Balance {
  final String id;
  final int balance;

  Balance({
    required this.id,
    required this.balance,
  });

  factory Balance.createFromJson(Map<String, dynamic> json) {
    return Balance(
      id: json["id"],
      balance: json["balance"],
    );
  }
}
