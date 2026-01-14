/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)

import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import store from "../store/store.js";
import router from "../router/router.js";
import App from "../app.vue";

// ★ ここから：axios の共通設定（トークン自動付与＆更新）
import axios from "axios";
import VueAxios from "vue-axios";
import "vuetify/dist/vuetify.min.css";
import "highlight.js/styles/monokai.css";
import "@fortawesome/fontawesome-free/css/all.css";
import Vuetify from "vuetify";

Vue.use(Vuex);
Vue.use(VueRouter);
Vue.use(VueAxios, axios);
Vue.use(Vuetify);

/**
 * ローカルストレージからトークンを読み取り、axios の共通ヘッダへ反映
 */
function loadAuthTokens() {
  try {
    const saved = JSON.parse(localStorage.getItem("authTokens") || "{}");
    if (saved && saved["access-token"] && saved.client && saved.uid) {
      axios.defaults.headers.common["access-token"] = saved["access-token"];
      axios.defaults.headers.common["client"] = saved.client;
      axios.defaults.headers.common["uid"] = saved.uid;
    }
  } catch (e) {
    console.warn("Failed to parse authTokens:", e);
  }
}

/**
 * レスポンスヘッダに新しいトークンがあれば保存＆axios に反映
 */
function saveAuthTokensFromHeaders(headers) {
  const at = headers["access-token"];
  const cl = headers["client"];
  const uid = headers["uid"];
  if (at && cl && uid) {
    const next = { "access-token": at, client: cl, uid };
    localStorage.setItem("authTokens", JSON.stringify(next));
    axios.defaults.headers.common["access-token"] = at;
    axios.defaults.headers.common["client"] = cl;
    axios.defaults.headers.common["uid"] = uid;
  }
}

// 起動時にトークン読み込み
loadAuthTokens();

// 全レスポンスでトークン更新を拾う
axios.interceptors.response.use(
  (res) => {
    saveAuthTokensFromHeaders(res.headers || {});
    return res;
  },
  (err) => {
    // エラーレスポンス側にもトークンが載る場合があるため一応拾っておく
    if (err && err.response && err.response.headers) {
      saveAuthTokensFromHeaders(err.response.headers);
    }
    return Promise.reject(err);
  }
);

// サインアウト時に他のコンポーネントから使えるよう、ユーティリティを公開（任意）
Vue.prototype.$clearAuthTokens = () => {
  localStorage.removeItem("authTokens");
  delete axios.defaults.headers.common["access-token"];
  delete axios.defaults.headers.common["client"];
  delete axios.defaults.headers.common["uid"];
};
// ★ ここまで：axios 設定

const vuetify = new Vuetify();

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    store,
    router,
    vuetify,
    render: (h) => h(App),
  }).$mount();
  document.body.appendChild(app.$el);

  console.log(app);
});

/*
  （以下はテンプレのコメント。必要なら消してOK）
*/
