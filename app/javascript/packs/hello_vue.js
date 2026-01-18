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

function initVue() {
  // #app が無くても動くように、仮に body 直下へマウントしてもOKにする
  const app = new Vue({
    store,
    router,
    vuetify,
    render: (h) => h(App),
  }).$mount(); // 要素指定なしで仮想DOM → 実DOM化
  document.body.appendChild(app.$el);
  // console.log(app); // 必要ならデバッグ
}

// すでに DOM 準備済みなら即時、未準備なら DOMContentLoaded でマウント
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initVue);
} else {
  initVue();
}
