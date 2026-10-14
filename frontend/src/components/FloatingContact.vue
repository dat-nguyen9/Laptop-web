<template>
  <div class="fixed bottom-6 right-6 z-50 flex flex-col items-end gap-3 select-none">
    <!-- Expanded Speed Dial Options (Overlay menu) -->
    <transition
      enter-active-class="transition duration-150 ease-out transform"
      enter-from-class="opacity-0 translate-y-2 scale-95"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition duration-100 ease-out transform"
      leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-2 scale-95"
    >
      <div v-if="isOpen" class="flex flex-col items-end gap-2 mb-1">
        <!-- Option 1: Zalo Direct Chat -->
        <a
          href="https://zalo.me/0778333362"
          target="_blank"
          class="flex items-center gap-3 bg-stage-surface pl-4 pr-3 py-2 rounded-lg text-white hover:bg-stage-lift transition-colors duration-150"
        >
          <span class="text-xs font-semibold">
            Chat Zalo: 0778.3333.62
          </span>
          <div class="w-8 h-8 rounded bg-sky-600 text-white flex items-center justify-center font-bold text-xs">
            Zalo
          </div>
        </a>

        <!-- Option 2: Direct Call -->
        <a
          href="tel:0778333362"
          class="flex items-center gap-3 bg-stage-surface pl-4 pr-3 py-2 rounded-lg text-white hover:bg-stage-lift transition-colors duration-150"
        >
          <span class="text-xs font-semibold">
            Gọi Hotline tư vấn
          </span>
          <div class="w-8 h-8 rounded bg-emerald-600 text-white flex items-center justify-center font-bold text-xs">
            Tel
          </div>
        </a>

        <!-- Option 3: Facebook Fanpage -->
        <a
          href="https://www.facebook.com/p/Hi%E1%BA%BFu-Tr%E1%BA%A7n-Laptop-US-61585268909952/"
          target="_blank"
          class="flex items-center gap-3 bg-stage-surface pl-4 pr-3 py-2 rounded-lg text-white hover:bg-stage-lift transition-colors duration-150"
        >
          <span class="text-xs font-semibold">
            Fanpage Hiếu Trần
          </span>
          <div class="w-8 h-8 rounded bg-blue-600 text-white flex items-center justify-center font-bold text-xs">
            FB
          </div>
        </a>

        <!-- Option 4: Scroll to Top -->
        <button
          @click="scrollToTop"
          class="flex items-center gap-3 bg-stage-surface pl-4 pr-3 py-2 rounded-lg text-stage-muted hover:text-white hover:bg-stage-lift transition-colors duration-150"
        >
          <span class="text-xs font-medium">
            Lên đầu trang
          </span>
          <div class="w-8 h-8 rounded bg-stage-bg text-white flex items-center justify-center font-bold text-xs">
            ↑
          </div>
        </button>
      </div>
    </transition>

    <!-- Main Trigger Button -->
    <div class="flex items-center gap-3">
      <button
        @click="isOpen = !isOpen"
        class="w-12 h-12 rounded-xl bg-stage-surface hover:bg-stage-lift text-white flex items-center justify-center transition-colors duration-150 active:scale-95"
        :aria-label="isOpen ? 'Đóng liên hệ' : 'Mở liên hệ Zalo'"
      >
        <span v-if="!isOpen" class="font-bold text-xs">Zalo</span>
        <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const isOpen = ref(false)

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>
