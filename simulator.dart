import 'dart:convert';
import 'dart:io';

import 'package:complex/complex.dart';
import 'gates.dart';
import 'qubit.dart';

void main() {
  final myFile = File(
      "/Users/rasmushenriksen/Desktop/UCLA/Quarters/Fall22/Quantum_Programming/qt_simulator/simulator/miller_11.qasm");

  runFile(myFile);
}

void runFile(File file) {
  List<String> lines = _getLines(file);
  int numberOfQubits = _getBitStringLength(lines);

  List<String> instructions = _getInstructions(lines);

  Qubit initState = Qubit(Complex(1), "0" * numberOfQubits);
  List<Qubit> states = [initState];

  print("\n\nInitial state is:");
  prettyPrinter(states);

  for (var instruction in instructions) {
    var updatedStates = parseInstruction(instruction, states);
    states = List<Qubit>.from(updatedStates);
    states.sort(
        (qb1, qb2) => (int.parse(qb1.value)).compareTo(int.parse(qb2.value)));
    states = List<Qubit>.from(combineStates(states));
    prettyPrinter(states);
  }
}

void prettyPrinter(List<Qubit> register) {
  for (var qb in register) {
    print(qb.amplitude.real.toString() +
        " + " +
        qb.amplitude.imaginary.toString() +
        " |" +
        qb.value +
        " >" +
        "\n");
  }
}

List<Qubit> combineStates(List<Qubit> states) {
  if (states.isNotEmpty) {
    int length = states.length;
    List<Qubit> newStates = [];
    var consecValues = 0;
    Complex combinedAmplitude = Complex(0);

    for (int i = 0; i < length - 1; i++) {
      if (states[i].value == states[i + 1].value) {
        consecValues++;
        combinedAmplitude += states[i].amplitude;
      } else {
        combinedAmplitude += states[i].amplitude;
        var newState = Qubit(combinedAmplitude, states[i].value);
        if ((combinedAmplitude).abs() - 0.0001 >= 0) {
          newStates.add(newState);
        }
        combinedAmplitude = Complex(0);
        consecValues = 0;
      }
    }

    combinedAmplitude += states[length - 1].amplitude;
    var newState = Qubit(combinedAmplitude, states[length - 1].value);

    if ((combinedAmplitude).abs() - 0.0001 >= 0) {
      newStates.add(newState);
    }

    combinedAmplitude = Complex(0);
    consecValues = 0;

    return newStates;
  }
  return states;
}

List<Qubit> parseInstruction(String line, List<Qubit> states) {
  var instructionSet = line.split(",");
  var gateInputs = _getGateCmds(instructionSet);
  return _applyGate(gateInputs, states);
}

Map<String, String> _getGateCmds(List<String> instructionSet) {
  if (instructionSet.length == 2) {
    // CNOT
    var cmd = instructionSet[0];
    var updatedCmd = cmd[cmd.length - 3] + cmd[cmd.length - 2];
    var ctr = cmd[cmd.length - 1];
    var tgt = instructionSet[1];

    return {"cmd": updatedCmd, "ctr": ctr, "tgt": tgt};
  } else {
    var cmd = instructionSet[0];

    if (cmd.length == 3) {
      // tdg
      var updatedCmd = cmd[cmd.length - 3] + cmd[cmd.length - 2];
      var tgt = cmd[cmd.length - 1];

      return {"cmd": updatedCmd, "ctr": "", "tgt": tgt};
    }
    // H or T
    var updatedCmd = cmd[cmd.length - 2];
    var tgt = cmd[cmd.length - 1];
    return {"cmd": updatedCmd, "ctr": "", "tgt": tgt};
  }
}

List<Qubit> _applyGate(
  Map<String, String> inputs,
  List<Qubit> states,
) {
  if (inputs["ctr"] != "") {
    print("command: " +
        inputs["cmd"]! +
        " controlbit: " +
        inputs["ctr"]! +
        " targetbit: " +
        inputs["tgt"]!);
    return controlledNotGate(
        int.parse(inputs["ctr"]!), int.parse(inputs["tgt"]!), states);
  }
  print("command: " + inputs["cmd"]! + " targetbit: " + inputs["tgt"]!);
  switch (inputs["cmd"]!) {
    case "h":
      return hadamardGate(int.parse(inputs["tgt"]!), states);
    case "t":
      return tPauliGate(int.parse(inputs["tgt"]!), states);
    case "td":
      return tdgPauliGate(int.parse(inputs["tgt"]!), states);
  }
  return List.empty();
}

List<String> _getLines(File file) {
  var lines = file.readAsStringSync();
  lines = lines.replaceAll(RegExp(r'[q r e g \[ \] ;]'), "");

  const splitter = LineSplitter();
  return splitter.convert(lines);
}

int _getBitStringLength(List<String> lines) {
  return int.parse(lines[2]);
}

List<String> _getInstructions(List<String> lines) {
  List<String> instructions = [];
  for (int i = 4; i < lines.length; i++) {
    instructions.add(lines[i]);
  }

  return instructions;
}
