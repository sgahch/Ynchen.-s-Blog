<template>
  <Card title="全站浏览量" prefix-icon="statistics" :isScale="true">
    <div class="visit-count">
      <span class="count">{{ formatted }}</span>
      <span class="unit">次</span>
    </div>
  </Card>
  </template>

<script setup lang="ts">
import Card from '@/components/Card/index.vue'
import { computed } from 'vue'
import useWebsiteStore from '@/store/modules/website.ts'

const useWebsite = useWebsiteStore()

const formatted = computed(() => {
  const n = useWebsite.webInfo?.visitCount ?? 0
  try {
    return new Intl.NumberFormat('zh-CN').format(n as number)
  } catch {
    return String(n)
  }
})
</script>

<style scoped lang="scss">
.visit-count {
  display: flex;
  align-items: baseline;
  justify-content: center;
  gap: 6px;
  color: var(--el-text-color-primary);

  .count {
    font-size: 20px;
    font-weight: 600;
  }

  .unit {
    font-size: 12px;
    color: var(--el-text-color-secondary);
  }
}
</style>
