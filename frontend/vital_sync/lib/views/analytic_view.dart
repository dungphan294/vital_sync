import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticView extends StatelessWidget {
  final dynamic apiData;

  const AnalyticView({super.key, this.apiData});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = _convertDataToSpots(apiData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Rate Monitor'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()}s');
                  },
                ),
                axisNameWidget: const Text('Time (seconds)'),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()}');
                  },
                ),
                axisNameWidget: const Text('Heart Rate (BPM)'),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey, width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _convertDataToSpots(dynamic data) {
    if (data == null || data is! List) {
      return [FlSpot(0, 75), FlSpot(1, 80), FlSpot(2, 85), FlSpot(3, 90)];
    }

    List<FlSpot> spots = [];
    DateTime? baseTime;

    for (var item in data) {
      if (item is Map &&
          item.containsKey('heart_rate') &&
          item.containsKey('timestamp')) {
        double heartRate = (item['heart_rate'] ?? 0).toDouble();
        String timestampStr = item['timestamp'];

        try {
          DateTime currentTime = DateTime.parse(timestampStr);

          // Set base time from first entry
          baseTime ??= currentTime;

          // Calculate seconds from base time
          double secondsFromStart =
              currentTime.difference(baseTime!).inMilliseconds / 1000.0;
          spots.add(FlSpot(secondsFromStart, heartRate));
        } catch (e) {
          // Skip invalid timestamps
          continue;
        }
      }
    }

    // Return default data if no valid data found
    if (spots.isEmpty) {
      return [FlSpot(0, 75), FlSpot(1, 80), FlSpot(2, 85), FlSpot(3, 90)];
    }

    return spots;
  }
}
