<template>
  <Teleport to="body">
    <Transition name="panel-slide">
      <div
        v-if="musicStore.isExpanded"
        class="music-player-panel"
        @click.stop
      >
        <!-- 毛玻璃遮罩层 -->
        <div class="glass-overlay"></div>

        <!-- 头部 -->
        <div class="panel-header">
          <div class="header-left">
            <span class="header-title">音乐播放器</span>
            <span class="play-mode-badge" @click="musicStore.togglePlayMode">
              {{ musicStore.playModeText }}
            </span>
          </div>
          <div class="header-right">
            <button class="header-btn" @click="handleMinimize" title="收起">
              <svg-icon name="minimize" />
            </button>
            <button class="header-btn" @click="handleClose" title="关闭">
              <svg-icon name="close" />
            </button>
          </div>
        </div>

        <!-- 内容区 -->
        <div class="panel-content">
          <!-- 左侧：歌曲信息 -->
          <div class="song-section">
            <!-- 封面 -->
            <div class="album-cover" :class="{ 'is-playing': musicStore.isPlaying }">
              <img
                v-if="musicStore.currentSong?.album.picUrl"
                :src="musicStore.currentSong.album.picUrl"
                alt="album cover"
              />
              <div v-else class="cover-placeholder">
                <svg-icon name="music" class="music-icon" />
              </div>
              <div class="cover-mask">
                <button class="play-btn-large" @click="musicStore.togglePlay()">
                  <svg-icon v-if="!musicStore.isPlaying" name="play" class="play-icon" />
                  <svg-icon v-else name="pause" class="play-icon" />
                </button>
              </div>
            </div>

            <!-- 歌曲信息 -->
            <div class="song-info">
              <h2 class="song-name">
                {{ musicStore.currentSong?.name || '未播放歌曲' }}
              </h2>
              <p class="artist-name">
                {{ musicStore.currentSong?.artists.map(a => a.name).join(' / ') || '未知艺术家' }}
              </p>
              <p class="album-name">{{ musicStore.currentSong?.album.name || '未知专辑' }}</p>

              <!-- 操作按钮 -->
              <div class="song-actions">
                <button
                  class="action-btn"
                  :class="{ active: musicStore.isFavorite }"
                  @click="musicStore.toggleFavorite()"
                  title="收藏"
                >
                  <svg-icon :name="musicStore.isFavorite ? 'heart-fill' : 'heart'" />
                </button>
                <button class="action-btn" @click="handleDownload" title="下载">
                  <svg-icon name="download" />
                </button>
                <button class="action-btn" @click="handleShare" title="分享">
                  <svg-icon name="share" />
                </button>
              </div>
            </div>
          </div>

          <!-- 中间：歌词 -->
          <div class="lyric-section">
            <div class="lyric-header">歌词</div>
            <div class="lyric-container" ref="lyricContainer">
              <div
                v-if="musicStore.lyricLines.length === 0"
                class="no-lyric"
              >
                {{ musicStore.currentSong ? '暂无歌词' : '播放歌曲查看歌词' }}
              </div>
              <div v-else class="lyric-content">
                <div
                  v-for="(line, index) in musicStore.lyricLines"
                  :key="index"
                  class="lyric-line"
                  :class="{ 'is-current': index === musicStore.currentLyricIndex }"
                >
                  {{ line.text || '♪ ♪ ♪' }}
                </div>
              </div>
            </div>
          </div>

          <!-- 右侧：播放列表 -->
          <div class="playlist-section">
            <div class="playlist-header">
              <span>播放列表</span>
              <span class="playlist-count">({{ musicStore.filteredPlaylist.length }})</span>
            </div>
            <div class="playlist-container">
              <div
                v-for="(song, index) in musicStore.filteredPlaylist"
                :key="song.id"
                class="playlist-item"
                :class="{
                  'is-current': getSongIndex(song.id) === musicStore.currentIndex,
                  'is-playing': getSongIndex(song.id) === musicStore.currentIndex && musicStore.isPlaying
                }"
                @click="playSongById(song.id)"
              >
                <div class="item-index">
                  <span v-if="getSongIndex(song.id) === musicStore.currentIndex && musicStore.isPlaying" class="playing-icon">
                    <span class="bar"></span>
                    <span class="bar"></span>
                    <span class="bar"></span>
                  </span>
                  <span v-else class="index-num">{{ index + 1 }}</span>
                </div>
                <div class="item-info">
                  <div class="item-name">{{ song.name }}</div>
                  <div class="item-artist">{{ song.artists[0]?.name }}</div>
                </div>
                <div class="item-duration">
                  {{ formatDuration(song.duration) }}
                </div>
              </div>
              <div v-if="musicStore.filteredPlaylist.length === 0" class="no-songs">
                暂无可播放歌曲
              </div>
            </div>
          </div>
        </div>

        <!-- 底部：进度条和控制区 -->
        <div class="panel-footer">
          <!-- 进度条 -->
          <div class="progress-bar" @click="handleProgressClick">
            <div class="progress-bg">
              <div class="progress-fill" :style="{ width: `${musicStore.progress}%` }"></div>
            </div>
            <div
              class="progress-thumb"
              :style="{ left: `${musicStore.progress}%` }"
            ></div>
          </div>

          <!-- 时间显示 -->
          <div class="time-display">
            {{ formatTime(musicStore.currentTime) }} / {{ formatTime(musicStore.duration) }}
          </div>

          <!-- 控制按钮 -->
          <div class="control-buttons">
            <button class="ctrl-btn" @click="musicStore.togglePlayMode()" :title="musicStore.playModeText">
              <svg-icon :name="playModeIcon" />
            </button>
            <button class="ctrl-btn" @click="musicStore.playPrev()" title="上一首">
              <svg-icon name="prev" />
            </button>
            <button class="ctrl-btn play-btn" @click="musicStore.togglePlay()" :title="musicStore.isPlaying ? '暂停' : '播放'">
              <svg-icon v-if="musicStore.isPlaying" name="pause" />
              <svg-icon v-else name="play" />
            </button>
            <button class="ctrl-btn" @click="musicStore.playNext()" title="下一首">
              <svg-icon name="next" />
            </button>
            <div class="volume-control">
              <button class="ctrl-btn" @click="musicStore.toggleMute()" title="音量">
                <svg-icon :name="volumeIcon" />
              </button>
              <div class="volume-slider">
                <input
                  type="range"
                  min="0"
                  max="1"
                  step="0.01"
                  :value="musicStore.volume"
                  @input="handleVolumeChange"
                />
              </div>
            </div>
          </div>
        </div>

        <!-- 加载状态 -->
        <div v-if="musicStore.isLoading" class="loading-overlay">
          <div class="loading-spinner"></div>
        </div>

        <!-- 错误提示 -->
        <Transition name="error-fade">
          <div v-if="musicStore.error" class="error-toast">
            {{ musicStore.error }}
            <button @click="musicStore.error = null">×</button>
          </div>
        </Transition>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useMusicStore } from '@/store/modules/music'
import SvgIcon from '@/components/SvgIcon/index.vue'
import { PLAYLIST_ID } from '@/apis/music'

const musicStore = useMusicStore()

// Refs
const lyricContainer = ref<HTMLElement | null>(null)

// 计算属性
const playModeIcon = computed(() => {
  const icons: Record<string, string> = {
    order: 'play-order',
    random: 'play-random',
    single: 'play-single',
  }
  return icons[musicStore.playMode] || 'play-order'
})

const volumeIcon = computed(() => {
  if (musicStore.isMuted || musicStore.volume === 0) {
    return 'volume-mute'
  } else if (musicStore.volume < 0.5) {
    return 'volume-low'
  } else {
    return 'volume-high'
  }
})

// 方法
function handleMinimize() {
  musicStore.collapse()
}

function handleClose() {
  musicStore.collapse()
}

function handleProgressClick(e: MouseEvent) {
  const target = e.currentTarget as HTMLElement
  const rect = target.getBoundingClientRect()
  const percent = ((e.clientX - rect.left) / rect.width) * 100
  musicStore.seekPercent(percent)
}

function handleVolumeChange(e: Event) {
  const value = parseFloat((e.target as HTMLInputElement).value)
  musicStore.setVolume(value)
}

function handleDownload() {
  if (musicStore.currentSong) {
    window.open(musicStore.currentSong.album.picUrl, '_blank')
  }
}

function handleShare() {
  if (musicStore.currentSong) {
    const text = `${musicStore.currentSong.name} - ${musicStore.currentSong.artists.map(a => a.name).join('/')}`
    if (navigator.share) {
      navigator.share({
        title: text,
        text: `分享一首好听的歌：${text}`,
        url: window.location.href,
      })
    } else {
      navigator.clipboard.writeText(window.location.href)
    }
  }
}

function formatDuration(ms: number): string {
  if (!ms) return '00:00'
  const seconds = Math.floor(ms / 1000)
  const minutes = Math.floor(seconds / 60)
  const secs = seconds % 60
  return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
}

function formatTime(seconds: number): string {
  if (!seconds || isNaN(seconds)) return '00:00'
  const mins = Math.floor(seconds / 60)
  const secs = Math.floor(seconds % 60)
  return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
}

// 根据歌曲ID获取在原始播放列表中的索引
function getSongIndex(songId: number): number {
  return musicStore.playlist.findIndex(s => s.id === songId)
}

// 根据ID播放歌曲
function playSongById(songId: number) {
  const index = getSongIndex(songId)
  if (index >= 0) {
    musicStore.playByIndex(index)
  }
}

// 初始化加载歌单
watch(
  () => musicStore.hasPlaylist,
  (hasPlaylist) => {
    if (!hasPlaylist && PLAYLIST_ID) {
      musicStore.loadPlaylist(PLAYLIST_ID)
    }
  },
  { immediate: true }
)

// 歌词滚动到当前行
watch(
  () => musicStore.currentLyricIndex,
  (index) => {
    if (index >= 0 && lyricContainer.value) {
      const lyricContent = lyricContainer.value.querySelector('.lyric-content')
      if (lyricContent && lyricContent.children[index]) {
        const currentEl = lyricContent.children[index] as HTMLElement
        currentEl.scrollIntoView({ behavior: 'smooth', block: 'center' })
      }
    }
  }
)
</script>

<style scoped lang="scss">
// 毛玻璃基础样式
$glass-bg: rgba(255, 255, 255, 0.25);
$glass-border: rgba(255, 255, 255, 0.3);
$glass-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15);
$primary-color: #667eea;
$text-primary: #2d3748;
$text-secondary: #718096;

.music-player-panel {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 520px;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  overflow: hidden;

  // 毛玻璃背景
  .glass-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(
      135deg,
      rgba(255, 255, 255, 0.9) 0%,
      rgba(255, 255, 255, 0.7) 50%,
      rgba(230, 240, 255, 0.8) 100%
    );
    backdrop-filter: blur(30px);
    -webkit-backdrop-filter: blur(30px);
    border-top: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 -8px 40px rgba(102, 126, 234, 0.15);
  }

  // 确保内容在遮罩层上方
  > * {
    position: relative;
    z-index: 1;
  }

  @media screen and (max-width: 768px) {
    height: 100vh;
  }
}

// 头部
.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 24px;
  border-bottom: 1px solid rgba(102, 126, 234, 0.1);
  flex-shrink: 0;

  .header-left {
    display: flex;
    align-items: center;
    gap: 12px;
  }

  .header-title {
    color: $text-primary;
    font-size: 15px;
    font-weight: 600;
  }

  .play-mode-badge {
    padding: 5px 12px;
    background: rgba(102, 126, 234, 0.1);
    border-radius: 20px;
    color: $primary-color;
    font-size: 12px;
    cursor: pointer;
    transition: all 0.2s;
    border: 1px solid rgba(102, 126, 234, 0.2);

    &:hover {
      background: rgba(102, 126, 234, 0.15);
    }
  }

  .header-right {
    display: flex;
    gap: 8px;
  }

  .header-btn {
    width: 36px;
    height: 36px;
    border: none;
    background: rgba(255, 255, 255, 0.5);
    border-radius: 10px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);

    :deep(svg) {
      width: 16px;
      height: 16px;
      color: $text-secondary;
    }

    &:hover {
      background: rgba(255, 255, 255, 0.8);
      transform: scale(1.05);
    }
  }
}

// 内容区
.panel-content {
  flex: 1;
  display: grid;
  grid-template-columns: 1fr 1.5fr 1fr;
  gap: 24px;
  padding: 24px;
  overflow: hidden;

  @media screen and (max-width: 1024px) {
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr 1fr;
  }

  @media screen and (max-width: 768px) {
    grid-template-columns: 1fr;
    grid-template-rows: auto 1fr 1fr;
    padding: 16px;
    gap: 16px;
  }
}

// 歌曲信息区
.song-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24px;
  overflow-y: auto;
}

.album-cover {
  width: 200px;
  height: 200px;
  border-radius: 20px;
  overflow: hidden;
  position: relative;
  box-shadow: $glass-shadow, 0 0 40px rgba(102, 126, 234, 0.1);
  transition: all 0.3s ease;
  border: 4px solid rgba(255, 255, 255, 0.6);

  &:hover {
    transform: scale(1.03);
    box-shadow: $glass-shadow, 0 0 60px rgba(102, 126, 234, 0.2);
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  &.is-playing img {
    animation: rotate 20s linear infinite;
  }

  .cover-placeholder {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #e0e5ec 0%, #d0d8e8 100%);

    .music-icon {
      width: 60px;
      height: 60px;
      color: rgba(102, 126, 234, 0.3);
    }
  }

  .cover-mask {
    position: absolute;
    inset: 0;
    background: rgba(255, 255, 255, 0.3);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity 0.3s;
    backdrop-filter: blur(2px);
  }

  &:hover .cover-mask {
    opacity: 1;
  }

  .play-btn-large {
    width: 64px;
    height: 64px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.9);
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3);

    :deep(svg) {
      width: 28px;
      height: 28px;
      color: $primary-color;
      margin-left: 3px;
    }

    &:hover {
      transform: scale(1.1);
      background: #fff;
    }
  }
}

.song-info {
  text-align: center;
  color: $text-primary;

  .song-name {
    font-size: 18px;
    font-weight: 600;
    margin: 0 0 10px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    color: $text-primary;
  }

  .vip-badge {
    display: inline-flex;
    align-items: center;
    padding: 3px 10px;
    background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
    color: #fff;
    font-size: 11px;
    font-weight: 700;
    border-radius: 6px;
    box-shadow: 0 2px 10px rgba(253, 160, 133, 0.4);
    animation: vipPulse 2s ease-in-out infinite;
  }

  @keyframes vipPulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
  }

  .artist-name {
    font-size: 14px;
    color: $text-secondary;
    margin: 0 0 6px;
  }

  .album-name {
    font-size: 12px;
    color: #a0aec0;
    margin: 0 0 20px;
  }

  .song-actions {
    display: flex;
    gap: 16px;
    justify-content: center;
  }

  .action-btn {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    border: none;
    background: rgba(255, 255, 255, 0.6);
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);

    :deep(svg) {
      width: 20px;
      height: 20px;
      color: $text-secondary;
    }

    &:hover {
      background: rgba(255, 255, 255, 0.9);
      transform: scale(1.1);

      :deep(svg) {
        color: $primary-color;
      }
    }

    &.active {
      background: rgba(102, 126, 234, 0.15);

      :deep(svg) {
        color: #e53e3e;
      }
    }
  }
}

// 歌词区
.lyric-section {
  display: flex;
  flex-direction: column;
  background: rgba(255, 255, 255, 0.4);
  border-radius: 20px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: $glass-shadow;

  .lyric-header {
    padding: 16px 24px;
    font-size: 14px;
    color: $primary-color;
    font-weight: 600;
    border-bottom: 1px solid rgba(102, 126, 234, 0.1);
    flex-shrink: 0;
    background: rgba(255, 255, 255, 0.3);
  }

  .lyric-container {
    flex: 1;
    overflow-y: auto;
    padding: 20px;

    &::-webkit-scrollbar {
      width: 4px;
    }

    &::-webkit-scrollbar-track {
      background: transparent;
    }

    &::-webkit-scrollbar-thumb {
      background: rgba(102, 126, 234, 0.3);
      border-radius: 2px;
    }
  }

  .no-lyric {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
    color: $text-secondary;
    font-size: 14px;
  }

  .lyric-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 18px;
  }

  .lyric-line {
    font-size: 15px;
    color: $text-secondary;
    text-align: center;
    padding: 8px 20px;
    border-radius: 12px;
    transition: all 0.3s ease;
    max-width: 90%;

    &:hover {
      color: $text-primary;
    }

    &.is-current {
      font-size: 20px;
      font-weight: 600;
      color: $primary-color;
      background: rgba(255, 255, 255, 0.7);
      box-shadow: 0 4px 20px rgba(102, 126, 234, 0.15);
      padding: 12px 28px;
      border-radius: 16px;
      transform: scale(1.02);
    }
  }
}

// 播放列表区
.playlist-section {
  display: flex;
  flex-direction: column;
  background: rgba(255, 255, 255, 0.4);
  border-radius: 20px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: $glass-shadow;

  .playlist-header {
    padding: 16px 24px;
    font-size: 14px;
    color: $primary-color;
    font-weight: 600;
    border-bottom: 1px solid rgba(102, 126, 234, 0.1);
    flex-shrink: 0;
    background: rgba(255, 255, 255, 0.3);
  }

  .playlist-count {
    color: $text-secondary;
    margin-left: 6px;
    font-weight: normal;
  }

  .playlist-container {
    flex: 1;
    overflow-y: auto;

    &::-webkit-scrollbar {
      width: 4px;
    }

    &::-webkit-scrollbar-track {
      background: transparent;
    }

    &::-webkit-scrollbar-thumb {
      background: rgba(102, 126, 234, 0.3);
      border-radius: 2px;
    }
  }

  .playlist-item {
    display: flex;
    align-items: center;
    padding: 14px 24px;
    cursor: pointer;
    transition: all 0.2s;

    &:hover {
      background: rgba(255, 255, 255, 0.5);
    }

    &.is-current {
      background: rgba(102, 126, 234, 0.1);

      .item-name {
        color: $primary-color;
        font-weight: 600;
      }
    }

    &.is-playing .item-index {
      .index-num {
        display: none;
      }
    }
  }

  .item-index {
    width: 28px;
    margin-right: 14px;
    display: flex;
    align-items: center;
    justify-content: center;

    .index-num {
      font-size: 12px;
      color: $text-secondary;
    }

    .playing-icon {
      display: flex;
      gap: 3px;
      align-items: flex-end;

      .bar {
        width: 4px;
        height: 14px;
        background: $primary-color;
        border-radius: 2px;
        animation: soundBars 0.5s ease-in-out infinite alternate;

        &:nth-child(1) { animation-delay: 0s; }
        &:nth-child(2) { animation-delay: 0.15s; }
        &:nth-child(3) { animation-delay: 0.3s; }
      }
    }
  }

  .item-info {
    flex: 1;
    min-width: 0;
    margin-right: 14px;
  }

  .item-name {
    font-size: 14px;
    color: $text-primary;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .item-artist {
    font-size: 12px;
    color: $text-secondary;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .item-duration {
    font-size: 12px;
    color: $text-secondary;
    flex-shrink: 0;
  }

  .no-songs {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px 20px;
    color: $text-secondary;
    font-size: 14px;
  }
}

// 底部
.panel-footer {
  padding: 16px 24px 20px;
  border-top: 1px solid rgba(102, 126, 234, 0.1);
  flex-shrink: 0;
}

.progress-bar {
  position: relative;
  height: 6px;
  background: rgba(102, 126, 234, 0.15);
  border-radius: 3px;
  cursor: pointer;
  margin-bottom: 12px;
  transition: height 0.2s;

  &:hover {
    height: 8px;

    .progress-thumb {
      opacity: 1;
      transform: translate(-50%, -50%) scale(1.2);
    }
  }

  .progress-bg {
    height: 100%;
    border-radius: 3px;
    overflow: hidden;
  }

  .progress-fill {
    height: 100%;
    background: linear-gradient(90deg, $primary-color 0%, #a78bfa 100%);
    border-radius: 3px;
    transition: width 0.1s linear;
    position: relative;
  }

  .progress-thumb {
    position: absolute;
    top: 50%;
    transform: translate(-50%, -50%);
    width: 16px;
    height: 16px;
    background: #fff;
    border-radius: 50%;
    opacity: 0;
    transition: opacity 0.2s, transform 0.2s;
    box-shadow: 0 2px 10px rgba(102, 126, 234, 0.4);
    border: 3px solid $primary-color;
  }
}

.time-display {
  font-size: 12px;
  color: $text-secondary;
  margin-bottom: 16px;
  text-align: center;
}

.control-buttons {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 24px;

  .ctrl-btn {
    width: 46px;
    height: 46px;
    border: none;
    background: rgba(255, 255, 255, 0.5);
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);

    :deep(svg) {
      width: 22px;
      height: 22px;
      color: $text-secondary;
    }

    &:hover {
      background: rgba(255, 255, 255, 0.8);
      transform: scale(1.1);

      :deep(svg) {
        color: $primary-color;
      }
    }
  }

  .play-btn {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: linear-gradient(135deg, $primary-color 0%, #a78bfa 100%);
    box-shadow: 0 4px 24px rgba(102, 126, 234, 0.4);

    :deep(svg) {
      width: 26px;
      height: 26px;
      color: #fff;
      margin-left: 2px;
    }

    &:hover {
      transform: scale(1.08);
      box-shadow: 0 6px 30px rgba(102, 126, 234, 0.5);
    }
  }

  .volume-control {
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .volume-slider {
    width: 100px;

    input[type="range"] {
      width: 100%;
      height: 4px;
      -webkit-appearance: none;
      background: rgba(102, 126, 234, 0.2);
      border-radius: 2px;
      outline: none;

      &::-webkit-slider-thumb {
        -webkit-appearance: none;
        width: 14px;
        height: 14px;
        background: linear-gradient(135deg, $primary-color 0%, #a78bfa 100%);
        border-radius: 50%;
        cursor: pointer;
        box-shadow: 0 2px 8px rgba(102, 126, 234, 0.4);
      }
    }
  }
}

// 加载状态
.loading-overlay {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10;
}

.loading-spinner {
  width: 44px;
  height: 44px;
  border: 3px solid rgba(102, 126, 234, 0.2);
  border-top-color: $primary-color;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

// 错误提示
.error-toast {
  position: absolute;
  bottom: 90px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  color: $text-primary;
  padding: 14px 24px;
  border-radius: 12px;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 12px;
  z-index: 20;
  box-shadow: $glass-shadow;
  border: 1px solid rgba(102, 126, 234, 0.2);

  button {
    background: none;
    border: none;
    color: $text-secondary;
    font-size: 20px;
    cursor: pointer;
    padding: 0;
    line-height: 1;

    &:hover {
      color: $primary-color;
    }
  }
}

// 动画
@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@keyframes soundBars {
  from { height: 8px; }
  to { height: 16px; }
}

// 过渡动画
.panel-slide-enter-active,
.panel-slide-leave-active {
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.panel-slide-enter-from,
.panel-slide-leave-to {
  transform: translateY(100%);
}

.error-fade-enter-active,
.error-fade-leave-active {
  transition: opacity 0.3s ease;
}

.error-fade-enter-from,
.error-fade-leave-to {
  opacity: 0;
}
</style>
