import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  final String title;
  final VoidCallback onDelete;

  const ItemTile({super.key, required this.title, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
