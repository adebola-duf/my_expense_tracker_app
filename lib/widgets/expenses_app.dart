import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/models/expense.dart';
import 'package:my_expense_tracker_app/providers/all_expenses_provider.dart';
import 'package:my_expense_tracker_app/widgets/chart/chart.dart';
import 'package:my_expense_tracker_app/widgets/expenses_list.dart';
import 'package:my_expense_tracker_app/widgets/new_expense_form_modal_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesApp extends ConsumerStatefulWidget {
  const ExpensesApp({super.key});

  @override
  ConsumerState<ExpensesApp> createState() {
    return _ExpensesAppState();
  }
}

class _ExpensesAppState extends ConsumerState<ExpensesApp> {
  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return const NewExpenseForm();
      },
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Expense> allExpenses = ref.watch(allExpensesProvider);

    final availalbleWidth = MediaQuery.of(context).size.width;
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
      body: availalbleWidth <= 600
          ? Column(
              children: [
                if (allExpenses.isNotEmpty) Chart(expenses: allExpenses),
                Expanded(
                  child: allExpenses.isEmpty
                      ? const Center(
                          child: Text(
                            "You have no Expenses",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        )
                      : const ExpensesList(),
                ),
              ],
            )
          : Row(
              children: [
                if (allExpenses.isNotEmpty)
                  Expanded(child: Chart(expenses: allExpenses)),
                Expanded(
                  child: allExpenses.isEmpty
                      ? const Center(
                          child: Text(
                            "You have no Expenses",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        )
                      : const ExpensesList(),
                ),
              ],
            ),
    );
  }
}
