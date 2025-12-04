import Vue from "vue";
import Router from "vue-router";
import ArticleList from "../components/ArticleList.vue"; // ← components（綴り注意）

Vue.use(Router);

export default new Router({
  mode: "history",   // URLをキレイに（#/ を使わない）
  routes: [
    { path: "/", name: "articles", component: ArticleList },
  ],
});

