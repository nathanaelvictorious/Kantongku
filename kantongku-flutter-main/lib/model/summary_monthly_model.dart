class SummaryMonthly {
  final int amount;
  final String month;

  SummaryMonthly({
    required this.amount,
    required this.month,
  });

  factory SummaryMonthly.createFromJson(Map<String, dynamic> json) {
    return SummaryMonthly(
      amount: json['amount'],
      month: json['month'],
    );
  }
}
