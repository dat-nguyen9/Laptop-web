<template>
  <div class="fixed top-20 right-4 sm:right-6 z-50 flex flex-col gap-2 max-w-sm w-full pointer-events-none">
    <transition-group
      enter-active-class="transition duration-200 ease-out transform"
      enter-from-class="translate-y-2 opacity-0 scale-95"
      enter-to-class="translate-y-0 opacity-100 scale-100"
      leave-active-class="transition duration-150 ease-out transform"
      leave-from-class="opacity-100 scale-100"
      leave-to-class="opacity-0 scale-95"
    >
      <div
        v-for="toast in toastStore.toasts"
        :key="toast.id"
        class="pointer-events-auto p-4 rounded-xl flex items-start gap-3 bg-stage-surface text-stage-ink transition-colors"
      >
        <!-- Icon Marker -->
        <div
          class="w-6 h-6 rounded flex items-center justify-center flex-shrink-0 text-xs font-bold"
          :class="[
            toast.type === 'success' ? 'bg-emerald-950 text-emerald-400' :
            toast.type === 'error' ? 'bg-rose-950 text-rose-400' :
            'bg-stage-bg text-white'
          ]"
        >
          <span v-if="toast.type === 'success'">OK</span>
          <span v-else-if="toast.type === 'error'">ER</span>
          <span v-else>i</span>
        </div>

        <!-- Content -->
        <div class="flex-1 min-w-0 pt-0.5">
          <p class="text-xs font-semibold leading-snug">
            {{ toast.message }}
          </p>

          <router-link
            v-if="toast.action"
            :to="toast.action.to"
            @click="toastStore.remove(toast.id)"
            class="inline-block text-[11px] font-bold text-sky-400 hover:underline mt-1"
          >
            {{ toast.action.label }} →
          </router-link>
        </div>

        <!-- Close Button -->
        <button
          @click="toastStore.remove(toast.id)"
          class="text-stage-muted hover:text-white p-1 transition-colors"
          aria-label="Đóng"
        >
          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
        </button>
      </div>
    </transition-group>
  </div>
</template>

<script setup>
import { useToastStore } from '@/stores/toast'

const toastStore = useToastStore()
</script>
