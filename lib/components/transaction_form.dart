import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_date_picker.dart';
import 'package:expenses/components/adaptative_textfield.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;
  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}


class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title  = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Padding (
        padding: const EdgeInsets.all(10),
        child: Column(
        children: [
          AdaptativeTextfield(
            label: 'Título',
            controller: _titleController,
            onSubmitted: (_) => _submitForm(),
          ),
          AdaptativeTextfield(
            label: 'Valor (R\$)',
            controller: _valueController,
            onSubmitted: (_) => _submitForm(),
          ),
          AdaptativeDatePicker(
            selectedDate: _selectedDate, 
            onDateChanged: (newDate) {
              setState(() {
                _selectedDate = newDate;
              });
            },
          ),
          AdaptativeButton(label: 'Nova Transação', onPressed:  _submitForm)
        ],
        )
      ),
    ]);
  }
}