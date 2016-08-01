const logger = require('morgan');
const bodyParser = require('body-parser');

module.exports = function middleware(app) {
  app.use((req, res, next) => {
    console.log('HEADERS FROM REQ------------', req.headers.origin);
    // res.header('Access-Control-Allow-Credentials', true);
    res.header('Access-Control-Allow-Origin', '*');
    // res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    // res.header('Access-Control-Allow-Headers',
    //   'X-Requested-With, X-HTTP-Method-Override, Content-Type, Accept');
    next();
  });

  app.use(logger('dev'));

  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({ extended: true }));
};
