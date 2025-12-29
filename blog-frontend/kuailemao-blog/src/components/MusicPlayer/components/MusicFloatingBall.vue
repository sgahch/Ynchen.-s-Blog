<template>
  <Teleport to="body">
    <Transition name="float-bounce">
      <div
        class="music-floating-ball"
        :style="ballStyle"
        @click.stop="handleClick"
        @mouseenter="isHovered = true"
        @mouseleave="isHovered = false"
      >
        <!-- 封面图片 -->
        <div class="ball-cover" :class="{ 'is-playing': musicStore.isPlaying }">
          <img
            v-if="currentCover"
            :src="currentCover"
            alt="cover"
            @load="onImageLoad"
            @error="onImageError"
          />
          <div v-else class="ball-placeholder">
            <svg-icon name="music" class="music-icon" />
          </div>
        </div>

        <!-- 播放状态指示器 -->
        <div v-if="musicStore.isPlaying" class="playing-indicator">
          <span class="bar" :style="{ animationDelay: '0s' }"></span>
          <span class="bar" :style="{ animationDelay: '0.2s' }"></span>
          <span class="bar" :style="{ animationDelay: '0.4s' }"></span>
        </div>

        <!-- 悬浮提示 -->
        <Transition name="tooltip-fade">
          <div v-if="showTooltip && !musicStore.isExpanded" class="ball-tooltip">
            {{ musicStore.currentSong?.name || '未播放' }}
            <span v-if="musicStore.currentSong"> - {{ musicStore.currentSong.artists[0]?.name }}</span>
          </div>
        </Transition>

        <!-- 关闭按钮 -->
        <button
          v-if="isHovered && !musicStore.isExpanded"
          class="ball-close"
          @click.stop="handleClose"
        >
          <svg-icon name="close" />
        </button>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { useMusicStore } from '@/store/modules/music'
import SvgIcon from '@/components/SvgIcon/index.vue'

// 颜色提取工具
function extractColors(imgSrc: string): Promise<string[]> {
  return new Promise((resolve) => {
    const img = new Image()
    img.crossOrigin = 'anonymous'
    img.onload = () => {
      const canvas = document.createElement('canvas')
      const ctx = canvas.getContext('2d')
      if (!ctx) {
        resolve(['#5cbfef', '#62c28a'])
        return
      }

      canvas.width = 100
      canvas.height = 100
      ctx.drawImage(img, 0, 0, 100, 100)

      // 从四个角采样颜色
      const corners = [
        ctx.getImageData(10, 10, 1, 1).data,
        ctx.getImageData(90, 10, 1, 1).data,
        ctx.getImageData(10, 90, 1, 1).data,
        ctx.getImageData(90, 90, 1, 1).data,
      ]

      const colors = corners.map(c => `rgb(${c[0]}, ${c[1]}, ${c[2]})`)
      resolve(colors.length >= 2 ? colors : ['#5cbfef', '#62c28a'])
    }
    img.onerror = () => {
      resolve(['#5cbfef', '#62c28a'])
    }
    img.src = imgSrc
  })
}

// 将RGB颜色转换为CSS渐变
function colorsToGradient(colors: string[]): string {
  if (colors.length < 2) {
    return 'linear-gradient(135deg, #5cbfef, #62c28a)'
  }
  return `linear-gradient(135deg, ${colors[0]}, ${colors[1]})`
}

const musicStore = useMusicStore()

// 状态
const isHovered = ref(false)
const showTooltip = ref(false)
const coverColors = ref<string>('linear-gradient(135deg, #5cbfef, #62c28a)')
const isAnimating = ref(false)

// 计算属性
const currentCover = computed(() => musicStore.currentSong?.album.picUrl)

const ballStyle = computed(() => ({
  background: coverColors.value,
  boxShadow: `0 4px 20px rgba(0, 0, 0, 0.3)`,
}))

// 方法
function handleClick() {
  if (isAnimating.value) return

  if (musicStore.isExpanded) {
    musicStore.collapse()
  } else {
    musicStore.expand()
  }
}

function handleClose() {
  // 清空播放列表
  musicStore.playlist = []
  musicStore.currentSong = null
  musicStore.currentIndex = -1
}

async function onImageLoad() {
  if (currentCover.value) {
    try {
      const colors = await extractColors(currentCover.value)
      coverColors.value = colorsToGradient(colors)
    } catch (e) {
      console.error('Extract colors error:', e)
    }
  }
}

function onImageError() {
  coverColors.value = 'linear-gradient(135deg, #5cbfef, #62c28a)'
}

// 监听歌曲变化更新颜色
watch(
  () => musicStore.currentSong?.album.picUrl,
  async (newCover) => {
    if (newCover) {
      await onImageLoad()
    }
  }
)

// 悬浮提示定时器
let tooltipTimer: ReturnType<typeof setTimeout> | null = null

onMounted(() => {
  // 延迟显示tooltip
  tooltipTimer = setTimeout(() => {
    showTooltip.value = true
  }, 1000)
})

onUnmounted(() => {
  if (tooltipTimer) {
    clearTimeout(tooltipTimer)
  }
})
</script>

<style scoped lang="scss">
.music-floating-ball {
  position: fixed;
  bottom: 80px;
  left: 30px;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  cursor: pointer;
  z-index: 9998;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  backdrop-filter: blur(10px);

  &:hover {
    transform: scale(1.1);
    box-shadow: 0 6px 30px rgba(0, 0, 0, 0.4);
  }

  &:active {
    transform: scale(0.95);
  }
}

.ball-cover {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  overflow: hidden;
  position: relative;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  &.is-playing img {
    animation: rotate 10s linear infinite;
  }
}

.ball-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.2);

  .music-icon {
    width: 24px;
    height: 24px;
    color: white;
  }
}

.playing-indicator {
  position: absolute;
  bottom: -12px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 3px;
  align-items: flex-end;
  height: 16px;

  .bar {
    width: 4px;
    height: 8px;
    background: white;
    border-radius: 2px;
    animation: soundBars 0.5s ease-in-out infinite alternate;
  }
}

.ball-tooltip {
  position: absolute;
  right: -200px;
  left: auto;
  top: 50%;
  transform: translateY(-50%);
  background: var(--mao-background-color, #fff);
  color: var(--mao-font-color, #333);
  padding: 8px 12px;
  border-radius: 8px;
  font-size: 12px;
  white-space: nowrap;
  max-width: 180px;
  overflow: hidden;
  text-overflow: ellipsis;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
  pointer-events: none;

  &::after {
    content: '';
    position: absolute;
    left: -8px;
    right: auto;
    top: 50%;
    transform: translateY(-50%);
    border: 4px solid transparent;
    border-right-color: var(--mao-background-color, #fff);
  }
}

.ball-close {
  position: absolute;
  top: -8px;
  right: -8px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #ff4757;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.2s;

  :deep(svg) {
    width: 12px;
    height: 12px;
    color: white;
  }

  &:hover {
    transform: scale(1.1);
  }
}

// 动画
@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

@keyframes soundBars {
  from {
    height: 8px;
  }
  to {
    height: 16px;
  }
}

@keyframes floatBounceIn {
  0% {
    opacity: 0;
    transform: scale(0) translateY(100px);
  }
  70% {
    transform: scale(1.1) translateY(-10px);
  }
  100% {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

@keyframes floatBounceOut {
  0% {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
  30% {
    transform: scale(1.1) translateY(-10px);
  }
  100% {
    opacity: 0;
    transform: scale(0) translateY(100px);
  }
}

.float-bounce-enter-active {
  animation: floatBounceIn 0.4s ease-out;
}

.float-bounce-leave-active {
  animation: floatBounceOut 0.3s ease-in;
}

.tooltip-fade-enter-active,
.tooltip-fade-leave-active {
  transition: opacity 0.3s ease;
}

.tooltip-fade-enter-from,
.tooltip-fade-leave-to {
  opacity: 0;
}
</style>
