import 'package:app_of_sales/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> notConnectedDdialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(CupertinoIcons.nosign, color: kErrorColor),
            const SizedBox(height: kPagePadding),
            Text('Offline')
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'CLOSE',
              style: TextStyle(fontSize: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
