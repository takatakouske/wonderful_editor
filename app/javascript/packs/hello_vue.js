/* eslint no-console: 0 */

import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import store from "../store/store.js";
import router from "../router/router.js";
import App from "../app.vue";

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

// --- 省略していたトークン処理はそのまま（あなたの現状コードでOK） ---
// もし入れていれば loadAuthTokens()/interceptors などは残してください。

const vuetify = new Vuetify();

// ★ マウント処理を関数化（#app があればそこに、無ければ body に挿す）
function mountVueApp() {
  // すでにマウント済みなら二重起動を避ける
  if (document.getElementById("vue-app-mounted-flag")) return;

  const app = new Vue({
    store,
    router,
    vuetify,
    render: (h) => h(App),
  });

  const mountTarget = document.getElementById("app");
  if (mountTarget) {
    app.$mount("#app");
  } else {
    const el = app.$mount().$el;
    document.body.appendChild(el);
  }

  // 二重マウント防止用のフラグ
  const flag = document.createElement("meta");
  flag.id = "vue-app-mounted-flag";
  document.head.appendChild(flag);

  console.log("Vue app mounted.");
}

// ★ Turbolinks と通常の両方に対応
document.addEventListener("turbolinks:load", mountVueApp);
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", mountVueApp);
} else {
  // 既に読み込み済みなら即実行
  mountVueApp();
}
