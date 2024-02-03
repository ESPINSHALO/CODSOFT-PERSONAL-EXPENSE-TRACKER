import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class Transaction {
  final String title;
  final double amount;
  final String category;

  Transaction({required this.title, required this.amount, required this.category});
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Transaction> transactions = [];

  void addTransaction(String title, double amount, String category) {
    setState(() {
      transactions.add(Transaction(title: title, amount: amount, category: category));
    });
  }

  double getTotalExpense() {
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          TransactionForm(onAddTransaction: addTransaction),
          ExpenseSummary(transactions: transactions),
        ],
      ),
    );
  }
}

class TransactionForm extends StatefulWidget {
  final Function(String, double, String) onAddTransaction;

  TransactionForm({required this.onAddTransaction});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  void _submitForm() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final category = _categoryController.text;

    if (title.isEmpty || amount <= 0 || category.isEmpty) {
      return;
    }

    widget.onAddTransaction(title, amount, category);

    _titleController.clear();
    _amountController.clear();
    _categoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          TextField(
            controller: _categoryController,
            decoration: InputDecoration(labelText: 'Category'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Add Transaction'),
          ),
        ],
      ),
    );
  }
}

class ExpenseSummary extends StatelessWidget {
  final List<Transaction> transactions;

  ExpenseSummary({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Expense Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Total Expense: \$${getTotalExpense().toStringAsFixed(2)}'),
          // Add more summary information as needed
        ],
      ),
    );
  }

  double getTotalExpense() {
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }
}
