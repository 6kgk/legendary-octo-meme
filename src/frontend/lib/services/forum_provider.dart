import 'package:flutter/material.dart';
import '../models/app_models.dart';

class ForumProvider with ChangeNotifier {
  final List<Post> _posts = [
    Post(
      id: 'p1', author: '深职大小迷妹', time: '10分钟前',
      content: '今天在图书馆复习数学，三角函数真的好难啊，有没有师兄指点一下？',
      likes: 12,
      comments: [
        Comment(id: 'c1', author: '数学学霸', time: '8分钟前', content: '记住公式 sin²x+cos²x=1，然后多练真题就好了！'),
        Comment(id: 'c2', author: '同是天涯备考人', time: '5分钟前', content: '一样一样，我也卡在这里了'),
        Comment(id: 'c3', author: '老师教的好', time: '3分钟前', content: '试试用单位圆理解，会直观很多'),
        Comment(id: 'c4', author: '加油鸭', time: '2分钟前', content: '我已经过了这关了，你也可以的！'),
        Comment(id: 'c5', author: '匿名用户', time: '1分钟前', content: '推荐看看粤职通的AI助教，解题思路很清晰'),
      ],
    ),
    Post(
      id: 'p2', author: '广轻工准学子', time: '半小时前',
      content: '刚查了去年的分数线，感觉自己还要再加把劲，3+证书考试加油！',
      likes: 24,
      comments: [
        Comment(id: 'c6', author: '一起冲', time: '25分钟前', content: '加油！我们一定可以的💪'),
        Comment(id: 'c7', author: '过来人', time: '20分钟前', content: '别慌，按计划复习就好'),
        Comment(id: 'c8', author: '深圳小伙', time: '15分钟前', content: '广轻工挺好的，值得冲'),
        Comment(id: 'c9', author: '中职生', time: '12分钟前', content: '今年分数线会不会涨啊'),
        Comment(id: 'c10', author: '备考中', time: '10分钟前', content: '我也是目标广轻工！'),
        Comment(id: 'c11', author: '学姐', time: '8分钟前', content: '去年被广轻工录取了，环境很好'),
        Comment(id: 'c12', author: '匿名', time: '5分钟前', content: '分数线可以在查校功能里看'),
        Comment(id: 'c13', author: '路过', time: '3分钟前', content: '一起加油一起上岸！'),
      ],
    ),
    Post(
      id: 'p3', author: '中职老司机', time: '1小时前',
      content: '建议大家多刷真题，特别是英语的语法填空，规律性很强。',
      likes: 45,
      comments: [
        Comment(id: 'c14', author: '英语渣', time: '55分钟前', content: '确实，语法填空套路就那几个'),
        Comment(id: 'c15', author: '高分选手', time: '50分钟前', content: '时态+从句+非谓语，搞定这三个就行'),
        Comment(id: 'c16', author: '求指路', time: '45分钟前', content: '有没有推荐的真题集？'),
        Comment(id: 'c17', author: '老司机粉丝', time: '40分钟前', content: '大佬说得对！'),
        Comment(id: 'c18', author: '英语70分目标', time: '35分钟前', content: '刷了20套，感觉确实有进步'),
        Comment(id: 'c19', author: '匿名', time: '30分钟前', content: '粤职通的英语题库也不错'),
        Comment(id: 'c20', author: '小白', time: '25分钟前', content: '请问从哪里开始刷比较好？'),
        Comment(id: 'c21', author: '学霸日记', time: '20分钟前', content: '建议先做近三年的，再往前推'),
        Comment(id: 'c22', author: '感谢', time: '15分钟前', content: '谢谢分享经验！'),
        Comment(id: 'c23', author: '备考党', time: '10分钟前', content: '今天就去刷'),
        Comment(id: 'c24', author: '同感', time: '5分钟前', content: '数学也是，多刷题真的有效'),
        Comment(id: 'c25', author: '加油', time: '3分钟前', content: '大家都加油！'),
      ],
    ),
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
      final post = _posts[index];
      if (post.isLiked) {
        post.likes--;
        post.isLiked = false;
      } else {
        post.likes++;
        post.isLiked = true;
      }
      notifyListeners();
    }
  }

  void addComment(String postId, String content) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].comments.add(Comment(
        id: DateTime.now().toString(),
        author: '粤职通用户',
        time: '刚刚',
        content: content,
      ));
      notifyListeners();
    }
  }
}
