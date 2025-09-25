import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  Future<String> getRawStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('time_entries') ?? '[]';
  }


  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('time_entries');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _entries = decoded.map((e) => TimeEntry(
        id: e['id'],
        projectId: e['projectId'],
        taskId: e['taskId'],
        totalTime: (e['totalTime'] as num).toDouble(),
        date: DateTime.parse(e['date']),
        notes: e['notes'],
      )).toList();
    }
    notifyListeners();
  }

  Future<void> addTimeEntry(TimeEntry entry) async {
    _entries.add(entry);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> deleteTimeEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _entries.map((e) => {
      'id': e.id,
      'projectId': e.projectId,
      'taskId': e.taskId,
      'totalTime': e.totalTime,
      'date': e.date.toIso8601String(),
      'notes': e.notes,
    }).toList();
    prefs.setString('time_entries', jsonEncode(data));
  }
}
