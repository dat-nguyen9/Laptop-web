import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useToastStore = defineStore('toast', () => {
  const toasts = ref([])

  function show(message, type = 'success', duration = 3500, action = null) {
    const id = Date.now() + Math.random()
    const toast = {
      id,
      message,
      type, // 'success', 'info', 'warning', 'error'
      duration,
      action
    }
    toasts.value.push(toast)

    setTimeout(() => {
      remove(id)
    }, duration)
  }

  function success(message, action = null) {
    show(message, 'success', 3500, action)
  }

  function error(message) {
    show(message, 'error', 4000)
  }

  function info(message) {
    show(message, 'info', 3000)
  }

  function remove(id) {
    toasts.value = toasts.value.filter(t => t.id !== id)
  }

  return {
    toasts,
    show,
    success,
    error,
    info,
    remove
  }
})
