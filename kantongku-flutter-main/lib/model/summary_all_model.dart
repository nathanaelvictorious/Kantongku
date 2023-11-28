class SummaryFinancial {
  final int amount;

  SummaryFinancial({required this.amount});

  factory SummaryFinancial.createFromJson(String json) {
    return SummaryFinancial(
      amount: int.parse(json),
    );
  }
}
