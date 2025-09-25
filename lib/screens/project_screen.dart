import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';

class ProjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Projects')),
      body: provider.projects.isEmpty
          ? Center(child: Text('No projects yet.'))
          : ListView.builder(
        itemCount: provider.projects.length,
        itemBuilder: (context, index) {
          final project = provider.projects[index];
          return ListTile(
            title: Text(project.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                provider.deleteProject(project.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProjectDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    final _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Project'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Project name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                Provider.of<ProjectProvider>(context, listen: false).addProject(
                  Project(
                    id: DateTime.now().toString(),
                    name: _controller.text,
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
