import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container (
      height: 500,
      child: transactions.isEmpty ? 
      Padding(padding:  EdgeInsets.all(20), child: 
      Column(
        children: [
          Text(
            'Nenhuma Transação Cadastrada!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 200,
            child: Image.asset(
              'assets/images/not-list.webp',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),) : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctxt, index) {
        final tr = transactions[index];
          return Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: FittedBox(
                  child: Text('R\$ ${tr.value.toStringAsFixed(2)}'),
                ),
              ),
            ),
            title: Text(
              tr.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              DateFormat('d MMM y').format(tr.date),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        );
      })
    );
  }
}