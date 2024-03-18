import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/models/expense.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({super.key, required this.expense});

  final Expense expense;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: const Color.fromARGB(255, 213, 192, 250),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.description,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Text(
                    "\$${expense.amount.toString()}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(
                      width: 20,
                    ),
                  ),
                  Icon(expense.expenseIcon),
                  Text(
                    expense.creationDate,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
