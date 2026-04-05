import 'package:flutter/material.dart';
import 'dart:async';
import '../state/app_state_notifier.dart';

class ExamHallPage extends StatelessWidget {
  final List<Map<String, dynamic>> examList = [
    {"title": "2026 广东省 3+证书 数学 (A)", "time": 120, "score": 150, "id": "m1"},
    {"title": "2026 广东省 3+证书 英语 (B)", "time": 90, "score": 100, "id": "e1"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('全真模拟考场'), backgroundColor: Color(0xFF1D4E89), foregroundColor: Colors.white),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: examList.length,
        itemBuilder: (context, index) {
          var exam = examList[index];
          return Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!)),
            child: Row(
              children: [
                Icon(Icons.assignment, color: Color(0xFF1D4E89), size: 30),
                SizedBox(width: 15),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(exam['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text('${exam['time']}分钟 · 总分 ${exam['score']}', style: TextStyle(color: Colors.grey, fontSize: 11))])),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InteractiveExamScreen(exam: exam))), 
                  child: Text('开始考试')
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InteractiveExamScreen extends StatefulWidget {
  final Map<String, dynamic> exam;
  InteractiveExamScreen({required this.exam});
  @override
  _InteractiveExamScreenState createState() => _InteractiveExamScreenState();
}

class _InteractiveExamScreenState extends State<InteractiveExamScreen> {
  int _currentIndex = 0;
  Map<int, String> _userAnswers = {};
  late Timer _timer;
  int _secondsRemaining = 0;

  final List<Map<String, dynamic>> _questions = [
    {"q": "1. 下列函数中，在其定义域内为偶函数的是？", "options": ["A. y=x", "B. y=x^2", "C. y=sin x", "D. y=log x"], "ans": "B"},
    {"q": "2. 若 sin α = 4/5，且 α 为第二象限角，则 cos α = ?", "options": ["A. 3/5", "B. -3/5", "C. 4/5", "D. -4/5"], "ans": "B"},
    {"q": "3. 集合 A={1,2,3}, B={2,3,4}，则 A∪B = ?", "options": ["A. {2,3}", "B. {1,2,3,4}", "C. {1,4}", "D. ∅"], "ans": "B"},
  ];

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.exam['time'] * 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _submitExam();
      }
    });
  }

  void _submitExam() {
    _timer.cancel();
    int score = 0;
    int correctCount = 0;
    _userAnswers.forEach((index, ans) {
      if (ans == _questions[index]['ans']) {
        correctCount++;
      }
    });
    score = (correctCount / _questions.length * widget.exam['score']).toInt();
    globalStateNotifier.addExamResult(widget.exam['title'], score);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => Container(
        padding: EdgeInsets.all(30),
        height: 350,
        child: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 20),
            Text('考试结束', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('真实得分：$score 分', style: TextStyle(fontSize: 24, color: Color(0xFF1D4E89), fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('数据已同步至提分雷达与个人中心', style: TextStyle(color: Colors.grey)),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1D4E89), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 15)),
                child: Text('返回考场'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var q = _questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('计时中: ${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}'),
        actions: [
          TextButton(onPressed: _submitExam, child: Text('提交', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('第 ${_currentIndex + 1} / ${_questions.length} 题', style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 10),
            Text(q['q'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ...List.generate(4, (i) {
              String opt = q['options'][i];
              String code = opt.substring(0, 1);
              bool isSelected = _userAnswers[_currentIndex] == code;
              return GestureDetector(
                onTap: () => setState(() => _userAnswers[_currentIndex] = code),
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF1D4E89).withOpacity(0.05) : Colors.white,
                    border: Border.all(color: isSelected ? Color(0xFF1D4E89) : Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 12, backgroundColor: isSelected ? Color(0xFF1D4E89) : Colors.grey[100], child: Text(code, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black))),
                      SizedBox(width: 15),
                      Text(opt.substring(3), style: TextStyle(fontSize: 15, color: isSelected ? Color(0xFF1D4E89) : Colors.black)),
                    ],
                  ),
                ),
              );
            }),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0) OutlinedButton(onPressed: () => setState(() => _currentIndex--), child: Text('上一题')),
                if (_currentIndex < _questions.length - 1) ElevatedButton(onPressed: () => setState(() => _currentIndex++), child: Text('下一题')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
