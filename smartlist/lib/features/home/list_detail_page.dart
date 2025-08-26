import 'package:flutter/material.dart';

class ListDetailPage extends StatefulWidget {
  final String listName;

  const ListDetailPage({super.key, required this.listName});

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  final List<String> items = [];
  final TextEditingController controller = TextEditingController();

  void _addItem() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        items.add(text);
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listName),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Add item na lista'),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addItem),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('No items yet.'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) => CheckboxListTile(
                        value: false,
                        onChanged: (_) {},
                        title: Text(items[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
