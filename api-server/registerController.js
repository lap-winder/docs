const {validationResult} = require('express-validator');
const bcrypt = require('bcryptjs');
const conn = require('../utils/dbConnection').promise();
const jwt = require('jsonwebtoken');

exports.register = async(req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) {
		return res.status(422).json({ errors: errors.array() });
	}

	try {
		const [row] = await conn.execute(
			"SELECT `email` FROM `members` WHERE `email`=?",
			[req.body.email]
		);

		if (row.length > 0) {
			return res.status(201).json({
				message: "The E-mail already in use",
			});
		}
		const nameTemp = Math.random().toString().substr(2, 6);
		const hashPass = await bcrypt.hash(req.body.password, 12);

		const [rows] = await conn.execute(
			"INSERT INTO `members`(`email`, `nickname`, `password`) VALUES (?,?,?)", [
				req.body.email,
				nameTemp,
				hashPass
			]
		);

		if (rows.affectedRows === 1) {
			const [newUser] = await conn.execute(
				"SELECT * FROM `members` WHERE `email`=?",
				[req.body.email]
			);
			console.log(newUser[0]);
			const theToken = jwt.sign({id:newUser[0].id}, 'the-super-strong-secret', {expiresIn: '1h'});
			console.log(`Register Success\nEmail: ${req.body.email}\naccessToken: ${theToken}`);
			return res.status(200).json({
				"code": "S1201",
				"message": "회원가입 성공",
				"data": {
					"provider": "winder",
					"email": `${req.body.email}`,
					"nickname": newUser[0].nickname,
					"accessToken": `${theToken}`,
					"expireIn": 3600
				}
			});
		}
	}catch(err){
		next(err);
	}
}
