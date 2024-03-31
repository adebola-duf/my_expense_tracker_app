import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Category { flex, travel, work, food }

var format = DateFormat.yMd();
const categoryIcons = {
  Category.flex: Icons.movie,
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.dateOfExpense,
  }) : expenseIcon = categoryIcons[category]!;

  final DateTime id;
  final DateTime dateOfExpense;
  final double amount;
  final Category category;
  final String description;

  final IconData expenseIcon;
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.forCategory(
      {required List<Expense> allExpenses, required this.category})
      : expenses = allExpenses
            .where((eachExpense) => eachExpense.category == category)
            .toList();

  double get totalExpenses {
    double sum = 0;

    for (Expense eachExpense in expenses) {
      sum += eachExpense.amount;
    }
    return sum;
  }
}
