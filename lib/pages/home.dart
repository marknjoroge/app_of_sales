import 'dart:io';

import 'package:app_of_sales/pages/edit_entry.dart';
import 'package:app_of_sales/pages/new_entry.dart';
import 'package:app_of_sales/pages/profits/profits_page.dart';
import 'package:app_of_sales/pages/stats/stats_page.dart';
import 'package:app_of_sales/services/firestore_service.dart';
import 'package:app_of_sales/services/sqlite_helper.dart';
import 'package:app_of_sales/utils/constants.dart';
import 'package:app_of_sales/utils/database.dart';
import 'package:app_of_sales/utils/date_ops.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/details_dialog.dart';
import '../components/not_connected_dialog.dart';
import '../utils/check_connection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();

  double profit = 0.0;
  double soldTotal = 0.0;
  double bought = 0.0;

  List<dynamic> sales = [];

  var databaseHelper = DatabaseHelper();
  var firestoreHelper = FirestoreService();

  Future<void> _selectDate(BuildContext context, {DateTime? picked}) async {
    await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101))
        .then((value) {
      setState(() {
        selectedDate = value!;
      });
      return null;
    });
    print("changed date");
  }

  void reloadForNewDate() async {
    // await databaseHelper
    //     .queryDay(
    //       SalesTable.tableName,
    //       getNormalDate(selectedDate),
    //     )
    //     .then(
    //       (value) => setState(() => sales = value),
    //     );

    double plus = 0;
    double minus = 0;
    await firestoreHelper
        .readAll(SalesTable.tableName, getNormalDate(selectedDate))
        .then((value) {
      setState(() => sales = value);
      sales.forEach((item) {
        print("Price: ${item[SalesTable.priceCol]}");
        double price = item[SalesTable.priceCol];
        if (price > 0) {
          plus += price;
        } else {
          minus += price.abs();
        }
      });
      print("$plus $sales");
      setState(() {
        soldTotal = plus;
        bought = minus;
        profit = soldTotal - bought;
      });
    });
    print("reloaded for new data??");
  }

  @override
  void initState() {
    super.initState();
    reloadForNewDate();
  }

  @override
  Widget build(BuildContext context) {
    checkIfConnected().then((value) {
      if (!value) {
        notConnectedDdialogBuilder(context).then((value) => exit(0));
      }
    });

    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // backgroundColor: kBgColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StatsPage(),
              ),
            );
          },
          icon: const Icon(Icons.show_chart_sharp),
        ),
        // title: Text(
        //   "Savannah Bar",
        //   style: textTheme.titleMedium,
        // ),
        title: Image.asset(
          'assets/images/savanna.png',
          height: kInputElementHeight,
        ),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // title: const Text("Savanna\'s app of sales"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(kPagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kPagePadding),
                Row(
                  children: [
                    dateCardTopbar(
                      'Today',
                      kWarningColor,
                      kWarningColorLight,
                      () async {
                        await _selectDate(
                          context,
                          picked: DateTime.now(),
                        );
                        reloadForNewDate();
                      },
                    ),
                    const SizedBox(width: kPagePadding),
                    dateCardTopbar(
                      'Choose another date',
                      kErrorColor,
                      kErrorColorLight,
                      () async {
                        await _selectDate(context).then(
                          (value) => reloadForNewDate(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: kPagePadding * 2),
                // topBanner(context),
                Text(
                  getNormalDate(selectedDate),
                  style: Theme.of(context).textTheme.labelSmall,
                  // textAlign: TextAlign.start,
                ),
                const SizedBox(height: kPagePadding),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfitsPage(
                            selectedDate: selectedDate,
                          ),
                        ),
                      ),
                      child: Container(
                        padding: kPagePaddingInsets,
                        decoration: BoxDecoration(
                          color: kPrimaryColorLight,
                          // border: Border.all(
                          //   width: 1.0,
                          //   color: kDullColorLight,
                          // ),
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sales',
                                  style: textTheme.labelMedium,
                                ),
                                const Icon(
                                  CupertinoIcons.forward,
                                  color: kPrimaryColor,
                                  size: 10,
                                ),
                              ],
                            ),
                            Text(
                              'Ksh $soldTotal',
                              style: textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: kPagePadding,
                    ),
                    Container(
                      padding: kPagePaddingInsets,
                      decoration: BoxDecoration(
                        color: kErrorColorLight,
                        // border: Border.all(
                        //   width: 1.0,
                        //   color: kDullColorLight,
                        // ),
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Expenditure',
                                style: textTheme.labelMedium,
                              ),
                              const Icon(
                                CupertinoIcons.forward,
                                color: kErrorColor,
                                size: 10,
                              ),
                            ],
                          ),
                          Text(
                            'Ksh $bought',
                            style: textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kPagePadding * 2),
                Row(children: [
                  Text(
                    "Sales & Expenditure",
                    style: textTheme.labelSmall,
                  )
                ]),
                const SizedBox(height: kPagePadding),
                sales.isEmpty
                    ? emptySalesContainer(textTheme)
                    : salesContainer(textTheme),
                const SizedBox(height: kPagePadding * 5),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewEntryPage()),
          ).then((value) => reloadForNewDate());
        },
        tooltip: 'New Sale/Expenditure input',
        foregroundColor: kBgColor,
        backgroundColor: kSecondaryColor,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  Container topBanner(BuildContext context) {
    return Container(
      padding: kPagePaddingInsets,
      decoration: BoxDecoration(
        // color: kLightBlueColor.withOpacity(0.2),
        border: Border.all(
          width: 1.0,
          color: kDullColorLight,
        ),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            getNormalDate(selectedDate),
            style: Theme.of(context).textTheme.labelSmall!.merge(
                  const TextStyle(
                    color: kSecondaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 8,
                  ),
                ),
          ),
          const SizedBox(height: kPagePadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // const Text(
              //   "ksh",
              // ),
              // const SizedBox(width: kPagePadding / 4),
              Text(
                "$profit",
                style: Theme.of(context).textTheme.headlineMedium!.merge(
                      TextStyle(
                        color: profit < 0 ? kErrorColor : kPrimaryColor,
                      ),
                    ),
              ),
              const SizedBox(width: kPagePadding),
              const Icon(
                Icons.file_upload_outlined,
                color: kErrorColor,
                size: 10,
              ),
              const SizedBox(width: kPagePadding / 4),
              Text(
                "$bought",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .merge(const TextStyle(color: kErrorColor)),
              ),
              const SizedBox(width: kPagePadding / 2),
              const Icon(
                Icons.file_download_outlined,
                color: kPrimaryColor,
                size: 10,
              ),
              const SizedBox(width: kPagePadding / 4),
              Text(
                "$soldTotal",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .merge(const TextStyle(color: kPrimaryColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget salesContainer(TextTheme textTheme) {
    return Container(
      // padding: kPagePaddingInsets,
      decoration: const BoxDecoration(
        color: kLightColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kBorderRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: sales.map((sale) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Container(
              padding: kPagePaddingInsets,
              decoration: BoxDecoration(
                color: kBgColor,
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const EditEntryPage()),
                  // );
                  // editDdialogBuilder(context);
                  detailsDialogBuilder(
                    context,
                    sale[SalesTable.idCol],
                    sale[SalesTable.dateCol],
                    sale[SalesTable.timeCol],
                    sale[SalesTable.typeOfEntry],
                    sale[SalesTable.nameCol],
                    sale[SalesTable.quantityCol],
                    sale[SalesTable.priceCol],
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${sale[SalesTable.nameCol]}'),
                        Text(
                          '${sale[SalesTable.priceCol]}',
                          style: TextStyle(
                            color: (double.parse(sale[SalesTable.priceCol]) < 0)
                                ? kErrorColor
                                : kPrimaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${sale[SalesTable.dateCol]} $interpunct ${sale[SalesTable.timeCol]}',
                          style: textTheme.labelSmall!.merge(
                            TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Text(
                          '${sale[SalesTable.quantityCol]}',
                          style: textTheme.labelSmall!.merge(
                            const TextStyle(
                              // fontWeight: FontWeight.w900,
                              fontSize: 10,
                              // color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget dateCardTopbar(
      String text, Color kColor, Color kColorLight, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kColorLight,
          borderRadius: BorderRadius.circular(kBorderRadius / 2),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: kPagePadding / 2, vertical: kPagePadding / 4),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .merge(TextStyle(color: kColor, fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }

  Widget emptySalesContainer(TextTheme theme) {
    return Container(
      decoration: const BoxDecoration(
        color: kLightColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kBorderRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: kPagePadding * 3),
          Text(
            'Tap on \'+\' below to add a new entry',
            style: theme.labelLarge!.merge(
              const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
