// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// import '../utils/constants.dart';


// class LineGraph extends StatelessWidget {
//   const LineGraph({super.key});

//   @override
//   Widget build(BuildContext context) {
//   var textTheme = Theme.of(context).textTheme;
//   return Container(
//     padding: kPagePaddingInsets,
//     decoration: BoxDecoration(
//       color: kBgColor,
//       borderRadius: BorderRadius.circular(kBorderRadius),
//       border: Border.all(color: kBgColor.withOpacity(0.5), width: 3),
//     ),
//     child: SfCartesianChart(
//       primaryXAxis: CategoryAxis(),
//       // Chart title
//       title: ChartTitle(text: 'Half yearly sales analysis'),
//       // Enable legend
//       legend: Legend(
//         iconWidth: 4,
//         textStyle: textTheme.labelSmall,
//         isVisible: true,
//         // orientation: LegendItemOrientation.vertical,
//         // isResponsive: false,
//       ),
//       // Enable tooltip
//       tooltipBehavior: _salesTooltipBehavior,
//       palette: salesChartPalette,
//       series: <LineSeries<SalesData, String>>[
//         LineSeries<SalesData, String>(
//           name: 'profits',
//           dataSource: <SalesData>[
//             SalesData('Jan', 35),
//             SalesData('Feb', 28),
//             SalesData('Mar', 34),
//             SalesData('Apr', 32),
//             SalesData('May', 40)
//           ],
//           xValueMapper: (SalesData sales, _) => sales.year,
//           yValueMapper: (SalesData sales, _) => sales.sales,
//           // Enable data label
//           dataLabelSettings: const DataLabelSettings(
//             isVisible: true,
//             useSeriesColor: true,
//           ),
//         ),
//         LineSeries<SalesData, String>(
//           name: 'expenses',
//           dataSource: <SalesData>[
//             SalesData('Jan', 25),
//             SalesData('Feb', 18),
//             SalesData('Mar', 44),
//             SalesData('Apr', 52),
//             SalesData('May', 50)
//           ],
//           xValueMapper: (SalesData sales, _) => sales.year,
//           yValueMapper: (SalesData sales, _) => sales.sales,
//           // Enable data label
//           dataLabelSettings: const DataLabelSettings(
//             isVisible: true,
//             useSeriesColor: true,
//           ),
//         ),
//         LineSeries<SalesData, String>(
//           name: 'sales',
//           dataSource: <SalesData>[
//             SalesData('Jan', 23),
//             SalesData('Feb', 19),
//             SalesData('Mar', 40),
//             SalesData('Apr', 55),
//             SalesData('May', 52)
//           ],
//           xValueMapper: (SalesData sales, _) => sales.year,
//           yValueMapper: (SalesData sales, _) => sales.sales,
//           // Enable data label
//           dataLabelSettings: const DataLabelSettings(
//             isVisible: true,
//             useSeriesColor: true,
//           ),
//         ),
//       ],
//     ),
//     );
//   }
// }