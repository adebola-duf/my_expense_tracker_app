import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/main.dart';
import 'package:my_expense_tracker_app/models/expense.dart';
import 'package:my_expense_tracker_app/widgets/expense_card.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {required this.onExpenseDismissed, required this.allExpenses, super.key});

  final void Function(Expense) onExpenseDismissed;
  final List<Expense> allExpenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Dismissible(
          key: ValueKey(allExpenses[index]),
          background: Container(
            decoration: BoxDecoration(
              color: kColorScheme.error.withOpacity(0.7),
              borderRadius: BorderRadius.circular(9),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal,
            ),
          ),
          onDismissed: (direction) {
            onExpenseDismissed(allExpenses[index]);
          },
          child: ExpenseCard(
            expense: allExpenses[index],
          ),
        );
      },
      itemCount: allExpenses.length,
    );
  }
}
