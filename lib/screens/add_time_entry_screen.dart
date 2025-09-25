import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: projectId,
                decoration: InputDecoration(labelText: 'Project'),
                items: <String>['Project 1', 'Project 2', 'Project 3']
                    .map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    projectId = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a project' : null,
              ),
              DropdownButtonFormField<String>(
                value: taskId,
                decoration: InputDecoration(labelText: 'Task'),
                items: <String>['Task 1', 'Task 2', 'Task 3']
                    .map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    taskId = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a task' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                onSaved: (value) => notes = value ?? '',
              ),
              SizedBox(height: 20),

              /// ✅ Date picker button
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      date = picked;
                    });
                  }
                },
                child: Text('Select Date: ${date.toString().substring(0, 10)}'),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final entry = TimeEntry(
                      id: DateTime.now().toString(),
                      projectId: projectId!,
                      taskId: taskId!,
                      totalTime: totalTime,
                      date: date,
                      notes: notes,
                    );

                    Provider.of<TimeEntryProvider>(context, listen: false)
                        .addTimeEntry(entry);

                    Navigator.pop(context);
                  }
                },
                child: Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
