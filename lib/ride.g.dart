// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ride _$rideFromJson(Map<String, dynamic> json) => ride(
      carId: json['carId'] as String?,
      carType: json['carType'] as String?,
      carColor: json['carColor'] as String?,
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLng: (json['locationLng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$rideToJson(ride instance) => <String, dynamic>{
      'carId': instance.carId,
      'carType': instance.carType,
      'carColor': instance.carColor,
      'locationLat': instance.locationLat,
      'locationLng': instance.locationLng,
    };
