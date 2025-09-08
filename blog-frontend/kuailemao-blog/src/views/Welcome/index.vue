<script setup lang="ts">
import { ref, onMounted } from "vue";
import { getUserInfo } from "@/apis/user";

const isLoading = ref(true);
const webmasterAvatar = ref("");

onMounted(async () => {
  try {
    const res = await getUserInfo();
    webmasterAvatar.value = res?.data?.avatar || "";
  } catch (e) {
    console.error("获取用户头像失败", e);
    webmasterAvatar.value = "";
  } finally {
    isLoading.value = false;
  }
});
</script>


<template>
  <!-- 头部组件 -->
  <Header/>

  <!-- 主体布局容器 -->
  <div style="width: 100vw; height: 100vh; overflow: hidden; display: flex">
    <!-- 左边区域：背景图 -->
    <div class="left-card">
      <!-- 使用Element Plus的骨架屏组件来优化加载体验 -->
      <el-skeleton style="width: 100%; height: 100%" :loading="isLoading" animated>
        <!-- #template 插槽定义了在加载时显示的内容 -->
        <template #template>
          <el-skeleton-item variant="image" style="width: 100%; height: 100%" />
        </template>
        <!-- #default 插槽定义了加载完成后显示的内容 -->
        <template #default>
          <el-image
              style="width: 100%; height: 100%"
              fit="cover"
              :src="webmasterAvatar"
          />
        </template>
      </el-skeleton>
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