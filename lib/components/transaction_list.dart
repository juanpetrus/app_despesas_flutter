import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;
  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Container (
      height: MediaQuery.of(context).size.height * 0.7,
      child: transactions.isEmpty ? LayoutBuilder(builder:  (cxt, constraints) {
        return Padding(
        padding:  EdgeInsets.all(20), 
        child: 
          Column(
            children: [
              Text(
                'Nenhuma Transação Cadastrada!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: constraints.maxHeight * 0.05,
              ),
              Container(
                height: constraints.maxHeight * 0.6,
                child: Image.asset(
                  'assets/images/not-list.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      }) : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctxt, index) {
        final tr = transactions[index];
          return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: FittedBox(
                  child: Text('R\$ ${tr.value.toStringAsFixed(2)}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
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
              DateFormat('d MMMM y', 'pt-br').format(tr.date),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: MediaQuery.of(context).size.width > 400 ?
            ElevatedButton.icon(
              onPressed: () => onRemove(tr.id), 
              icon: Icon(Icons.delete), 
              label: Text('Excluir'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            )
            : IconButton(
              icon: Icon(Icons.delete), 
              color: Theme.of(context).colorScheme.error,
              onPressed: () => onRemove(tr.id),
            ),
          ),
        );
      })
    );
  }
}