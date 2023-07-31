abstract class EventClass {}

class SetDisplayEvent extends EventClass {
  String clickNo;

  SetDisplayEvent({required this.clickNo});
}

class ClearDisplay extends EventClass {
  String command;

  ClearDisplay({required this.command});
}

class EraseDisplay extends EventClass {}

class OperatorEvent extends EventClass {
  String operatorSign;

  OperatorEvent({required this.operatorSign});
}

class AnswerEvent extends EventClass {}
