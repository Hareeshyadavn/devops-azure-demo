const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from devops-azure-demo!',
    commit: process.env.GITHUB_SHA || 'local'
  });
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});