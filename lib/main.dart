import 'package:bloc_calculator/Bloc/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipe/swipe.dart';

import 'Bloc/bloc.dart';
import 'Bloc/state.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider(
      create: (context) => BlocClass(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static late double screenWidth;
  static String display = '0';

  Widget myButton({
    required String title,
    required BuildContext context,
    Color color = Colors.white,
    Alignment? alignment,
    double? height,
    double? width,
    EdgeInsets? padding,
    bool isOperator = false,
    Color? textColor,
  }) {
    height = height ?? screenWidth / 5.5;
    width = width ?? screenWidth / 5.5;
    padding = padding ?? const EdgeInsets.all(0);
    alignment = alignment ?? Alignment.center;
    textColor = textColor ?? Colors.white;
    return GestureDetector(
      onTap: () {
        if (isOperator) {
          BlocProvider.of<BlocClass>(context)
              .add(OperatorEvent(operatorSign: title));
        } else if (title == '=') {
          BlocProvider.of<BlocClass>(context).add(AnswerEvent());
        } else if (title == 'Ac' || title == 'C') {
          BlocProvider.of<BlocClass>(context).add(ClearDisplay(command: title));
        } else {
          BlocProvider.of<BlocClass>(context)
              .add(SetDisplayEvent(clickNo: title));
        }
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth / 2.25)),
        child: SizedBox(
          height: height,
          width: width,
          child: Align(
              alignment: alignment,
              child: Padding(
                padding: padding,
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Swipe(
            onSwipeLeft: () {
              BlocProvider.of<BlocClass>(context).add(EraseDisplay());
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<BlocClass, StateClass>(
                  builder: (context, state) {
                    if (state is SetDisplayState) {
                      display = state.display;
                    }
                    return Text(
                      display,
                      style: const TextStyle(fontSize: 70),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<BlocClass, StateClass>(
                builder: (context, state) {
                  String title = 'Ac';
                  if (state is SetDisplayState && state.display != '0') {
                    title = 'C';
                  }
                  return myButton(
                      context: context,
                      title: title,
                      textColor: Colors.black,
                      color: const Color(0xFF999999));
                },
              ),
              myButton(
                context: context,
                title: '+/-',
                textColor: Colors.black,
                color: const Color(0xFF999999),
              ),
              myButton(
                context: context,
                title: '%',
                textColor: Colors.black,
                isOperator: true,
                color: const Color(0xFF999999),
              ),
              BlocBuilder<BlocClass, StateClass>(
                builder: (context, state) {
                  Color bgColor;
                  Color textColor;
                  if (state is OperatorState &&
                      state.operator == Operator.div) {
                    textColor = const Color(0xFFFF9500);
                    bgColor = const Color(0xFFFFFFFF);
                  } else {
                    bgColor = const Color(0xFFFF9500);
                    textColor = const Color(0xFFFFFFFF);
                  }
                  return myButton(
                      context: context,
                      title: '÷',
                      isOperator: true,
                      textColor: textColor,
                      color: bgColor);
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myButton(
                  context: context, title: '7', color: const Color(0xFF313131)),
              myButton(
                  context: context, title: '8', color: const Color(0xFF313131)),
              myButton(
                  context: context, title: '9', color: const Color(0xFF313131)),
              BlocBuilder<BlocClass, StateClass>(
                builder: (context, state) {
                  Color bgColor = const Color(0xFFFF9500);
                  Color textColor = const Color(0xFFFFFFFF);
                  if (state is OperatorState &&
                      state.operator == Operator.multi) {
                    textColor = const Color(0xFFFF9500);
                    bgColor = const Color(0xFFFFFFFF);
                  }
                  return myButton(
                      context: context,
                      title: 'X',
                      isOperator: true,
                      textColor: textColor,
                      color: bgColor);
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myButton(
                  context: context, title: '4', color: const Color(0xFF313131)),
              myButton(
                  context: context, title: '5', color: const Color(0xFF313131)),
              myButton(
                  context: context, title: '6', color: const Color(0xFF313131)),
              BlocBuilder<BlocClass, StateClass>(
                builder: (context, state) {
                  Color bgColor = const Color(0xFFFF9500);
                  Color textColor = const Color(0xFFFFFFFF);
                  if (state is OperatorState &&
                      state.operator == Operator.minus) {
                    textColor = const Color(0xFFFF9500);
                    bgColor = const Color(0xFFFFFFFF);
                  }
                  return myButton(
                      context: context,
                      title: '-',
                      isOperator: true,
                      textColor: textColor,
                      color: bgColor);
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myButton(
                  context: context, title: '1', color: const Color(0xFF313131)),
              myButton(
                  context: context, title: '2', color: const Color(0xFF313131)),
              myButton(
                  context: context, title: '3', color: const Color(0xFF313131)),
              BlocBuilder<BlocClass, StateClass>(
                builder: (context, state) {
                  Color bgColor = const Color(0xFFFF9500);
                  Color textColor = const Color(0xFFFFFFFF);
                  if (state is OperatorState &&
                      state.operator == Operator.plus) {
                    textColor = const Color(0xFFFF9500);
                    bgColor = const Color(0xFFFFFFFF);
                  }
                  return myButton(
                      context: context,
                      title: '+',
                      isOperator: true,
                      textColor: textColor,
                      color: bgColor);
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myButton(
                  title: '0',
                  width: screenWidth / 2.3,
                  color: const Color(0xFF313131),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 30),
                  context: context),
              myButton(
                  context: context, title: '.', color: const Color(0xFF313131)),
              myButton(
                  context: context, title: '=', color: const Color(0xFFFF9500)),
            ],
          ),
        ]),
      ),
    );
  }
}
