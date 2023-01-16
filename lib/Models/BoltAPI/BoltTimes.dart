import 'package:json_annotation/json_annotation.dart';
part 'BoltTimes.g.dart';

@JsonSerializable(explicitToJson: true)
class BoltTimes {
  final String localized_display_name;
  final int estimate;
  final String display_name;
  final String product_id;

  BoltTimes(
      {required this.localized_display_name,
        required this.estimate,
        required this.display_name,
        required this.product_id});

  factory BoltTimes.fromJson(Map<String, dynamic> json) => _$BoltTimesFromJson(json);

  Map<String, dynamic> toJson() => _$BoltTimesToJson(this);
}




