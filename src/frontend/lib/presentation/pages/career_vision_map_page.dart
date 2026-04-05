import 'package:flutter/material.dart';

/**
 * 【职教通】V2.0 - 职业全景认知图谱 (Task #121)
 * 职责：展示知识点在真实职场场景（大疆、比亚迪）中的应用位置。
 */
class CareerVisionMapPage extends StatelessWidget {
  final String knowledgePoint;
  
  CareerVisionMapPage({required this.knowledgePoint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('职业全景图谱')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&q=80&w=2070'),
            fit: BoxFit.cover,
            colorFilter: ColorScheme.fromSeed(seedColor: Colors.blue).brightness == Brightness.light ? ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken) : null,
          ),
        ),
        child: Stack(
          children: [
            _buildContextOverlay(),
            _buildKnowledgeNode(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContextOverlay() {
    return Positioned(
      top: 100,
      left: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('当前场景：比亚迪 E-Platform 3.0 电控系统', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('知识点关联：$knowledgePoint -> 逆变器频率调制', style: TextStyle(color: Colors.blue[200], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildKnowledgeNode(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 4),
              boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)],
            ),
            child: Icon(Icons.bolt, size: 50, color: Colors.blue[800]),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text('核心逻辑：正弦波脉宽调制 (SPWM)', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('返回实战辅导'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
