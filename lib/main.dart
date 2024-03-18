import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/widgets/expenses_app.dart';

void main() {
  runApp(
    const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ExpensesApp()
  ),);
}
