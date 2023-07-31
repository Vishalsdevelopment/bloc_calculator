abstract class StateClass {}

class InitialState extends StateClass {}

class SetDisplayState extends StateClass {
  String display;

  SetDisplayState({required this.display});
}

class OperatorState extends StateClass {
  bool plus = false;
  bool minus = false;
  bool multi = false;
  bool div = false;

  OperatorState({required String operatorSign}) {
    plus = operatorSign == '+';
    minus = operatorSign == '-';
    multi = operatorSign == 'X';
    div = operatorSign == '÷';
  }
}
