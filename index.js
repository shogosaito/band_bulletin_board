"use strict";

require("dotenv").config();

//　ライブラリインポート
const express = require("express");
const app = express();
const line_login = require("line-login");
const session = require("express-session");
const session_options = {
  secret: process.env.LINE_LOGIN_CHANNEL_SECRET,
  resave: false,
  saveUninitialized: false
}
app.use(session(session_options));

//　認証設定
const login = new line_login({
  channel_id: process.env.LINE_LOGIN_CHANNEL_ID,
  channel_secret: process.env.LINE_LOGIN_CHANNEL_SECRET,
  callback_url: process.env.LINE_LOGIN_CALLBACK_URL
});

//　サーバー起動設定
app.listen(process.env.PORT || 3000, () => {
  console.log(`server is listening to ${process.env.PORT || 3000}...`);
})
// 認証フローを開始するためのルーター設定
app.get("/auth", login.auth());

// ユーザーが承認したあとに実行する処理のためのルーター設定。
app.get("/callback", login.callback(
  (req, res, next, token_response) => {
    //　成功時
    res.json(token_response);
  }, (req, res, next, error) => {
    // 失敗時
    res.status(400).json(error);
  }
));
