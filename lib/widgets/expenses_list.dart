import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/main.dart';
import 'package:my_expense_tracker_app/models/expense.dart';
import 'package:my_expense_tracker_app/providers/all_expenses_provider.dart';
import 'package:my_expense_tracker_app/widgets/expense_card.dart';

class ExpensesList extends ConsumerWidget {
  const ExpensesList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Expense> allExpenses = ref.watch(allExpensesProvider);
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Dismissible(
          key: ValueKey(allExpenses[index]),
          background: Container(
            decoration: BoxDecoration(
              color: kColorScheme.error.withOpacity(0.5),
              borderRadius: BorderRadius.circular(9),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal,
            ),
          ),
          onDismissed: (direction) {
            ref
                .read(allExpensesProvider.notifier)
                .deleteExpense(allExpenses[index], context);
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
