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
  DateTime? _selectedDate;

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
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitForm() {
    var enteredAmount = double.tryParse(_amountController.text);
    bool invalidAmount = enteredAmount == null || enteredAmount < 0;
    if (invalidAmount ||
        _descriptionController.text.trim().isEmpty ||
        _selectedDate == null) {
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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
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
                      prefixText: "\$",
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
                  _selectedDate == null
                      ? "No Date Selected"
                      : format.format(_selectedDate!),
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
