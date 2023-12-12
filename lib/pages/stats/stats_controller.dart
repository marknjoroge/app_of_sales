import '../../services/sqlite_helper.dart';
import '../../utils/database.dart';
import '../../utils/date_ops.dart';

class StatsController {
  var databaseHelper = DatabaseHelper();

  void getTopSales(DateTime selectedDate) async {
    double plus = 0;
    double minus = 0;
    await databaseHelper.queryCustom(
      SalesTable.tableName,
      '${SalesTable.dateCol} = ?',
      [getNormalDate(selectedDate)],
    ).then((sales) {
      sales.forEach((item) {
        print("Price: ${item[SalesTable.priceCol]}");
        double price = item[SalesTable.priceCol];
        if (price > 0) {
          plus += price;
        } else {
          minus += price.abs();
        }
      });
    });
    // print("$plus $sales");
    // setState(() {
    //   soldTotal = plus;
    //   bought = minus;
    //   profit = soldTotal - bought;
    // });
    print("reloaded for new data??");
  }
}
