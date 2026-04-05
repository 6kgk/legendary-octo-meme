import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../state/app_state_notifier.dart';
import 'ai_tutor_processing_screen.dart';
import 'mistake_book_page.dart';
import 'teacher_intervention_dashboard_page.dart';
import 'career_vision_map_page.dart';

class LearningHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: globalStateNotifier,
      builder: (context, _) {
        final progress = globalStateNotifier.progress;
        return CustomScrollView(
          slivers: [
            _buildHeader(progress),
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverList(delegate: SliverChildListDelegate([
                _buildScoreProgress(progress),
                SizedBox(height: 25),
                _buildSectionTitle("AI 推荐攻克点 (艾宾浩斯记忆路径)"),
                _buildRecommendationCard("正弦函数", "记忆已模糊，需紧急复习", "+8分"),
                _buildRecommendationCard("相似比性质", "掌握度较低，提分潜力大", "+5分"),
                SizedBox(height: 25),
                _buildSectionTitle("认知聚类错题本 (Ebbinghaus Plan)"),
                _buildFunctionalButton(context, "查看错题本与复习计划", Icons.book, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (context) => MistakeBookPage()))),
                SizedBox(height: 25),
                _buildAITutorEntrance(context),
                SizedBox(height: 25),
                _buildSectionTitle("教师干预与职业图谱"),
                _buildFunctionalButton(context, "教师认知干预大盘", Icons.dashboard_customize, Colors.indigo, () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherInterventionDashboardPage()))),
                SizedBox(height: 12),
                _buildFunctionalButton(context, "职业全景认知图谱", Icons.map, Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (context) => CareerVisionMapPage(knowledgePoint: "电控系统")))),
                SizedBox(height: 25),
                _buildSectionTitle("认知溯源记录"),
                ...progress.wrongQuestions.map<Widget>((q) => _buildWrongQuestionItem(q.title, q.root)).toList(),
              ])),
            ),
          ],
        );
      }
    );
  }

  Widget _buildRecommendationCard(String title, String reason, String gain) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.blue[100]!)),
      child: Row(
        children: [
          Icon(Icons.bolt, color: Colors.blue[800]),
          SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold)), Text(reason, style: TextStyle(fontSize: 11, color: Colors.blue[700]))])),
          Text(gain, style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic progress) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(25, 60, 25, 30),
        decoration: BoxDecoration(color: Color(0xFF1D4E89), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35))),
        child: Row(
          children: [
            CircleAvatar(radius: 25, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
            SizedBox(width: 15),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('你好, 林同学', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('深圳一职 · 电子信息工程', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreProgress(dynamic progress) {
    double percent = progress.currentScore / progress.targetScore;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('预估总分 (对标商用数据层)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
            Text('${progress.currentScore.toInt()} / ${progress.targetScore.toInt()}', style: TextStyle(color: Color(0xFF1D4E89), fontWeight: FontWeight.bold, fontSize: 20)),
          ]),
          SizedBox(height: 15),
          LinearPercentIndicator(lineHeight: 8.0, percent: percent > 1.0 ? 1.0 : percent, padding: EdgeInsets.zero, backgroundColor: Colors.grey[100]!, progressColor: Color(0xFF1D4E89), barRadius: Radius.circular(4), animation: true),
        ],
      ),
    );
  }

  Widget _buildAITutorEntrance(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AITutorProcessingScreen(imagePath: image.path)));
        }
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1D4E89), Color(0xFF1E3A8A)]), borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Color(0xFF1D4E89).withOpacity(0.3), blurRadius: 15, offset: Offset(0, 8))]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: Colors.white, size: 50),
            SizedBox(height: 10),
            Text('拍照搜题 · 认知溯源', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('商用级架构 · 异步加载闭环', style: TextStyle(color: Colors.white60, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(padding: EdgeInsets.only(bottom: 12), child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D4E89))));
  }

  Widget _buildWrongQuestionItem(String title, String reason) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates, color: Colors.orange[300]),
          SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), Text(reason, style: TextStyle(fontSize: 11, color: Colors.orange[400]))])),
          Icon(Icons.chevron_right, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildFunctionalButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: color.withOpacity(0.2))),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 15),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}
