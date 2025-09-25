import 'package:flutter/material.dart';

class ProjectManagementScreen extends StatefulWidget {
  @override
  _ProjectManagementScreenState createState() => _ProjectManagementScreenState();
}

class _ProjectManagementScreenState extends State<ProjectManagementScreen> {
  List<String> projects = [];

  void _addProject(String name) {
    setState(() {
      projects.add(name);
    });
  }

  void _showAddDialog() {
    String newProject = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Project'),
        content: TextField(
          onChanged: (val) => newProject = val,
          decoration: InputDecoration(labelText: 'Project Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (newProject.isNotEmpty) _addProject(newProject);
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Projects')),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) => ListTile(title: Text(projects[index])),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
