import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/screens/transaction/transactions.dart';

import '../provider/transaction_provider.dart';

class TypeFilterClass extends StatelessWidget {
  const TypeFilterClass({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderTransaction>(
        builder: (context, showCategory, child) {
      return PopupMenuButton(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          itemBuilder: ((context) => [
                PopupMenuItem(
                  value: 1,
                  onTap: () => showCategory.setShowCategory = "All",
                  child: const Text("All"),
                ),
                PopupMenuItem(
                  value: 2,
                  onTap: () => showCategory.setShowCategory = "income",
                  child: const Text("Income"),
                ),
                PopupMenuItem(
                  value: 3,
                  onTap: () => showCategory.setShowCategory = "Expense",
                  child: const Text("Expense"),
                ),
              ]),
          child: const Icon(
            Icons.filter_list_sharp,
            size: 30,
          ));
    });
  }
}
