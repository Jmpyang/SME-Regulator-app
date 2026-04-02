import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderProvider>().loadReminders();
    });
  }

  void _addReminder() {
    showDialog(
      context: context,
      builder: (context) {
        final titleCtrl = TextEditingController();
        final descCtrl = TextEditingController();
        return AlertDialog(
          title: const Text('New Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<ReminderProvider>().addReminder({
                  'title': titleCtrl.text,
                  'description': descCtrl.text,
                  'due_date': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
                  'completed': false,
                });
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: provider.isLoading && provider.reminders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.loadReminders,
              child: ListView.builder(
                itemCount: provider.reminders.length,
                itemBuilder: (context, index) {
                  final rem = provider.reminders[index];
                  return ListTile(
                    leading: Checkbox(
                      value: rem.completed,
                      onChanged: (val) {
                        if (val == true) {
                          context.read<ReminderProvider>().markAsCompleted(rem.id);
                        }
                      },
                    ),
                    title: Text(
                      rem.title,
                      style: TextStyle(
                        decoration: rem.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text('${rem.description}\ntry: ${rem.dueDate.toLocal().toString().split(' ')[0]}'),
                    isThreeLine: true,
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
