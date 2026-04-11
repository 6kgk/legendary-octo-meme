import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/school_provider.dart';
import '../models/app_models.dart';
import '../theme.dart';

class SchoolSearchPage extends StatefulWidget {
  const SchoolSearchPage({super.key});

  @override
  State<SchoolSearchPage> createState() => _SchoolSearchPageState();
}

class _SchoolSearchPageState extends State<SchoolSearchPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<SchoolProvider>(context, listen: false).loadData());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SchoolProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: !provider.isLoaded
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('查校', style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.mainText)),
                      const SizedBox(height: 4),
                      const Text('广东高职院校信息大全', style: TextStyle(
                        fontSize: 14, color: AppColors.subText)),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (val) => provider.updateSearch(val),
                        decoration: InputDecoration(
                          hintText: '搜索院校、专业或地区...',
                          prefixIcon: const Icon(Icons.search_rounded, size: 22, color: AppColors.subText),
                          filled: true,
                          fillColor: AppColors.areaBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: ['全部', '公办', '民办'].map((type) {
                          final isSelected = provider.selectedType == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () => provider.updateFilter(type),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: isSelected ? AppColors.primaryGradient : null,
                                  color: isSelected ? null : AppColors.cardBg,
                                  borderRadius: BorderRadius.circular(24),
                                  border: isSelected ? null : Border.all(color: AppColors.divider),
                                ),
                                child: Text(type, style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.mainText)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Text('${provider.filteredSchools.length} 所院校',
                        style: const TextStyle(fontSize: 13, color: AppColors.subText)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: provider.filteredSchools.isEmpty
                    ? const Center(child: Text('未找到符合条件的院校'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: provider.filteredSchools.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _buildSchoolCard(context, provider.filteredSchools[i]),
                      ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildSchoolCard(BuildContext context, School school) {
    return GestureDetector(
      onTap: () => _showSchoolDetail(context, school),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(school.name, style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.mainText)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Icon(Icons.location_on_outlined, size: 14, color: AppColors.subText),
                    const SizedBox(width: 4),
                    Text(school.location, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: school.type == '公办' ? AppColors.secondaryLight : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(school.type, style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: school.type == '公办' ? AppColors.secondary : AppColors.primary)),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6, runSpacing: 4,
                    children: school.majorCategories.take(3).map((m) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.areaBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(m, style: const TextStyle(fontSize: 11, color: AppColors.subText)),
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Text('${school.score}', style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const Text('投档线', style: TextStyle(fontSize: 10, color: AppColors.subText)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSchoolDetail(BuildContext context, School school) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65, maxChildSize: 0.9, minChildSize: 0.4,
        expand: false,
        builder: (_, sc) => SingleChildScrollView(
          controller: sc,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
              )),
              const SizedBox(height: 24),
              Text(school.name, style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.mainText)),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.location_on_outlined, size: 16, color: AppColors.subText),
                const SizedBox(width: 4),
                Text('${school.location} · ${school.type}',
                  style: const TextStyle(fontSize: 14, color: AppColors.subText)),
              ]),
              const SizedBox(height: 24),
              Row(children: [
                _buildDetailStat('投档线', '${school.score}分', AppColors.primary),
                const SizedBox(width: 12),
                _buildDetailStat('类型', school.type, AppColors.secondary),
              ]),
              const SizedBox(height: 24),
              const Text('院校简介', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.mainText)),
              const SizedBox(height: 8),
              Text(school.description, style: const TextStyle(
                fontSize: 15, height: 1.6, color: AppColors.mainText)),
              const SizedBox(height: 24),
              const Text('开设专业', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.mainText)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: school.majorCategories.map((m) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.areaBg, borderRadius: BorderRadius.circular(10)),
                  child: Text(m, style: const TextStyle(fontSize: 13, color: AppColors.mainText)),
                )).toList(),
              ),
              if (school.website.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text('官方网站', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.mainText)),
                const SizedBox(height: 8),
                Text(school.website, style: const TextStyle(
                  fontSize: 14, color: AppColors.primary)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subText)),
          ],
        ),
      ),
    );
  }
}
