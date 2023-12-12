import 'package:app_of_sales/services/sqlite_helper.dart';
import 'package:app_of_sales/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/database.dart';
import '../../utils/date_ops.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late TooltipBehavior _salesTooltipBehavior;

  late List<_ChartData> data;
  late TooltipBehavior _profitsTooltip;

  List<String> salesTimeframesCashFlow = ['hr', 'da', 'wk', 'mn', 'qu', 'an'];
  List<String> doughnutOptios = ['gainers', 'losers'];

  var salesTimeframesProfitLossChart = ['hr', 'da', 'wk', 'mn', 'qu', 'an'];
  var salesTimeframesSalesLevels = ['hr', 'da', 'wk', 'mn', 'qu', 'an'];
  var allAvailableDrinkNames = ['Kinyagi', 'da', 'wk', 'mn', 'qu', 'an'];

  late String selectedTimeframeCashFlow;
  late String selectedTimeframeProfitLossChart;
  late String selectedTimeframeSalesLevels;
  late String selectedDoughnut;
  late String selectedDrinkName;

  var databaseHelper = DatabaseHelper();

  @override
  void initState() {
    data = [
      _ChartData('David', 25),
      _ChartData('Steve', 38),
      _ChartData('Jack', 34),
      _ChartData('Others', 52)
    ];
    selectedTimeframeCashFlow = salesTimeframesCashFlow[0];
    selectedTimeframeProfitLossChart = salesTimeframesProfitLossChart[0];
    selectedDoughnut = doughnutOptios[0];
    selectedDrinkName = allAvailableDrinkNames[0];
    selectedTimeframeSalesLevels = salesTimeframesSalesLevels[0];
    _profitsTooltip = TooltipBehavior(enable: true);
    _salesTooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  // void reloadForNewTimeFrame() async {
  //   await databaseHelper
  //       .queryDay(
  //         SalesTable.tableName,
  //         getNormalDate(selectedDate),
  //       )
  //       .then((value) => setState(() => sales = value));
  //   double plus = 0;
  //   double minus = 0;
  //   sales.forEach((item) {
  //     print("Price: ${item[SalesTable.priceCol]}");
  //     double price = item[SalesTable.priceCol];
  //     if (price > 0) {
  //       plus += price;
  //     } else {
  //       minus += price.abs();
  //     }
  //   });
  //   print("$plus $sales");
  //   setState(() {
  //     soldTotal = plus;
  //     bought = minus;
  //     profit = soldTotal - bought;
  //   });
  //   print("reloaded for new data??");
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: kPagePaddingInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kPagePadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cash Flow Summary',
                      style: textTheme.labelMedium!.merge(
                        TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.settings,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kPagePadding / 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: kBgColor, // Background color
                    borderRadius: BorderRadius.circular(
                      kBorderRadius,
                    ), // Border radius
                  ),
                  child: DropdownButton<String>(
                    value: selectedTimeframeCashFlow,
                    icon: const Icon(CupertinoIcons
                        .chevron_down_circle_fill), // Custom dropdown icon
                    iconSize: 14,
                    // elevation: 16,
                    style: textTheme.labelSmall,
                    underline: Container(),
                    dropdownColor: kBgColor,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTimeframeCashFlow = newValue!;
                      });
                    },
                    items: salesTimeframesCashFlow
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: textTheme.labelSmall!.merge(
                            const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: kPagePadding / 3),
                Container(
                  padding: kPagePaddingInsets,
                  decoration: BoxDecoration(
                    color: kBgColor,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    border:
                        Border.all(color: kBgColor.withOpacity(0.5), width: 3),
                  ),
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    // Chart title
                    // Enable legend
                    legend: Legend(
                      iconWidth: 4,
                      textStyle: textTheme.labelSmall,
                      isVisible: true,
                      // orientation: LegendItemOrientation.vertical,
                      // isResponsive: false,
                    ),
                    // Enable tooltip
                    tooltipBehavior: _salesTooltipBehavior,
                    palette: salesChartPalette,
                    series: <LineSeries<SalesData, String>>[
                      LineSeries<SalesData, String>(
                        name: 'profits',
                        dataSource: <SalesData>[
                          SalesData('Jan', 35),
                          SalesData('Feb', 28),
                          SalesData('Mar', 34),
                          SalesData('Apr', 32),
                          SalesData('May', 40)
                        ],
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        // Enable data label
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                        ),
                      ),
                      LineSeries<SalesData, String>(
                        name: 'expenses',
                        dataSource: <SalesData>[
                          SalesData('Jan', 25),
                          SalesData('Feb', 18),
                          SalesData('Mar', 44),
                          SalesData('Apr', 52),
                          SalesData('May', 50)
                        ],
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        // Enable data label
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                        ),
                      ),
                      LineSeries<SalesData, String>(
                        name: 'sales',
                        dataSource: <SalesData>[
                          SalesData('Jan', 23),
                          SalesData('Feb', 19),
                          SalesData('Mar', 40),
                          SalesData('Apr', 55),
                          SalesData('May', 52)
                        ],
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        // Enable data label
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kPagePadding * 2),
                Text(
                  'Gainers & Losers',
                  style: textTheme.labelMedium!.merge(
                    TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: kPagePadding / 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // const Text('Biggest Gainers'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Biggest",
                              style: textTheme.labelSmall,
                            ),
                            Padding(padding: const EdgeInsets.all(2)),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: kBgColor, // Background color
                                borderRadius: BorderRadius.circular(
                                    kBorderRadius), // Border radius
                              ),
                              child: DropdownButton<String>(
                                value: selectedDoughnut,
                                icon: const Icon(
                                  CupertinoIcons.chevron_down_circle_fill,
                                ), // Custom dropdown icon
                                iconSize: 14,
                                // elevation: 16,
                                style: textTheme.labelSmall,
                                underline: Container(),
                                dropdownColor: kBgColor,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedDoughnut = newValue!;
                                  });
                                },
                                items: doughnutOptios
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: textTheme.labelSmall!.merge(
                                        const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: kPagePadding),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "In the last 1",
                              style: textTheme.labelSmall,
                            ),
                            Padding(padding: const EdgeInsets.all(2)),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: kBgColor, // Background color
                                borderRadius: BorderRadius.circular(
                                  kBorderRadius,
                                ), // Border radius
                              ),
                              child: DropdownButton<String>(
                                value: selectedTimeframeProfitLossChart,
                                icon: const Icon(CupertinoIcons
                                    .chevron_down_circle_fill), // Custom dropdown icon
                                iconSize: 14,
                                // elevation: 16,
                                style: textTheme.labelSmall,
                                underline: Container(),
                                dropdownColor: kBgColor,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedTimeframeProfitLossChart =
                                        newValue!;
                                  });
                                },
                                items: salesTimeframesProfitLossChart
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: textTheme.labelSmall!.merge(
                                        const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.settings),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: kPagePadding / 3),
                Container(
                  child: SfCircularChart(
                    tooltipBehavior: _profitsTooltip,
                    borderColor: kBgColor,
                    legend: Legend(
                      iconWidth: 4,
                      textStyle: textTheme.labelSmall,
                      isVisible: true,
                    ),
                    series: <CircularSeries>[
                      DoughnutSeries<_ChartData, String>(
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        enableTooltip: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kPagePadding),
                Text(
                  'Sales Levels',
                  style: textTheme.labelMedium!.merge(
                    TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: kPagePadding / 2),
                Row(
                  children: [
                    // const Text('Biggest Gainers'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time",
                          style: textTheme.labelSmall,
                        ),
                        Padding(padding: const EdgeInsets.all(2)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: kBgColor, // Background color
                            borderRadius: BorderRadius.circular(
                                kBorderRadius), // Border radius
                          ),
                          child: DropdownButton<String>(
                            value: selectedTimeframeSalesLevels,
                            icon: const Icon(
                              CupertinoIcons.chevron_down_circle_fill,
                            ), // Custom dropdown icon
                            iconSize: 14,
                            // elevation: 16,
                            style: textTheme.labelSmall,
                            underline: Container(),
                            dropdownColor: kBgColor,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTimeframeSalesLevels = newValue!;
                              });
                            },
                            items: salesTimeframesSalesLevels
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: textTheme.labelSmall!.merge(
                                    const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: kPagePadding),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item",
                          style: textTheme.labelSmall,
                        ),
                        Padding(padding: const EdgeInsets.all(2)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: kBgColor, // Background color
                            borderRadius: BorderRadius.circular(
                                kBorderRadius), // Border radius
                          ),
                          child: DropdownButton<String>(
                            value: selectedDrinkName,
                            icon: const Icon(
                              CupertinoIcons.chevron_down_circle_fill,
                            ), // Custom dropdown icon
                            iconSize: 14,
                            // elevation: 16,
                            style: textTheme.labelSmall,
                            underline: Container(),
                            dropdownColor: kBgColor,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDrinkName = newValue!;
                              });
                            },
                            items: allAvailableDrinkNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: textTheme.labelSmall!.merge(
                                    const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: kPagePadding / 3),
                Container(
                  padding: kPagePaddingInsets,
                  decoration: BoxDecoration(
                    color: kBgColor,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    border:
                        Border.all(color: kBgColor.withOpacity(0.5), width: 3),
                  ),
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    // Chart title
                    // Enable legend
                    legend: Legend(
                      iconWidth: 4,
                      textStyle: textTheme.labelSmall,
                      isVisible: true,
                      // orientation: LegendItemOrientation.vertical,
                      // isResponsive: false,
                    ),
                    // Enable tooltip
                    tooltipBehavior: _salesTooltipBehavior,
                    palette: salesChartPalette,
                    series: <LineSeries<SalesData, String>>[
                      LineSeries<SalesData, String>(
                        name: 'profits',
                        dataSource: <SalesData>[
                          SalesData('Jan', 35),
                          SalesData('Feb', 28),
                          SalesData('Mar', 34),
                          SalesData('Apr', 32),
                          SalesData('May', 40)
                        ],
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        // Enable data label
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                        ),
                      ),
                      LineSeries<SalesData, String>(
                        name: 'expenses',
                        dataSource: <SalesData>[
                          SalesData('Jan', 25),
                          SalesData('Feb', 18),
                          SalesData('Mar', 44),
                          SalesData('Apr', 52),
                          SalesData('May', 50)
                        ],
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        // Enable data label
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                        ),
                      ),
                      LineSeries<SalesData, String>(
                        name: 'sales',
                        dataSource: <SalesData>[
                          SalesData('Jan', 23),
                          SalesData('Feb', 19),
                          SalesData('Mar', 40),
                          SalesData('Apr', 55),
                          SalesData('May', 52)
                        ],
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        // Enable data label
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
