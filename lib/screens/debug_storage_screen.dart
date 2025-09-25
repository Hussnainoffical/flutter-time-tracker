import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';

class DebugStorageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Local Storage Debug'),
      ),
      body: FutureBuilder(
        future: provider.getRawStorage(), // custom helper
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No storage data found.'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Text(
              snapshot.data.toString(),
              style: TextStyle(fontFamily: 'monospace'),
            ),
          );
        },
      ),
    );
  }
}
