import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/main.dart';
import 'package:my_expense_tracker_app/models/expense.dart';
import 'package:my_expense_tracker_app/providers/all_expenses_provider.dart';
import 'package:my_expense_tracker_app/providers/user_info_provider.dart';
import 'package:my_expense_tracker_app/widgets/expense_card.dart';
import 'package:http/http.dart' as http;

class ExpensesList extends ConsumerWidget {
  const ExpensesList({
    super.key,
  });

  void _sendDeleteExpenseRequest(DateTime expenseId) async {
    final url =
        Uri.http('localhost:8000', '/delete-expense/${expenseId.toString()}');
    await http.delete(url);
  }

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
            _sendDeleteExpenseRequest(allExpenses[index].id);
            ref.read(allExpensesProvider.notifier).deleteExpense(
                allExpenses[index], context, ref.watch(userInfoProvider).email);
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
