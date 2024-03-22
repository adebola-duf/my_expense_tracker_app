import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/models/expense.dart';

class NewExpenseForm extends StatefulWidget {
  const NewExpenseForm({required this.onSubmitForm, super.key});

  final void Function(Expense) onSubmitForm;

  @override
  State<NewExpenseForm> createState() => _NewExpenseFormState();
}

class _NewExpenseFormState extends State<NewExpenseForm> {
  var _selectedCategory = Category.values[0];
  DateTime _selectedDate = DateTime.now();

  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

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

  void _submitForm() {
    var enteredAmount = double.tryParse(_amountController.text);
    bool invalidAmount = enteredAmount == null || enteredAmount < 0;
    if (invalidAmount || _descriptionController.text.trim().isEmpty) {
      _showDialog();
      return;
    }
    widget.onSubmitForm(
      Expense(
        description: _descriptionController.text,
        amount: enteredAmount,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
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
