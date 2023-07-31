import 'package:bloc_calculator/Bloc/event.dart';
import 'package:bloc_calculator/Bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocClass extends Bloc<EventClass, StateClass> {
  BlocClass() : super(InitialState()) {
    String display = '';
    double firstNum = 0;
    double secondNum = 0;
    bool plus = false;
    bool minus = false;
    bool multi = false;
    bool div = false;
    double tempNum = 0;
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
          display = display.substring(1, display.length);
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
      firstNum = secondNum = tempNum = 0;
      plus = false;
      minus = false;
      multi = false;
      div = false;
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
      } else {
        try {
          tempNum = firstNum;
          firstNum = double.parse(display);
          display = '';
          if (plus) {
            firstNum = tempNum + firstNum;
          } else if (minus) {
            firstNum = tempNum - firstNum;
          } else if (multi) {
            firstNum = tempNum * firstNum;
          } else if (div) {
            firstNum = tempNum / firstNum;
          }
          plus = event.operatorSign == '+';
          minus = event.operatorSign == '-';
          multi = event.operatorSign == 'X';
          div = event.operatorSign == '÷';
          emit(OperatorState(operatorSign: event.operatorSign));
        } on FormatException catch (_) {
          display = 'Error';
          emit(SetDisplayState(display: display));
        }
      }
    });

    on<AnswerEvent>((event, emit) {
      try {
        secondNum = double.parse(display);
        if (plus) {
          display = (firstNum + secondNum).toString();
        } else if (minus) {
          display = (firstNum - secondNum).toString();
        } else if (multi) {
          display = (firstNum * secondNum).toString();
        } else if (div) {
          display = (firstNum / secondNum).toString();
        }
        if (display.endsWith('0')) {
          display = display.substring(0, display.length - 2);
        }
      } on FormatException catch (_) {
        display = 'Error';
      }
      emit(SetDisplayState(display: display));
    });
  }
}
