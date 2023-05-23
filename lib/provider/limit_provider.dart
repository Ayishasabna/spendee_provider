import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendee/provider/transaction_provider.dart';

import '../widgets/limit.dart';

class LimitProvider extends ChangeNotifier {
  void new1() async {
    final sharedPref = await SharedPreferences.getInstance();
    var limitvariable = sharedPref.getString('limit');
    //limitController.text = limitvariable;
    if (limitvariable != null) {
      limitController.text = limitvariable;
    }
  }
}
