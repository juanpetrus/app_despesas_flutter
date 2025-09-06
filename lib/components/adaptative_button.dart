import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed; 

  AdaptativeButton({
    this.label = 'Nova Transação',
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoButton(
      child: Text(label),
      onPressed: onPressed,
    ) : ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}