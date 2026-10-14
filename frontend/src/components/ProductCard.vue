<template>
  <div class="group bg-stage-surface hover:bg-stage-lift rounded-xl p-4 flex flex-col justify-between transition-colors duration-150">
    <!-- Image Area -->
    <div class="relative w-full aspect-[4/3] bg-stage-bg rounded-lg overflow-hidden flex items-center justify-center p-3 mb-4">
      <router-link :to="`/products/${product.slug}`" class="block w-full h-full flex items-center justify-center">
        <img
          :src="product.images || 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=600&q=80'"
          :alt="product.name"
          class="max-w-full max-h-full object-contain"
          loading="lazy"
          @error="handleImageError"
        />
      </router-link>

      <div class="absolute top-2 left-2 flex items-center gap-1.5">
        <span class="text-[11px] font-bold px-2 py-0.5 rounded bg-stage-surface text-stage-muted">
          {{ product.brand }}
        </span>
        <span v-if="discountPercent > 0" class="text-[11px] font-bold px-2 py-0.5 rounded bg-stage-accent text-white">
          -{{ discountPercent }}%
        </span>
      </div>

      <!-- Quick View Button on Hover -->
      <button
        @click.prevent="$emit('quickView', product)"
        class="absolute bottom-2 inset-x-2 py-1.5 bg-stage-surface text-stage-ink hover:text-white text-xs font-semibold rounded opacity-0 group-hover:opacity-100 transition-opacity duration-150"
      >
        Xem thông số
      </button>
    </div>

    <!-- Product Info -->
    <div class="space-y-3">
      <div>
        <div class="text-xs text-stage-muted mb-1">
          {{ product.category?.name || 'Doanh nhân' }} • Nhập Mỹ
        </div>

        <router-link
          :to="`/products/${product.slug}`"
          class="font-bold text-white hover:text-stage-muted text-sm sm:text-base line-clamp-2 leading-snug transition-colors"
          :title="product.name"
        >
          {{ product.name }}
        </router-link>
      </div>

      <!-- Spec Indicators -->
      <div class="flex flex-wrap gap-1 text-[11px]">
        <span v-if="specs.cpu" class="px-2 py-0.5 rounded bg-stage-bg text-stage-muted">
          {{ specs.cpu }}
        </span>
        <span v-if="specs.ram" class="px-2 py-0.5 rounded bg-stage-bg text-white font-semibold">
          RAM {{ specs.ram }}
        </span>
        <span v-if="specs.storage" class="px-2 py-0.5 rounded bg-stage-bg text-stage-muted">
          {{ specs.storage }}
        </span>
      </div>

      <!-- Price & Order Actions -->
      <div class="pt-3 flex items-center justify-between gap-2">
        <div>
          <div v-if="product.salePrice" class="text-xs text-stage-muted line-through">
            {{ formatCurrency(product.price) }}
          </div>
          <div class="text-base sm:text-lg font-black text-white">
            {{ formatCurrency(product.salePrice || product.price) }}
          </div>
        </div>

        <div class="flex items-center gap-1.5">
          <a
            :href="`https://zalo.me/0778333362?text=${encodeURIComponent('Hỏi mua máy: ' + product.name + ' - Giá: ' + formatCurrency(product.salePrice || product.price))}`"
            target="_blank"
            class="px-2.5 py-1.5 rounded bg-stage-bg hover:bg-stage-surface text-sky-400 text-xs font-semibold transition-colors"
            title="Chat Zalo"
          >
            Zalo
          </a>

          <button
            @click="handleAddToCart"
            class="px-3 py-1.5 rounded bg-stage-accent text-white hover:opacity-90 text-xs font-semibold transition-opacity"
            title="Thêm giỏ"
          >
            Thêm
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useCartStore } from '@/stores/cart'
import { useToastStore } from '@/stores/toast'

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
})

defineEmits(['quickView'])

const cartStore = useCartStore()
const toastStore = useToastStore()

const discountPercent = computed(() => {
  if (!props.product.price || !props.product.salePrice) return 0
  if (props.product.price <= props.product.salePrice) return 0
  return Math.round(((props.product.price - props.product.salePrice) / props.product.price) * 100)
})

const specs = computed(() => {
  if (!props.product.specs) return {}
  try {
    return typeof props.product.specs === 'string'
      ? JSON.parse(props.product.specs)
      : props.product.specs
  } catch {
    return {}
  }
})

function formatCurrency(val) {
  if (!val) return '0 ₫'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val)
}

function handleImageError(e) {
  e.target.src = 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=600&q=80'
}

function handleAddToCart() {
  cartStore.addItem(props.product)
  toastStore.success(`Đã thêm "${props.product.name}" vào giỏ hàng`, {
    to: '/cart',
    label: 'Xem giỏ hàng'
  })
}
</script>
