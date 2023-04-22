import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Selectionez une bière"),
          backgroundColor: theme.primaryColor,
          centerTitle: true,
        ),
        body: Container(
            color: Colors.white,
            child: Center(
              child: Text("Selectionez une bière",
                  style: TextStyle(
                      fontSize: 24,
                      color: theme.primaryColor,
                      decorationStyle: TextDecorationStyle.solid)),
            )));
  }
}
