const {validationResult} = require('express-validator');
const conn = require('../utils/dbConnection').promise();
const request = require('request');

exports.kakaoRegister = async(req, res, next) => {
	const errors = validationResult(req);
	const accessToken = req.body.accessToken["token"];
	const refreshToken = req.body.refreshToken["token"];
	const checkKakaoAccessToken = {
		uri: "https://kapi.kakao.com/v1/user/access_token_info",
		method: "GET",
		headers: { Authorization: `Bearer ${accessToken}`}
	}

	const renewAccessToken = {
		uri: "https://kauth.kakao.com/oauth/token",
		method: "POST",
		qs: {
			"grant_type" : "refresh_token",
			"client_id": "${CLIENT_ID}",
			"refresh_token": `${refreshToken}`
		}
	}

	const getKakaoUserInfo = {
		uri: "https://kapi.kakao.com/v2/user/me",
		method: "GET",
		headers: { Authorization: `Bearer ${accessToken}`}
	}

	if (!errors.isEmpty()) {
		return res.status(400).json({
			message: errors.array()
		});
	}
	function getKakaoResponse(options) {
		return new Promise(resolve => {
			request(options, (err, res, body) => {
				console.log(options);
				resolve(res.body);
			});
		});
	}
	// 카카오 api 서버에 액세스 토큰 확인 요청
	getKakaoResponse(getKakaoUserInfo).then(async (result) => {
		let userJson = JSON.parse(result);
		// 액세스 토큰 유효성 검사
		if (userJson.hasOwnProperty('id') === false) {
			return res.status(400).json({
				"code": "E1601",
				"message": "잘못된 액세스 토큰이거나 토큰이 만료되었습니다.",
				"data" : userJson
			});
		}
		// oauth 테이블에서 카카오 로그인 서비스로 우리 앱에 가입한적이 있는지 확인
		const [row] = await conn.query(
			"SELECT * FROM `oauth` WHERE `oauth_id`=? AND `provider_id`=?;",
			[userJson.id, 1]
		);
		// 카카오 로그인 서비스로 회원 가입한 경우
		if (row.length > 0) {
			// 리프레시 토큰 최신화
			const [updateRefreshToken] = await conn.query(
				"UPDATE `oauth` SET `refresh_token`=? WHERE `oauth_id`=?;",
				[refreshToken, userJson.id, 1]
			);
			// 와인더 회원 테이블에 등록되어있는지 확인
			const [checkMemberTable] = await conn.query(
				"SELECT * FROM `members` WHERE `oauth_id`=?",
				[row[0].id]
			);
			// 등록 되어 있으면 해당 회원 정보를 전송
			if (checkMemberTable.length > 0) {
				return res.status(201).json({
					"code": "S1602",
					"message": `oauth 연결 및 와인더에 가입 되어있는 kakao 회원입니다. 로그인 완료`,
					"data": {
						"id": checkMemberTable[0].id,
						"provider": "kakao",
						"providerUserId": userJson.id, 
						"email": userJson.kakao_account.email,
						"nickname": userJson.kakao_account.profile.nickname,
						"accessToken": accessToken,
					},
				});
			}
			// 카카오 서비스로 와인더와 연결했지만 와인더 회원으로 등록 되어 있지 않은 경우
			else {
				// 와인더 멤버 데이터베이스에 추가
				const [createMember] = await conn.query(
					"INSERT INTO `members`(`oauth_id`,`nickname) VALUES (?,?)",
					[row[0].id,userJson.kakao_account.profile.nickname]
				);
				if (createMember.affectedRows === 1) {
					const [getMemberId] = await conn.query(
						"SELECT * FROM `members` WHERE `oauth_id`=?",
						[row[0].id]
					);
					return res.status(200).json({
						"code": "S1603",
						"message": `와인더에 가입 되어있지 않은 kakao 회원입니다. 등록 및 로그인 완료`,
						"data": {
							"id": checkMemberTable[0].id,
							"provider": "kakao",
							"providerUserId": userJson.id, 
							"email": userJson.kakao_account.email,
							"nickname": userJson.kakao_account.profile.nickname,
							"accessToken": accessToken,
						}
					});
				}
			}
		}
		// 아예 처음 인 경우
		else {
			const [rows] = await conn.query(
				"INSERT INTO `oauth`(`oauth_id`, `provider_id`, `refresh_token`, `expire_at`) VALUES (?,?,?,?)",
				[userJson.id, 1, refreshToken, userJson.expireAt]
			);
			if (rows.affectedRows === 1) {
				const [createMember] = await conn.query(
					"INSERT INTO `members`(`oauth_id`) VALUES (?)",
					[userJson.id]
				);
				const [getMemberId] = await conn.query(
					"SELECT * FROM `members` WHERE `oauth_id`=?",
					[userJson.id]
				);
				return res.status(200).json({
					"code": "S1601",
					"message": `와인더에 가입 되어있지 않은 kakao 회원입니다. 등록 및 로그인 완료`,
					"data": {
						"id": checkMemberTable[0].id,
						"provider": "kakao",
						"providerUserId": userJson.id, 
						"email": userJson.kakao_account.email,
						"nickname": userJson.kakao_account.profile.nickname,
						"accessToken": accessToken,
					}
				});
			}
		}
	});
}
