import 'dart:io';
import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

main() {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  ExpensesApp({super.key});
  final ThemeData tema = ThemeData();
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        fontFamily: 'OpenSans',
        useMaterial3: false,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          primary: Colors.green,
          secondary: Colors.green,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          titleMedium: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            color: Colors.black,
          ),
          labelLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'), // Portuguese, Brazil
        const Locale('en', 'US'), // English, United States
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

   _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      builder: (_) {
        return TransactionForm(_addTransaction);
      }
    );
  }

  Widget _getIconButton(IconData icon, VoidCallback fn) {
    return Platform.isIOS ? GestureDetector(
      onTap: fn,
      child: Icon(icon),
    ) : IconButton(
      onPressed: fn,
      icon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandescape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    final iconList = Platform.isIOS ? CupertinoIcons.list_dash : Icons.list;
    final iconChart = Platform.isIOS ? CupertinoIcons.chart_bar : Icons.show_chart;
    
    final PreferredSizeWidget appBar = Platform.isIOS ? CupertinoNavigationBar(
        middle: Text('Despesas Pessoais'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(isLandescape)
            _getIconButton(
              _showChart ? iconList : iconChart, 
              () {
                setState(() {
                  _showChart = !_showChart;
                });
              }
            ),
            _getIconButton(Platform.isIOS ? CupertinoIcons.add : Icons.add, () => _openTransactionFormModal(context)),
          ],
        ),
      ) : AppBar(
      title: const Text(
        'Despesas Pessoais', 
        style: TextStyle(
          fontSize: 28, 
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      ),
      actions: [
          if(isLandescape)
          IconButton(
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            }, 
            icon: Icon(_showChart ? Icons.list : Icons.show_chart, color: Colors.white),
          ),
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: Icon(Icons.add, color: Colors.white),
          )
        ],
    );  
    final availablelHeight = MediaQuery.of(context).size.height - 
    appBar.preferredSize.height - MediaQuery.of(context).padding.top;


    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(_showChart || !isLandescape) 
            Container(
              height: availablelHeight * (isLandescape ? 0.7 : 0.3),
              child: Chart(_recentTransactions)
            ),
            if(!_showChart || !isLandescape) 
            Container(
              height: availablelHeight * (isLandescape ? 1 : 0.7),
              child: TransactionList(_transactions, _deleteTransaction),
            ),
          ],
        ),
      ),
    );


    return Platform.isIOS ? CupertinoPageScaffold(
      navigationBar: appBar as ObstructingPreferredSizeWidget,
      child: bodyPage,
      ) : Scaffold(
      appBar: appBar,
      body: bodyPage,
      floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
    );
  }
}