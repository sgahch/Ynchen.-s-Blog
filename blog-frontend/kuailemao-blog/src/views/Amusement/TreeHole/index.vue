<script setup lang="ts">
import vueDanmaku from "vue3-danmaku";
import { addTreeHole, getTreeHoleList } from "@/apis/treeHole";
import { ElMessage } from "element-plus";

const treeHoleList = ref([]);
// 是否显示提交按钮
const isShowSubmit = ref(false);
const content = ref("");
// 输入框聚焦状态
const isFocused = ref(false);
// 提交按钮加载状态
const isSubmitting = ref(false);
// textarea 引用
const textareaRef = ref<HTMLTextAreaElement | null>(null);

// 弹幕随机颜色主题
const colorThemes = [
  {
    bg: "rgba(139, 92, 246, 0.15)",
    border: "rgba(139, 92, 246, 0.3)",
    text: "#a78bfa",
    glow: "0 0 20px rgba(139, 92, 246, 0.4)",
  },
  {
    bg: "rgba(236, 72, 153, 0.15)",
    border: "rgba(236, 72, 153, 0.3)",
    text: "#f472b6",
    glow: "0 0 20px rgba(236, 72, 153, 0.4)",
  },
  {
    bg: "rgba(59, 130, 246, 0.15)",
    border: "rgba(59, 130, 246, 0.3)",
    text: "#60a5fa",
    glow: "0 0 20px rgba(59, 130, 246, 0.4)",
  },
  {
    bg: "rgba(16, 185, 129, 0.15)",
    border: "rgba(16, 185, 129, 0.3)",
    text: "#34d399",
    glow: "0 0 20px rgba(16, 185, 129, 0.4)",
  },
  {
    bg: "rgba(251, 146, 60, 0.15)",
    border: "rgba(251, 146, 60, 0.3)",
    text: "#fb923c",
    glow: "0 0 20px rgba(251, 146, 60, 0.4)",
  },
];

// 生成星星粒子
const stars = ref(
  Array.from({ length: 50 }, (_, i) => ({
    id: i,
    left: Math.random() * 100,
    top: Math.random() * 100,
    size: Math.random() * 3 + 1,
    duration: Math.random() * 3 + 2,
    delay: Math.random() * 2,
  }))
);

onMounted(() => {
  getTreeHole();
});

// 监听内容变化，自动调整 textarea 高度
watch(content, () => {
  nextTick(() => {
    autoResizeTextarea();
  });
});

// 自动调整 textarea 高度
function autoResizeTextarea() {
  const textarea = document.querySelector(
    ".auto-resize-textarea"
  ) as HTMLTextAreaElement;
  if (textarea) {
    textarea.style.height = "auto";
    textarea.style.height = textarea.scrollHeight + "px";
  }
}

// 为每条弹幕分配随机颜色主题
function getRandomTheme() {
  return colorThemes[Math.floor(Math.random() * colorThemes.length)];
}

function addTreeHoleBtn() {
  if (content.value.trim() === "") {
    ElMessage.warning("请输入内容");
    return;
  }

  isSubmitting.value = true;
  addTreeHole(content.value)
    .then((res) => {
      if (res.code === 200) {
        ElMessage.success("添加成功");
        getTreeHole();
        content.value = "";
        isShowSubmit.value = false;
        isFocused.value = false;
        // 重置 textarea 高度
        nextTick(() => {
          const textarea = document.querySelector(
            ".auto-resize-textarea"
          ) as HTMLTextAreaElement;
          if (textarea) {
            textarea.style.height = "auto";
          }
        });
      } else {
        ElMessage.error(res.msg);
      }
    })
    .finally(() => {
      isSubmitting.value = false;
    });
}

function getTreeHole() {
  getTreeHoleList().then((res) => {
    if (res.code === 200) {
      // 为每条数据添加随机主题
      treeHoleList.value = res.data.map((item: any) => ({
        ...item,
        theme: getRandomTheme(),
      }));
    }
  });
}

function handleFocus() {
  isFocused.value = true;
  isShowSubmit.value = true;
}

function handleBlur() {
  // 只有在没有输入内容时才缩回
  if (!content.value.trim()) {
    isFocused.value = false;
    isShowSubmit.value = false;
  }
}
</script>
<template>
  <div class="container">
    <!-- 背景装饰层 -->
    <div class="bg-decorations">
      <!-- 渐变光斑 -->
      <div class="gradient-orb orb-1"></div>
      <div class="gradient-orb orb-2"></div>
      <div class="gradient-orb orb-3"></div>

      <!-- 星星粒子 -->
      <div
        v-for="star in stars"
        :key="star.id"
        class="star"
        :style="{
          left: star.left + '%',
          top: star.top + '%',
          width: star.size + 'px',
          height: star.size + 'px',
          animationDuration: star.duration + 's',
          animationDelay: star.delay + 's',
        }"
      ></div>
    </div>

    <!-- 中央输入卡片 -->
    <div class="content_container" :class="{ focused: isFocused }">
      <div class="card-glass">
        <h1 class="title">
          <span class="title-icon">✨</span>
          树洞
          <span class="title-icon">✨</span>
        </h1>
        <p class="subtitle">说出你的心里话，让它随风飘散...</p>

        <div class="input-wrapper">
          <div class="input-container">
            <span class="input-icon">💭</span>
            <textarea
              v-model="content"
              @focus="handleFocus"
              @blur="handleBlur"
              placeholder="在这里留下自己的足迹吧..."
              maxlength="200"
              rows="1"
              class="auto-resize-textarea"
            ></textarea>
          </div>
          <transition name="button-slide">
            <button
              v-show="isShowSubmit"
              @click="addTreeHoleBtn"
              :disabled="isSubmitting"
              class="submit-btn"
            >
              <span v-if="!isSubmitting">发送</span>
              <span v-else class="loading">发送中...</span>
            </button>
          </transition>
        </div>
      </div>
    </div>

    <!-- 弹幕层 -->
    <vue-danmaku
      :debounce="3000"
      random-channel
      :speeds="80"
      :channels="5"
      is-suspend
      v-model:danmus="treeHoleList"
      use-slot
      loop
      style="height: 100vh; width: 100vw"
    >
      <template v-slot:dm="{ danmu }">
        <div
          class="barrage_container"
          :style="{
            '--theme-bg': danmu.theme?.bg,
            '--theme-border': danmu.theme?.border,
            '--theme-text': danmu.theme?.text,
            '--theme-glow': danmu.theme?.glow,
          }"
        >
          <div class="avatar-wrapper">
            <el-avatar :src="danmu.avatar" class="avatar" />
            <div class="avatar-ring"></div>
          </div>
          <div class="message-content">
            <span class="nickname">{{ danmu.nickname }}</span>
            <span class="separator">·</span>
            <span class="text">{{ danmu.content }}</span>
          </div>
        </div>
      </template>
    </vue-danmaku>
  </div>
</template>

<style scoped lang="scss">
// ========== 容器和背景 ==========
.container {
  position: relative;
  min-width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: linear-gradient(
    135deg,
    #667eea 0%,
    #764ba2 25%,
    #f093fb 50%,
    #4facfe 75%,
    #667eea 100%
  );
  background-size: 400% 400%;
  animation: gradientShift 15s ease infinite;

  // 叠加原背景图片（半透明）
  &::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-image: url("http://8.148.31.90:9000/blog/banners/77744e98-032e-48f9-8c1e-17558d0c4be2.jpg");
    background-size: cover;
    background-position: center;
    opacity: 0.3;
    z-index: 0;
  }
}

// ========== 背景装饰层 ==========
.bg-decorations {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
  overflow: hidden;
}

// 渐变光斑
.gradient-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.6;
  animation: float 20s ease-in-out infinite;

  &.orb-1 {
    width: 400px;
    height: 400px;
    background: radial-gradient(circle, rgba(139, 92, 246, 0.8), transparent);
    top: -10%;
    left: -10%;
    animation-delay: 0s;
  }

  &.orb-2 {
    width: 500px;
    height: 500px;
    background: radial-gradient(circle, rgba(236, 72, 153, 0.6), transparent);
    bottom: -15%;
    right: -15%;
    animation-delay: 7s;
  }

  &.orb-3 {
    width: 350px;
    height: 350px;
    background: radial-gradient(circle, rgba(59, 130, 246, 0.7), transparent);
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    animation-delay: 3.5s;
  }
}

// 星星粒子
.star {
  position: absolute;
  background: white;
  border-radius: 50%;
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.8);
  animation: twinkle linear infinite;
}

// ========== 中央输入卡片 ==========
.content_container {
  position: absolute;
  top: 35%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 2;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);

  &.focused {
    transform: translate(-50%, -50%) scale(1.02);
  }
}

.card-glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 2.5rem 3rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1),
    0 0 0 1px rgba(255, 255, 255, 0.1) inset, 0 0 60px rgba(139, 92, 246, 0.3);
  min-width: 500px;
  animation: cardFadeIn 0.8s ease-out;
}

.title {
  color: white;
  font-size: 2.5rem;
  font-weight: 700;
  text-align: center;
  margin: 0 0 0.5rem 0;
  background: linear-gradient(135deg, #fff, #e0e7ff, #fff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 0 30px rgba(255, 255, 255, 0.5);
  letter-spacing: 0.3rem;
  animation: titleGlow 3s ease-in-out infinite;

  .title-icon {
    display: inline-block;
    animation: iconFloat 2s ease-in-out infinite;
    font-size: 2rem;
  }
}

.subtitle {
  color: rgba(255, 255, 255, 0.8);
  text-align: center;
  font-size: 0.95rem;
  margin: 0 0 2rem 0;
  font-weight: 300;
  letter-spacing: 0.05rem;
}

// ========== 输入区域 ==========
.input-wrapper {
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
}

.input-container {
  position: relative;
  flex: 1;
  display: flex;
  align-items: flex-start;

  .input-icon {
    position: absolute;
    left: 1.2rem;
    top: 1rem;
    font-size: 1.3rem;
    pointer-events: none;
    z-index: 1;
    animation: iconPulse 2s ease-in-out infinite;
  }

  textarea {
    width: 100%;
    min-height: 3.2rem;
    max-height: 200px;
    padding: 0.9rem 1.5rem 0.9rem 3.5rem;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 24px;
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(10px);
    color: white;
    font-size: 1rem;
    font-family: inherit;
    line-height: 1.5;
    outline: none;
    resize: none;
    overflow-y: auto;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);

    &::placeholder {
      color: rgba(255, 255, 255, 0.6);
      font-style: italic;
    }

    &:focus {
      border-color: rgba(255, 255, 255, 0.6);
      background: rgba(255, 255, 255, 0.2);
      box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.2),
        0 8px 25px rgba(0, 0, 0, 0.15);
      transform: translateY(-2px);
    }

    &:hover {
      border-color: rgba(255, 255, 255, 0.5);
    }

    // 美化滚动条
    &::-webkit-scrollbar {
      width: 6px;
    }

    &::-webkit-scrollbar-track {
      background: rgba(255, 255, 255, 0.1);
      border-radius: 10px;
    }

    &::-webkit-scrollbar-thumb {
      background: rgba(255, 255, 255, 0.3);
      border-radius: 10px;

      &:hover {
        background: rgba(255, 255, 255, 0.5);
      }
    }
  }
}

// ========== 提交按钮 ==========
.submit-btn {
  height: 3.2rem;
  min-height: 3.2rem;
  padding: 0 2rem;
  border: none;
  border-radius: 50px;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  font-size: 1rem;
  flex-shrink: 0;
  font-weight: 600;
  cursor: pointer;
  outline: none;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4),
    0 0 0 1px rgba(255, 255, 255, 0.1) inset;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;

  &::before {
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.3);
    transform: translate(-50%, -50%);
    transition: width 0.6s, height 0.6s;
  }

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 25px rgba(102, 126, 234, 0.6),
      0 0 0 1px rgba(255, 255, 255, 0.2) inset;

    &::before {
      width: 300px;
      height: 300px;
    }
  }

  &:active {
    transform: translateY(0);
  }

  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
  }

  .loading {
    display: inline-block;
    animation: pulse 1.5s ease-in-out infinite;
  }
}

// 按钮滑入动画
.button-slide-enter-active,
.button-slide-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.button-slide-enter-from {
  opacity: 0;
  transform: translateX(20px);
}

.button-slide-leave-to {
  opacity: 0;
  transform: translateX(20px);
}

// ========== 弹幕样式 ==========
.barrage_container {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1.25rem;
  background: var(--theme-bg, rgba(255, 255, 255, 0.15));
  backdrop-filter: blur(12px) saturate(180%);
  -webkit-backdrop-filter: blur(12px) saturate(180%);
  border-radius: 50px;
  border: 1px solid var(--theme-border, rgba(255, 255, 255, 0.3));
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15),
    0 0 0 1px rgba(255, 255, 255, 0.1) inset;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  position: relative;
  overflow: hidden;

  &::before {
    content: "";
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(
      90deg,
      transparent,
      rgba(255, 255, 255, 0.2),
      transparent
    );
    transition: left 0.5s;
  }

  &:hover {
    transform: translateY(-3px) scale(1.02);
    box-shadow: var(--theme-glow, 0 0 20px rgba(139, 92, 246, 0.4)),
      0 8px 30px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(255, 255, 255, 0.2) inset;
    border-color: var(--theme-text, rgba(255, 255, 255, 0.5));

    &::before {
      left: 100%;
    }

    .avatar-ring {
      transform: scale(1.1);
      opacity: 1;
    }
  }
}

.avatar-wrapper {
  position: relative;
  flex-shrink: 0;

  .avatar {
    width: 40px;
    height: 40px;
    border: 2px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    transition: all 0.3s ease;
  }

  .avatar-ring {
    position: absolute;
    top: -3px;
    left: -3px;
    right: -3px;
    bottom: -3px;
    border-radius: 50%;
    border: 2px solid var(--theme-text, #a78bfa);
    opacity: 0;
    transition: all 0.3s ease;
    animation: ringPulse 2s ease-in-out infinite;
  }
}

.message-content {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
  min-width: 0;

  .nickname {
    color: var(--theme-text, #a78bfa);
    font-weight: 600;
    font-size: 0.95rem;
    text-shadow: 0 0 10px var(--theme-text, #a78bfa);
    flex-shrink: 0;
  }

  .separator {
    color: rgba(255, 255, 255, 0.5);
    font-size: 0.9rem;
    flex-shrink: 0;
  }

  .text {
    color: white;
    font-size: 1.05rem;
    line-height: 1.5;
    word-break: break-word;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
  }
}

// ========== 动画关键帧 ==========
@keyframes gradientShift {
  0%,
  100% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
}

@keyframes float {
  0%,
  100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(30px, -30px) scale(1.1);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.9);
  }
}

@keyframes twinkle {
  0%,
  100% {
    opacity: 0.3;
    transform: scale(1);
  }
  50% {
    opacity: 1;
    transform: scale(1.2);
  }
}

@keyframes cardFadeIn {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes titleGlow {
  0%,
  100% {
    text-shadow: 0 0 20px rgba(255, 255, 255, 0.5),
      0 0 40px rgba(139, 92, 246, 0.3);
  }
  50% {
    text-shadow: 0 0 30px rgba(255, 255, 255, 0.8),
      0 0 60px rgba(139, 92, 246, 0.5);
  }
}

@keyframes iconFloat {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-5px);
  }
}

@keyframes iconPulse {
  0%,
  100% {
    transform: scale(1);
    opacity: 0.8;
  }
  50% {
    transform: scale(1.1);
    opacity: 1;
  }
}

@keyframes pulse {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

@keyframes ringPulse {
  0%,
  100% {
    transform: scale(1);
    opacity: 0.5;
  }
  50% {
    transform: scale(1.15);
    opacity: 0.8;
  }
}

// ========== 响应式设计 ==========
@media screen and (max-width: 768px) {
  .card-glass {
    min-width: auto;
    width: 90vw;
    padding: 2rem 1.5rem;
  }

  .title {
    font-size: 2rem;

    .title-icon {
      font-size: 1.5rem;
    }
  }

  .subtitle {
    font-size: 0.85rem;
    margin-bottom: 1.5rem;
  }

  .input-wrapper {
    flex-direction: column;
    gap: 0.5rem;
  }

  .input-container {
    width: 100%;

    textarea {
      min-height: 2.8rem;
      font-size: 0.9rem;
      padding: 0.7rem 1.2rem 0.7rem 3rem;
    }

    .input-icon {
      font-size: 1.1rem;
      left: 1rem;
      top: 0.8rem;
    }
  }

  .submit-btn {
    width: 100%;
    height: 2.8rem;
  }

  .barrage_container {
    padding: 0.6rem 1rem;
    gap: 0.5rem;
  }

  .avatar-wrapper .avatar {
    width: 35px;
    height: 35px;
  }

  .message-content {
    .nickname {
      font-size: 0.85rem;
    }

    .text {
      font-size: 0.95rem;
    }
  }

  .gradient-orb {
    &.orb-1 {
      width: 250px;
      height: 250px;
    }

    &.orb-2 {
      width: 300px;
      height: 300px;
    }

    &.orb-3 {
      width: 200px;
      height: 200px;
    }
  }
}

@media screen and (max-width: 480px) {
  .content_container {
    top: 30%;
  }

  .card-glass {
    padding: 1.5rem 1rem;
  }

  .title {
    font-size: 1.5rem;
    letter-spacing: 0.15rem;
  }

  .subtitle {
    font-size: 0.8rem;
  }
}
</style>
