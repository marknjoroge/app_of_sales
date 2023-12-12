import 'package:app_of_sales/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'pages/home.dart';
import 'utils/database.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'sales.db');

  await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE ${SalesTable.tableName} (${SalesTable.idCol} INTEGER PRIMARY KEY AUTOINCREMENT, ${SalesTable.nameCol} TEXT, ${SalesTable.quantityCol} INTEGER, ${SalesTable.dateCol} TEXT, ${SalesTable.timeCol} TEXT, ${SalesTable.priceCol} REAL, ${SalesTable.typeOfEntry} TEXT)',
      );

      await db.execute(
        'CREATE TABLE ${PricesTable.tableName} (${PricesTable.idCol} INTEGER PRIMARY KEY AUTOINCREMENT, ${PricesTable.nameCol} TEXT, ${PricesTable.priceCol} REAL)',
      );
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Savannah\'s app of sales',
      theme: ThemeData(
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: kDullColor),
        useMaterial3: true,
        scaffoldBackgroundColor: kLightColor,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: kBgColor.withOpacity(0.0),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
