import 'package:flutter/material.dart';
import '../theme.dart';

class SchoolsManagePage extends StatelessWidget {
  const SchoolsManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final schools = [
      {'name': '深圳职业技术大学', 'location': '深圳市南山区', 'type': '公办', 'score': 312},
      {'name': '番禺职业技术学院', 'location': '广州市番禺区', 'type': '公办', 'score': 298},
      {'name': '广东轻工职业技术大学', 'location': '广州市海珠区', 'type': '公办', 'score': 285},
      {'name': '顺德职业技术学院', 'location': '佛山市顺德区', 'type': '公办', 'score': 276},
      {'name': '广东科学技术职业学院', 'location': '广州市天河区', 'type': '公办', 'score': 270},
      {'name': '广州城建职业学院', 'location': '广州市从化区', 'type': '民办', 'score': 195},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('院校管理'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('添加院校'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(120, 40)),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: AdminColors.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            itemCount: schools.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: AdminColors.divider),
            itemBuilder: (_, i) {
              final s = schools[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(s['name'] as String, style: const TextStyle(
                  fontWeight: FontWeight.w600, color: AdminColors.mainText)),
                subtitle: Text('${s['location']} · ${s['type']}',
                  style: const TextStyle(color: AdminColors.subText, fontSize: 13)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AdminColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${s['score']}分', style: const TextStyle(
                        fontWeight: FontWeight.w700, color: AdminColors.primary, fontSize: 14)),
                    ),
                    const SizedBox(width: 12),
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 20),
                      color: AdminColors.primary, onPressed: () {}),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 20),
                      color: AdminColors.danger, onPressed: () {}),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
