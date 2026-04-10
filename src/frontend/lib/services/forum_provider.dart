import 'package:flutter/material.dart';
import '../models/app_models.dart';

class ForumProvider with ChangeNotifier {
  final List<Post> _posts = [
    Post(id: 'p1', author: '深职大小迷妹', time: '10分钟前', content: '今天在图书馆复习数学，三角函数真的好难啊，有没有师兄指点一下？', likes: 12, commentsCount: 5),
    Post(id: 'p2', author: '广轻工准学子', time: '半小时前', content: '刚查了去年的分数线，感觉自己还要再加把劲，3+证书考试加油！', likes: 24, commentsCount: 8),
    Post(id: 'p3', author: '中职老司机', time: '1小时前', content: '建议大家多刷真题，特别是英语的语法填空，规律性很强。', likes: 45, commentsCount: 12),
  ];

  List<Post> get posts => _posts;

  void addPost(String content) {
    _posts.insert(0, Post(
      id: DateTime.now().toString(),
      author: '粤职通用户',
      time: '刚刚',
      content: content,
    ));
    notifyListeners();
  }

  void toggleLike(String id) {
    final index = _posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _posts[index].likes++;
      notifyListeners();
    }
  }
}
