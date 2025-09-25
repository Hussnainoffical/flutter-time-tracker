import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../models/time_entry.dart';
import 'add_time_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context, listen: false);
    provider.loadEntries(); // Load saved entries

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Time Tracker'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Entries'),
              Tab(text: 'By Project'),
            ],
          ),
        ),

        // ✅ Drawer with Debug Storage option
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                title: Text('Projects'),
                onTap: () {
                  Navigator.pushNamed(context, '/projects');
                },
              ),
              ListTile(
                title: Text('Tasks'),
                onTap: () {
                  Navigator.pushNamed(context, '/tasks');
                },
              ),
              ListTile(
                title: Text('Debug Storage'),
                onTap: () {
                  Navigator.pushNamed(context, '/debug'); // ✅ opens debug screen
                },
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            _buildEntriesList(),
            _buildGroupedEntries(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddTimeEntryScreen()),
            );
          },
          child: Icon(Icons.add),
          tooltip: 'Add Time Entry',
        ),
      ),
    );
  }

  /// Tab 1: All Entries
  Widget _buildEntriesList() {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(child: Text('No time entries yet.'));
        }
        return ListView.builder(
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
            final entry = provider.entries[index];
            return ListTile(
              title: Text('${entry.projectId} - ${entry.totalTime} hrs'),
              subtitle: Text(
                '${entry.date.toString().substring(0, 10)} - Notes: ${entry.notes}',
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  provider.deleteTimeEntry(entry.id);
                },
              ),
            );
          },
        );
      },
    );
  }

  /// Tab 2: Grouped by Project
  Widget _buildGroupedEntries() {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(child: Text('No time entries to group.'));
        }

        final Map<String, List<TimeEntry>> grouped = {};
        for (var entry in provider.entries) {
          grouped.putIfAbsent(entry.projectId, () => []).add(entry);
        }

        return ListView(
          children: grouped.entries.map((group) {
            final totalHours = group.value.fold<double>(
              0.0,
                  (sum, item) => sum + item.totalTime,
            );
            return ListTile(
              title: Text('${group.key}'),
              subtitle: Text('Total: $totalHours hrs'),
            );
          }).toList(),
        );
      },
    );
  }
}
