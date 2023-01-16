import 'package:json_annotation/json_annotation.dart';
part 'UberPrices.g.dart';

@JsonSerializable(explicitToJson: true)
class UberPrices {
  final String localized_display_name;
  final double distance;
  final String display_name;
  final String product_id;
  final int high_estimate;
  final int low_estimate;
  final int duration;
  final String estimate;
  final String currency_code;

  UberPrices(
    {required this.localized_display_name,
      required this.distance,
      required this.display_name,
      required this.product_id,
      required this.high_estimate,
      required this.low_estimate,
      required this.duration,
      required this.estimate,
      required this.currency_code});

  factory UberPrices.fromJson(Map<String, dynamic> json) => _$UberPricesFromJson(json);

  Map<String, dynamic> toJson() => _$UberPricesToJson(this);
}




