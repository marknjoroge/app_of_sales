import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showErrorPostingDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          title: const Text('Basic dialog title'),
          content: Column(children: <Widget>[]),
          actions: []);
    },
  );
}
