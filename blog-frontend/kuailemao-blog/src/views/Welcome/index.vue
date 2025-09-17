<script setup lang="ts">
import { ref } from "vue";
// import { getUserInfo } from "@/apis/user"; // 不再需要，已移除

// 直接将图片的URL硬编码在这里
// 这个URL是您之前在浏览器中确认可以访问的那个
const webmasterAvatar = ref("http://192.168.182.128:9000/blog/websiteInfo/avatar/a49e54ac-c169-47c2-92f1-78c1e1f5bb3c.jpg");

// 因为是硬编码，不再需要异步加载，所以 onMounted 和 isLoading 逻辑都已移除
</script>

<template>
  <!-- 头部组件 -->
  <Header/>

  <!-- 主体布局容器 -->
  <div style="width: 100vw; height: 100vh; overflow: hidden; display: flex">
    <!-- 左边区域：背景图 -->
    <div class="left-card">
      <!-- 移除骨架屏，直接使用 el-image 组件 -->
      <el-image
          style="width: 100%; height: 100%"
          fit="cover"
          :src="webmasterAvatar"
      />
    </div>

    <!-- 欢迎文字 (绝对定位) -->
    <div class="welcome-title">
      <div class="welcome-main-text">欢迎来到我的个人博客</div>
      <div class="welcome-sub-text">
        在这里你可以学习如何使用 Java，如何搭建网站，如何拥有自己的个人网站
      </div>
    </div>

    <!-- 右边区域：登录/注册表单 -->
    <div class="right-card">
      <!-- 路由视图，用于显示子路由组件（如登录、注册页） -->
      <router-view v-slot="{ Component }">
        <transition name="el-fade-in-linear" mode="out-in">
          <component :is="Component"/>
        </transition>
      </router-view>
    </div>
  </div>
</template>

<style scoped>
/* 左侧卡片样式 */
.left-card {
  flex: 1;
  background-color: black;
}

/* 右侧卡片样式 */
.right-card {
  width: 400px;
  z-index: 1;
  background-color: var(--el-bg-color);
}

/* 媒体查询：当屏幕宽度小于600px时，隐藏左侧卡片，右侧占满全屏 */
@media screen and (max-width: 600px) {
  .left-card {
    display: none;
  }
  .right-card {
    width: 100vw;
  }
}

/* 欢迎文字容器样式 */
.welcome-title {
  position: absolute;
  bottom: 30px;
  left: 30px;
  color: white;
  text-shadow: 0 0 10px white;
}

/* 欢迎主标题样式 */
.welcome-main-text {
  font-size: 30px;
  font-weight: bold;
}

/* 欢迎副标题样式 */
.welcome-sub-text {
  margin-top: 10px;
}
</style>