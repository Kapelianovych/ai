// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ae_structure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AeStructure _$AeStructureFromJson(Map<String, dynamic> json) {
  return AeStructure(json['input'] as int, json['encoded'] as int,
      hiddens:
          (json['hiddens'] as List)?.map((dynamic e) => e as int)?.toList());
}

Map<String, dynamic> _$AeStructureToJson(AeStructure instance) =>
    <String, dynamic>{
      'input': instance.input,
      'hiddens': instance.hiddens,
      'encoded': instance.encoded
    };
