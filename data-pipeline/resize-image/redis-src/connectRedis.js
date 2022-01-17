const redis = require('redis');

class Redis {
  constructor() {
    this.host = process.env.REDIS_HOST || 'localhost';
    this.port = process.env.REDIS_PORT || '6379';
    this.connected = false;
    this.client = null;
  }

  getConnection() {
    if (this.connected) return this.client;

    console.log('New redis instance');
    this.client = redis.createClient({
      host: this.host,
      port: this.port,
    });
    return this.client;
  }
}

module.exports = new Redis();
