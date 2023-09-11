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

  // Validate user's input
  void _submitExpenseData() {
    if ((_titleController.text.trim().isEmpty) ||
        (double.tryParse(_amountController.text) == null) ||
        (double.tryParse(_amountController.text)! <= 0) ||
        (_selectedDate == null) ||
        (_selectedCategory == null)) {
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
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
              const SizedBox(
                width: 20,
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
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
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
                  Navigator.pop(context); // Remove overlay from the screen
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
    );
  }
}
