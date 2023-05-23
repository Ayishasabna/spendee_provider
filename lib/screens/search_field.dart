import 'package:flutter/material.dart';
import 'package:spendee/db/transaction_db.dart';
import 'package:spendee/screens/transaction/transactionlist.dart';
import 'package:provider/provider.dart';

import '../provider/transaction_provider.dart';

class SearchField extends StatelessWidget {
  SearchField({super.key});

  TextEditingController searchQueryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 9,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: searchQueryController,
            onChanged: (query) {
              //print('$query');
              searchResult(query, context);
              // overViewListNotifier.notifyListeners();
            },
            decoration: InputDecoration(
                hintText: 'Search..',
                border: InputBorder.none,
                icon: const Icon(
                  Icons.search,
                  // color: textClr,
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      Provider.of<ProviderTransaction>(context, listen: false)
                              .overviewTransactions =
                          Provider.of<ProviderTransaction>(context,
                                  listen: false)
                              .transactionListProvider;
                      Provider.of<ProviderTransaction>(context, listen: false)
                          .notifyListeners();
                    },
                    icon: const Icon(
                      Icons.close,
                      // color: Colors.black,
                    ))),
          ),
        ),
      ),
    );
  }

  searchResult(String query, BuildContext context) {
    //debugPrint('queryprinted  $query');
    if (query.isEmpty || query == '') {
      Provider.of<ProviderTransaction>(context, listen: false)
              .overviewTransactions =
          Provider.of<ProviderTransaction>(context, listen: false)
              .transactionListProvider;
      Provider.of<ProviderTransaction>(context, listen: false)
          .notifyListeners();
    } else {
      Provider.of<ProviderTransaction>(context, listen: false)
              .overviewTransactions =
          Provider.of<ProviderTransaction>(context, listen: false)
              .overviewTransactions
              .where((element) =>
                  element.category.categoryName
                      .toString()
                      .toLowerCase()
                      .contains(query.trim().toLowerCase()) ||
                  element.explain.contains(query.trim().toLowerCase()))
              .toList();
      Provider.of<ProviderTransaction>(context, listen: false)
          .notifyListeners();
    }
  }
}
