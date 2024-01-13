import 'package:app_of_sales/services/sqlite_helper.dart';
import 'package:app_of_sales/services/firestore_service.dart';
import 'package:app_of_sales/utils/database.dart';
import 'package:app_of_sales/utils/date_ops.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../utils/constants.dart';

class EditEntryPage extends StatefulWidget {
  final int? id;
  final DateTime? date;
  final String? name;
  final int? units;
  final double? unitPrice;
  final double? totalPrice;
  const EditEntryPage({
    this.id,
    this.date,
    this.name,
    this.units,
    this.totalPrice,
    this.unitPrice,
    super.key,
  });

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  DateTime selectedDate = DateTime.now();

  DatabaseHelper databaseHelper = DatabaseHelper();
  FirestoreService firestoreService = FirestoreService();

  var itemController = TextEditingController();
  var priceController = TextEditingController();
  var totalPriceController = TextEditingController();
  var quantityController = TextEditingController();

  late List<Map<String, dynamic>> pricesMap;

  List<String> items = [];
  List<double> prices = [];

  int quantity = 1;
  String saleEntry = "Sale";
  String typeOfEntry = "";

  int id = 0;

  @override
  void initState() {
    super.initState();
    typeOfEntry = saleEntry;
    getAndProcessData();
    setData();
  }

  void changeQuantity(int newQuantity) {
    setState(() {
      quantity = newQuantity >= 0 ? newQuantity : 0;
      quantityController.text = quantity.toString();
    });
  }

  void getAndProcessData() async {
    pricesMap = await databaseHelper.queryAll(PricesTable.tableName);

    print("Yooo $pricesMap");

    for (var row in pricesMap) {
      prices.add(row[PricesTable.priceCol]);
      items.add(row[PricesTable.nameCol]);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> processAndPostData() async {
    print("posting");
    if (!items.contains(itemController.text)) {
      print("posting 1");
      databaseHelper.insertStuff(
        {
          PricesTable.nameCol: itemController.text,
          PricesTable.priceCol: priceController.text,
        },
        PricesTable.tableName,
      );
    } else {
      print("posting 2");
      databaseHelper.updateStuff(
        {
          PricesTable.idCol: items.indexOf(itemController.text) + 1,
          PricesTable.nameCol: itemController.text,
          PricesTable.priceCol: priceController.text
        },
        PricesTable.tableName,
      );
    }

    print("posting 3");
    // await databaseHelper.updateStuff(
    //   {
    //     SalesTable.idCol: id,
    //     SalesTable.nameCol: itemController.text,
    //     SalesTable.priceCol: (typeOfEntry == saleEntry)
    //         ? totalPriceController.text
    //         : "-${totalPriceController.text}",
    //     SalesTable.quantityCol: quantity,
    //     SalesTable.dateCol: getNormalDate(selectedDate),
    //     SalesTable.timeCol: getNormalTime(DateTime.now()),
    //     SalesTable.typeOfEntry: typeOfEntry,
    //   },
    //   SalesTable.tableName,
    // );

    await firestoreService.update(
      SalesTable.tableName,
      widget!.id.toString(),
      {
        SalesTable.nameCol: itemController.text,
        SalesTable.priceCol: (typeOfEntry == saleEntry)
            ? totalPriceController.text
            : "-${totalPriceController.text}",
        SalesTable.quantityCol: quantity,
        SalesTable.dateCol: getNormalDate(selectedDate),
        SalesTable.timeCol: getNormalTime(DateTime.now()),
        SalesTable.typeOfEntry: typeOfEntry,
      },
    );

    "${SalesTable.nameCol} : ${itemController.text} \n ${SalesTable.priceCol} : ${typeOfEntry == saleEntry ? priceController.text : priceController.text} ${SalesTable.quantityCol} : $quantity ${SalesTable.dateCol} : ${getNormalDate(selectedDate)} ${SalesTable.timeCol} : ${getNormalTime(DateTime.now())} ${SalesTable.typeOfEntry} : ${typeOfEntry}";
  }

  void deleteData() async {
    await firestoreService.delete(SalesTable.tableName, id.toString());
  }

  void setData() {
    priceController.text = widget.unitPrice.toString();
    totalPriceController.text = widget.totalPrice!.toString();
    itemController.text = widget.name!;
    changeQuantity(widget.units!);
    id = widget.id!;
  }

  @override
  Widget build(BuildContext context) {
    selectedDate = widget.date ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(kPagePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Nature of entry"),
              const SizedBox(height: kPagePadding / 4),
              Container(
                // padding: kPagePaddingInsets,
                // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    // color: kBgColor, // Background color
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    border: Border.all()),
                child: DropdownButton<String>(
                  value: typeOfEntry,
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  icon: const Icon(CupertinoIcons.chevron_down_circle),
                  // underline: null,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    setState(() {
                      typeOfEntry = newValue!;
                    });
                  },
                  // focusColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  isExpanded: true,
                  // dropdownColor: Colors.transparent,
                  items: <String>[
                    'Sale',
                    'Expense - Opening Stock',
                    'Expense - Added Stock',
                    'Expense - Other',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: kPagePadding),
              const Text("Item Name"),
              const SizedBox(height: kPagePadding / 4),
              Container(
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    // autofocus: true,
                    controller: itemController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius)),
                      hintText: 'Item',
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return items.where(
                      (suggestion) => suggestion
                          .toLowerCase()
                          .contains(pattern.toLowerCase()),
                    );
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    // Navigate to a new screen or do something else with the selected suggestion
                    itemController.text = suggestion;
                    priceController.text =
                        prices.elementAt(items.indexOf(suggestion)).toString();
                  },
                ),
              ),
              const SizedBox(height: kPagePadding),
              const Text("Units Sold / Acquired"),
              const SizedBox(height: kPagePadding / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => changeQuantity(quantity - 1),
                    child: const Text(
                      "-",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        kErrorColorLight,
                      ),
                      elevation: MaterialStateProperty.all(0),
                      foregroundColor: MaterialStateProperty.all(
                        kErrorColor,
                      ),
                      // shape: OutlinedBorder(),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(kPagePadding),
                      ),
                    ),
                  ),
                  // Text("$quantity"),
                  SizedBox(
                    width: kInputElementHeight,
                    child: TextField(
                      onChanged: (text) {
                        changeQuantity(int.parse(text));
                      },
                      controller: quantityController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        hintText: '',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        kPrimaryColorLight,
                      ),
                      elevation: MaterialStateProperty.all(0),
                      foregroundColor: MaterialStateProperty.all(
                        kPrimaryColor,
                      ),
                      // shape: OutlinedBorder(),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(kPagePadding),
                      ),
                    ),
                    onPressed: () => changeQuantity(quantity + 1),
                    child: const Text(
                      "+",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kPagePadding),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Price per unit"),
                        const SizedBox(height: kPagePadding / 4),
                        TextField(
                          onChanged: (text) {
                            changeQuantity(int.parse(text));
                          },
                          controller: totalPriceController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius)),
                            hintText: 'Unit Price',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kPagePadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total price"),
                        const SizedBox(height: kPagePadding / 4),
                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            // autofocus: true,
                            controller: totalPriceController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius)),
                              hintText: 'Total',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return prices.where((suggestion) => suggestion
                                .toString()
                                .contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion.toString()),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            // Navigate to a new screen or do something else with the selected suggestion
                            priceController.text = suggestion.toString();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // TextField(
              //   controller: priceController,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(kBorderRadius)),
              //     hintText: 'Price',
              //   ),
              //   keyboardType: const TextInputType.numberWithOptions(
              //     signed: true,
              //     decimal: true,
              //   ),
              // ),
              const SizedBox(height: kPagePadding),
              const Text("Date"),
              const SizedBox(height: kPagePadding / 4),
              OutlinedButton(
                onPressed: () => _selectDate(context),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(kSecondaryColor),
                  alignment: Alignment.centerLeft,
                  padding: MaterialStateProperty.all(kPagePaddingInsets),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                  ),
                ),
                child: Text("${selectedDate.toLocal()}".split(' ')[0]),
              ),
              const SizedBox(height: kPagePadding * 2),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        // shape: OutlinedBorder(),
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(kSecondaryColor),
                        foregroundColor: MaterialStateProperty.all(kLightColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: kPagePadding * 1.5),
                        ),
                      ),
                      onPressed: () async {
                        processAndPostData()
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Text("UPDATE"),
                    ),
                  ),
                  const SizedBox(width: kPagePadding / 2),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        // shape: OutlinedBorder(),
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(kErrorColor),
                        foregroundColor: MaterialStateProperty.all(kLightColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: kPagePadding * 1.5),
                        ),
                      ),
                      onPressed: () async {
                        processAndPostData()
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Text("DELETE"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
