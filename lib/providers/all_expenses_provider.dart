import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/models/expense.dart';
import 'package:http/http.dart' as http;

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

    final url = Uri.http('localhost:8000', '/get-expenses');
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

  void setAllExpenses(List<dynamic> allExpensesMap) {
    final List<Expense> allExpenses = [];

    for (final expenseMap in allExpensesMap) {
      allExpenses.add(
        Expense(
          description: expenseMap['description'],
          amount: expenseMap['amount'],
          category: whichCategory(expenseMap['category_name']),
          dateOfExpense: DateTime.parse(expenseMap['expense_date']),
        ),
      );
    }
    state = allExpenses;
  }
}

Category whichCategory(String categoryName) {
  if (categoryName == Category.flex.name) {
    return Category.flex;
  } else if (categoryName == Category.food.name) {
    return Category.food;
  } else if (categoryName == Category.work.name) {
    return Category.work;
  } else {
    return Category.travel;
  }
}

final allExpensesProvider =
    StateNotifierProvider<AllExpensesNotifier, List<Expense>>(
  (ref) => AllExpensesNotifier(),
);
