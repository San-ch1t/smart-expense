import 'package:flutter/material.dart';
import '../models/category.dart';
import 'expenses_calendar_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Category> categories = [
    Category(id: '1', name: 'Food', isEssential: true),
    Category(id: '2', name: 'Transport', isEssential: false),
    Category(id: '3', name: 'Entertainment', isEssential: false),
  ];

  void addCategory(String name, bool isEssential) {
    setState(() {
      categories.add(
        Category(
          id: DateTime.now().toString(),
          name: name,
          isEssential: isEssential,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          final category = categories[index];

          return ListTile(
            leading: Icon(
              category.isEssential ? Icons.star : Icons.category,
              color: category.isEssential ? Colors.orange : null,
            ),
            title: Text(category.name),
            subtitle: Text(
              category.isEssential ? 'Essential' : 'Non-essential',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ExpensesCalendarScreen(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    bool isEssential = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: const Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: 'Category name'),
              ),
              const SizedBox(height: 16),
              RadioListTile<bool>(
                title: const Text('Essential'),
                value: true,
                groupValue: isEssential,
                onChanged: (value) =>
                    setModalState(() => isEssential = value!),
              ),
              RadioListTile<bool>(
                title: const Text('Non-essential'),
                value: false,
                groupValue: isEssential,
                onChanged: (value) =>
                    setModalState(() => isEssential = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                addCategory(nameController.text.trim(), isEssential);
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
