import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendee/db/category_db.dart';
import 'package:spendee/db/transaction_db.dart';
import 'package:spendee/models/transactions/transaction_model.dart';
import 'package:spendee/onboarding/first_screen.dart';
import 'package:spendee/provider/transaction_provider.dart';
import 'package:spendee/screens/settings_screens/settings.dart';
import 'package:spendee/widgets/bottomnavigation.dart';
import '../../models/category/category_model.dart';

class SettingFunctions extends ChangeNotifier {
  editLimit(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    var limitvariable1 = sharedPref.getString('limit')!;
    limitchangecontroller = TextEditingController(text: limitvariable1);
    // ignore: use_build_context_synchronously
    showdialog(context);
  }

  showdialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter the Limit'),
            content: TextField(
              controller: limitchangecontroller,
              style: const TextStyle(fontSize: 20),
              keyboardType: TextInputType.number,
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    var newLimit = limitchangecontroller.text;
                    if (!RegExp(r'^\d+$').hasMatch(newLimit)) {
                      //Navigator.of(context).push(MaterialPageRoute(builder:Limit()));
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Please enter a valide number..!!!',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }

                    final sharedPref = await SharedPreferences.getInstance();
                    sharedPref.setString('limit', newLimit);

                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNavBar()),
                    );
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.redAccent)),
                  child: const Text('Save'),
                ),
              )
            ],
          );
        });
  }

  resetApp(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text(
              'Do you want to Reset the app?',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            actions: [
              TextButton(
                  onPressed: (() async {
                    Navigator.of(context).pop();

                    /* final categoryDB =
                        await Hive.openBox<CategoryModel>(categoryDBName); */

                    //categoryDB.clear();

                    final transactionDb =
                        await Hive.openBox<TransactionModel>(transactionDbName);

                    transactionDb.clear();

                    TransactionDB().transactionListNotifier.value.clear();
                    TransactionDB().transactionListNotifier.notifyListeners();

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const FirstScreen(),
                      ),
                    );

                    //CategoryDB().categoryNotifier.notifyListeners();
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    await pref.clear();
                  }),
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )),
              TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        });
  }
}
