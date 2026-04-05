import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import '../../data/repositories/learning_repository.dart';
import 'career_vision_map_page.dart';

class AITutorProcessingScreen extends StatefulWidget {
  final String imagePath;
  AITutorProcessingScreen({required this.imagePath});
  @override
  _AITutorProcessingScreenState createState() => _AITutorProcessingScreenState();
}

class _AITutorProcessingScreenState extends State<AITutorProcessingScreen> {
  bool _isAnalyzing = true;
  String _statusText = '正在初始化 AI 诊断引擎...';
  bool _isVoiceOn = true;
  double _currentStage = 0; // 0: Analyzing, 1: Intent, 1.5: Probe, 2: Traceability, 3: Guidance
  Map<String, dynamic>? _matchedNode;
  String? _probeAnswer;
  bool _probeFailed = false;

  @override
  void initState() { 
    super.initState(); 
    _startDeepAnalysis(); 
  }

  void _startDeepAnalysis() {
    setState(() {
      _statusText = '正在进行笔迹增强与降噪 (Task #119)...';
    });
    
    Timer(Duration(seconds: 2), () {
      setState(() {
        _statusText = '正在进行 FTS 本地特征匹配 (Task #110)...';
      });
      
      Timer(Duration(seconds: 2), () {
        setState(() {
          // Task #115 认知防火墙：探测题已准备好
          _matchedNode = {
            "title": "三角函数诱导公式",
            "root": "相似三角形比例性质",
            "probe": {
              "q": "在进入正题前，AI 先考考你：sin(30°) 的值是多少？",
              "options": ["1/2", "√3/2", "1"],
              "ans": "1/2",
              "fail": "看来基础值还有些模糊，我们先用‘影长模型’把基础认知补回来。"
            },
            "mentalModel": "思维模型：第一性原理 —— 与其死记公式，不如回到‘圆周运动影子变化’这个物理底层。",
            "refutationTip": "【归谬引导】如果你觉得这里的符号应该是正号，那我们可以反过来想：如果在第三象限纵坐标是正的，那圆周运动岂不是跑出地球了？"
          };
          _isAnalyzing = false;
          _currentStage = 1;
          if (_isVoiceOn) _playVoiceStep(1);
        });
      });
    });
  }

  void _playVoiceStep(int stage) {
    debugPrint("【AI 语音流式分发】正在播报第 $stage 阶段内容...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI 启发式辅导内核'),
        actions: [
          IconButton(
            icon: Icon(_isVoiceOn ? Icons.volume_up : Icons.volume_off),
            onPressed: () => setState(() => _isVoiceOn = !_isVoiceOn),
          )
        ],
      ),
      body: Column(
        children: [
          _buildHeroSection(),
          Expanded(child: _buildInteractionArea()),
          _buildBottomControl(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          Image.file(File(widget.imagePath), fit: BoxFit.cover, width: double.infinity),
          if (_isAnalyzing)
            Container(
              color: Colors.blue.withOpacity(0.3),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(_statusText, style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInteractionArea() {
    if (_isAnalyzing) return SizedBox.shrink();

    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentStage >= 1) _buildStageIntent(),
          if (_currentStage == 1.5) _buildStageProbe(),
          if (_currentStage >= 2) _buildStageTraceability(),
          if (_currentStage >= 3) _buildStageGuidance(),
        ],
      ),
    );
  }

  Widget _buildStageIntent() {
    return _buildBubble(
      title: "【第一段：读题确认】",
      content: "检测到题目属于《${_matchedNode?['title']}》。这道题的核心是要求“诱导公式下的三角函数值”，对吗？",
      color: Colors.blue[50]!,
      icon: Icons.search_outlined,
    );
  }

  Widget _buildStageProbe() {
    var probe = _matchedNode?['probe'];
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.purple[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.purple[100]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(Icons.shield_outlined, size: 16, color: Colors.purple), SizedBox(width: 8), Text("【认知防火墙：概念探查】", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple))]),
          SizedBox(height: 15),
          Text(probe['q'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          ...List.generate(3, (i) {
            String opt = probe['options'][i];
            bool isSelected = _probeAnswer == opt;
            return RadioListTile(
              title: Text(opt),
              value: opt,
              groupValue: _probeAnswer,
              onChanged: (val) => setState(() => _probeAnswer = val.toString()),
            );
          }),
          if (_probeFailed)
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(probe['fail'], style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildStageTraceability() {
    return _buildBubble(
      title: "【第二段：认知溯源】",
      content: "系统分析发现，你在这道题卡壳的根源是《${_matchedNode?['root']}》概念未打通。我们需要先从底层逻辑开始热身。",
      color: Colors.orange[50]!,
      icon: Icons.history_edu,
    );
  }

  Widget _buildStageGuidance() {
    return Column(
      children: [
        _buildBubble(
          title: "【第三段：大白话引导】",
          content: "想象你在一个时钟的 3 点方向（30°），如果你继续转到 7 点方向（210°），你离地面（x轴）的高度是不是正好和之前相反了？所以...",
          color: Colors.green[50]!,
          icon: Icons.lightbulb_outline,
        ),
        if (_matchedNode?['refutationTip'] != null)
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red[100]!)),
            child: Row(
              children: [
                Icon(Icons.psychology_alt, color: Colors.red[800], size: 20),
                SizedBox(width: 10),
                Expanded(child: Text(_matchedNode?['refutationTip'], style: TextStyle(fontSize: 13, color: Colors.red[900], fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
          child: Text(_matchedNode?['mentalModel'], style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.blueGrey)),
        ),
        SizedBox(height: 15),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CareerVisionMapPage(knowledgePoint: _matchedNode?['title']))),
          icon: Icon(Icons.map, size: 16),
          label: Text('查看该知识点的职业全景图谱 (Task #121)', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue[800]),
        ),
      ],
    );
  }

  Widget _buildBubble({required String title, required String content, required Color color, required IconData icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 16, color: Colors.black54), SizedBox(width: 8), Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54))]),
          SizedBox(height: 10),
          Text(content, style: TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildBottomControl() {
    if (_isAnalyzing) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (_currentStage == 1) {
              setState(() => _currentStage = 1.5);
            } else if (_currentStage == 1.5) {
              _handleProbe();
            } else if (_currentStage < 3) {
              setState(() => _currentStage++);
            } else {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1D4E89), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text(_currentStage == 1 ? '确认意图' : (_currentStage == 1.5 ? '提交探查' : (_currentStage < 3 ? '我听懂了，进行下一步' : '已掌握知识点，返回首页'))),
        ),
      ),
    );
  }

  void _handleProbe() {
    var probe = _matchedNode?['probe'];
    if (_probeAnswer == probe['ans']) {
      setState(() {
        _currentStage = 2;
        _probeFailed = false;
      });
    } else {
      setState(() {
        _probeFailed = true;
        // 强制进入降维模式
      });
      // 延迟 2 秒后强制进入引导（模拟降维逻辑触发）
      Timer(Duration(seconds: 2), () {
        setState(() => _currentStage = 2);
      });
    }
  }
}
