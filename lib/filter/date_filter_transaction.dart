import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/db/transaction_db.dart';
import 'package:spendee/screens/home_screen.dart';
import 'package:spendee/screens/transaction/transactionlist.dart';

import '../provider/transaction_provider.dart';

class DateFilterTransaction extends StatefulWidget {
  const DateFilterTransaction({
    Key? key,
  }) : super(key: key);

  @override
  State<DateFilterTransaction> createState() => _DateFilterTransactionState();
}

class _DateFilterTransactionState extends State<DateFilterTransaction> {
  DateTime? startDate, endDate;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderTransaction>(
        builder: (context, showCategory, child) {
      return PopupMenuButton<int>(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        child: const Icon(
          Icons.calendar_view_day_rounded,
        ),
        itemBuilder: (ctx) => [
          PopupMenuItem(
            value: 1,
            child: const Text(
              "All",
            ),
            onTap: () {
              showCategory.setOverviewTransactions =
                  showCategory.transactionListProvider;
            },
          ),
          PopupMenuItem(
            value: 2,
            child: const Text(
              "Today",
            ),
            onTap: () {
              showCategory.setOverviewTransactions =
                  showCategory.transactionListProvider;
              showCategory.setOverviewTransactions = showCategory
                  .overviewTransactions
                  .where((element) =>
                      element.datetime.day == DateTime.now().day &&
                      element.datetime.month == DateTime.now().month &&
                      element.datetime.year == DateTime.now().year)
                  .toList();
            },
          ),
          PopupMenuItem(
              value: 2,
              child: const Text(
                "Yesterday",
              ),
              onTap: () {
                showCategory.setOverviewTransactions =
                    showCategory.transactionListProvider;
                showCategory.setOverviewTransactions = showCategory
                    .overviewTransactions
                    .where((element) =>
                        element.datetime.day == DateTime.now().day - 1 &&
                        element.datetime.month == DateTime.now().month &&
                        element.datetime.year == DateTime.now().year)
                    .toList();
              }),
          PopupMenuItem(
              value: 2,
              child: const Text(
                "Month",
              ),
              onTap: () {
                showCategory.setOverviewTransactions =
                    showCategory.transactionListProvider;
                showCategory.setOverviewTransactions = showCategory
                    .overviewTransactions
                    .where((element) =>
                        element.datetime.month == DateTime.now().month &&
                        element.datetime.year == DateTime.now().year)
                    .toList();
              }),
          PopupMenuItem(
              value: 2,
              child: const Text(
                "Date Range",
              ),
              onTap: () {
                showCustomDateRangePicker(context,
                    dismissible: true,
                    minimumDate: DateTime(2010),
                    maximumDate: DateTime(DateTime.now().year + 500),
                    endDate: endDate,
                    startDate: startDate, onApplyClick: (start, end) {
                  setState(() {
                    endDate = end.add(const Duration(days: 1));
                    startDate = start.subtract(const Duration(days: 1));
                  });

                  showCategory.setOverviewTransactions =
                      showCategory.transactionListProvider;
                  showCategory.setOverviewTransactions = showCategory
                      .overviewTransactions
                      .where((element) =>
                          element.datetime.isAfter(startDate!) &&
                          element.datetime.isBefore(endDate!))
                      .toList();
                  startDate = null;
                  endDate = null;
                }, onCancelClick: () {
                  setState(() {
                    endDate = null;
                    startDate = null;
                  });
                },
                    backgroundColor: Colors.white,
                    primaryColor: const Color.fromARGB(255, 244, 98, 54));
                //print('start date $startDate , end date $endDate');
              }),
        ],
      );
    });
  }
}
