const express = require('express');
const router = express.Router();
const fs = require('fs');
const path = require('path');

const dataPath = path.join(__dirname, '../../frontend/assets/data/questions.json');

// Helper to read data
const readQuestions = () => {
  try {
    const data = fs.readFileSync(dataPath, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    console.error('Error reading questions:', error);
    return [];
  }
};

// GET /api/questions - 返回所有题目（支持 ?subject=语文 筛选）
router.get('/', (req, res) => {
  const { subject } = req.query;
  let questions = readQuestions();
  
  if (subject) {
    questions = questions.filter(q => q.subject === subject);
  }
  
  res.json(questions);
});

// GET /api/questions/:id - 返回单道题目
router.get('/:id', (req, res) => {
  const { id } = req.params;
  const questions = readQuestions();
  const question = questions.find(q => q.id === parseInt(id) || q.id === id);
  
  if (question) {
    res.json(question);
  } else {
    res.status(404).json({ message: 'Question not found' });
  }
});

module.exports = router;
