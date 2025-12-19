import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScanResult {
  final String animalName;
  final double confidence;
  final DateTime timestamp;
  final String? imagePath;

  ScanResult({
    required this.animalName,
    required this.confidence,
    required this.timestamp,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'animalName': animalName,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      animalName: json['animalName'],
      confidence: json['confidence'],
      timestamp: DateTime.parse(json['timestamp']),
      imagePath: json['imagePath'],
    );
  }
}

class ScanHistoryService {
  static const String _historyKey = 'scan_history';

  Future<List<ScanResult>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_historyKey);

    if (historyJson == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(historyJson);
    return decoded.map((item) => ScanResult.fromJson(item)).toList();
  }

  Future<void> saveResult(ScanResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ScanResult> currentHistory = await getHistory();

    // Add new result to the beginning of the list
    currentHistory.insert(0, result);

    // Optional: Limit history size (e.g., keep last 50 scans)
    if (currentHistory.length > 50) {
      currentHistory.removeLast();
    }

    final String encoded =
        jsonEncode(currentHistory.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
