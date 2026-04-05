import 'package:flutter/material.dart';

/**
 * 【职教通】V2.0 - 教师认知干预大盘 (Task #122)
 * 职责：从单纯的“分数看板”升级为“认知处方库”，发现全班共通逻辑断层并分发一键强化包。
 */
class TeacherInterventionDashboardPage extends StatefulWidget {
  @override
  _TeacherInterventionDashboardState createState() => _TeacherInterventionDashboardState();
}

class _TeacherInterventionDashboardState extends State<TeacherInterventionDashboardPage> {
  final List<Map<String, dynamic>> _interventionList = [
    {
      "concept": "分式通分逻辑断层 (Task #122)",
      "impact": "85% 全班均值下降",
      "prescription": "分发：【大白话】巧克力分配模型（30分钟强化包）",
      "status": "待分发"
    },
    {
      "concept": "电感频率阻抗模型",
      "impact": "20% 实操风险",
      "prescription": "分发：【时空扫描】逆变器逻辑演示",
      "status": "已介入"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('教师认知干预大盘')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('全班认知干预处方 (AI Prescriptions)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
            SizedBox(height: 10),
            Text('基于全班 AI 辅导轨迹生成的逻辑断层诊断', style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _interventionList.length,
                itemBuilder: (context, index) {
                  final item = _interventionList[index];
                  return Card(
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.blue[50]!)),
                    child: ListTile(
                      title: Text(item['concept'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${item['impact']} -> ${item['prescription']}', style: TextStyle(fontSize: 12)),
                      ),
                      trailing: ElevatedButton(
                        onPressed: item['status'] == '待分发' ? () {
                          setState(() {
                            item['status'] = '已分发';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('干预强化包已推送到全班学生端！')));
                        } : null,
                        child: Text(item['status']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: item['status'] == '待分发' ? Colors.orange : Colors.grey[400],
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
