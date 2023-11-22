// @author: Amir Armion
// @version: V.01

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      "Flutter Course",
      19.99,
      DateTime.now(),
      Category.work,
    ),
    Expense(
      "Cinema",
      15.69,
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 3,
      ),
      Category.leisure,
    ),
    Expense(
      "Food",
      27,
      DateTime(
        DateTime.now().year,
        DateTime.now().month - 1,
        DateTime.now().day - 10,
      ),
      Category.food,
    ),
  ];

  // Showing an overlay
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(_addExpense);
      },
    );
  }

  // Adding a new expense
  void _addExpense(Expense newExpense) {
    // Using setState to update the UI after adding the new expense
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    // Using setState to update the UI after removing that expense
    setState(() {
      _registeredExpenses.remove(expense);
    });

    // Avoiding conflict snackbar
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense Deleted!'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    // Getting UI width size
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found! Start adding some...'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        _registeredExpenses,
        _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Tracker",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        actions: [
          Padding(
            padding: const EdgeInsets.all(7),
            child: IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(
                Icons.add,
                size: 28,
                weight: 400,
              ),
            ),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(_registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(_registeredExpenses),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
