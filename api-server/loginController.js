const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const {validationResult} = require('express-validator');
const conn = require = require('../utils/dbConnection').promise();

exports.login = async (req, res, next) => {
	const errors = validationResult(req);
	console.log(req.array);
	console.log(req.headers.authorization);
	if (!errors.isEmpty()) {
		console.log(req.body);
		return res.status(422).json({ errors: errors.array() });
	}

	try{

		const [row] = await conn.execute(
			"SELECT * FROM `members` WHERE `email`=?",
			[req.body.email]
		);

		if (row.length === 0) {
			return res.status(422).json({
				message: "Invalid email address",
			});
		}

		const passMatch = await bcrypt.compare(req.body.password, row[0].password);
		if (!passMatch){
			return res.status(422).json({
				message: "Incorrect password"
			});
		}
		
		const theToken = jwt.sign({id:row[0].id}, '${SECRET_KEY}', {expiresIn: '1h'});
		
		if (theToken){
			console.log(req.body);
		}
		console.log(`Register Success\nEmail: ${req.body.email}\naccessToken: ${theToken}`);
		return res.status(200).json({
			"code": "S1301",
			"message": "로그인 성공",
			"data": {
				"provider": "winder",
				"email": `${req.body.email}`,
				"nickname": row[0].nickname,
				"accessToken": `${theToken}`,
				"expireIn": 3600
			}
		});
	}
	catch(err){
		next(err);
	}
}
