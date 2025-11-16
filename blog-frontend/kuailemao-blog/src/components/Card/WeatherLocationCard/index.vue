<template>
  <Card title="所在地天气" prefix-icon="address_icon" :isScale="true">
    <div class="container" v-if="!loading && city">
      <div class="place">
        <span class="city">{{ displayCity }}</span>
        <span class="isp" v-if="detail?.isp">{{ detail?.isp }}</span>
      </div>
      <div class="weather" v-if="weather">
        <span class="temp">{{ Math.round(weather.temperature) }}℃</span>
        <span class="desc">{{ weatherDesc }}</span>
        <span class="wind" v-if="weather.wind">风速 {{ Math.round(weather.wind) }} m/s</span>
      </div>
    </div>
    <div class="placeholder" v-else>
      <el-skeleton :loading="loading" animated :rows="2"/>
    </div>
  </Card>
</template>

<script setup lang="ts">
import Card from '@/components/Card/index.vue'
import { ref, computed, onMounted } from 'vue'
import { getIpDetail } from '@/apis/public'

type IpDetail = {
  ip?: string
  isp?: string
  city?: string
  region?: string
  country?: string
}

const loading = ref(true)
const detail = ref<IpDetail | null>(null)
const city = computed(() => detail.value?.city || '')
const displayCity = computed(() => {
  const r = detail.value?.region || ''
  const c = detail.value?.city || ''
  return r && c ? `${r} · ${c}` : (r || c)
})

const weather = ref<{ temperature: number; code: number; wind?: number } | null>(null)
const weatherDesc = computed(() => codeToDesc(weather.value?.code))

function codeToDesc(code?: number) {
  const map: Record<number, string> = {
    0: '晴', 1: '多云', 2: '阴', 3: '雾', 45: '雾', 48: '雾冰',
    51: '小雨', 53: '中雨', 55: '大雨', 61: '小雨', 63: '中雨', 65: '大雨',
    71: '小雪', 73: '中雪', 75: '大雪', 80: '阵雨', 81: '阵雨', 82: '强阵雨',
    95: '雷雨', 96: '雷雨伴冰雹', 99: '强雷雨伴冰雹'
  }
  return map[code ?? -1] ?? '未知天气'
}

async function fetchWeatherByCity(name: string) {
  try {
    const geo = await fetch(`https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(name)}&language=zh&count=1`).then(r => r.json())
    const item = geo?.results?.[0]
    if (!item) return
    const { latitude, longitude } = item
    const data = await fetch(`https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current=temperature_2m,weather_code,wind_speed_10m`).then(r => r.json())
    const cur = data?.current
    if (cur) {
      weather.value = { temperature: cur.temperature_2m, code: cur.weather_code, wind: cur.wind_speed_10m }
    }
  } catch (_) {}
}

async function init() {
  try {
    const res = await getIpDetail()
    detail.value = res.data
    const name = detail.value?.city || detail.value?.region
    if (name) await fetchWeatherByCity(name)
  } catch (_) {
    // 兜底：使用 ipapi.co 获取城市
    try {
      const ipRes = await fetch('https://ipapi.co/json/').then(r => r.json())
      detail.value = { city: ipRes.city, region: ipRes.region, country: ipRes.country_name, ip: ipRes.ip }
      if (ipRes.city) await fetchWeatherByCity(ipRes.city)
    } catch (_) {}
  } finally {
    loading.value = false
  }
}

onMounted(() => { init() })
</script>

<style scoped lang="scss">
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  color: var(--el-text-color-primary);

  .place {
    display: flex;
    gap: 8px;
    align-items: baseline;
    .city { font-weight: 600; }
    .isp { font-size: 12px; color: var(--el-text-color-secondary); }
  }

  .weather {
    display: flex;
    gap: 10px;
    align-items: baseline;
    .temp { font-size: 20px; font-weight: 600; }
    .desc { font-size: 13px; }
    .wind { font-size: 12px; color: var(--el-text-color-secondary); }
  }
}

.placeholder { padding: 6px 10px; }
</style>
