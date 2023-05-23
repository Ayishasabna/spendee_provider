import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/db/income_expence.dart';
import 'package:spendee/db/transaction_db.dart';
import 'package:spendee/models/transactions/transaction_model.dart';
import 'package:spendee/provider/income_expence.dart';
import 'package:spendee/provider/transaction_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/* ValueNotifier<List<TransactionModel>> overViewGraphNotifier =
    ValueNotifier(TransactionDB.instance.transactionListNotifier.value); */

class ScreenAll extends StatelessWidget {
  ScreenAll({super.key});
  late TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  // late TooltipBehavior _tooltipBehavior;

  /* @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  } */
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 245, 245),
        //Color.fromARGB(255, 205, 204, 204),
        body: Consumer<ProviderTransaction>(
          builder: (context, value, child) {
            Map incomeMap = {
              'name': 'Income',
              "amount": IncomeAndExpence().income(),
            };
            Map expenseMap = {
              "name": "Expense",
              "amount": IncomeAndExpence().expense()
            };
            List<Map> totalMap = [incomeMap, expenseMap];
            //List<Map> totalMap = [incomeMap, expenseMap];
            return value.overviewGraphTransactions.isEmpty
                ? SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Center(child: Text('No data Found')),
                        ],
                      ),
                    ),
                  )
                : SfCircularChart(
                    tooltipBehavior: _tooltipBehavior,
                    series: <CircularSeries>[
                      PieSeries<Map, String>(
                        dataSource: totalMap,
                        xValueMapper: (Map data, _) => data['name'],
                        yValueMapper: (Map data, _) => data['amount'],
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      )
                    ],
                    legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.scroll,
                      alignment: ChartAlignment.center,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
