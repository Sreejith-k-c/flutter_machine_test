// models/gift_card_model.dart
class GiftCard {
  final String id;
  final String title;
  final double minAmount;
  final double maxAmount;
  final bool disablePurchase;
  final List<Discount> discounts;
  final List<String> redeemSteps;

  GiftCard({
    required this.id,
    required this.title,
    required this.minAmount,
    required this.maxAmount,
    required this.disablePurchase,
    required this.discounts,
    required this.redeemSteps,
  });

  factory GiftCard.fromJson(Map<String, dynamic> json) {
    return GiftCard(
      id: json['id'],
      title: json['title'],
      minAmount: (json['minAmount'] as num).toDouble(),
      maxAmount: (json['maxAmount'] as num).toDouble(),
      disablePurchase: json['disablePurchase'],
      discounts: (json['discounts'] as List)
          .map((d) => Discount.fromJson(d))
          .toList(),
      redeemSteps: List<String>.from(json['redeemSteps'][0].entries
          .map((e) => e.value)
          .whereType<String>()),
    );
  }
}

class Discount {
  final String method;
  final double percent;

  Discount({
    required this.method,
    required this.percent,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      method: json['method'],
      percent: (json['percent'] as num).toDouble(),
    );
  }
}