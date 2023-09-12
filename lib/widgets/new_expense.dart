// @author: Amir Armion
// @version: V.01

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense(this.addExpense, {super.key});

  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category? _selectedCategory;

  // Always we have to dispose the controller we have created (when widget is not needed it anymore)
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _datePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year - 1,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime.now(),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

// Showing Dialog based on the platform
  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: const Text('Invalid Input!'),
            content: const Text(
                'Please make sure a valid "Title", "Amount", "Date", and "Category" was entered!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Closing the dialog
                },
                child: const Text('Okay!'),
              )
            ],
          );
        },
      );
    } else if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input!'),
            content: const Text(
                'Please make sure a valid "Title", "Amount", "Date", and "Category" was entered!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Closing the dialog
                },
                child: const Text('Okay!'),
              )
            ],
          );
        },
      );
    }
  }

  // Validate user's input
  void _submitExpenseData() {
    if ((_titleController.text.trim().isEmpty) ||
        (double.tryParse(_amountController.text) == null) ||
        (double.tryParse(_amountController.text)! <= 0) ||
        (_selectedDate == null) ||
        (_selectedCategory == null)) {
      _showDialog();
    } else {
      widget.addExpense(
        Expense(
            _titleController.text.trim(),
            double.tryParse(_amountController.text)!,
            _selectedDate!,
            _selectedCategory!),
      );

      Navigator.pop(context);

      return;
    }
  }

  @override
  Widget build(context) {
    // How much space occupied by keyboard in landscape mood
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity, // Taking whole screen height
        child: SingleChildScrollView(
          // Make scrollable when keyboard come up
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 25, 25, keyboardSpace + 20),
            child: Column(
              children: [
                // Landscape mode
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      )
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                // Landscape mode
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory, // Showing on screen
                        items: Category.values
                            .map(
                              (eachCategory) => DropdownMenuItem(
                                value: eachCategory,
                                child: Text(
                                    '${eachCategory.name[0].toUpperCase()}${eachCategory.name.substring(1)}'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (_selectedDate == null)
                                ? 'No date selected!'
                                : formatter.format(_selectedDate!).toString(),
                          ),
                          IconButton(
                            onPressed: _datePicker,
                            icon: const Icon(Icons.calendar_month),
                          )
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              (_selectedDate == null)
                                  ? 'No date selected!'
                                  : formatter.format(_selectedDate!).toString(),
                            ),
                            IconButton(
                              onPressed: _datePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 90,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                // Landscape mode
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Remove overlay from the screen
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory, // Showing on screen
                        items: Category.values
                            .map(
                              (eachCategory) => DropdownMenuItem(
                                value: eachCategory,
                                child: Text(
                                    '${eachCategory.name[0].toUpperCase()}${eachCategory.name.substring(1)}'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Remove overlay from the screen
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
