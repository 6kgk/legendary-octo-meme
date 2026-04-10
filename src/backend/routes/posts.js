const express = require('express');
const router = express.Router();

// Preset posts
let posts = [
  { id: 1, title: '初三复习心得分享', content: '分享一下我的物理复习方法，希望能帮到大家。', author: '小明', likes: 12, date: '2023-04-10' },
  { id: 2, title: '深圳哪所职高比较好？', content: '最近在考虑职高，想听听大家的建议，特别是计算机专业。', author: '匿名用户', likes: 8, date: '2023-04-12' },
  { id: 3, title: '数学压轴题解析', content: '针对上周模考的最后一道大题，我总结了几种解法。', author: '学霸君', likes: 45, date: '2023-04-15' },
  { id: 4, title: '考前心态调节小贴士', content: '压力太大怎么办？教你几招简单的放松技巧。', author: '心理老师', likes: 23, date: '2023-04-18' },
  { id: 5, title: '我的中考目标校：深实', content: '立个Flag，一定要考上深圳实验学校！', author: '奋斗的小鱼', likes: 15, date: '2023-04-20' }
];

// GET /api/posts - 返回所有帖子
router.get('/', (req, res) => {
  res.json(posts);
});

// POST /api/posts - 创建新帖子
router.post('/', (req, res) => {
  const { title, content, author } = req.body;
  
  if (!title || !content || !author) {
    return res.status(400).json({ message: 'Title, content, and author are required' });
  }
  
  const newPost = {
    id: posts.length + 1,
    title,
    content,
    author,
    likes: 0,
    date: new Date().toISOString().split('T')[0]
  };
  
  posts.unshift(newPost); // Add to beginning
  res.status(201).json(newPost);
});

// POST /api/posts/:id/like - 点赞
router.post('/:id/like', (req, res) => {
  const { id } = req.params;
  const post = posts.find(p => p.id === parseInt(id));
  
  if (post) {
    post.likes += 1;
    res.json(post);
  } else {
    res.status(404).json({ message: 'Post not found' });
  }
});

module.exports = router;
