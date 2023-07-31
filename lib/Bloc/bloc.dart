import 'package:bloc_calculator/Bloc/event.dart';
import 'package:bloc_calculator/Bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Operator { plus, minus, multi, div }

class BlocClass extends Bloc<EventClass, StateClass> {
  BlocClass() : super(InitialState()) {
    String display = '';
    double firstNum = 0;
    double secondNum = 0;
    double tempNum = 0;
    Operator? operator;
    on<SetDisplayEvent>((event, emit) {
      if (display == '0' || display == 'Error') {
        display = '';
      }
      if (event.clickNo == '.') {
        if (display.isEmpty) {
          display = '0';
          display += event.clickNo;
        } else if (!display.contains('.')) {
          display += event.clickNo;
        }
      } else if (event.clickNo == '+/-') {
        if (display.startsWith('-')) {
          if (display.length > 1) {
            display = display.substring(1, display.length);
          } else {
            display = '0';
          }
        } else {
          display = '-$display';
        }
      } else {
        display += event.clickNo;
      }

      emit(SetDisplayState(display: display));
    });
    on<ClearDisplay>((event, emit) {
      display = '0';
      if (event.command == 'Ac') {
        firstNum = secondNum = tempNum = 0;
        operator = null;
      }
      emit(SetDisplayState(display: display));
    });

    on<EraseDisplay>((event, emit) {
      display =
          display.length == 1 ? '0' : display.substring(0, display.length - 1);
      emit(SetDisplayState(display: display));
    });

    on<OperatorEvent>((event, emit) {
      if (display == '0' && event.operatorSign == '-') {
        display = '-';
        emit(SetDisplayState(display: display));
      } else if (display == '-') {
        display = '0';
        emit(SetDisplayState(display: display));
      } else if (event.operatorSign == '%') {
        display = '${double.parse(display) / 100}';
        emit(SetDisplayState(display: display));
      } else {
        try {
          tempNum = firstNum;
          firstNum = double.parse(display);
          display = '';

          if (operator == Operator.plus) {
            firstNum = tempNum + firstNum;
          } else if (operator == Operator.minus) {
            firstNum = tempNum - firstNum;
          } else if (operator == Operator.multi) {
            firstNum = tempNum * firstNum;
          } else if (operator == Operator.div) {
            firstNum = tempNum / firstNum;
          }
        } catch (_) {}
        if (event.operatorSign == '+') {
          operator = Operator.plus;
        } else if (event.operatorSign == '-') {
          operator = Operator.minus;
        } else if (event.operatorSign == 'X') {
          operator = Operator.multi;
        } else if (event.operatorSign == '÷') {
          operator = Operator.div;
        }
        emit(OperatorState(operator: operator));
      }
    });

    on<AnswerEvent>((event, emit) {
      try {
        secondNum = double.parse(display);
        if (operator == Operator.plus) {
          display = (firstNum + secondNum).toString();
        } else if (operator == Operator.minus) {
          display = (firstNum - secondNum).toString();
        } else if (operator == Operator.multi) {
          display = (firstNum * secondNum).toString();
        } else if (operator == Operator.div) {
          display = (firstNum / secondNum).toString();
          if (display == 'Infinity') {
            display = 'Error';
          }
        }
        if (display.endsWith('.0')) {
          display = display.substring(0, display.length - 2);
        }
      } catch (_) {
        display = 'Error';
      }
      emit(SetDisplayState(display: display));
    });
  }
}
