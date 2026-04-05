import 'package:flutter/material.dart';
import '../state/app_state_notifier.dart';

class LearningReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: globalStateNotifier,
      builder: (context, _) {
        final progress = globalStateNotifier.progress;
        return Scaffold(
          appBar: AppBar(title: Text('提分学情报告')),
          body: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1D4E89), Color(0xFF3B82F6)]), borderRadius: BorderRadius.circular(25)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _buildStat("预估分", "${progress.currentScore.toInt()}"),
                  _buildStat("超越率", "${progress.nationalPercentile}"),
                  _buildStat("提分率", "${progress.improvementRate}"),
                ]),
              ),
              SizedBox(height: 30),
              Text('最近考场成绩 (DB 实时同步)', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              ...progress.examHistory.map<Widget>((e) => ListTile(title: Text(e.title), subtitle: Text(e.date), trailing: Text('${e.score}分', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)))).toList(),
            ],
          ),
        );
      }
    );
  }

  Widget _buildStat(String label, String val) {
    return Column(children: [Text(val, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text(label, style: TextStyle(color: Colors.white70, fontSize: 11))]);
  }
}
