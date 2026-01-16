/* eslint no-console: 0 */
import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import store from "../store/store.js";
import router from "../router/router.js";
import App from "../app.vue";

import axios from "axios";
import VueAxios from "vue-axios";
import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";
import "highlight.js/styles/monokai.css";
import "@fortawesome/fontawesome-free/css/all.css";

Vue.use(Vuex);
Vue.use(VueRouter);
Vue.use(VueAxios, axios);
Vue.use(Vuetify);

/** ====== 認証トークンの共通設定 ====== */
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
loadAuthTokens();
axios.interceptors.response.use(
  (res) => {
    saveAuthTokensFromHeaders(res.headers || {});
    return res;
  },
  (err) => {
    if (err && err.response && err.response.headers) {
      saveAuthTokensFromHeaders(err.response.headers);
    }
    return Promise.reject(err);
  }
);
Vue.prototype.$clearAuthTokens = () => {
  localStorage.removeItem("authTokens");
  delete axios.defaults.headers.common["access-token"];
  delete axios.defaults.headers.common["client"];
  delete axios.defaults.headers.common["uid"];
};
/** ====== /認証トークン ====== */

let vueApp = null;
const mount = () => {
  const el = document.getElementById("app"); // ← このDOMにマウント（layoutやhome#indexで用意）
  if (!el) return;

  // 既にマウント済みなら一度破棄（Turbolinksで二重マウント防止）
  if (vueApp) {
    vueApp.$destroy();
    vueApp = null;
    el.innerHTML = "";
  }

  vueApp = new Vue({
    store,
    router,
    vuetify: new Vuetify(),
    render: (h) => h(App),
  }).$mount(el); // ← 直接 #app にマウント
};

// Turbolinks 使用時はこちらのイベントでOK
document.addEventListener("turbolinks:load", mount);

// Turbolinksを使っていない環境でも動く保険
document.addEventListener("DOMContentLoaded", mount);
