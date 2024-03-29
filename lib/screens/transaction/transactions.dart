import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendee/db/transaction_db.dart';
import 'package:spendee/filter/date_filter_transaction.dart';
import 'package:spendee/filter/type_filter_transaction.dart';
import 'package:spendee/screens/home_screen.dart';
import 'package:spendee/screens/search_field.dart';
import 'package:spendee/screens/transaction/transactionlist.dart';

ValueNotifier showCategory = ValueNotifier('All');

class Transactions extends StatelessWidget {
  Transactions({super.key});

  ValueNotifier showCategory = ValueNotifier('All');

  // TextEditingController amountC = TextEditingController();
  @override
  /*  void initState() {
    overViewListNotifier.value =
        TransactionDB.instance.transactionListNotifier.value;
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: const [
              DateFilterTransaction(),
              SizedBox(
                width: 10,
              ),
              TypeFilterClass(),
              SizedBox(
                width: 20,
              ),
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(247, 22, 22, 0.878),
                  Color.fromRGBO(255, 67, 40, 0.88),
                  Color.fromRGBO(255, 152, 100, 0.88),
                ]),
              ),
            ),
            title: const Center(
              child: Text('Transactions'),
            ),
          ),
          body: Column(
            children: [
              SearchField(),
              Expanded(
                child: TransactionList(),
              ),
            ],
          )),
    );
  }
}

popoutfuction(BuildContext context) {
  return Navigator.of(context).pop();
}

String parseDate(DateTime date) {
  return '${day[date.weekday - 1]}-${date.year} ${DateFormat.MMMd().format(date)}';
}
