<script setup lang="ts">
import JSConfetti from "js-confetti";
import useWebsiteStore from "@/store/modules/website.ts";

const jsConfetti = new JSConfetti();
jsConfetti.addConfetti();

const websiteStore = useWebsiteStore();

// 打字机效果文本
const typedText = ref("");
const fullText =
  "Life is a movie with an unwritten script and no director, a chaotic mix of comedy, tragedy, and long, quiet scenes. So don't take any single act too seriously; the whole point is just to have some fun before the credits roll.";
const typingSpeed = 50; // 打字速度（毫秒）
const isTypingComplete = ref(false);

// 技能标签
const skills = ref([
  { name: "Vue.js", color: "#42b883", icon: "🎯" },
  { name: "TypeScript", color: "#3178c6", icon: "📘" },
  { name: "Node.js", color: "#68a063", icon: "🚀" },
  { name: "Java", color: "#f89820", icon: "☕" },
  { name: "Spring Boot", color: "#6db33f", icon: "🍃" },
  { name: "MySQL", color: "#4479a1", icon: "🗄️" },
  { name: "Redis", color: "#dc382d", icon: "⚡" },
  { name: "Docker", color: "#2496ed", icon: "🐳" },
]);

// 社交链接数据
const socialLinks = ref([
  {
    name: "GitHub",
    icon: "github_icon",
    url: "https://github.com/sgahch",
    color: "#333",
  },
  {
    name: "Gitee",
    icon: "gitee_icon",
    url: "https://gitee.com/Ynchenhq",
    color: "#c71d23",
  },
  {
    name: "Bilibili",
    icon: "bilibili_icon",
    url: "https://space.bilibili.com/3546574317684872?spm_id_from=333.1387.0.0",
    color: "#00a1d6",
  },
  {
    name: "CSDN",
    icon: "csdn_icon",
    url: "https://blog.csdn.net/2402_88603680?type=blog",
    color: "#fc5531",
  },
]);

// 打字机效果
onMounted(() => {
  let index = 0;
  const typeWriter = () => {
    if (index < fullText.length) {
      typedText.value += fullText.charAt(index);
      index++;
      setTimeout(typeWriter, typingSpeed);
    } else {
      isTypingComplete.value = true;
    }
  };
  setTimeout(typeWriter, 1000); // 延迟1秒开始打字
});
</script>

<template>
  <div class="about-container">
    <!-- 动态背景层 -->
    <div class="bg-animated">
      <div class="gradient-bg"></div>
      <div class="grid-overlay"></div>
      <div class="particles">
        <div
          v-for="i in 30"
          :key="i"
          class="particle"
          :style="{
            left: Math.random() * 100 + '%',
            top: Math.random() * 100 + '%',
            animationDelay: Math.random() * 3 + 's',
            animationDuration: Math.random() * 3 + 2 + 's',
          }"
        ></div>
      </div>
    </div>

    <!-- 主内容区 -->
    <div class="content-wrapper">
      <div
        class="flex justify-center items-center max-lg:flex-col h-full w-full xl:w-[90%]"
      >
        <!-- 左侧：头像和名字 -->
        <div
          class="w-[40%] max-lg:w-full h-full flex flex-col justify-center items-center left-section"
        >
          <!-- 头像容器 -->
          <div class="avatar-container">
            <div class="avatar-glow-ring"></div>
            <div class="avatar-glow-ring ring-2"></div>
            <div class="avatar-wrapper">
              <div
                class="avatar-image"
                :style="{
                  'background-image':
                    'url(' + websiteStore.webInfo?.webmasterAvatar + ')',
                }"
              ></div>
            </div>
          </div>

          <!-- 名字 -->
          <div class="name-container">
            <h1
              class="name-text"
              :data-shadow="websiteStore.webInfo?.webmasterName"
            >
              {{ websiteStore.webInfo?.webmasterName }}
            </h1>
          </div>

          <!-- 副标题 -->
          <div class="subtitle-text">I'm here waiting for u. ✨</div>

          <!-- 技能标签云 -->
          <div class="skills-container">
            <div
              v-for="(skill, index) in skills"
              :key="skill.name"
              class="skill-tag"
              :style="{
                animationDelay: index * 0.1 + 's',
                '--skill-color': skill.color,
              }"
            >
              <span class="skill-icon">{{ skill.icon }}</span>
              <span class="skill-name">{{ skill.name }}</span>
            </div>
          </div>
        </div>
        <!-- 右侧：介绍和社交链接 -->
        <div
          class="flex flex-col justify-center items-center xl:w-[40%] lg:w-[60%] h-full right-section"
        >
          <!-- 介绍卡片 -->
          <div class="intro-card">
            <div class="intro-title">
              一名中二Web全栈小白
              <span class="version-badge">v3.0</span>
            </div>
            <div class="intro-description">
              <span class="typed-text">{{ typedText }}</span>
              <span v-if="!isTypingComplete" class="typing-cursor">|</span>
            </div>
          </div>
          <!-- 社交链接区域 -->
          <div class="social-section">
            <div class="section-title">
              <span class="title-line"></span>
              <span class="title-text">我的个人导航</span>
              <span class="title-line"></span>
            </div>
            <div class="social-links">
              <a
                v-for="(link, index) in socialLinks"
                :key="link.name"
                :href="link.url"
                target="_blank"
                class="social-link-item"
                :style="{ animationDelay: index * 0.1 + 's' }"
              >
                <div
                  class="social-card"
                  :style="{ '--social-color': link.color }"
                >
                  <div class="social-icon-wrapper">
                    <SvgIcon :name="link.icon" width="80px" height="80px" />
                  </div>
                  <div class="social-name">{{ link.name }}</div>
                </div>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
@import url(https://fonts.googleapis.com/css?family=Righteous);

// ========== 全局样式 ==========
*,
*:before,
*:after {
  box-sizing: border-box;
}

// ========== 容器和背景 ==========
.about-container {
  position: relative;
  width: 100%;
  min-height: 100vh;
  height: 100%;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
}

// 动态背景
.bg-animated {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  overflow: hidden;
}

// 渐变背景
.gradient-bg {
  position: absolute;
  width: 100%;
  height: 100%;
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
}

// 网格叠加层
.grid-overlay {
  position: absolute;
  width: 100%;
  height: 100%;
  background-image: linear-gradient(
      rgba(255, 255, 255, 0.05) 1px,
      transparent 1px
    ),
    linear-gradient(90deg, rgba(255, 255, 255, 0.05) 1px, transparent 1px);
  background-size: 50px 50px;
  animation: gridMove 20s linear infinite;
}

// 粒子效果
.particles {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.particle {
  position: absolute;
  width: 4px;
  height: 4px;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 50%;
  animation: particleFloat 3s ease-in-out infinite;
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
}

// 主内容区
.content-wrapper {
  position: fixed;
  z-index: 1;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 2rem 0;
}

// ========== 左侧区域样式 ==========
.left-section {
  animation: fadeInLeft 1s ease-out;
}

// 头像容器
.avatar-container {
  position: relative;
  margin-top: 3rem;
  margin-bottom: 2rem;
}

// 头像光环
.avatar-glow-ring {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 22rem;
  height: 22rem;
  border-radius: 50%;
  border: 3px solid rgba(255, 255, 255, 0.3);
  animation: ringPulse 3s ease-in-out infinite;

  &.ring-2 {
    width: 24rem;
    height: 24rem;
    border: 2px solid rgba(255, 255, 255, 0.2);
    animation: ringPulse 3s ease-in-out infinite reverse;
  }
}

// 头像包装器
.avatar-wrapper {
  position: relative;
  width: 20rem;
  height: 20rem;
  border-radius: 50%;
  overflow: hidden;
  box-shadow: 0 0 40px rgba(255, 255, 255, 0.3),
    0 0 80px rgba(102, 126, 234, 0.4), 0 20px 60px rgba(0, 0, 0, 0.3);
  animation: avatarFloat 4s ease-in-out infinite;
  transition: transform 0.3s ease;

  &:hover {
    transform: scale(1.05);
  }
}

// 头像图片
.avatar-image {
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  animation: avatarGlow 3s ease-in-out infinite;
}

// 名字容器
.name-container {
  margin: 1.5rem 0 1rem;
}

.name-text {
  display: inline-block;
  color: white;
  font-family: "Righteous", serif;
  font-size: 4rem;
  text-shadow: 0.03em 0.03em 0 hsla(230, 40%, 50%, 1),
    0 0 20px rgba(255, 255, 255, 0.5);
  animation: nameGlow 2s ease-in-out infinite;
  position: relative;

  &:after {
    content: attr(data-shadow);
    position: absolute;
    top: 0.06em;
    left: 0.06em;
    z-index: -1;
    text-shadow: none;
    background-image: linear-gradient(
      45deg,
      transparent 45%,
      hsla(48, 20%, 90%, 1) 45%,
      hsla(48, 20%, 90%, 1) 55%,
      transparent 0
    );
    background-size: 0.05em 0.05em;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    animation: shadAnim 15s linear infinite;
  }
}

// 副标题
.subtitle-text {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.2rem;
  font-weight: 600;
  text-align: center;
  margin-bottom: 2rem;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  animation: fadeIn 1.5s ease-out;
}

// 技能标签云
.skills-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 0.8rem;
  max-width: 500px;
  margin-top: 1rem;
  padding: 0 1rem;
}

.skill-tag {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.6rem 1.2rem;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 20px;
  color: white;
  font-size: 0.9rem;
  font-weight: 500;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  animation: skillFadeIn 0.6s ease-out backwards;
  cursor: default;

  &:hover {
    transform: translateY(-3px) scale(1.05);
    background: rgba(255, 255, 255, 0.25);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2),
      0 0 20px var(--skill-color, rgba(255, 255, 255, 0.5));
    border-color: var(--skill-color, rgba(255, 255, 255, 0.5));
  }

  .skill-icon {
    font-size: 1.2rem;
  }

  .skill-name {
    white-space: nowrap;
  }
}

// ========== 右侧区域样式 ==========
.right-section {
  animation: fadeInRight 1s ease-out;
}

// 介绍卡片
.intro-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 24px;
  padding: 2.5rem 3rem;
  margin-bottom: 3rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1), 0 0 60px rgba(102, 126, 234, 0.2);
  animation: cardFadeIn 1.2s ease-out;
  transition: transform 0.3s ease;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15),
      0 0 80px rgba(102, 126, 234, 0.3);
  }
}

.intro-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: white;
  text-align: center;
  margin-bottom: 1.5rem;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;

  .version-badge {
    display: inline-block;
    padding: 0.3rem 0.8rem;
    background: linear-gradient(135deg, #667eea, #764ba2);
    border-radius: 12px;
    font-size: 1rem;
    font-weight: 600;
    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    animation: badgePulse 2s ease-in-out infinite;
  }
}

.intro-description {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.1rem;
  line-height: 1.8;
  text-align: center;
  min-height: 120px;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);

  .typed-text {
    display: inline;
  }

  .typing-cursor {
    display: inline-block;
    margin-left: 2px;
    animation: blink 1s step-end infinite;
    font-weight: bold;
    color: rgba(255, 255, 255, 0.9);
  }
}

// 社交链接区域
.social-section {
  width: 100%;
  padding: 2rem 0;
}

.section-title {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 2.5rem;

  .title-line {
    flex: 1;
    max-width: 100px;
    height: 2px;
    background: linear-gradient(
      to right,
      transparent,
      rgba(255, 255, 255, 0.5),
      transparent
    );
  }

  .title-text {
    color: rgba(255, 255, 255, 0.9);
    font-size: 1.2rem;
    font-weight: 600;
    white-space: nowrap;
    text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  }
}

.social-links {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 2rem;
  flex-wrap: wrap;
  padding: 0 1rem;
}

.social-link-item {
  text-decoration: none;
  animation: socialFadeIn 0.8s ease-out backwards;
}

.social-card {
  position: relative;
  width: 130px;
  height: 130px;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(10px);
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  cursor: pointer;
  overflow: hidden;

  &::before {
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) scale(0);
    width: 100%;
    height: 100%;
    background: radial-gradient(
      circle,
      var(--social-color, rgba(255, 255, 255, 0.3)) 0%,
      transparent 70%
    );
    opacity: 0;
    transition: all 0.5s ease;
    border-radius: 20px;
  }

  &:hover {
    transform: translateY(-10px) rotateY(10deg) scale(1.1);
    border-color: var(--social-color, rgba(255, 255, 255, 0.6));
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3),
      0 0 30px var(--social-color, rgba(255, 255, 255, 0.5));

    &::before {
      transform: translate(-50%, -50%) scale(1);
      opacity: 0.3;
    }

    .social-icon-wrapper {
      transform: scale(1.1) rotate(5deg);
    }

    .social-name {
      opacity: 1;
      transform: translateY(0);
    }
  }
}

.social-icon-wrapper {
  transition: transform 0.4s ease;
}

.social-name {
  color: white;
  font-size: 0.95rem;
  font-weight: 600;
  opacity: 0.8;
  transition: all 0.3s ease;
  text-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
  transform: translateY(5px);
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

@keyframes gridMove {
  0% {
    transform: translate(0, 0);
  }
  100% {
    transform: translate(50px, 50px);
  }
}

@keyframes particleFloat {
  0%,
  100% {
    transform: translateY(0) scale(1);
    opacity: 0.3;
  }
  50% {
    transform: translateY(-20px) scale(1.2);
    opacity: 1;
  }
}

@keyframes fadeInLeft {
  from {
    opacity: 0;
    transform: translateX(-50px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeInRight {
  from {
    opacity: 0;
    transform: translateX(50px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@keyframes ringPulse {
  0%,
  100% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.5;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.1);
    opacity: 0.8;
  }
}

@keyframes avatarFloat {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

@keyframes avatarGlow {
  0%,
  100% {
    filter: brightness(1);
  }
  50% {
    filter: brightness(1.1);
  }
}

@keyframes nameGlow {
  0%,
  100% {
    text-shadow: 0.03em 0.03em 0 hsla(230, 40%, 50%, 1),
      0 0 20px rgba(255, 255, 255, 0.5);
  }
  50% {
    text-shadow: 0.03em 0.03em 0 hsla(230, 40%, 50%, 1),
      0 0 30px rgba(255, 255, 255, 0.8);
  }
}

@keyframes shadAnim {
  0% {
    background-position: 0 0;
  }
  100% {
    background-position: 100% -100%;
  }
}

@keyframes skillFadeIn {
  from {
    opacity: 0;
    transform: translateY(20px) scale(0.8);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
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

@keyframes badgePulse {
  0%,
  100% {
    transform: scale(1);
    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
  }
  50% {
    transform: scale(1.05);
    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
  }
}

@keyframes blink {
  0%,
  50% {
    opacity: 1;
  }
  51%,
  100% {
    opacity: 0;
  }
}

@keyframes socialFadeIn {
  from {
    opacity: 0;
    transform: translateY(30px) scale(0.8);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

// ========== 响应式设计 ==========
@media screen and (max-width: 1024px) {
  .left-section {
    padding: 2rem 0;
  }

  .avatar-container {
    margin-top: 2rem;
  }

  .avatar-glow-ring {
    width: 18rem;
    height: 18rem;

    &.ring-2 {
      width: 20rem;
      height: 20rem;
    }
  }

  .avatar-wrapper {
    width: 16rem;
    height: 16rem;
  }

  .name-text {
    font-size: 3rem;
  }

  .skills-container {
    max-width: 400px;
  }

  .intro-card {
    padding: 2rem 2.5rem;
  }

  .intro-title {
    font-size: 2rem;
  }

  .intro-description {
    font-size: 1rem;
  }

  .social-card {
    width: 110px;
    height: 110px;
  }
}

@media screen and (max-width: 768px) {
  .avatar-glow-ring {
    width: 16rem;
    height: 16rem;

    &.ring-2 {
      width: 18rem;
      height: 18rem;
    }
  }

  .avatar-wrapper {
    width: 14rem;
    height: 14rem;
  }

  .name-text {
    font-size: 2.5rem;
  }

  .subtitle-text {
    font-size: 1rem;
  }

  .skills-container {
    max-width: 350px;
    gap: 0.6rem;
  }

  .skill-tag {
    padding: 0.5rem 1rem;
    font-size: 0.85rem;

    .skill-icon {
      font-size: 1rem;
    }
  }

  .intro-card {
    padding: 1.5rem 2rem;
    margin-bottom: 2rem;
  }

  .intro-title {
    font-size: 1.8rem;
    flex-direction: column;
    gap: 0.5rem;

    .version-badge {
      font-size: 0.9rem;
    }
  }

  .intro-description {
    font-size: 0.95rem;
    min-height: 100px;
  }

  .social-links {
    gap: 1.5rem;
  }

  .social-card {
    width: 100px;
    height: 100px;
  }

  .social-name {
    font-size: 0.85rem;
  }
}

@media screen and (max-width: 480px) {
  .avatar-container {
    margin-top: 1rem;
  }

  .avatar-glow-ring {
    width: 13rem;
    height: 13rem;

    &.ring-2 {
      width: 15rem;
      height: 15rem;
    }
  }

  .avatar-wrapper {
    width: 11rem;
    height: 11rem;
  }

  .name-text {
    font-size: 2rem;
  }

  .subtitle-text {
    font-size: 0.9rem;
    padding: 0 1rem;
  }

  .skills-container {
    max-width: 300px;
    gap: 0.5rem;
  }

  .skill-tag {
    padding: 0.4rem 0.8rem;
    font-size: 0.8rem;
  }

  .intro-card {
    padding: 1.2rem 1.5rem;
  }

  .intro-title {
    font-size: 1.5rem;
  }

  .intro-description {
    font-size: 0.9rem;
    line-height: 1.6;
  }

  .section-title {
    .title-line {
      max-width: 50px;
    }

    .title-text {
      font-size: 1rem;
    }
  }

  .social-links {
    gap: 1rem;
  }

  .social-card {
    width: 90px;
    height: 90px;
  }

  .social-icon-wrapper {
    :deep(svg) {
      width: 60px !important;
      height: 60px !important;
    }
  }

  .social-name {
    font-size: 0.8rem;
  }
}
</style>
