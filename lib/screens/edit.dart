import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spendee/db/income_expence.dart';
import 'package:spendee/db/transaction_db.dart';
import 'package:spendee/models/category/category_model.dart';
import 'package:spendee/models/transactions/transaction_model.dart';
import 'package:spendee/provider/add_transaction.dart';
import 'package:spendee/provider/transaction_provider.dart';
import 'package:spendee/widgets/button.dart';

import '../provider/category_provider.dart';

// ignore: must_be_immutable
class EditTransaction extends StatefulWidget {
  final String? id;
  final TransactionModel obj;

  EditTransaction({
    super.key,
    required this.obj,
    this.id,
  });

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  DateTime date = DateTime.now();

  DateTime? _selectedDateTime;

  // ignore: unused_field
  String? _selectedFinanace;

  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  // ignore: unused_field
  int _value = 0;

  TextEditingController _amountTextEditingController = TextEditingController();

  TextEditingController _explainTextEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> _iteminex = ['income', 'expense'];

  /*  @override
  void initState() {
    super.initState();

    super.initState();
    _value = int.parse(widget.obj.id);
    _amountTextEditingController =
        TextEditingController(text: widget.obj.amount);
    _explainTextEditingController =
        TextEditingController(text: widget.obj.explain);
    _selectedDateTime = widget.obj.datetime;
    // _selectedCategorName = widget.obj.categoryName;
    _selectedCategoryModel = widget.obj.category;
  } */
  @override
  Widget build(BuildContext context) {
    Provider.of<AddTransactionProvider>(context, listen: false).categoryId =
        widget.obj.category.categoryid;
    _amountTextEditingController =
        TextEditingController(text: widget.obj.amount.toString());
    _explainTextEditingController =
        TextEditingController(text: widget.obj.explain);
    Provider.of<AddTransactionProvider>(context, listen: false)
        .selectedDateTime = widget.obj.datetime;
    Provider.of<AddTransactionProvider>(context, listen: false)
        .selectedCategoryModel = widget.obj.category;

    //Provider.of<ProviderTransaction>(context).refreshUi();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          backgroundContainer(context),
          SingleChildScrollView(
            child: Container(
              child: mainContainer(context),
            ),
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
        /*  height: 550,
      width: 340, */
        height: size.height * 0.7,
        width: size.width * 0.9,
        child: Form(
          key: _formKey,
          child: Consumer<AddTransactionProvider>(
              builder: (context, value, child) {
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                name(context),
                const SizedBox(
                  height: 20,
                ),
                explain(context),
                const SizedBox(
                  height: 20,
                ),
                amount(context),
                const SizedBox(
                  height: 20,
                ),
                finance(context),
                const SizedBox(
                  height: 20,
                ),
                dateTime(context),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      submitEditIncomeTransaction(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Transaction Edited Successfully')),
                      );
                    }
                  },
                  child:
                      button(size.width * 0.30, size.height * 0.06, 'Save', 18),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          }),
        ));
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
                //date = newDate;
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
                'Date : ${value.selectedDateTime.year}/${value.selectedDateTime.month}/${value.selectedDateTime.day}',
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
            ),
          ),
          child: SingleChildScrollView(
            child: DropdownButtonFormField<String>(
              hint: Row(
                children: [
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 40,
                    child: Image.asset(
                        'assets/images/image/${widget.obj.finanace}.png'),
                  ),
                  // ignore: unnecessary_string_interpolations
                  Text('${widget.obj.finanace}',
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
              value: _selectedFinanace,

              onChanged: ((value) {
                _selectedFinanace = value!;
                /* setState(() {
                  _selectedFinanace = value!;
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

              //
            ),
          )),
    );
  }

  Padding amount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: 300,
        child: Consumer<AddTransactionProvider>(
          builder: (context, value, child) {
            return TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required Name';
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
              //focusNode: amount,
              controller: _amountTextEditingController,
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
                    borderSide:
                        const BorderSide(width: 2, color: Colors.green)),
              ),
            );
          },
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
          //focusNode: ex,
          controller: _explainTextEditingController,

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
                      //print('addTra******${e.categoryName}');
                    },
                  );
                }).toList(),
                onChanged: ((value) {
                  tProvider.categoryId = value;
                  print('addTra******${tProvider.categoryId}');
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
                      'Edit Transaction',
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

  Future<void> submitEditIncomeTransaction(context) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final _explainText = _explainTextEditingController.text;
    //final _explainText = 'ggg';
    // ignore: no_leading_underscores_for_local_identifiers
    final _amountText = _amountTextEditingController.text;
    //final _amountText = '5000';

    final model = TransactionModel(
        explain: _explainText,
        amount: _amountText,
        datetime: Provider.of<AddTransactionProvider>(context, listen: false)
            .selectedDateTime,
        //categoryName: _selectedCategorName!,
        finanace: _selectedFinanace!,
        category: Provider.of<AddTransactionProvider>(context, listen: false)
            .selectedCategoryModel!,

        //category: _selectedCategoryModel!,
        id: widget.obj.id);
    print(model);

    await Provider.of<ProviderTransaction>(context, listen: false)
        .editTransaction(model);
    //await TransactionDB.instance.editTransaction(model);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}
