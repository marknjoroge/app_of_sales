import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/constants.dart';
import '../../utils/database.dart';
import '../../utils/date_ops.dart';
import '../stats/stats_page.dart';

class ProfitsPage extends StatefulWidget {
  final DateTime selectedDate;
  const ProfitsPage({super.key, required this.selectedDate});

  @override
  State<ProfitsPage> createState() => _ProfitsPageState();
}

class _ProfitsPageState extends State<ProfitsPage> {
  List<Map<String, dynamic>> sales = [];

  late String selectedTimeframeCashFlow;
  
  late TooltipBehavior _salesTooltipBehavior;
  List<String> salesTimeframesCashFlow = ['hr', 'da', 'wk', 'mn', 'qu', 'an'];

  
  @override
  void initState() {
    selectedTimeframeCashFlow = salesTimeframesCashFlow[0];
    _salesTooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: kPagePaddingInsets,
          child: Column(
            children: [
              // const SizedBox(height: kPagePadding * 2),
              // topBanner(context),
              profitsChart(context, textTheme),
              const SizedBox(height: kPagePadding * 2),
              Text(
                getNormalDate(widget.selectedDate),
                style: Theme.of(context).textTheme.labelSmall,
                // textAlign: TextAlign.start,
              ),
              const SizedBox(height: kPagePadding * 2),
              salesContainer(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget profitsChart(BuildContext context, TextTheme textTheme) {
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sales',
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
            border: Border.all(color: kBgColor.withOpacity(0.5), width: 3),
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
            ],
          ),
        ),
      ],
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
                          color: (sale[SalesTable.priceCol] < 0)
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
          );
        }).toList(),
      ),
    );
  }
}
