import 'package:json_annotation/json_annotation.dart';

part 'mlp_structure.g.dart';

/// Class that represent `structure.json` for `MLP`
@JsonSerializable(nullable: false)
class MlpStructure {
  /// Creates [MlpStructure] instance
  MlpStructure(this.input, this.output, {this.hiddens});

  /// Creates instance of [MlpStructure] from JSON
  factory MlpStructure.fromJson(Map<String, dynamic> json) =>
      _$MlpStructureFromJson(json);

  /// Count of input neurons
  final int input;

  @JsonKey(nullable: true)

  /// Array that contains counts of hidden layers neurons
  final List<int> hiddens;

  /// Count of output neurons
  final int output;

  /// Converts this to JSON
  Map<String, dynamic> toJson() => _$MlpStructureToJson(this);
}
