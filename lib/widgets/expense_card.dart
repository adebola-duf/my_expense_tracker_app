import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/models/expense.dart';
import 'package:my_expense_tracker_app/widgets/new_expense_form_modal_sheet.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
  });

  final Expense expense;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    expense.description,
                    style: Theme.of(context).textTheme.titleLarge
                    // .copyWith(backgroundColor: Colors.yellow),,
                    ,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return NewExpenseForm(
                            expenseToBeEdited: expense,
                          );
                        },
                        isScrollControlled: true,
                      );
                    },
                    icon: const Icon(Icons.edit)),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  "₦${expense.amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Icon(expense.expenseIcon),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  format.format(expense.dateOfExpense),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
