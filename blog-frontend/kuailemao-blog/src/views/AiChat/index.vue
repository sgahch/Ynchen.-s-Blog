<script setup lang="ts">
const iframeUrl = "https://chat.baidu.com/";
</script>

<template>
  <Main only-father-container>
    <template #banner>
      <Banner title="AI问答" subtitle="AI Chat" />
    </template>
    <template #content>
      <div class="ai-chat">
        <div class="ai-header">
          <div>
            <div class="title">AI问答</div>
            <div class="subtitle">
              直接在站内使用百度智能问答，随时发起对话。
            </div>
          </div>
          <div class="hint">加载时间取决于网络状况，请稍候。</div>
        </div>
        <div class="frame-shell">
          <!-- 默认加载百度 AI -->
          <iframe
            id="frame"
            :src="iframeUrl"
            title="百度 AI 问答"
            allowfullscreen
            referrerpolicy="no-referrer"
          ></iframe>
        </div>
      </div>
    </template>
  </Main>
</template>

<style scoped lang="scss">
.ai-chat {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.ai-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  flex-wrap: wrap;
  gap: 0.75rem;

  .title {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--text-color);
  }

  .subtitle {
    margin-top: 0.35rem;
    color: var(--el-text-color-secondary);
    font-size: 0.95rem;
  }

  .hint {
    color: var(--el-color-primary);
    font-size: 0.9rem;
    background: rgba(64, 158, 255, 0.08);
    padding: 0.35rem 0.75rem;
    border-radius: 999px;
  }
}

.frame-shell {
  border-radius: 14px;
  overflow: hidden;
  background: linear-gradient(135deg, #eef5ff, #f5f7fb);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(64, 158, 255, 0.12);

  iframe {
    width: 100%;
    height: 72vh;
    min-height: 480px;
    border: none;
    display: block;
    background: #fff;
  }
}

@media screen and (max-width: 768px) {
  .frame-shell iframe {
    height: 70vh;
    min-height: 400px;
  }
}
</style>
