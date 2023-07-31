import 'package:bloc_calculator/Bloc/bloc.dart';

abstract class StateClass {}

class InitialState extends StateClass {}

class SetDisplayState extends StateClass {
  String display;

  SetDisplayState({required this.display});
}

class OperatorState extends StateClass {
  Operator? operator;
  double? firstNum;

  OperatorState({required this.operator, this.firstNum});
}
