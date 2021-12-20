const {validationResult} = require('express-validator');
const conn = require('../utils/dbConnection').promise();
const https = require('https');

exports.naverRegister = async (req, res, next) => {
	const errors = validationResult(req);
	const accessToken = req.body.accessToken["token"];
	const refreshToken = req.body.refreshToken["token"];

	// accessToken 상태 확인 API
	const checkNaverAccessToken = {
		hostname: "openapi.naver.com",
		path: "/v1/nid/me",
		port: 443,
		method: "GET",
		headers: { "Authorization": `Bearer ${accessToken}`},
		agent: false
	};

	// accessToken 재발급 API
	const renewNaverAccessToken = {
		uri: "https://nid.naver.com/oauth2.0/token",
		method: "GET",
		qs: {
			client_id: "${CLIENT_ID}",
			client_secret: "${SECRET_KEY}",
			refresh_token: refreshToken,
			grant_type: "refresh_token"
		}
	};

	// req.body error
	if (!errors.isEmpty()) {
		return res.status(422).json({
			errors: errors.array()
		});
	}
	console.log(checkNaverAccessToken);

	function getNaverResponse(options) {
		return new Promise((resolve) => {
			const req = https.request(options, (res) => {
				let data = "";
				res.on('data', (chunk) => {
					data += chunk.toString();
				});
				res.on('end', () => {
					data = JSON.parse(data);
					resolve(data);
				});
			});
			req.on('error', (error) => {
				console.log("req error:", error);
				res.send(error);
			});
			req.end();
		});
	}

	try {

		// 1. 액세스 토큰 상태확인 시도
		getNaverResponse(checkNaverAccessToken).then(async (result) => {
			console.log("result:", result);
			if (result.resultcode !== '00') {
				return res.status(400).json({
					code: "E1701",
					message: "토큰이 만료되었거나 잘못된 토큰입니다."
				});
			}
			else {
				const [checkUser] = await conn.query(
					"SELECT * FROM `oauth` WHERE `oauth_id`=? AND `provider_id`=?",
					[result.response.id, 2]
				);
				if (checkUser.length === 0) {
					const [createOauthUser] = await conn.query(
						"insert into oauth (oauth_id, provider_id, refresh_token) values (?,?,?)",
						[result.response.id, 2, refreshToken]
					);
					const [selectOauthUser] = await conn.query(
						"select * from oauth where oauth_id=? and provider_id=?",
						[result.response.id, 2]
					);
					console.log(selectOauthUser[0]);
					if (createOauthUser.affectedRows === 1) {
						const [createMember] = await conn.query(
							"insert into members (nickname, oauth_id) values (?,?)",
							[result.response.name, selectOauthUser[0].id]
						);
						const [selectMember] = await conn.query(
							"select * from members where oauth_id=?",
							[selectOauthUser[0].id]
						);
						return res.status(200).json({
							code: "S1701",
							message: "naver로 와인더 회원가입완료",
							data: {
								id: selectMember[0].id,
								provider: "naver",
								providerUserId: result.response.id,
								email: result.response.email,
								nickname: selectMember[0].nickname,
								accessToken: accessToken,
							}
						});
					}
				}
				else {
					const [selectOauthUser] = await conn.query(
						"select * from oauth where oauth_id=? and provider_id=?",
						[result.response.id, 2]
					);
					const [selectMember] = await conn.query(
						"select * from members where oauth_id=?",
						[selectOauthUser[0].id]
					);
					console.log(selectOauthUser[0], selectMember[0]);
					if (selectOauthUser.length == selectMember.length) {
						return res.status(200).json({
							code: "S1702",
							message: "naver로 로그인 완료",
							data: {
								id: selectMember[0].id,
								provider: "naver",
								providerUserId: result.response.id,
								email: result.response.email,
								nickname: selectMember[0].nickname,
								accessToken: accessToken,
							}
						});
					}
				}
			}
		});

	} catch (err) {
		next(err);
	}
}