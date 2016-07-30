const redis = require('redis');

let client;

if (process.env.NODE_ENV === 'production') {
  client = redis.createClient('6379', 'redis');
} else {
  client = redis.createClient();
}

client.on('connect', () => console.log('Redis server connected')
  );

client.on('error', (err) => console.log('Redis error: ', err)
  );


module.exports = client;