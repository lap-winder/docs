import AWS from 'aws-sdk';
import sharp from 'sharp';

const S3 = new AWS.S3({
  region: 'ap-northeast-2',
});

function noImage() {
  throw new Error("Image doesn't exist.");
}

exports.handler = async (event) => {
  const params = event.queryStringParameters;

  try {
    const { Body } = await S3.getObject({
      Bucket: params.bucket,
      Key: params.imageName,
    }).promise();

    if (Body === undefined) noImage();

    let resizedImage;
    if (params.width !== 'default' && params.height !== 'default') {
      const width = parseInt(params.width, 10);
      const height = parseInt(params.height, 10);
      resizedImage = await sharp(Body)
        .resize(width, height, { fit: 'fill' })
        .withMetadata().rotate()
        .toFormat(params.type)
        .toBuffer();
    } else if (params.width !== 'default') {
      const width = parseInt(params.width, 10);
      resizedImage = await sharp(Body)
        .resize({ width })
        .withMetadata().rotate()
        .toFormat(params.type)
        .toBuffer();
    } else if (params.height !== 'default') {
      const height = parseInt(params.height, 10);
      resizedImage = await sharp(Body)
        .resize({ height })
        .withMetadata().rotate()
        .toFormat(params.type)
        .toBuffer();
    } else {
      resizedImage = Body;
    }

    return {
      statusCode: 200,
      headers: {
        'Content-Type': `image/${params.type}`,
      },
      body: resizedImage.toString('base64'),
      isBase64Encoded: true,
    };
  } catch (e) {
    return {
      statusCode: 400,
      headers: {
        'Content-Type': 'application/json',
      },
      body: e.toJSON,
      isBase64Encoded: false,
    };
  }
};
