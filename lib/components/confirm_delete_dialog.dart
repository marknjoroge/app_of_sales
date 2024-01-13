import 'package:app_of_sales/services/firestore_service.dart';
import 'package:app_of_sales/utils/constants.dart';
import 'package:app_of_sales/utils/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> confirmDeleteDialog(
  BuildContext context,
  String name,
  String id,
) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete $name'),
        actions: [
          IconButton(
            onPressed: () {
              FirestoreService firestoreService = FirestoreService();
              firestoreService
                  .delete(SalesTable.tableName, id)
                  .then((value) => Navigator.pop(context));
            },
            icon: Icon(
              CupertinoIcons.delete,
              color: kErrorColor,
            ),
          ),
        ],
      );
    },
  );
}
