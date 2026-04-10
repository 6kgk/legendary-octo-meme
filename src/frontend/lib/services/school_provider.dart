import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'data_loader.dart';

class SchoolProvider with ChangeNotifier {
  List<School> _allSchools = [];
  bool _isLoaded = false;
  String _searchQuery = '';
  String _selectedType = '全部';

  bool get isLoaded => _isLoaded;
  String get selectedType => _selectedType;

  Future<void> loadData() async {
    if (_isLoaded) return;
    _allSchools = await DataLoader.loadSchools();
    _isLoaded = true;
    notifyListeners();
  }

  List<School> get filteredSchools {
    return _allSchools.where((s) {
      final matchesSearch = _searchQuery.isEmpty ||
          s.name.contains(_searchQuery) ||
          s.location.contains(_searchQuery) ||
          s.majorCategories.any((m) => m.contains(_searchQuery));
      final matchesType = _selectedType == '全部' || s.type == _selectedType;
      return matchesSearch && matchesType;
    }).toList();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateFilter(String type) {
    _selectedType = type;
    notifyListeners();
  }
}
