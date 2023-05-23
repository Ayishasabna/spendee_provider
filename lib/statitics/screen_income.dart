import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/models/transactions/transaction_model.dart';
import 'package:spendee/statitics/statitics_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../provider/transaction_provider.dart';

class ScreenIncomeChart extends StatelessWidget {
  const ScreenIncomeChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 245, 245),
        body: Consumer<ProviderTransaction>(
          builder: (context, value, child) {
            var allIncome = value.overviewGraphTransactions
                .where((element) => element.finanace == 'income')
                .toList();
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
                    series: <CircularSeries>[
                      PieSeries<TransactionModel, String>(
                        dataSource: allIncome,
                        xValueMapper: (TransactionModel incomeDate, _) =>
                            incomeDate.category.categoryName,
                        yValueMapper: (TransactionModel incomeDate, _) =>
                            int.parse(incomeDate.amount),
                        //num.parse(incomeDate.amount),
                        //incomeDate.hashCode,
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
