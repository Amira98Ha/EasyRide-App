// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BoltTimes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoltTimes _$BoltTimesFromJson(Map<String, dynamic> json) => BoltTimes(
      localized_display_name: json['localized_display_name'] as String,
      estimate: json['estimate'] as num,
      display_name: json['display_name'] as String,
      product_id: json['product_id'] as String,
    );

Map<String, dynamic> _$BoltTimesToJson(BoltTimes instance) => <String, dynamic>{
      'localized_display_name': instance.localized_display_name,
      'estimate': instance.estimate,
      'display_name': instance.display_name,
      'product_id': instance.product_id,
    };
