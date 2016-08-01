// Load environment variables
if (process.env.NODE_ENV === 'development') {
  require('dotenv').config({ path: './env/development.env' });
} else {
  require('dotenv').config({ path: './env/production.env' });
}

const db = require('./db/db');

const middleware = require('./middleware');

const express = require('express');
const app = express();

middleware(app);

app.get('/', (req, res) => res.send('Hello World!')
  );

app.post('/api/users/:userId/message', (req, res) => {
  // track user location message
  console.log('message---', req.body.message);
  console.log('body---', req.body);
  // db.set(`user:${req.params.userId}`, req.body.message);
  res.sendStatus(200);
});

app.get('/api/users/:userId/message', (req, res) => {
  // track user location message
  db.get(`user:${req.params.userId}`, (err, reply) => {
    if (err) {
      console.log(err);
    }
    console.log('reply:', reply)
    res.send(reply);
  });
});

app.get('*', (req, res) => res.sendStatus(404)
  );

const startApp = () =>
  app.listen(Number(process.env.PORT), process.env.HOST, () => {
    console.log(
      `${process.env.APP_NAME} is listening at ${process.env.HOST} on port ${process.env.PORT}`
    );
  });

startApp();
