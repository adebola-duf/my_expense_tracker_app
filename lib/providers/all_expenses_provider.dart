import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/models/expense.dart';

class AllExpensesNotifier extends StateNotifier<List<Expense>> {
  AllExpensesNotifier() : super([]);

  void editExpense({required Expense oldExpense, required Expense newExpense}) {
    int indexOfExpense = state.indexOf(oldExpense);

    var tempAllExpense = [...state];
    tempAllExpense[indexOfExpense] = newExpense;
    state = tempAllExpense;
  }

  void createExpense(expense) {
    state = [...state, expense];
  }

  void deleteExpense(Expense expense, BuildContext context) {
    int expenseIndex = state.indexOf(expense);
    var tempState = [...state];
    tempState.remove(expense);
    state = tempState;

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
            undoDeletingExpense(expense, expenseIndex);
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

  void undoDeletingExpense(Expense expense, int expenseIndex) {
    List<Expense> tempState = [...state];
    tempState.insert(expenseIndex, expense);
    state = tempState;
  }

}

final allExpensesProvider =
    StateNotifierProvider<AllExpensesNotifier, List<Expense>>(
  (ref) => AllExpensesNotifier(),
);
