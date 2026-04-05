import 'package:flutter/material.dart';
import '../state/app_state_notifier.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: globalStateNotifier,
      builder: (context, _) {
        final progress = globalStateNotifier.progress;
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildUserCard(progress)),
              SliverToBoxAdapter(child: _buildAchievementMedals(progress)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('核心竞争力档案', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      _buildProfileItem(Icons.track_changes, "目标分达成率", "当前进度：${((progress.currentScore / progress.targetScore) * 100).toInt()}%"),
                      _buildProfileItem(Icons.trending_up, "提分斜率", "近 7 天提分速度：${progress.improvementRate}"),
                      _buildProfileItem(Icons.verified_user, "学籍认证", "已验证：深圳一职 · 电子信息工程"),
                      _buildProfileItem(Icons.history, "辅导记录", "累计启发辅导 128 次"),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: OutlinedButton(onPressed: () {}, child: Text('退出登录', style: TextStyle(color: Colors.red))),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Widget _buildUserCard(dynamic progress) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 80, 25, 40),
      decoration: BoxDecoration(color: Color(0xFF1D4E89).withOpacity(0.05)),
      child: Row(
        children: [
          CircleAvatar(radius: 40, backgroundColor: Color(0xFF1D4E89), child: Icon(Icons.person, size: 50, color: Colors.white)),
          SizedBox(width: 25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('林同学', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('目标：${progress.targetScore.toInt()} 分 · 超越全省 ${progress.nationalPercentile}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAchievementMedals(dynamic progress) {
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('我的职场勋章', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: progress.medals.map<Widget>((m) => _buildMedal(m)).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildMedal(String label) {
    return Column(
      children: [
        Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.orange[50], shape: BoxShape.circle), child: Icon(Icons.workspace_premium, color: Colors.orange, size: 30)),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.orange[900])),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF1D4E89), size: 24),
          SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold)), Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey))])),
          Icon(Icons.chevron_right, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
