<template>
  <div id="articles-container">
    <div v-for="a in articles" :key="a.id">
      <v-card class="mb-5" style="margin:0 auto;" justify-center max-width="600">
        <v-card-title>{{ a.title }}</v-card-title>
        <v-divider class="mx-4"></v-divider>
        <v-card-text>
          最終更新: {{ formatDate(a.updated_at || a.updatedAt) }}
        </v-card-text>
      </v-card>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "ArticleList",
  data() {
    return { articles: [] };
  },
  async mounted() { await this.fetchArticles(); },
  methods: {
    async fetchArticles() {
      // hello_vue.js で baseURL="/api/v1" にしているのでここは '/articles'
      const res = await axios.get("/articles");
      const list = Array.isArray(res.data) ? res.data : (res.data.articles || []);
      this.articles = list;
    },
    formatDate(iso) {
      try { return new Date(iso).toLocaleString(); } catch { return ""; }
    }
  }
}
</script>

<style scoped></style>
