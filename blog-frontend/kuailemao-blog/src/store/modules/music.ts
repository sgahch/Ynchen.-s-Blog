import { defineStore } from 'pinia'
import { ref, computed, watch } from 'vue'
import {
  getCachedPlaylistDetail,
  getSongUrl,
  getLyric,
  type Song,
} from '@/apis/music'

// 歌词行类型
interface LyricLine {
  time: number
  text: string
}

// 播放器状态类型
interface MusicState {
  isPlaying: boolean
  isExpanded: boolean
  isMuted: boolean
  volume: number
  currentTime: number
  duration: number
  playMode: 'order' | 'random' | 'single'
  currentSong: Song | null
  playlist: Song[]
  currentIndex: number
  playHistory: Song[]
  favoriteIds: Set<number>
  currentLyric: string
  lyricLines: LyricLine[]
  currentLyricIndex: number
  isLoading: boolean
  error: string | null
}

// 从URL参数恢复播放列表
function restoreFromUrl(): { playlistId?: string; songId?: string } {
  const params = new URLSearchParams(window.location.search)
  return {
    playlistId: params.get('music_playlist') || undefined,
    songId: params.get('music_song') || undefined,
  }
}

// 从本地存储恢复状态
function restoreFromStorage(): Partial<MusicState> {
  try {
    const saved = localStorage.getItem('ruyu-music-state')
    if (saved) {
      const parsed = JSON.parse(saved)
      return {
        isMuted: parsed.isMuted ?? false,
        volume: parsed.volume ?? 0.8,
        playMode: parsed.playMode ?? 'order',
        playHistory: parsed.playHistory ?? [],
        favoriteIds: new Set(parsed.favoriteIds ?? []),
      }
    }
  } catch (e) {
    console.error('Failed to restore music state:', e)
  }
  return {}
}

// 解析歌词
function parseLyric(lrc: string): LyricLine[] {
  const lines: LyricLine[] = []
  const regex = /\[(\d{2}):(\d{2})\.(\d{2,3})\](.*)/g
  let match
  while ((match = regex.exec(lrc)) !== null) {
    const min = parseInt(match[1])
    const sec = parseInt(match[2])
    const ms = parseInt(match[3])
    const time = min * 60 + sec + ms / 1000
    const text = match[4].trim()
    if (text) {
      lines.push({ time, text })
    }
  }
  lines.sort((a, b) => a.time - b.time)
  return lines
}

// 随机打乱播放列表
function shuffleArray<T>(arr: T[]): T[] {
  const result = [...arr]
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[result[i], result[j]] = [result[j], result[i]]
  }
  return result
}

// 保存状态到本地存储
function saveMusicState(data: {
  isMuted: boolean
  volume: number
  playMode: string
  playHistory: Song[]
  favoriteIds: number[]
}) {
  try {
    localStorage.setItem('ruyu-music-state', JSON.stringify(data))
  } catch (e) {
    console.error('Failed to save music state:', e)
  }
}

// 定义 store
export const useMusicStore = defineStore('music', () => {
  // ========== 状态定义 ==========
  const isPlaying = ref(false)
  const isExpanded = ref(false)
  const isMuted = ref(false)
  const volume = ref(0.8)
  const currentTime = ref(0)
  const duration = ref(0)
  const playMode = ref<'order' | 'random' | 'single'>('order')

  const currentSong = ref<Song | null>(null)
  const playlist = ref<Song[]>([])
  const currentIndex = ref(-1)
  const playHistory = ref<Song[]>([])
  const favoriteIds = ref<Set<number>>(new Set())

  const currentLyric = ref('')
  const lyricLines = ref<LyricLine[]>([])
  const currentLyricIndex = ref(-1)

  const isLoading = ref(false)
  const error = ref<string | null>(null)
  const isVipSong = ref(false) // 是否是VIP歌曲
  const vipSongIds = ref<Set<number>>(new Set()) // 记录VIP歌曲ID

  // 音频元素
  let audioElement: HTMLAudioElement | null = null

  // ========== 计算属性 ==========
  const hasPlaylist = computed(() => playlist.value.length > 0)
  const hasSong = computed(() => currentSong.value !== null)
  const progress = computed(() => {
    if (duration.value === 0) return 0
    return (currentTime.value / duration.value) * 100
  })
  const isFirst = computed(() => currentIndex.value <= 0)
  const isLast = computed(() => currentIndex.value >= playlist.value.length - 1)
  const isFavorite = computed(() => {
    return currentSong.value ? favoriteIds.value.has(currentSong.value.id) : false
  })
  const playModeText = computed(() => {
    const texts: Record<string, string> = { order: '顺序播放', random: '随机播放', single: '单曲循环' }
    return texts[playMode.value]
  })
  const progressColor = computed(() => {
    if (currentSong.value?.album.picUrl) {
      return 'linear-gradient(135deg, #ff6b6b, #feca57, #48dbfb, #ff9ff3)'
    }
    return 'linear-gradient(135deg, #5cbfef, #62c28a)'
  })

  // 过滤后的播放列表（不显示VIP歌曲）
  const filteredPlaylist = computed(() => {
    return playlist.value.filter(song => !vipSongIds.value.has(song.id))
  })

  // ========== 方法 ==========

  // 初始化音频元素
  function initAudio() {
    if (!audioElement) {
      audioElement = new Audio()
      audioElement.volume = volume.value

      audioElement.addEventListener('timeupdate', () => {
        if (!audioElement) return
        currentTime.value = audioElement.currentTime
        updateLyricIndex()
      })
      audioElement.addEventListener('loadedmetadata', () => {
        if (!audioElement) return
        duration.value = audioElement.duration
      })
      audioElement.addEventListener('ended', onEnded)
      audioElement.addEventListener('play', () => { isPlaying.value = true })
      audioElement.addEventListener('pause', () => { isPlaying.value = false })
      audioElement.addEventListener('error', onError)
      audioElement.preload = 'metadata'
    }
    return audioElement
  }

  // 播放结束
  function onEnded() {
    if (playMode.value === 'single') {
      audioElement && (audioElement.currentTime = 0)
      audioElement?.play()
    } else {
      playNext()
    }
  }

  // 播放错误
  function onError(e: Event) {
    console.error('Audio error:', e)
    error.value = '播放失败，请尝试切换歌曲'
    isPlaying.value = false
  }

  // 更新歌词索引
  function updateLyricIndex() {
    const time = currentTime.value
    let index = -1
    for (let i = lyricLines.value.length - 1; i >= 0; i--) {
      if (lyricLines.value[i].time <= time) {
        index = i
        break
      }
    }
    currentLyricIndex.value = index
  }

  // 加载歌单
  async function loadPlaylist(playlistId: string | number) {
    isLoading.value = true
    error.value = null

    try {
      const data = await getCachedPlaylistDetail(playlistId)
      playlist.value = data.songs

      // 保存到URL
      const url = new URL(window.location.href)
      url.searchParams.set('music_playlist', playlistId.toString())
      window.history.replaceState({}, '', url.toString())

      if (playMode.value === 'random') {
        playlist.value = shuffleArray(playlist.value)
      }

      // 自动播放第一首非VIP歌曲
      if (playlist.value.length > 0) {
        await playFirstAvailableSong()
      }
    } catch (e: any) {
      error.value = e.message || '加载歌单失败'
      console.error('Load playlist error:', e)
    } finally {
      isLoading.value = false
    }
  }

  // 播放第一首可用歌曲（跳过VIP）
  async function playFirstAvailableSong() {
    if (playlist.value.length === 0) return

    // 查找第一首不在VIP列表中的歌曲
    const firstAvailable = playlist.value.find(song => !vipSongIds.value.has(song.id))
    if (firstAvailable) {
      const index = playlist.value.findIndex(s => s.id === firstAvailable.id)
      await playSong(firstAvailable, index)
    } else {
      error.value = '没有可播放的歌曲'
    }
  }

  // 播放歌曲
  async function playSong(song: Song, index: number) {
    currentSong.value = song
    currentIndex.value = index
    addToHistory(song)

    isLoading.value = true
    error.value = null
    isVipSong.value = false

    try {
      const audio = initAudio()
      const url = await getSongUrl(song.id)

      // 检测是否是VIP歌曲（没有URL或URL为空）
      if (!url || url === '' || url.includes('null') || url.includes('undefined') || !url.startsWith('http')) {
        isVipSong.value = true
        vipSongIds.value.add(song.id) // 记录VIP歌曲ID
        isPlaying.value = false
        isLoading.value = false
        console.log('VIP歌曲 detected:', song.name, 'ID:', song.id)
        // 直接播放下一首，不显示错误
        playNextWithSkipVip(index)
        return
      }

      audio.src = url
      audio.play()

      try {
        const lrc = await getLyric(song.id)
        currentLyric.value = lrc
        lyricLines.value = parseLyric(lrc)
      } catch {
        currentLyric.value = ''
        lyricLines.value = []
      }

      const urlParams = new URLSearchParams(window.location.search)
      urlParams.set('music_song', song.id.toString())
      window.history.replaceState({}, '', `?${urlParams.toString()}`)
    } catch (e: any) {
      error.value = e.message || '播放失败'
      isPlaying.value = false
      // 播放错误也跳过
      setTimeout(() => {
        error.value = null
        playNextWithSkipVip(index)
      }, 1500)
      console.error('Play song error:', e)
    } finally {
      isLoading.value = false
    }
  }

  // 跳过VIP歌曲播放下一首（使用已过滤的播放列表）
  function playNextWithSkipVip(currentIdx: number) {
    if (!hasPlaylist.value) return

    // 获取在过滤列表中的索引位置
    const currentSongId = playlist.value[currentIdx]?.id
    const filteredList = filteredPlaylist.value

    if (filteredList.length === 0) {
      error.value = '没有可播放的歌曲'
      return
    }

    // 找到当前歌曲在过滤列表中的位置
    const currentFilterIndex = filteredList.findIndex(s => s.id === currentSongId)
    let nextFilterIndex = currentFilterIndex + 1

    if (nextFilterIndex >= filteredList.length) {
      nextFilterIndex = 0 // 循环到第一首
    }

    // 获取下一首歌曲的ID，在原始列表中找到索引
    const nextSong = filteredList[nextFilterIndex]
    const nextOriginalIndex = playlist.value.findIndex(s => s.id === nextSong.id)

    if (nextOriginalIndex >= 0) {
      playSong(nextSong, nextOriginalIndex)
    }
  }

  // 播放/暂停
  function togglePlay() {
    if (!audioElement) return
    if (isPlaying.value) {
      audioElement.pause()
    } else {
      audioElement.play()
    }
  }

  // 上一首
  function playPrev() {
    if (!hasPlaylist.value) return
    if (playMode.value === 'random') {
      const randomIndex = Math.floor(Math.random() * playlist.value.length)
      playSong(playlist.value[randomIndex], randomIndex)
    } else {
      let prevIndex = currentIndex.value - 1
      if (prevIndex < 0) prevIndex = playlist.value.length - 1
      playSong(playlist.value[prevIndex], prevIndex)
    }
  }

  // 下一首
  function playNext() {
    if (!hasPlaylist.value) return
    if (playMode.value === 'random') {
      const randomIndex = Math.floor(Math.random() * playlist.value.length)
      playSong(playlist.value[randomIndex], randomIndex)
    } else {
      let nextIndex = currentIndex.value + 1
      if (nextIndex >= playlist.value.length) nextIndex = 0
      playSong(playlist.value[nextIndex], nextIndex)
    }
  }

  // 跳转播放
  function seek(time: number) {
    if (!audioElement) return
    audioElement.currentTime = time
    currentTime.value = time
  }

  // 跳转进度（百分比）
  function seekPercent(percent: number) {
    const time = (percent / 100) * duration.value
    seek(time)
  }

  // 设置音量
  function setVolume(val: number) {
    volume.value = Math.max(0, Math.min(1, val))
    if (audioElement) audioElement.volume = volume.value
    if (val > 0 && isMuted.value) isMuted.value = false
  }

  // 切换静音
  function toggleMute() {
    isMuted.value = !isMuted.value
    if (audioElement) audioElement.muted = isMuted.value
  }

  // 切换播放模式
  function togglePlayMode() {
    const modes: Array<'order' | 'random' | 'single'> = ['order', 'random', 'single']
    const currentIdx = modes.indexOf(playMode.value)
    const nextIdx = (currentIdx + 1) % modes.length
    playMode.value = modes[nextIdx]

    if (playMode.value === 'random') {
      playlist.value = shuffleArray(playlist.value)
    }
  }

  // 添加到播放历史
  function addToHistory(song: Song) {
    const history = playHistory.value
    const filtered = history.filter(s => s.id !== song.id)
    filtered.unshift(song)
    playHistory.value = filtered.slice(0, 50)
  }

  // 切换收藏
  function toggleFavorite() {
    if (!currentSong.value) return
    const id = currentSong.value.id
    if (favoriteIds.value.has(id)) {
      favoriteIds.value.delete(id)
    } else {
      favoriteIds.value.add(id)
    }
    saveState()
  }

  // 播放指定索引
  function playByIndex(index: number) {
    if (index >= 0 && index < playlist.value.length) {
      playSong(playlist.value[index], index)
    }
  }

  // 展开/收起
  function expand() { isExpanded.value = true }
  function collapse() { isExpanded.value = false }
  function toggleExpand() { isExpanded.value = !isExpanded.value }

  // 保存状态
  function saveState() {
    saveMusicState({
      isMuted: isMuted.value,
      volume: volume.value,
      playMode: playMode.value,
      playHistory: playHistory.value,
      favoriteIds: Array.from(favoriteIds.value),
    })
  }

  // 初始化
  async function init() {
    const saved = restoreFromStorage()
    if (saved.volume !== undefined) volume.value = saved.volume!
    if (saved.isMuted !== undefined) isMuted.value = saved.isMuted!
    if (saved.playMode !== undefined) playMode.value = saved.playMode!
    if (saved.playHistory) playHistory.value = saved.playHistory!
    if (saved.favoriteIds) favoriteIds.value = new Set(saved.favoriteIds!)

    initAudio()

    const { playlistId, songId } = restoreFromUrl()
    if (playlistId) {
      await loadPlaylist(playlistId)
      if (songId) {
        const idx = playlist.value.findIndex(s => s.id === Number(songId))
        if (idx >= 0) await playSong(playlist.value[idx], idx)
      }
    }
  }

  // 监听状态变化保存
  watch([isMuted, volume, playMode, playHistory, favoriteIds], () => saveState(), { deep: true })

  // ========== 返回 ==========
  return {
    isPlaying, isExpanded, isMuted, volume, currentTime, duration, playMode,
    currentSong, playlist, filteredPlaylist, currentIndex, playHistory, favoriteIds,
    currentLyric, lyricLines, currentLyricIndex, isLoading, error, isVipSong, vipSongIds,
    hasPlaylist, hasSong, progress, isFirst, isLast, isFavorite, playModeText, progressColor,
    loadPlaylist, playSong, playFirstAvailableSong, togglePlay, playPrev, playNext, playNextWithSkipVip, seek, seekPercent,
    setVolume, toggleMute, togglePlayMode, toggleFavorite, playByIndex,
    expand, collapse, toggleExpand, init,
  }
})
