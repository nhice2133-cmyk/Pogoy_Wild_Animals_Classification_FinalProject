import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scan_history_service.dart';
import 'report_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final ScanHistoryService _historyService = ScanHistoryService();
  final ReportService _reportService = ReportService();

  List<ScanResult> _history = [];
  Map<String, int> _animalCounts = {};
  bool _isLoading = true;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final history = await _historyService.getHistory();
    final counts = <String, int>{};

    for (var result in history) {
      counts[result.animalName] = (counts[result.animalName] ?? 0) + 1;
    }

    setState(() {
      _history = history;
      _animalCounts = counts;
      _isLoading = false;
    });
  }

  Future<void> _exportReport() async {
    if (_history.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to export')),
      );
      return;
    }

    await _reportService.generateAndPrintReport(_history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Statistics',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A1A1A), Color(0xFF263238)],
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _animalCounts.isEmpty
                  ? Center(
                      child: Text(
                        'No data available',
                        style: GoogleFonts.poppins(color: Colors.white54),
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 100),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        _touchedIndex = -1;
                                        return;
                                      }
                                      _touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                sections: _showingSections(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildLegend(),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: ElevatedButton.icon(
                            onPressed: _exportReport,
                            icon: const Icon(Icons.picture_as_pdf),
                            label: Text('Export PDF Report',
                                style: GoogleFonts.poppins()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.tealAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.cyan,
      Colors.pink,
    ];

    int i = 0;
    return _animalCounts.entries.map((entry) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = colors[i % colors.length];
      i++;

      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${((entry.value / _history.length) * 100).toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.cyan,
      Colors.pink,
    ];

    int i = 0;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: _animalCounts.entries.map((entry) {
        final color = colors[i % colors.length];
        i++;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              entry.key,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(width: 4),
            Text(
              '(${entry.value})',
              style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}
