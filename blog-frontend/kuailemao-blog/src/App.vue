<template>
  <div>
    <router-view></router-view>
  </div>

  <canvas id="fx"></canvas>

  <!-- 全局loading -->
  <loading></loading>
  <MusicPlayer />
  <DevToolsBlocker :enableDevToolsBlocker="true" />
  <ContextMenu />
</template>

<script setup lang="ts">
import {useDark, useToggle} from "@vueuse/core";
import useWebsiteStore from "@/store/modules/website.ts";
import DevToolsBlocker from "@/components/DevToolsBlocker/index.vue";
import ContextMenu from "@/components/ContextMenu/index.vue";
import MusicPlayer from "@/components/MusicPlayer/index.vue";
import { onMounted } from 'vue'
import initMouseTrail from "@/utils/mouseTrail.ts";

const useWebsite = useWebsiteStore()

onMounted(() => {
  initMouseTrail();
  useWebsite.getInfo()
})

//  深色切换
useDark({
  selector: 'html',
  attribute: 'class',
  valueLight: 'light',
  valueDark: 'dark'
})

useDark({
  onChanged(dark) {
    useToggle(dark)
  }
})
</script>

<style  lang="scss">

    #fx {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      pointer-events: none; // 不影响鼠标事件
      z-index: 99999;
    }


</style>