<template>
  <div class="music-player">
    <!-- 左下角固定播放器 -->
    <MusicPlayerMini
      v-if="!musicStore.isExpanded && musicStore.hasPlaylist"
      @click="musicStore.expand()"
    />

    <!-- 悬浮球 -->
    <MusicFloatingBall />

    <!-- 展开的播放器面板 -->
    <MusicPlayerPanel />

    <!-- 点击其他区域关闭遮罩 -->
    <Transition name="mask-fade">
      <div
        v-if="musicStore.isExpanded"
        class="music-player-mask"
        @click="handleMaskClick"
      ></div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'
import { useMusicStore } from '@/store/modules/music'
import MusicFloatingBall from './components/MusicFloatingBall.vue'
import MusicPlayerPanel from './components/MusicPlayerPanel.vue'

// 迷你播放器组件（可选的左下角小播放器）
import MusicPlayerMini from './components/MusicPlayerMini.vue'

const musicStore = useMusicStore()

// 点击遮罩关闭
function handleMaskClick() {
  musicStore.collapse()
}

// 全局点击事件处理
function handleGlobalClick(e: MouseEvent) {
  // 如果播放器已展开，不阻止默认行为
  // 只在点击非播放器区域时触发关闭
}

// ESC键关闭
function handleKeydown(e: KeyboardEvent) {
  if (e.key === 'Escape' && musicStore.isExpanded) {
    musicStore.collapse()
  }
}

// 初始化
onMounted(() => {
  musicStore.init()
  document.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeydown)
})
</script>

<style scoped lang="scss">
.music-player {
  pointer-events: none;
  position: fixed;
  inset: 0;
  z-index: 9997;
}

.music-player-mask {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(5px);
  pointer-events: auto;
  z-index: 9990;
}

.mask-fade-enter-active,
.mask-fade-leave-active {
  transition: opacity 0.3s ease;
}

.mask-fade-enter-from,
.mask-fade-leave-to {
  opacity: 0;
}
</style>
