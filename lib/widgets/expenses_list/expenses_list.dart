import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpensesList extends StatelessWidget {
  // Constructor
  const ExpensesList(this.expenses, this.removeExpense, {super.key});

  final List<Expense> expenses;
  final void Function(Expense expense) removeExpense;

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.8),
          margin: Theme.of(context).cardTheme.margin,
          // margin: const EdgeInsets.fromLTRB(15, 7, 15, 7),
        ),
        onDismissed: (directions) {
          removeExpense(expenses[index]);
        },
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
