import 'package:json_annotation/json_annotation.dart';

part 'ae_structure.g.dart';

/// Class that represent `structure.json` for `AE`
@JsonSerializable(nullable: false)
class AeStructure {
  /// Creates [AeStructure] instance
  AeStructure(this.input, this.encoded, {this.hiddens});

  /// Creates instance of [AeStructure] from JSON
  factory AeStructure.fromJson(Map<String, dynamic> json) =>
      _$AeStructureFromJson(json);

  /// Count of input neurons
  final int input;

  /// Array that contains counts of hidden layers neurons
  @JsonKey(nullable: true)
  final List<int> hiddens;

  /// Count of neurons that produce encoded data
  final int encoded;

  /// Converts this to JSON
  Map<String, dynamic> toJson() => _$AeStructureToJson(this);
}
