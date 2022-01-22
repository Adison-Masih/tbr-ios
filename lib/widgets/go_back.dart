import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class GoBack extends StatelessWidget {
  const GoBack({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: context.theme.buttonColor,
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }
}
