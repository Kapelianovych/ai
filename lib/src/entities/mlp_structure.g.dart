// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mlp_structure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MlpStructure _$MlpStructureFromJson(Map<String, dynamic> json) {
  return MlpStructure(
      json['input'] as int,
      (json['hiddens'] as List).map((e) => e as int).toList(),
      json['output'] as int);
}

Map<String, dynamic> _$MlpStructureToJson(MlpStructure instance) =>
    <String, dynamic>{
      'input': instance.input,
      'hiddens': instance.hiddens,
      'output': instance.output
    };
