import 'package:json_annotation/json_annotation.dart';
part 'UberTimes.g.dart';

@JsonSerializable(explicitToJson: true)
class UberTimes {
  final String localized_display_name;
  final int estimate;
  final String display_name;
  final String product_id;

  UberTimes(
    {required this.localized_display_name,
      required this.estimate,
      required this.display_name,
      required this.product_id});

  factory UberTimes.fromJson(Map<String, dynamic> json) => _$UberTimesFromJson(json);

  Map<String, dynamic> toJson() => _$UberTimesToJson(this);
}




