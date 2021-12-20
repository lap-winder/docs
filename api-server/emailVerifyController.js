const conn = require('../utils/dbConnection').promise();
const nodemailer = require('nodemailer');
const {validationResult} = require('express-validator');
require('dotenv').config();

exports.emailVerification = async (req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) {
		return res.status(422).json({ errors: errors.array() });
	}

	try {
		const [row] = await conn.execute(
			"SELECT * FROM `members` WHERE `email`=?", [req.body.email]
		);
		console.log("request come in email verify controller");
		console.log(`userInput : ${req.body.email}`);
		console.log(row.length);
		if (row.length > 0) {
			return res.status(422).json({
				"code": "E1101",
				"message": "이미 사용중인 이메일입니다.",
				"data": {
					"inputAddress": `${req.body.email}`
				}
			});
		}

		const authNum = Math.random().toString().substr(2, 6);
		
		const transporter = nodemailer.createTransport({
			host: "email-smtp.ap-northeast-2.amazonaws.com",
			port: 587,
			secure: false,
			auth: {
				user: "${AWS KEY}",
				pass: "${AWS SECRET KEY}",
			},
		});

		const mailOptions = await transporter.sendMail({
			from: "와인더 <lap.winder@winder.info>",
			to: req.body.email,
			subject: `와인더 Email 인증`,
			html: `<h2> ${authNum}</h2>`,
		}, (err) => {
			if (err) next(err);
			else {
				return res.status(200).json({
					"code": "S1101",
					"message": "인증번호를 발송했습니다.",
					"data": {
						"toAddress": `${req.body.email}`,
						"authCode": `${authNum}`
					}
				});
			}
		});

		// transporter.sendMail(mailOptions, (err) => {
		// 	if (err) next(err);
		// 	else {
		// 		return res.status(200).json({
		// 			"code": "S1101",
		// 			"message": "인증번호를 발송했습니다.",
		// 			"data": {
		// 				"toAddress": `${req.body.email}`,
		// 				"authCode": `${authNum}`
		// 			}
		// 		});
		// 	}
		// });
	}
	catch(err){
		next(err);
	}
}
