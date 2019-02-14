# Library for creating AI with Dart

Created under a MIT-style
[license](https://github.com/YevhenKap/ai/blob/master/LICENSE).

## Overview

This library represent an simple way to create neural network.

There are 2 types of neural network that can be created:

- **MLP**(multilayer and single-layer perceptron).
- **AE**(autoencoder).

### API

#### MLP

Perseptron is designed due to Rosenblatt's perseptron.

The main class is the `MLP` which can contains `Layers`.
Each layer consist of one or many `Neuron`s.
First layer always must consist of input neurons where each of them take one input value and have weight equal to 1.
All neurons of previous layer have contacts with each neurons of next layer.

In learning is used __backpropagation__ algorithm.

#### AE

Architecture of `AE` is the same as `MLP`, except that first is used for encoding data.

#### Memory

Neural network have long-time and short-time memory.
All information (knowledge - weights of synapces) of neural network during studying pass through short-time memory.
When studying finished and knowledge is structured, then it pass to long-time memory.
Knowledge is saved in JSON file `knowledge.json` in `resources` directory in the root of your library.
For next time network take knowledge from file and initialize with proper weights.

#### Structure

Neural network can be created from predefined structure difined in `structure.json` file. You can place it anywhere you want, but default and preffered way is placing it in `resources` directory in the root of your library.

Every `structure.json` must have `type` property that corresspond to neural network's name.
Other properties such as:

    - activation: specifies which function are used for neuron activation (default sigmoid)
    - momentum: describe step of gradient descent (default 1)
    - bias: is limit of neuron's choice. Used only in `step` function
    - hyperparameter: is used in `PReLU`, `RReLU` and `ELU`. For `RReLU` it is a random number sampled from a uniform distribution `𝑈(𝑙, u)`, for `PReLU` it is a random value and for `ELU` it is random value that is equal or greater than zero

are optional. Specific properties for each structure type should be provided, except there are optional ones.

Structure of *MLP*:

```json
{
  "type": "MLP",
  "activation": "relu",
  "input": 15,
  "hiddens": [3],
  "output": 3
}
```

Where `input` - count of input neurons, `hiddens` - array length shows
count of hidden `Layer`s and values are count of `Neuron`s of each layer, `output` - count of output `Neuron`s.

Structure of *AE*:

```json
{
  "type": "AE",
  "input": 15,
  "hiddens": [3],
  "encoded": 3
}
```

Where `input` - count of input neurons, `hiddens` - array length shows count of hidden `Layer`s and values are count
of `Neuron`s of each layer for encoded and decoded parts, `decoded` - count of decoded data `Neuron`s.

#### Activation functions

Supported 9 activation functions:

    1. step
    2. sigmoid (default)
    3. tanh
    4. relu
    5. srelu (smooth relu or softplus)
    6. lrelu (leaky relu)
    7. prelu (parametric relu)
    8. rrelu (randomized relu)
    9. elu (exponential linear units)

#### Visualization

Visualization of process of training network is available. Implemented only `Mean Squared Error` (`MSE`). If `visualise` paramenter of `train()` method is `true` then MSE sends to console.

## Sample

This testing network recognize number 5 from numbers in range from 0 to 9. Also she detects distorted numbers of 5.

![Numbers](assets/images/5.png)

```dart
import 'package:ai/ai.dart';

void main() {

  final l1 = Layer(<Neuron>[
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true),
    Neuron(0, isInput: true)
  ]);
  final l2 = Layer(<Neuron>[
    Neuron(15),
    Neuron(15),
    Neuron(15),
    Neuron(15),
    Neuron(15)
  ]);
  final l3 = Layer(<Neuron>[
    Neuron(5)
  ]);

  final n = MLP.from(Structure());

  // Expected results according to learning data (10)
  final expected = <List<double>>[
    <double>[0.01],
    <double>[0.01],
    <double>[0.01],
    <double>[0.01],
    <double>[0.01],
    <double>[0.99], // 5
    <double>[0.01],
    <double>[0.01],
    <double>[0.01],
    <double>[0.01]
  ];

  // Цифры (Обучающая выборка)
  final trainInput = <List<double>>[
    '111101101101111'.split('').map(double.parse).toList(),
    '001001001001001'.split('').map(double.parse).toList(),
    '111001111100111'.split('').map(double.parse).toList(),
    '111001111001111'.split('').map(double.parse).toList(),
    '101101111001001'.split('').map(double.parse).toList(),
    '111100111001111'.split('').map(double.parse).toList(), // 5
    '111100111101111'.split('').map(double.parse).toList(),
    '111001001001001'.split('').map(double.parse).toList(),
    '111101111101111'.split('').map(double.parse).toList(),
    '111101111001111'.split('').map(double.parse).toList()
  ];

  // Виды цифры 5 (Тестовая выборка)
  final testInput = <List<double>>[
    '111100111000111'.split('').map(double.parse).toList(),
    '111100010001111'.split('').map(double.parse).toList(),
    '111100011001111'.split('').map(double.parse).toList(),
    '110100111001111'.split('').map(double.parse).toList(),
    '110100111001011'.split('').map(double.parse).toList(),
    '111100101001111'.split('').map(double.parse).toList()
  ];

  final num5 = '111100111001111'.split('').map(double.parse).toList();

  n.train(input: trainInput, expected: expected, learningRate: 0.1, epoch: 5000, visualize: true);

  print('Узнал 5? - ${n.predict(num5)}');
  for (var item in testInput) {
    print('Узнал искаженную 5? - ${n.predict(item)[0]}');
  }
  print('А 0? - ${n.predict(trainInput[0])}');
  print('А 8? - ${n.predict(trainInput[8])}');
  print('А 3? - ${n.predict(trainInput[3])}');

}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/YevhenKap/ai/issues).

**With ❤️ to AI**