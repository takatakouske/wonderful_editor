<template>
  <v-app>
    <div class="header">
      <Header />
    </div>

    <!-- Vuetifyのコンテンツ領域 -->
    <v-main>
      <div class="layout">
        <router-view />
      </div>
    </v-main>
  </v-app>
</template>

<script>
import Header from "./components/layout/Header.vue";

export default {
  name: "AppRoot",
  components: { Header },
};
</script>

<style scoped>
.header {
  /* ヘッダー分の余白（v-app-bar app を想定） */
  margin-bottom: 70px;
}

.layout {
  background: #ecf6fe;
  min-height: 100vh; /* 画面全体を覆う */
}
</style>

<style lang="scss">
/* ====== グローバル調整（Vuetify / Highlight.js） ====== */
.v-application code,
.v-application kbd {
  border-radius: initial !important;
  font-size: initial !important;
  font-weight: initial !important;
}

.hljs {
  background-color: #23241f !important;
  padding: 0.5em !important;
}

.hljs,
.hljs-tag,
.hljs-subst {
  color: #fff !important;
}

/* highlight.js の 1行目のずれ対策 */
code:before {
  content: none !important;
}

.hljs span:first-child {
  position: relative;
  left: -2px;
}

.preview,
.article_detail {
  h2 {
    border-bottom: 1px solid rgba(0, 0, 0, 0.42);
    margin: 30px 0 10px;
  }

  h3 {
    margin: 30px 0 10px;
  }

  h4 {
    margin: 15px 0 10px;
  }

  p {
    margin: 20px 0;
  }

  pre {
    margin: 10px 0;
  }
}
</style>
