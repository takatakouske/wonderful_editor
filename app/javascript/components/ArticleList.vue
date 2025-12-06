<<!-- app/javascript/components/ArticleList.vue -->
<template>
  <div id="articles-container">
    <div v-for="a in articles" :key="a.id">
      <v-card class="mb-5" style="margin:0 auto;" justify-center max-width="600">
        <v-card-title>{{ a.title }}</v-card-title>
        <v-divider class="mx-4"></v-divider>
        <!-- 一覧は本文を含めない仕様なので updated_at を表示 -->
        <v-card-text>更新: {{ a.updated_at }}</v-card-text>
      </v-card>
    </div>
  </div>
</template>

<script>
import axios from "axios"
export default {
  data() { return { articles: [] } },
  async mounted() {
    try {
      // 先頭に / を付けない（baseURL="/api/v1" が前に付く）
      const res = await axios.get("articles")
      const payload = res.data.articles || res.data
      this.articles = Array.isArray(payload) ? payload : []
    } catch (e) {
      console.error("fetchArticles failed:", e)
    }
  }
}
</script>
