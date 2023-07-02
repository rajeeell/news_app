import 'package:flutter/material.dart';

class TabsWidget extends StatelessWidget {
  const TabsWidget(
      {super.key,
      required this.color,
      required this.fontSize,
      required this.function,
      required this.text});
      
  final String text;
  final Color color;
  final Function function;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: color),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
            ),
          )),
    );
  }
}
