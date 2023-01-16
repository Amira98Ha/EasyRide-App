// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BoltPrices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoltPrices _$BoltPricesFromJson(Map<String, dynamic> json) => BoltPrices(
      localized_display_name: json['localized_display_name'] as String,
      distance: (json['distance'] as num).toDouble(),
      display_name: json['display_name'] as String,
      product_id: json['product_id'] as String,
      high_estimate: json['high_estimate'] as int,
      low_estimate: json['low_estimate'] as int,
      duration: json['duration'] as int,
      estimate: json['estimate'] as String,
      currency_code: json['currency_code'] as String,
    );

Map<String, dynamic> _$BoltPricesToJson(BoltPrices instance) =>
    <String, dynamic>{
      'localized_display_name': instance.localized_display_name,
      'distance': instance.distance,
      'display_name': instance.display_name,
      'product_id': instance.product_id,
      'high_estimate': instance.high_estimate,
      'low_estimate': instance.low_estimate,
      'duration': instance.duration,
      'estimate': instance.estimate,
      'currency_code': instance.currency_code,
    };
