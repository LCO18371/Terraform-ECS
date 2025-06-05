const express = require('express');
const app = express();
const PORT = process.env.PORT || 80;

app.get('/hello', (req, res) => {
  res.json({ message: 'Hello from Express on port 80!' });
});

app.get('/health', (req, res) => {
    res.json({ message: 'Ok 200!' });
  });

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
