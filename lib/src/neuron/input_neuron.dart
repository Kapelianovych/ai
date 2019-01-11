import 'base/neuron_base.dart';

/// Class that represent input neuron (S-neuron)
class InputNeuron extends NeuronBase {
  /// Create [InputNeuron]
  InputNeuron({ double input }) 
    : super(1, inputs: <double>[input], weights: <double>[1]);

    @override
    double get out => inputs[0];
}