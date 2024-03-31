import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/models/expense.dart';
import 'package:my_expense_tracker_app/providers/all_expenses_provider.dart';
import 'package:http/http.dart' as http;
import 'package:my_expense_tracker_app/providers/user_info_provider.dart';

class NewExpenseForm extends ConsumerStatefulWidget {
  const NewExpenseForm({
    this.expenseToBeEdited,
    super.key,
  });

  final Expense? expenseToBeEdited;

  @override
  ConsumerState<NewExpenseForm> createState() => _NewExpenseFormState();
}

class _NewExpenseFormState extends ConsumerState<NewExpenseForm> {
  var _selectedCategory = Category.values[0];
  DateTime _selectedDate = DateTime.now();

  late TextEditingController _descriptionController;
  late TextEditingController _amountController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.expenseToBeEdited?.description);
    _amountController = TextEditingController(
        text: widget.expenseToBeEdited?.amount.toString());
    if (widget.expenseToBeEdited != null) {
      _selectedCategory = widget.expenseToBeEdited!.category;
      _selectedDate = widget.expenseToBeEdited!.dateOfExpense;
    }
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    DateTime? pickedDate;
    DateTime currently = DateTime.now();
    pickedDate = await showDatePicker(
      context: context,
      initialDate: currently,
      firstDate: DateTime(currently.year - 1),
      lastDate: currently,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate!;
      });
    }
  }

  void _showDialog() {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: const Text("Invalid Data"),
            content: const Text(
                "You either didn't enter a description, an amount, a date or an invalid amount"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Invalid Data"),
            content: const Text(
                "You either didn't enter a description, an amount, a date or an invalid amount"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              )
            ],
          );
        },
      );
    }
  }

  Future<http.Response> _sendCreateExpenseRequest(Expense expense) async {
    final url = Uri.http('localhost:8000', '/create-expense');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'id': expense.id.toString(),
          'description': expense.description,
          'category_name': expense.category.name,
          'amount': expense.amount,
          'expense_date': expense.dateOfExpense.toString(),
          'user_email': ref.watch(userInfoProvider).email,
        },
      ),
    );
    return response;
  }

  Future<http.Response> _sendUpdateExpenseRequest(Expense newExpense) async {
    final url = Uri.http('localhost:8000', '/update-expense/');

    final response = await http.put(
      url,
      body: json.encode(
        {
          'id': newExpense.id.toString(),
          'description': newExpense.description,
          'category_name': newExpense.category.name,
          'amount': newExpense.amount,
          'expense_date': newExpense.dateOfExpense.toString(),
        },
      ),
      headers: {'Content-Type': 'application/json'},
    );

    return response;
  }

  void _submitForm() async {
    var enteredAmount = double.tryParse(_amountController.text);
    bool invalidAmount = enteredAmount == null || enteredAmount < 0;
    if (invalidAmount || _descriptionController.text.trim().isEmpty) {
      _showDialog();
      return;
    }

    // if widget.expenseToBeEdited != null we want to edit an expense
    if (widget.expenseToBeEdited != null) {
      final response = await _sendUpdateExpenseRequest(
        Expense(
          id: widget.expenseToBeEdited!.id,
          dateOfExpense: _selectedDate,
          amount: enteredAmount,
          description: _descriptionController.text,
          category: _selectedCategory,
        ),
      );

      if (response.statusCode == 200) {
        ref.read(allExpensesProvider.notifier).updateExpense(
              oldExpense: widget.expenseToBeEdited!,
              newExpense: Expense(
                id: widget.expenseToBeEdited!.id,
                dateOfExpense: _selectedDate,
                amount: enteredAmount,
                description: _descriptionController.text,
                category: _selectedCategory,
              ),
            );
        Navigator.pop(context);
        return;
      }
    }

    // if we are not editing and we are creating instead
    final Expense expense = Expense(
      id: DateTime.now(),
      dateOfExpense: _selectedDate,
      description: _descriptionController.text,
      amount: enteredAmount,
      category: _selectedCategory,
    );

    final response = await _sendCreateExpenseRequest(expense);
    if (response.statusCode == 200) {
      ref.read(allExpensesProvider.notifier).createExpense(expense);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
              top: 30, bottom: keyboardSize + 30, left: 30, right: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                if (availableWidth <= 600) ...[
                  TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Description"),
                      hintText: "   Enter the Description of the expense.",
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "₦",
                            label: Text("Amount"),
                            hintText: "    Enter the Amount of the expense.",
                            hintStyle: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        format.format(_selectedDate),
                      ),
                      IconButton(
                        onPressed: _showDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // the dropdown, and buttons rows
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: [
                          for (var category in Category.values)
                            DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            )
                        ],
                        onChanged: (value) {
                          setState(
                            () {
                              _selectedCategory = value!;
                            },
                          );
                          // setstate
                        },
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text(
                          "Save expense",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                        ),
                      )
                    ],
                  ),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.text,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Description"),
                            hintText:
                                "   Enter the Description of the expense.",
                            hintStyle: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "₦",
                            label: Text("Amount"),
                            hintText: "    Enter the Amount of the expense.",
                            hintStyle: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: [
                          for (var category in Category.values)
                            DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            )
                        ],
                        onChanged: (value) {
                          setState(
                            () {
                              _selectedCategory = value!;
                            },
                          );
                          // setstate
                        },
                      ),
                      const Spacer(),
                      Text(
                        format.format(_selectedDate),
                      ),
                      IconButton(
                        onPressed: _showDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // the dropdown, and buttons rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text(
                          "Save expense",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                        ),
                      )
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      );
    });
  }
}
