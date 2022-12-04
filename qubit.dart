import 'package:complex/complex.dart';

class Qubit {
  late Complex _amplitude;
  String _value = "";

  Qubit(Complex newAmplitude, String newValue) {
    _amplitude = newAmplitude;
    _value = newValue;
  }

  Complex get amplitude => _amplitude;
  String get value => _value;

  set amplitude(Complex amp) {
    _amplitude = amp;
  }

  set value(String val) {
    _value = val;
  }
}
