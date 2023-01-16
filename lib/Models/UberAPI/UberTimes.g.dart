// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UberTimes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UberTimes _$UberTimesFromJson(Map<String, dynamic> json) => UberTimes(
      localized_display_name: json['localized_display_name'] as String,
      estimate: json['estimate'] as int,
      display_name: json['display_name'] as String,
      product_id: json['product_id'] as String,
    );

Map<String, dynamic> _$UberTimesToJson(UberTimes instance) => <String, dynamic>{
      'localized_display_name': instance.localized_display_name,
      'estimate': instance.estimate,
      'display_name': instance.display_name,
      'product_id': instance.product_id,
    };
