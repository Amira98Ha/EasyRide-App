import 'package:json_annotation/json_annotation.dart';
part 'ride.g.dart';

@JsonSerializable(explicitToJson: true)
class ride {
  final String? carId;
  final String? carType;
  final String? carColor;
  final double? locationLat;
  final double? locationLng;

  ride(
      {required this.carId,
        required this.carType,
        required this.carColor,
        required this.locationLat,
        required this.locationLng,});

  factory ride.fromJson(Map<String, dynamic> json) => _$rideFromJson(json);

  Map<String, dynamic> toJson() => _$rideToJson(this);
}




