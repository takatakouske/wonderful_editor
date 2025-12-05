import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import App from "../app.vue";
import router from "../router/router.js";
import store from "../store/store.js";

import axios from "axios";
import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";

Vue.use(Vuex);
Vue.use(VueRouter);
Vue.use(Vuetify);

// API は同一Rails内の /api/v1/* を叩く想定
axios.defaults.baseURL = "/api/v1";

// turbolinks の有無どちらでも動くようにマウント関数を定義
const mount = () => {
  // Vuetifyインスタンス
  const vuetify = new Vuetify();

  // Vueアプリを生成して「要素未指定」でマウント（＝仮想DOM要素を返す）
  const app = new Vue({
    store,
    router,
    vuetify,
    render: h => h(App),
  }).$mount();

  // 生成された実DOM要素を body 末尾に挿入
  document.body.appendChild(app.$el);
};

// turbolinks あり/なし双方に対応
if (window.Turbolinks) {
  document.addEventListener("turbolinks:load", mount);
} else {
  document.addEventListener("DOMContentLoaded", mount);
}
