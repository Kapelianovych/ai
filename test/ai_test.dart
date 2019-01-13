import 'package:ai/ai.dart';

void main() {

  final l1 = Layer<InputNeuron>(<InputNeuron>[
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron(),
    InputNeuron()
  ]);
  final l2 = Layer<Neuron>(<Neuron>[
    Neuron(15),
    Neuron(15),
    Neuron(15),
    Neuron(15),
    Neuron(15)
  ]);
  final l3 = Layer<Neuron>(<Neuron>[
    Neuron(5)
  ]);
  final n = MultilayerPerceptron(<Layer<NeuronBase>>[
    l1,
    l2,
    l3
  ]);

  // Expected results according to learning data (10)
  final expected = <List<double>>[
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01],
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01],
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01],
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01],
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01],
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01],
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01],
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01],
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01],
    <double>[0.01, 0.01, 0.01, 0.01, 0.01, 0.99, 0.01, 0.01, 0.01, 0.01]
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

  n.train(input: trainInput, expected: expected, learningRate: 0.42, epoch: 5000);

  print('Узнал 5? - ${n.predict(num5)}');
  for (var item in testInput) {
    print('Узнал искаженную 5? - ${n.predict(item)[0]}');
  }
  print('А 0? - ${n.predict(trainInput[0])}');
  print('А 8? - ${n.predict(trainInput[8])}');
  print('А 3? - ${n.predict(trainInput[3])}');

}
