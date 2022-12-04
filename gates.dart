import 'package:complex/complex.dart';

import 'constants.dart';
import 'qubit.dart';

List<Qubit> hadamardGate(int bitIndex, List<Qubit> qubits) {
  List<Qubit> editedList = [];

  for (var qb in qubits) {
    editedList.add(qb);
  }

  var updatedAmpl;
  var updatedVal;

  List<Qubit> tempList = [];

  for (var qb in editedList) {
    if (qb.value[bitIndex] == '0') {
      updatedVal = _replaceCharAt(qb.value, bitIndex, "1");
      updatedAmpl = qb.amplitude * hadamard;
      qb.amplitude = updatedAmpl;
    } else {
      updatedVal = _replaceCharAt(qb.value, bitIndex, "0");
      updatedAmpl = qb.amplitude * hadamard;
      qb.amplitude = updatedAmpl * (-1.0);
    }

    Qubit newState = Qubit(updatedAmpl, updatedVal);
    tempList.add(newState);
  }

  for (var qb in tempList) {
    editedList.add(qb);
  }

  return editedList;
}

List<Qubit> controlledNotGate(
    int controlBit, int targetBit, List<Qubit> qubits) {
  List<Qubit> editedList = [];

  var updatedVal;
  List<Qubit> tempList = [];

  for (var qb in qubits) {
    if (qb.value[controlBit] == '1') {
      if (qb.value[targetBit] == '0') {
        updatedVal = _replaceCharAt(qb.value, targetBit, "1");
      } else {
        updatedVal = _replaceCharAt(qb.value, targetBit, '0');
      }
      Qubit newState = Qubit(qb.amplitude, updatedVal);
      tempList.add(newState);
    } else {
      tempList.add(qb);
    }
  }

  for (var qb in tempList) {
    editedList.add(qb);
  }

  return editedList;
}

List<Qubit> notGate(int bitIndex, List<Qubit> qubits) {
  List<Qubit> editedList = [];

  var updatedVal;
  List<Qubit> tempList = [];

  for (var qb in qubits) {
    if (qb.value[bitIndex] == '0') {
      updatedVal = _replaceCharAt(qb.value, bitIndex, "1");
    } else {
      updatedVal = _replaceCharAt(qb.value, bitIndex, '0');
    }
    Qubit newState = Qubit(qb.amplitude, updatedVal);
    tempList.add(newState);
  }

  for (var qb in tempList) {
    editedList.add(qb);
  }

  return editedList;
}

List<Qubit> tPauliGate(int bitIndex, List<Qubit> qubits) {
  List<Qubit> editedList = [];
  List<Qubit> tempList = [];

  for (var qb in qubits) {
    if (qb.value[bitIndex] == '1') {
      var updatedAmp = qb.amplitude * t_pauli;
      Qubit newState = Qubit(qb.amplitude * t_pauli, qb.value);
      tempList.add(newState);
    } else {
      tempList.add(qb);
    }
  }

  for (var qb in tempList) {
    editedList.add(qb);
  }
  return editedList;
}

List<Qubit> tdgPauliGate(int bitIndex, List<Qubit> qubits) {
  List<Qubit> editedList = [];
  List<Qubit> tempList = [];

  for (var qb in qubits) {
    if (qb.value[bitIndex] == '1') {
      var updatedAmp = qb.amplitude * tdg_pauli;
      Qubit newState = Qubit(qb.amplitude * tdg_pauli, qb.value);
      tempList.add(newState);
    } else {
      tempList.add(qb);
    }
  }

  for (var qb in tempList) {
    editedList.add(qb);
  }

  return editedList;
}

String _replaceCharAt(String oldstring, int index, String newChar) {
  return oldstring.substring(0, index) +
      newChar +
      oldstring.substring(index + 1);
}
