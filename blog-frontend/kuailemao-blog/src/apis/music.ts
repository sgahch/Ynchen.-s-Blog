/**
 * 网易云音乐 API 服务
 * 使用免费的第三方代理服务，无需部署后端
 * 可用代理：
 * 1. VITE_APP_MUSIC_PROXY_URL - 自定义代理地址
 * 2. 默认使用: https://api.muxiaoguo.cn/api/NETEASE-MUSIC
 */

const PROXY_URL = import.meta.env.VITE_APP_MUSIC_PROXY_URL

// 免费第三方代理API (无需部署，直接可用)
const FREE_PROXY_BASE = 'https://api-enhanced-rho-gold.vercel.app'

// API基础地址
const API_BASE = PROXY_URL ? `${PROXY_URL}/api/music` : FREE_PROXY_BASE

// 网易云API路径
const NCM_API = {
  // 获取歌单详情
  playlistDetail: '/playlist/detail',
  // 获取歌曲详情
  songDetail: '/song/detail',
  // 获取歌曲URL
  songUrl: '/song/url',
  // 获取歌词
  lyric: '/lyric',
  // 搜索
  search: '/search',
}

// 歌单ID (用户提供的歌单)
export const PLAYLIST_ID = 12433389973

// 缓存配置
const CACHE_DURATION = 5 * 60 * 1000 // 5分钟

// 简单请求封装
async function request<T>(url: string, params: Record<string, any> = {}): Promise<T> {
  const apiUrl = API_BASE + url
  const queryString = new URLSearchParams(params).toString()
  const fullUrl = queryString ? `${apiUrl}?${queryString}` : apiUrl

  try {
    const response = await fetch(fullUrl)
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    return response.json()
  } catch (error) {
    console.error('Music API Error:', error)
    throw error
  }
}

// 接口响应类型
interface NCMResponse<T> {
  code: number
  data?: T
  playlist?: any
  songs?: any[]
  lrc?: { lyric: string }
  [key: string]: any
}

// 歌曲类型
export interface Song {
  id: number
  name: string
  artists: Artist[]
  album: Album
  duration: number
  url?: string
  picUrl?: string
  lrc?: string
}

export interface Artist {
  id: number
  name: string
  picUrl?: string
}

export interface Album {
  id: number
  name: string
  picUrl: string
}

// 从网易云数据结构转换为统一格式
function transformSong(songs: any[]): Song[] {
  if (!songs) return []
  return songs.map((item: any) => ({
    id: item.id,
    name: item.name,
    artists: item.ar || item.artists || [],
    album: {
      id: item.al?.id || item.album?.id,
      name: item.al?.name || item.album?.name || '未知专辑',
      picUrl: item.al?.picUrl || item.album?.picUrl || '',
    },
    duration: item.dt || item.duration || 0,
    url: item.url,
    picUrl: item.al?.picUrl || item.album?.picUrl || '',
  }))
}

// API 方法

/**
 * 获取歌单详情
 */
export async function getPlaylistDetail(id: number | string): Promise<{
  playlist: {
    id: number
    name: string
    coverImgUrl: string
    description: string
    trackCount: number
    playCount: number
    creator: any
  }
  songs: Song[]
}> {
  const data = await request<NCMResponse<any>>(
    NCM_API.playlistDetail,
    { id: id.toString() }
  )

  if (data.code !== 200) {
    throw new Error('获取歌单详情失败')
  }

  return {
    playlist: {
      id: data.playlist.id,
      name: data.playlist.name,
      coverImgUrl: data.playlist.coverImgUrl,
      description: data.playlist.description,
      trackCount: data.playlist.trackCount,
      playCount: data.playlist.playCount,
      creator: data.playlist.creator,
    },
    songs: transformSong(data.playlist.tracks),
  }
}

/**
 * 获取歌曲详情
 */
export async function getSongDetail(ids: string | number): Promise<Song[]> {
  const data = await request<NCMResponse<any>>(
    NCM_API.songDetail,
    { ids: ids.toString() }
  )

  if (data.code !== 200) {
    throw new Error('获取歌曲详情失败')
  }

  return transformSong(data.songs)
}

/**
 * 获取歌曲播放URL
 */
export async function getSongUrl(id: number | string): Promise<string> {
  const data = await request<NCMResponse<any>>(
    NCM_API.songUrl,
    { id: id.toString() }
  )

  if (data.code !== 200) {
    throw new Error('获取歌曲URL失败')
  }

  const songData = data.data?.[0]
  if (songData && songData.url) {
    return songData.url
  }
  throw new Error('歌曲无法播放')
}

/**
 * 获取歌词
 */
export async function getLyric(id: number | string): Promise<string> {
  const data = await request<NCMResponse<any>>(
    NCM_API.lyric,
    { id: id.toString() }
  )

  if (data.code !== 200) {
    throw new Error('获取歌词失败')
  }

  return data.lrc?.lyric || ''
}

// 本地缓存管理
const cache = new Map<string, { data: any; time: number }>()

function getCache<T>(key: string): T | null {
  const item = cache.get(key)
  if (item && Date.now() - item.time < CACHE_DURATION) {
    return item.data
  }
  cache.delete(key)
  return null
}

function setCache(key: string, data: any): void {
  cache.set(key, { data, time: Date.now() })
}

/**
 * 获取并缓存歌单详情
 */
export async function getCachedPlaylistDetail(id: number | string) {
  const cacheKey = `playlist_${id}`
  const cached = getCache<any>(cacheKey)
  if (cached) return cached

  const data = await getPlaylistDetail(id)
  setCache(cacheKey, data)
  return data
}

/**
 * 搜索歌曲
 */
export async function searchSongs(keywords: string, limit = 20): Promise<Song[]> {
  const data = await request<NCMResponse<any>>(
    NCM_API.search,
    { keywords, limit: limit.toString(), type: '1' }
  )

  if (data.code !== 200) {
    throw new Error('搜索失败')
  }

  return transformSong(data.result?.songs || [])
}

/**
 * 下载歌曲（通过播放URL）
 */
export function getDownloadUrl(url: string, filename: string = 'music.mp3') {
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  link.target = '_blank'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

export default {
  getPlaylistDetail,
  getSongDetail,
  getSongUrl,
  getLyric,
  searchSongs,
  getCachedPlaylistDetail,
  getDownloadUrl,
  PLAYLIST_ID,
}
