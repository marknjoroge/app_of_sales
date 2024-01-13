import 'package:app_of_sales/pages/edit_entry.dart';
import 'package:app_of_sales/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/date_ops.dart';
import 'confirm_delete_dialog.dart';

Future<void> detailsDialogBuilder(
  BuildContext context,
  String id,
  String date,
  String time,
  String entryType,
  String name,
  int quantity,
  String totalPrice,
) {
  TextTheme textTheme = Theme.of(context).textTheme;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(entryType),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '$date $interpunct $time',
              style: textTheme.labelSmall,
            ),
            Text(
              name,
              style: textTheme.titleLarge,
            ),
            Text(
              'KSH $totalPrice $interpunct $quantity units @ KSH ${double.parse(totalPrice) / quantity}',
              style: textTheme.titleSmall,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            // style: TextButton.styleFrom(
            //   textStyle: Theme.of(context).textTheme.labelLarge,
            // ),
            icon: const Icon(CupertinoIcons.pencil_ellipsis_rectangle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEntryPage(
                    id: 0,
                    date: toDateTime(date, time),
                    name: name,
                    units: quantity,
                    totalPrice: double.parse(totalPrice),
                    unitPrice: (double.parse(totalPrice) / quantity),
                  ),
                ),
              );
            },
          ),
          IconButton(
            // style: TextButton.styleFrom(
            //   textStyle: Theme.of(context).textTheme.labelLarge,
            // ),
            icon: const Icon(CupertinoIcons.delete),
            onPressed: () {
              confirmDeleteDialog(context, name, id)
                  .then((value) => Navigator.of(context).pop());
            },
          ),
        ],
      );
    },
  );
}
