/// Library for creating AI with Dart
///
/// This library represent an simple way to create neural network.
/// Currently **multilayer** and **single-layer** perceptron can be created.
/// In learning used __backpropagation__ algorithm for both of them.
///
/// Perseptron is designed due to Rosenblatt's perseptron.
///
/// The main class is the `MultilayerPerseptron` which can contains `Layers`.
/// Each layer consist of one or many `Neuron`s.
/// First layer always consist of `InputNeuron`s where each of them take one input value and have weight equal to 1.
/// All neurons of previous layer have contacts with each neurons of next layer.
///
/// Neural network have long-time and short-time memory.
/// All information (knowledge - weights of synapces) of neural network during studying pass through short-time memory.
/// When studying finished and knowledge is structured, then it pass to long-time memory.
/// Knowledge is saved in JSON file `knowledge.json` in `resources` directory.
/// For next time network take knowledge from file and initialize with proper weights.
library ai;

export 'src/layer.dart';

export 'src/memory/long_memory.dart';
export 'src/memory/short_memory.dart';

export 'src/network/base/network_base.dart';
export 'src/network/multilayer_perceptron.dart';

export 'src/neuron/base/neuron_base.dart';
export 'src/neuron/input_neuron.dart';
export 'src/neuron/neuron.dart';


