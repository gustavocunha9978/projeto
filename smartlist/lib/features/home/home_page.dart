import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'list_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomeTab(),
    HistoryTab(),
    SettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Map<String, dynamic>> lists = [];

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _saveLists() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(lists);
    await prefs.setString('lists', data);
  }

  Future<void> _loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('lists');
    if (data != null) {
      setState(() {
        lists = List<Map<String, dynamic>>.from(jsonDecode(data));
      });
    }
  }

  void _addNewList() async {
    final TextEditingController controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New List'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'List name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        lists.add({
          'name': result.trim(),
          'date': DateTime.now().toIso8601String(),
        });
      });
      await _saveLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartList'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue[50],
              child: ListTile(
                leading: Icon(Icons.add, size: 40, color: Colors.blue),
                title: Text('New List', style: TextStyle(fontSize: 22)),
                onTap: _addNewList,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (lists.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text('No lists yet.'),
              )
            else
              ...lists.map(
                (list) => Card(
                  child: ListTile(
                    leading: Icon(Icons.list_alt),
                    title: Text(list['name']),
                    subtitle: Text(
                      (() {
                        final date = DateTime.tryParse(list['date'] ?? '');
                        if (date != null) {
                          return '${date.day}/${date.month}/${date.year}';
                        }
                        return '';
                      })(),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListDetailPage(listName: list['name']),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('No history yet.')),
    );
  }
}

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool enableSuggestions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable Suggestions'),
              value: enableSuggestions,
              onChanged: (value) {
                setState(() {
                  enableSuggestions = value;
                });
              },
            ),
            ListTile(
              title: const Text('Reminder'),
              subtitle: const Text('7 days without buying'),
              trailing: Icon(Icons.notifications),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
