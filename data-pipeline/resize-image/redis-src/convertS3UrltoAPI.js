// DB에 저장된 S3 url 을 Image resize API 엔드포인트에 적합하도록 변환
function convertS3UrltoAPI(url, width = 'default', height = 'default', type = 'jpeg') {
  const [, bucket, , , , , key] = url.match(/https:\/\/(.*)\.(.*)\.(.*)\.(.*)\.(.*)\/(.*)/);
  const urlAPI = `https://winder.info/api/v1/image?bucket=${bucket}&key=${key}&type=${type}&width=${width}&height=${height}`;
  return urlAPI;
}

module.exports = convertS3UrltoAPI;
