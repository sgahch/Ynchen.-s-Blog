<template>
  <Teleport to="body">
    <Transition name="mini-slide">
      <div
        v-if="musicStore.hasPlaylist && !musicStore.isExpanded"
        class="music-player-mini"
        :style="miniStyle"
        @click="$emit('click')"
      >
        <!-- 进度条 -->
        <div class="mini-progress">
          <div class="progress-fill" :style="{ width: `${musicStore.progress}%` }"></div>
        </div>

        <!-- 内容 -->
        <div class="mini-content">
          <!-- 封面 -->
          <div class="mini-cover" :class="{ 'is-playing': musicStore.isPlaying }">
            <img
              v-if="musicStore.currentSong?.album.picUrl"
              :src="musicStore.currentSong.album.picUrl"
              alt="cover"
            />
            <div v-else class="cover-placeholder">
              <svg-icon name="music" />
            </div>
          </div>

          <!-- 信息 -->
          <div class="mini-info">
            <div class="mini-name">{{ musicStore.currentSong?.name || '未播放' }}</div>
            <div class="mini-artist">
              {{ musicStore.currentSong?.artists[0]?.name || '点击播放' }}
            </div>
          </div>

          <!-- 控制按钮 -->
          <div class="mini-controls">
            <button class="ctrl-btn" @click.stop="musicStore.playPrev()" title="上一首">
              <svg-icon name="prev" />
            </button>
            <button class="ctrl-btn play-btn" @click.stop="musicStore.togglePlay()" title="播放/暂停">
              <svg-icon :name="musicStore.isPlaying ? 'pause' : 'play'" />
            </button>
            <button class="ctrl-btn" @click.stop="musicStore.playNext()" title="下一首">
              <svg-icon name="next" />
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useMusicStore } from '@/store/modules/music'
import SvgIcon from '@/components/SvgIcon/index.vue'

defineEmits(['click'])

const musicStore = useMusicStore()

const miniStyle = computed(() => ({
  '--progress-color': musicStore.progressColor,
}))
</script>

<style scoped lang="scss">
.music-player-mini {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 400px;
  max-width: calc(100vw - 320px);
  height: 64px;
  background: var(--mao-background-color, #fff);
  border-radius: 12px 12px 0 0;
  box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.15);
  cursor: pointer;
  z-index: 9996;
  overflow: hidden;
  backdrop-filter: blur(10px);

  @media screen and (max-width: 768px) {
    width: 100%;
    max-width: 100%;
  }

  &:hover {
    .mini-progress {
      opacity: 1;
    }
  }
}

.mini-progress {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: rgba(0, 0, 0, 0.1);
  opacity: 0.8;
  transition: opacity 0.2s;

  .progress-fill {
    height: 100%;
    background: v-bind('musicStore.progressColor');
    transition: width 0.1s linear;
  }
}

.mini-content {
  display: flex;
  align-items: center;
  height: 100%;
  padding: 8px 16px;
  gap: 12px;
}

.mini-cover {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  &.is-playing img {
    animation: rotate 10s linear infinite;
  }

  .cover-placeholder {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #5cbfef, #62c28a);

    :deep(svg) {
      width: 24px;
      height: 24px;
      color: white;
    }
  }
}

.mini-info {
  flex: 1;
  min-width: 0;

  .mini-name {
    font-size: 14px;
    font-weight: 500;
    color: var(--mao-font-color, #333);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .mini-artist {
    font-size: 12px;
    color: var(--mao-meta-color, #858585);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
}

.mini-controls {
  display: flex;
  align-items: center;
  gap: 8px;

  .ctrl-btn {
    width: 36px;
    height: 36px;
    border: none;
    background: transparent;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    transition: background 0.2s;

    :deep(svg) {
      width: 18px;
      height: 18px;
      color: var(--mao-font-color, #333);
    }

    &:hover {
      background: rgba(0, 0, 0, 0.05);
    }
  }

  .play-btn {
    width: 42px;
    height: 42px;
    background: linear-gradient(135deg, #5cbfef, #62c28a);

    :deep(svg) {
      color: white;
      margin-left: 2px;
    }

    &:hover {
      transform: scale(1.05);
    }
  }
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.mini-slide-enter-active,
.mini-slide-leave-active {
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.mini-slide-enter-from,
.mini-slide-leave-to {
  transform: translateY(100%);
}
</style>
