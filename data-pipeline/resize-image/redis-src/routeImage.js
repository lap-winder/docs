import { Router } from 'express';
import Redis from './connectRedis.js';
import reqLambda from './reqestResize.js';

const router = Router();

// Redis 연결

const client = Redis.getConnection();
router.use((req, res, next) => {
  req.client = client;
  next();
});

// query validation 검증은 생략

router.get(
  '/api/v1/image',
  reqLambda,
  async (req, res) => {
    res.set('Content-Type', 'image/jpeg');
    res.send(req.resizedImage);
  },
);

// Error 검출 생략

module.exports = router;
