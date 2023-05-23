import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendee/db/income_expence.dart';
import 'package:spendee/db/transaction_db.dart';
import 'package:spendee/models/category/category_model.dart';
import 'package:spendee/models/transactions/transaction_model.dart';
import 'package:spendee/provider/add_transaction.dart';
import 'package:spendee/provider/category_provider.dart';
import 'package:spendee/provider/transaction_provider.dart';
import 'package:spendee/widgets/bottomnavigation.dart';
import 'package:spendee/widgets/button.dart';

import '../../provider/income_expence.dart';

class AddTransaction extends StatelessWidget {
  AddTransaction({super.key});

  DateTime date = DateTime.now();

  String? selectedFinanace;

  CategoryModel? selectedCategoryModel;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController explainController = TextEditingController();

  FocusNode ex = FocusNode();
  final TextEditingController amountcontroller = TextEditingController();
  FocusNode amount = FocusNode();

  final List<String> _iteminex = ['income', 'expense'];

  /*  void initstate() {
    super.initState();
    IncomeAndExpence().income();
  } */

  @override
  Widget build(BuildContext context) {
    Provider.of<ProviderTransaction>(context).refreshUi();
    Provider.of<CategoryProvider>(context).refreshUI();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          backgroundContainer(context),
          // ignore: avoid_unnecessary_containers
          Container(
            //width: screenWidth * 0.9,
            child: SingleChildScrollView(child: mainContainer(context)),
          )
        ],
      )),
    );
  }

  Container mainContainer(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      //SizedBox(height: screenHeight * .08),

      /* height: 550,
       width: 340, */

      height: size.height * 0.7,
      width: size.width * 0.9,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            name(context),
            const SizedBox(
              height: 20,
            ),
            explain(context),
            const SizedBox(
              height: 20,
            ),
            transactionAmount(context),
            const SizedBox(
              height: 20,
            ),
            finance(context),
            const SizedBox(
              height: 20,
            ),
            dateTime(context),
            const SizedBox(
              height: 50,
            ),
            //const Spacer(),
            GestureDetector(
              onTap: () {
                //addTransaction(context);
                if (_formKey.currentState!.validate()) {
                  addTransaction(context);
                }
              },
              child: button(size.width * 0.30, size.height * 0.06, 'Save', 18),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Container dateTime(BuildContext context) {
    return Container(
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Colors.grey)),
        width: 300,
        child: Consumer<AddTransactionProvider>(
          builder: (context, value, child) {
            return TextButton(
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100));

                value.dateSelection(newDate);

                // ignore: unrelated_type_equality_checks
                if (newDate == null) {
                  return;
                } else {
                  date = newDate;
                  print(date.year);
                  /* setState(() {
                date = newDate;
              }); */
                }
              },
              child: Text(
                'Date : ${date.year}/${date.month}/${date.day}',
                //'Date : ${date.year}/${date.month}/${date.day}',
                style: const TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            );
          },
        ));
  }

  Padding finance(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: Colors.grey,
              )),
          child: DropdownButtonFormField<String>(
            value: selectedFinanace,

            onChanged: ((value) {
              selectedFinanace = value!;
              print(selectedFinanace);
              /* setState(() {
                selectedFinanace = value!;
              }); */
            }),

            items: _iteminex
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/image/$e.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            e,
                            style: const TextStyle(fontSize: 17),
                          )
                        ],
                      ),
                    ))
                .toList(),

            hint: const Text(
              'Select',
              style: TextStyle(color: Colors.grey),
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            //underline: Container(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Select finanace';
              } else {
                return null;
              }
            },
          )),
    );
  }

  Padding transactionAmount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: 300,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Select Amount';
            } else if (value.contains(',')) {
              return 'Please remove special character';
            } else if (value.contains('.')) {
              return 'Please remove special character';
            } else if (value.contains(' ')) {
              return 'Please Enter a valid number';
            } else {
              return null;
            }
          },
          keyboardType: TextInputType.number,
          focusNode: amount,
          controller: amountcontroller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            labelText: 'Amount',
            labelStyle: const TextStyle(fontSize: 17, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 2, color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 2, color: Colors.green)),
          ),
        ),
      ),
    );
  }

  Padding explain(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: 300,
        child: TextField(
          focusNode: ex,
          controller: explainController,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            labelText: 'explain',
            labelStyle: const TextStyle(fontSize: 17, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 2, color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 2, color: Colors.green)),
          ),
        ),
      ),
    );
  }

  Padding name(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: Colors.grey,
            ),
          ),
          child: Consumer2<AddTransactionProvider, CategoryProvider>(
            builder: (context, tProvider, cProvider, child) {
              return DropdownButtonFormField<String>(
                // items: dropdownitems(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select Name';
                  } else {
                    return null;
                  }
                },
                //hint: Text('Select Expense'),
                value: tProvider.categoryId,

                items: cProvider.categoryProvider.map((e) {
                  return DropdownMenuItem(
                    value: e.categoryid,
                    child: Row(children: [
                      Image.asset(
                        'assets/images/image/${e.categoryImage}.png',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        e.categoryName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17),
                      ),
                    ]),
                    onTap: () {
                      //print('addTra******${e.categoryName}');
                      tProvider.selectedCategoryModel = e;
                    },
                  );
                }).toList(),
                onChanged: ((value) {
                  tProvider.categoryId = value;
                }),

                /*  onChanged: (value) {
                  tProvider.categoryId = value;
                  print('addTra******${tProvider.selectedCategoryModel}');
                }, */
              );
            },
          )),
    );
  }

  Future addTransaction(BuildContext context) async {
    /*  if (amountcontroller.text.isEmpty) {
      return;
    }
    if ((explainController.text.isEmpty)) {
      return;
    }
    if (selectedCategoryModel == null) {
      return;
    }
    if (selectedFinanace == null) {
      return;
    } */
    print('amount  :${amountcontroller.text}');
    print('finance  :${selectedFinanace}');
    // print('date  :${date}');
    print('explain  :${explainController.text}');
    //print('category  :${selectedCategoryModel?.categoryName}');
    print(
      Provider.of<AddTransactionProvider>(context, listen: false)
          .selectedCategoryModel
          ?.categoryName,
    );

    final model = TransactionModel(
      finanace: selectedFinanace!,
      amount: amountcontroller.text,
      datetime: date,
      explain: explainController.text,
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      category: Provider.of<AddTransactionProvider>(context, listen: false)
          .selectedCategoryModel!,
    );

    /*  final model = TransactionModel(
        // categoryName: name,
        finanace: selectedFinanace!,
        amount: amountcontroller.text,
        datetime: date,
        //datetime: Provider.of<AddTransactionProvider>(context, listen: false).selectedDateTime,
        explain: explainController.text,
        category: Provider.of<AddTransactionProvider>(context, listen: false)
            .selectedCategoryModel!,
        id: DateTime.now().microsecondsSinceEpoch.toString());
 */
    print('date  :${date}');
    await Provider.of<ProviderTransaction>(context, listen: false)
        .addTransaction(model);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Transaction Added Successfully',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.amber,
      ),
    );
    limitCheck(selectedFinanace!, context);
  }

  limitCheck(String finance, BuildContext context) async {
    if (finance == 'expense') {
      final sharedPref = await SharedPreferences.getInstance();
      var limitvariable = sharedPref.getString('limit');

      int expense1 = IncomeAndExpence().expense();
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const BottomNavBar()));
      double limit = double.parse(limitvariable!);
      double expenses = expense1.toDouble();
      double eightyPercentOfLimit = limit * 0.8;

      if (expenses >= eightyPercentOfLimit && expenses < limit) {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Align(
                  alignment: Alignment.center,
                  child: Text(
                    ' Expense has crossed \n   80% of the limit',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            });
      }
      if (expenses >= limit) {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Center(
                  child: Text(
                    'Expense has crossed \n the limit',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            });
      }
    }
  }
}

Column backgroundContainer(BuildContext context) {
  return Column(
    children: [
      Container(
        width: double.infinity,
        height: 240,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(199, 12, 12, 0.88),
              Color.fromRGBO(255, 67, 40, 0.88),
              Color.fromRGBO(255, 152, 100, 0.88)
            ]),
            //color: Colors.amber,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    width: 80,
                  ),
                  const Text(
                    'Add Transaction',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    ],
  );
}
