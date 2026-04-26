const express = require('express');
const router = express.Router();
const fs = require('fs');
const path = require('path');

const dataPath = path.join(__dirname, '../../frontend/assets/data/schools.json');

// Helper to read data
const readSchools = () => {
  try {
    const data = fs.readFileSync(dataPath, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    console.error('Error reading schools:', error);
    return [];
  }
};

// GET /api/schools - 返回所有院校（支持 ?type=公办 和 ?search=深圳 筛选）
router.get('/', (req, res) => {
  const { type, search } = req.query;
  let schools = readSchools();
  
  if (type) {
    schools = schools.filter(s => s.type === type);
  }
  
  if (search) {
    const searchTerm = search.toLowerCase();
    schools = schools.filter(s => 
      s.name.toLowerCase().includes(searchTerm) || 
      s.location.toLowerCase().includes(searchTerm)
    );
  }
  
  res.json(schools);
});

// GET /api/schools/:id - 返回单个院校
router.get('/:id', (req, res) => {
  const { id } = req.params;
  const schools = readSchools();
  const school = schools.find(s => s.id === parseInt(id) || s.id === id);
  
  if (school) {
    res.json(school);
  } else {
    res.status(404).json({ message: 'School not found' });
  }
});

module.exports = router;
