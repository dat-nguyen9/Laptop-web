<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
    <!-- Breadcrumb & Header -->
    <div class="space-y-3">
      <nav class="flex items-center gap-2 text-xs text-stage-muted font-medium">
        <router-link to="/" class="hover:text-white transition-colors">Trang chủ</router-link>
        <span>/</span>
        <span class="text-stage-ink font-semibold">Theo dõi & Lịch sử đơn hàng</span>
      </nav>
      <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
        <div>
          <h1 class="text-3xl sm:text-4xl font-extrabold tracking-tight text-white leading-tight">
            Lịch sử & Tra cứu đơn hàng
          </h1>
          <p class="text-sm text-stage-muted mt-1">
            Theo dõi tình trạng test máy, video xác nhận ngoại hình và lộ trình giao hàng COD
          </p>
        </div>
        <div class="flex items-center gap-2 self-start sm:self-auto">
          <button
            v-if="authStore.isAuthenticated"
            @click="activeMode = 'my'"
            :class="[
              'px-3.5 py-1.5 rounded-lg text-xs font-semibold transition-colors',
              activeMode === 'my'
                ? 'bg-stage-surface text-white'
                : 'text-stage-muted hover:text-white bg-stage-bg'
            ]"
          >
            Đơn của tôi ({{ myOrdersCount }})
          </button>
          <button
            @click="activeMode = 'track'"
            :class="[
              'px-3.5 py-1.5 rounded-lg text-xs font-semibold transition-colors',
              activeMode === 'track'
                ? 'bg-stage-surface text-white'
                : 'text-stage-muted hover:text-white bg-stage-bg'
            ]"
          >
            Tra cứu theo SĐT
          </button>
        </div>
      </div>
    </div>

    <!-- Mode: Track by Phone or Order ID Form -->
    <div v-if="activeMode === 'track'" class="bg-stage-surface p-6 rounded-2xl space-y-4">
      <div class="max-w-2xl space-y-2">
        <h2 class="text-base font-bold text-white">Tra cứu nhanh tình trạng đơn hàng</h2>
        <p class="text-xs text-stage-muted">
          Dành cho khách hàng đặt mua qua Zalo hoặc website chưa tạo tài khoản. Nhập số điện thoại nhận hàng để xem chi tiết.
        </p>
      </div>

      <form @submit.prevent="handleTrackOrders" class="flex flex-col sm:flex-row gap-3 max-w-2xl">
        <div class="flex-1">
          <input
            v-model="trackPhone"
            type="tel"
            required
            placeholder="Nhập số điện thoại nhận máy (ví dụ: 0912345678)"
            class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
          />
        </div>
        <div class="w-full sm:w-40">
          <input
            v-model="trackOrderId"
            type="number"
            placeholder="Mã đơn (tùy chọn)"
            class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
          />
        </div>
        <button
          type="submit"
          :disabled="tracking"
          class="px-6 py-2.5 bg-stage-accent hover:bg-red-700 text-white font-bold text-xs rounded-xl transition-colors disabled:opacity-50 whitespace-nowrap"
        >
          <span>{{ tracking ? 'Đang tìm...' : 'Tra cứu' }}</span>
        </button>
      </form>

      <p v-if="trackError" class="text-xs text-rose-400 font-medium">
        {{ trackError }}
      </p>
    </div>

    <!-- Loading Skeleton -->
    <div v-if="loading" class="space-y-4">
      <div v-for="i in 3" :key="i" class="h-32 bg-stage-surface rounded-2xl opacity-60"></div>
    </div>

    <!-- Empty State -->
    <div v-else-if="displayedOrders.length === 0" class="text-center py-20 bg-stage-surface rounded-2xl p-8 max-w-xl mx-auto space-y-5">
      <div class="w-16 h-16 bg-stage-bg rounded-2xl flex items-center justify-center mx-auto text-stage-muted">
        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
        </svg>
      </div>
      <div>
        <h2 class="text-xl font-bold text-white">
          {{ activeMode === 'track' && hasSearched ? 'Không tìm thấy đơn hàng' : 'Chưa có đơn hàng nào' }}
        </h2>
        <p class="text-xs text-stage-muted mt-2 max-w-sm mx-auto leading-relaxed">
          {{ activeMode === 'track' && hasSearched
              ? 'Vui lòng kiểm tra lại số điện thoại hoặc liên hệ trực tiếp Zalo 0778.3333.62 để được shop hỗ trợ ngay.'
              : 'Khi bạn đặt mua laptop qua Zalo hoặc website, toàn bộ thông tin đơn hàng và tiến độ test máy sẽ được hiển thị tại đây.' }}
        </p>
      </div>
      <div class="flex justify-center gap-3">
        <router-link
          to="/products"
          class="inline-flex items-center gap-2 px-6 py-3.5 bg-stage-accent hover:bg-red-700 text-white font-bold text-xs rounded-xl transition-colors"
        >
          <span>Xem kho máy nhập Mỹ</span>
          <span>→</span>
        </router-link>
        <a
          href="https://zalo.me/0778333362"
          target="_blank"
          class="inline-flex items-center gap-2 px-5 py-3.5 bg-stage-bg hover:bg-stage-lift text-white font-bold text-xs rounded-xl transition-colors"
        >
          <span>Hỏi hỗ trợ qua Zalo</span>
        </a>
      </div>
    </div>

    <!-- Orders List -->
    <div v-else class="space-y-4">
      <div
        v-for="order in displayedOrders"
        :key="order.id"
        class="bg-stage-surface p-6 rounded-2xl space-y-4"
      >
        <!-- Order Header -->
        <div class="flex flex-wrap items-center justify-between gap-3">
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-stage-bg text-stage-ink flex items-center justify-center font-bold text-xs">
              #{{ order.id }}
            </div>
            <div>
              <p class="text-xs text-stage-muted font-medium">Thời gian đặt:</p>
              <p class="text-xs font-bold text-white">{{ formatDate(order.createdAt) }}</p>
            </div>
          </div>

          <div class="flex items-center gap-3">
            <span :class="getStatusBadgeClass(order.status)" class="px-3 py-1.5 text-xs font-bold rounded-lg">
              {{ formatStatus(order.status) }}
            </span>

            <a
              :href="`https://zalo.me/0778333362?text=${encodeURIComponent('Xin chào shop, tôi muốn kiểm tra tình trạng đơn hàng #' + order.id + ' (SĐT ' + order.phone + ')')}`"
              target="_blank"
              class="px-3 py-1.5 bg-stage-bg hover:bg-stage-lift text-white text-xs font-semibold rounded-lg transition-colors inline-flex items-center gap-1.5"
            >
              <span>Hỏi qua Zalo</span>
            </a>
          </div>
        </div>

        <!-- Order Items -->
        <div class="bg-stage-bg rounded-xl p-3.5 space-y-2">
          <div
            v-for="item in order.items"
            :key="item.id"
            class="flex items-center justify-between text-xs sm:text-sm py-1"
          >
            <div class="flex items-center gap-2.5">
              <span class="w-6 h-6 rounded bg-stage-surface flex items-center justify-center font-bold text-xs text-stage-muted">
                {{ item.quantity }}x
              </span>
              <span class="text-white font-medium">{{ item.product?.name }}</span>
            </div>
            <span class="font-bold text-white ml-4">
              {{ formatCurrency(item.price * item.quantity) }}
            </span>
          </div>
        </div>

        <!-- Order Footer Info -->
        <div class="flex flex-col sm:flex-row justify-between sm:items-center gap-3 text-xs pt-1">
          <div class="text-stage-muted space-y-0.5">
            <p>Người nhận: <strong class="text-white font-medium">{{ order.fullName }}</strong> ({{ order.phone }})</p>
            <p>Địa chỉ nhận máy: <strong class="text-white font-medium">{{ order.address }}</strong></p>
            <p v-if="order.note" class="text-stage-muted">Ghi chú: <em>{{ order.note }}</em></p>
          </div>
          <div class="sm:text-right">
            <span class="text-xs text-stage-muted block font-medium">Tổng thanh toán COD:</span>
            <span class="text-xl font-black text-stage-accent">
              {{ formatCurrency(order.total) }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { orderApi } from '@/api/orders'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const authStore = useAuthStore()

const activeMode = ref(authStore.isAuthenticated ? 'my' : 'track')
const myOrders = ref([])
const trackedOrders = ref([])
const loading = ref(true)
const tracking = ref(false)
const trackError = ref('')
const hasSearched = ref(false)

const trackPhone = ref('')
const trackOrderId = ref('')

const myOrdersCount = computed(() => myOrders.value.length)

const displayedOrders = computed(() => {
  if (activeMode.value === 'my') {
    return myOrders.value
  }
  return trackedOrders.value
})

function formatCurrency(val) {
  if (!val) return '0 ₫'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val)
}

function formatDate(dateStr) {
  if (!dateStr) return ''
  return new Date(dateStr).toLocaleDateString('vi-VN', {
    day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit'
  })
}

function formatStatus(status) {
  const map = {
    PENDING: 'Chờ xác nhận & Test máy',
    CONFIRMED: 'Đã xác nhận (Đang quay video)',
    SHIPPING: 'Đang gửi COD đồng kiểm',
    DELIVERED: 'Đã nhận máy thành công',
    CANCELLED: 'Đã hủy đơn'
  }
  return map[status] || status
}

function getStatusBadgeClass(status) {
  switch (status) {
    case 'PENDING': return 'bg-amber-500/10 text-amber-400'
    case 'CONFIRMED': return 'bg-sky-500/10 text-sky-400'
    case 'SHIPPING': return 'bg-blue-500/10 text-blue-400'
    case 'DELIVERED': return 'bg-emerald-500/10 text-emerald-400'
    case 'CANCELLED': return 'bg-rose-500/10 text-rose-400'
    default: return 'bg-stage-bg text-stage-ink'
  }
}

async function loadMyOrders() {
  if (!authStore.isAuthenticated) {
    loading.value = false
    return
  }
  loading.value = true
  try {
    const res = await orderApi.getMyOrders()
    myOrders.value = res.data || []
  } catch (err) {
    console.error('Lỗi nạp đơn hàng:', err)
  } finally {
    loading.value = false
  }
}

async function handleTrackOrders() {
  if (!trackPhone.value.trim()) return
  tracking.value = true
  trackError.value = ''
  hasSearched.value = true

  try {
    const params = { phone: trackPhone.value.trim() }
    if (trackOrderId.value) {
      params.orderId = trackOrderId.value
    }
    const res = await orderApi.trackOrders(params)
    trackedOrders.value = res.data || []
  } catch (err) {
    trackError.value = err.response?.data?.message || 'Có lỗi khi tra cứu đơn hàng, vui lòng thử lại!'
  } finally {
    tracking.value = false
  }
}

onMounted(() => {
  if (route.query.phone) {
    trackPhone.value = String(route.query.phone)
    if (route.query.orderId) {
      trackOrderId.value = String(route.query.orderId)
    }
    activeMode.value = 'track'
    handleTrackOrders()
  } else if (authStore.isAuthenticated) {
    loadMyOrders()
  } else {
    loading.value = false
  }
})
</script>
