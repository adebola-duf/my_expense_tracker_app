import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/models/expense.dart';
import 'package:my_expense_tracker_app/widgets/chart/chart.dart';
import 'package:my_expense_tracker_app/widgets/expenses_list.dart';
import 'package:my_expense_tracker_app/widgets/new_expense_form_modal_sheet.dart';

class ExpensesApp extends StatefulWidget {
  const ExpensesApp({super.key});

  @override
  State<ExpensesApp> createState() {
    return _ExpensesAppState();
  }
}

class _ExpensesAppState extends State<ExpensesApp> {
  final List<Expense> _allExpenses = [
    Expense(
        description:
            "Dummy Item: Without this Dummy Item, there is going to be an error",
        amount: 90,
        category: Category.flex)
  ];

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return NewExpenseForm(
          onSubmitForm: _createNewExpense,
        );
      },
      isScrollControlled: true,
    );
  }

  void _createNewExpense(Expense newExpense) {
    setState(() {
      _allExpenses.add(newExpense);
    });
  }

  void _undoDeletingExpense(Expense expense, int expenseIndex) {
    setState(() {
      _allExpenses.insert(expenseIndex, expense);
    });
  }

  void _deleteExpense(Expense expense) {
    int indexExpense = _allExpenses.indexOf(expense);
    setState(() {
      _allExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Theme.of(context).colorScheme.onInverseSurface
                : Theme.of(context).colorScheme.primary,
        content: const Text(
          "Expense Deleted",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: const Duration(
          seconds: 2,
        ),
        action: SnackBarAction(
          label: "Undo",
          textColor: Colors.white,
          backgroundColor: Colors.black,
          onPressed: () {
            _undoDeletingExpense(expense, indexExpense);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: IconButton(
              onPressed: _showModalBottomSheet,
              icon: const Icon(Icons.add),
            ),
          ),
        ],
        title: const Text(
          "Expense Tracker",
        ),
      ),
      body: Column(
        children: [
          if (_allExpenses.isNotEmpty) Chart(expenses: _allExpenses),
          Expanded(
            child: _allExpenses.isEmpty
                ? const Center(
                    child: Text(
                      "You have no Expenses",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  )
                : ExpensesList(
                    allExpenses: _allExpenses,
                    onExpenseDismissed: _deleteExpense,
                  ),
          ),
        ],
      ),
    );
  }
}
