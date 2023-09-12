// @author: Amir Armion
// @version: V.01

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

// Human readable date format
final formatter = DateFormat.yMd();

// Unique ID Creator
const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense(
    this.title,
    this.amount,
    this.date,
    this.category,
  ) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  // Constructor
  const ExpenseBucket(this.category, this.expenses);

  // Alternative Constructor
  ExpenseBucket.forCategory(this.category, List<Expense> allExpenses)
      : expenses = allExpenses
            .where((expense) => (expense.category == category))
            .toList();

  final Category category;
  final List<Expense> expenses;

  // Getter
  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
