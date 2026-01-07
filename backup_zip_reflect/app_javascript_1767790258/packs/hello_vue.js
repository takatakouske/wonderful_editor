/* app/javascript/packs/hello_vue.js */

/* Polyfills （babel preset-env の useBuiltIns: 'entry' に対応） */
import 'core-js/stable';
import 'regenerator-runtime/runtime';

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

/* API は同一Rails内の /api/v1/* を叩く想定 */
axios.defaults.baseURL = "/api/v1";
axios.defaults.headers.common["Accept"] = "application/json";
axios.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest";
/* CSRF（通常のHTML画面から叩くとき用。meta が無ければ無視される） */
const csrf = document.querySelector('meta[name="csrf-token"]');
if (csrf) axios.defaults.headers.common["X-CSRF-Token"] = csrf.content;

/* turbolinks の有無どちらでも動くマウント関数 */
const mount = () => {
  const vuetify = new Vuetify();
  const target = document.getElementById("app"); // あればここへ、無ければ自動生成

  const app = new Vue({
    store,
    router,
    vuetify,
    render: h => h(App),
  });

  if (target) {
    app.$mount("#app");
  } else {
    const vm = app.$mount();          // 要素未指定でマウント
    document.body.appendChild(vm.$el); // 生成されたDOMを挿入
  }
};

/* turbolinks あり/なし双方に対応 */
if (window.Turbolinks) {
  document.addEventListener("turbolinks:load", mount);
} else {
  document.addEventListener("DOMContentLoaded", mount);
}
