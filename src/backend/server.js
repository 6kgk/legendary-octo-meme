const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
const questionsRouter = require('./routes/questions');
const schoolsRouter = require('./routes/schools');
const postsRouter = require('./routes/posts');

app.use('/api/questions', questionsRouter);
app.use('/api/schools', schoolsRouter);
app.use('/api/posts', postsRouter);

// Basic health check
app.get('/', (req, res) => {
  res.send('Backend API Service is running');
});

app.listen(port, () => {
  console.log(`Backend server running at http://localhost:${port}`);
});
