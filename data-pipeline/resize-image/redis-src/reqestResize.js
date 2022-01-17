const axios = require('axios');

async function reqLamda(req, res, next) {
  try {
    const {
      bucket,
      key,
      type = 'jpeg',
      width = 'default',
      height = 'default',
    } = req.query;

    // redis 캐시 키값 확인하여 있다면 반환
    await req.client.get(`${key}${width}${height}`, (err, storage) => {
      if (err) throw err;
      if (storage) {
        req.resizedImage = Buffer.from(storage, 'base64');
        next();
      }
    });

    // lamda에 resize 요청
    const config = {
      method: 'get',
      url: process.env.LAMBDA_ENDPOINT,
      params: {
        bucket,
        imageName: key,
        type,
        width,
        height,
      },
    };
    const { data } = await axios(config).catch((error) => {
      console.log(error);
      throw new Error('S3 이미지를 찾을 수 없음');
    });
    // base64 스트림을 redis 에 캐싱함
    // base64 를 디코딩해서 요청자에게 전달한다.
    // todo 이부분에서 Redis 가 Base64 값을 저장하는 것이 적절한지 확인 필요해보인다
    req.client.set(`${key}${width}${height}`, data);
    req.resizedImage = Buffer.from(data, 'base64');
    next();
  } catch (err) {
    next(err);
  }
}

module.exports = reqLamda;
