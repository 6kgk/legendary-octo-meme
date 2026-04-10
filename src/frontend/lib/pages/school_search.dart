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
    Future.microtask(() {
      Provider.of<SchoolProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SchoolProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('查校')),
      body: !provider.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TextField(
                    onChanged: (val) => provider.updateSearch(val),
                    decoration: InputDecoration(
                      hintText: '搜索院校、专业或地区...',
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.mainText),
                      filled: true,
                      fillColor: AppColors.areaBg,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: ['全部', '公办', '民办']
                        .map((type) => _buildFilterChip(type, provider))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      Text('${provider.filteredSchools.length} 所院校',
                          style: const TextStyle(fontSize: 13, color: AppColors.subText)),
                      const Spacer(),
                      const Text('按分数排序',
                          style: TextStyle(fontSize: 12, color: AppColors.weakText)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: provider.filteredSchools.isEmpty
                      ? const Center(child: Text('未找到符合条件的院校'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: provider.filteredSchools.length,
                          itemBuilder: (context, index) {
                            return _buildSchoolTile(context, provider.filteredSchools[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String label, SchoolProvider provider) {
    final isSelected = provider.selectedType == label;
    return GestureDetector(
      onTap: () => provider.updateFilter(label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainText : AppColors.background,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.mainText : AppColors.divider, width: 0.5),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13, color: isSelected ? AppColors.background : AppColors.mainText)),
      ),
    );
  }

  Widget _buildSchoolTile(BuildContext context, School school) {
    return GestureDetector(
      onTap: () => _showSchoolDetail(context, school),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(school.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mainText)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Text(school.location, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
                    const SizedBox(width: 8),
                    const Text('·', style: TextStyle(color: AppColors.weakText)),
                    const SizedBox(width: 8),
                    Text(school.type, style: const TextStyle(fontSize: 13, color: AppColors.subText)),
                  ]),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    children: school.majorCategories.map((m) => _buildMiniTag(m)).toList(),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${school.score}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.mainText)),
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
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 24),
              Text(school.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.mainText)),
              const SizedBox(height: 8),
              Text('${school.location} · ${school.type}',
                  style: const TextStyle(fontSize: 14, color: AppColors.subText)),
              const SizedBox(height: 24),
              _buildInfoRow('投档线', '${school.score} 分'),
              _buildInfoRow('官网', school.website),
              const SizedBox(height: 24),
              const Text('院校简介',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mainText)),
              const SizedBox(height: 8),
              Text(school.description,
                  style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.mainText)),
              const SizedBox(height: 24),
              const Text('开设专业',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.mainText)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: school.majorCategories.map((m) => _buildMiniTag(m)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.subText))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, color: AppColors.mainText))),
        ],
      ),
    );
  }

  Widget _buildMiniTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.areaBg, borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.subText)),
    );
  }
}
