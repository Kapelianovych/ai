// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mlp_structure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MlpStructure _$MlpStructureFromJson(Map<String, dynamic> json) {
  return MlpStructure(json['input'] as int, json['output'] as int,
      hiddens:
          (json['hiddens'] as List)?.map((dynamic e) => e as int)?.toList());
}

Map<String, dynamic> _$MlpStructureToJson(MlpStructure instance) =>
    <String, dynamic>{
      'input': instance.input,
      'hiddens': instance.hiddens,
      'output': instance.output
    };
