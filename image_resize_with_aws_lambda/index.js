const AWS = require('aws-sdk')
const S3 = new AWS.S3({
	region: "ap-northeast-2"
});
const sharp = require('sharp');

exports.handler = async (event) => {
	const params = event.queryStringParameters;

	try{
		const {Body} = await S3.getObject({
			Bucket: params.bucket,
			Key   : params.imageName
		}).promise();

		if (Body === undefined) noImage();

		let resizedImage;

		if (params.width !== "default" && params.height !== "default"){
			const width = parseInt(params.width)
			const height = parseInt(params.height)
			resizedImage = await sharp(Body)
				.resize(width, height, {fit: "fill"})
				.withMetadata().rotate().toFormat(params.type).toBuffer();
		}else if(params.width !== "default"){
			const width = parseInt(params.width)
			resizedImage = await sharp(Body)
				.resize({width: width})
				.withMetadata().rotate().toFormat(params.type).toBuffer();
		}else if(params.height !== "default"){
			const height = parseInt(params.height)
			resizedImage = await sharp(Body)
				.resize({height: height})
				.withMetadata().rotate().toFormat(params.type).toBuffer();
		}else {
			resizedImage = Body;
		}

		const response = {
			statusCode: 200,
			headers: {
				"Content-Type": "image/" + params.type,
			},
			body: resizedImage.toString("base64"),
			isBase64Encoded: true
		}

		return response;
	}
	catch (e) {
		console.error(e)
		const responseErr = {
			statusCode: 400,
			headers: {
				"Content-Type": "application/json",
			},
			body: e.toJSON,
			isBase64Encoded: false,
		}
		return(responseErr);
	}
};

function noImage(){
	throw new Error("해당 파일은 존재하지 않습니다.");
}