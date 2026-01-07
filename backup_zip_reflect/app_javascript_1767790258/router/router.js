import Vue from "vue";
import Router from "vue-router";
import ArticleList from "../components/ArticleList.vue";

Vue.use(Router);

export default new Router({
  mode: "history",
  routes: [{ path: "/", component: ArticleList }]
});
