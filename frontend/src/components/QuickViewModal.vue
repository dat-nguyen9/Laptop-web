<template>
  <transition
    enter-active-class="transition duration-200 ease-out"
    enter-from-class="opacity-0"
    enter-to-class="opacity-100"
    leave-active-class="transition duration-150 ease-out"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div
      v-if="isOpen && product"
      class="fixed inset-0 z-50 overflow-y-auto bg-black/80 flex items-center justify-center p-4 sm:p-6"
      @click.self="close"
    >
      <div
        class="relative bg-stage-surface w-full max-w-2xl rounded-2xl p-6 sm:p-8 space-y-6 text-stage-ink"
      >
        <!-- Close Button -->
        <button
          @click="close"
          class="absolute top-4 right-4 w-8 h-8 rounded bg-stage-bg hover:bg-stage-lift text-stage-muted hover:text-white flex items-center justify-center transition-colors"
          aria-label="Đóng"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
        </button>

        <!-- Modal Body: 2 Columns -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-center">
          <!-- Image -->
          <div class="aspect-[4/3] rounded-xl bg-stage-bg p-4 flex items-center justify-center">
            <img
              :src="product.images || 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=600&q=80'"
              :alt="product.name"
              class="max-w-full max-h-full object-contain"
            />
          </div>

          <!-- Info -->
          <div class="space-y-4">
            <div>
              <span class="text-xs text-stage-muted">{{ product.brand }} • Nhập Mỹ</span>
              <h3 class="text-lg font-bold text-white leading-snug mt-1">
                {{ product.name }}
              </h3>
            </div>

            <div class="flex items-baseline gap-3">
              <span class="text-2xl font-black text-white">
                {{ formatCurrency(product.salePrice || product.price) }}
              </span>
              <span v-if="product.salePrice" class="text-xs text-stage-muted line-through">
                {{ formatCurrency(product.price) }}
              </span>
            </div>

            <p class="text-xs text-stage-muted line-clamp-3 leading-relaxed">
              {{ product.description }}
            </p>

            <!-- Specs Grid -->
            <div v-if="specs" class="grid grid-cols-2 gap-2 text-xs">
              <div v-if="specs.cpu" class="p-2 rounded bg-stage-bg">
                <span class="text-stage-muted block text-[10px]">CPU</span>
                <span class="font-semibold text-white">{{ specs.cpu }}</span>
              </div>
              <div v-if="specs.ram" class="p-2 rounded bg-stage-bg">
                <span class="text-stage-muted block text-[10px]">RAM</span>
                <span class="font-semibold text-white">{{ specs.ram }}</span>
              </div>
              <div v-if="specs.storage" class="p-2 rounded bg-stage-bg">
                <span class="text-stage-muted block text-[10px]">Ổ cứng</span>
                <span class="font-semibold text-white">{{ specs.storage }}</span>
              </div>
              <div v-if="specs.display" class="p-2 rounded bg-stage-bg">
                <span class="text-stage-muted block text-[10px]">Màn hình</span>
                <span class="font-semibold text-white">{{ specs.display }}</span>
              </div>
            </div>

            <!-- Actions -->
            <div class="flex items-center gap-3 pt-2">
              <button
                @click="addToCartAndClose"
                class="flex-1 py-2.5 px-4 bg-stage-accent hover:opacity-90 text-white font-bold text-xs rounded transition-opacity"
              >
                Thêm vào giỏ
              </button>

              <router-link
                :to="`/products/${product.slug}`"
                @click="close"
                class="py-2.5 px-4 bg-stage-bg hover:bg-stage-lift text-white font-semibold text-xs rounded transition-colors"
              >
                Xem chi tiết
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { computed } from 'vue'
import { useCartStore } from '@/stores/cart'
import { useToastStore } from '@/stores/toast'

const props = defineProps({
  isOpen: Boolean,
  product: Object
})

const emit = defineEmits(['close'])

const cartStore = useCartStore()
const toastStore = useToastStore()

const specs = computed(() => {
  if (!props.product?.specs) return null
  try {
    return typeof props.product.specs === 'string'
      ? JSON.parse(props.product.specs)
      : props.product.specs
  } catch {
    return null
  }
})

function formatCurrency(val) {
  if (!val) return '0 ₫'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val)
}

function close() {
  emit('close')
}

function addToCartAndClose() {
  if (props.product) {
    cartStore.addItem(props.product)
    toastStore.success(`Đã thêm "${props.product.name}" vào giỏ hàng`, {
      to: '/cart',
      label: 'Xem giỏ hàng'
    })
    close()
  }
}
</script>
