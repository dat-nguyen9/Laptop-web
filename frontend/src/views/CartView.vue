<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-10">
    <!-- Breadcrumb & Header -->
    <div class="space-y-3">
      <nav class="flex items-center gap-2 text-xs text-stage-muted font-medium">
        <router-link to="/" class="hover:text-white transition-colors">Trang chủ</router-link>
        <span>/</span>
        <span class="text-stage-ink font-semibold">Giỏ hàng & Đặt hàng</span>
      </nav>
      <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
        <div>
          <h1 class="text-3xl sm:text-4xl font-extrabold tracking-tight text-white leading-tight">
            Giỏ hàng của bạn
          </h1>
          <p class="text-sm text-stage-muted mt-1">
            Xác nhận cấu hình và hoàn tất thông tin giao máy đồng kiểm COD
          </p>
        </div>
        <span v-if="cartStore.items.length > 0" class="self-start sm:self-auto text-xs font-bold px-3 py-1.5 bg-stage-surface text-stage-ink rounded-lg">
          {{ cartStore.totalItems }} sản phẩm đã chọn
        </span>
      </div>
    </div>

    <!-- Empty State -->
    <div v-if="cartStore.items.length === 0" class="text-center py-20 bg-stage-surface rounded-2xl p-8 max-w-xl mx-auto space-y-5">
      <div class="w-16 h-16 bg-stage-bg text-stage-muted rounded-2xl flex items-center justify-center mx-auto">
        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
        </svg>
      </div>
      <div>
        <h2 class="text-xl font-bold text-white">Giỏ hàng hiện đang trống</h2>
        <p class="text-xs text-stage-muted mt-2 max-w-sm mx-auto leading-relaxed">
          Chưa có sản phẩm nào trong giỏ hàng. Hãy xem qua danh mục ThinkPad, Dell XPS và MacBook nguyên bản nhập Mỹ.
        </p>
      </div>
      <router-link
        to="/products"
        class="inline-flex items-center gap-2 px-6 py-3.5 bg-stage-accent hover:bg-red-700 text-white font-bold text-xs rounded-xl transition-colors"
      >
        <span>Khám phá kho máy nhập Mỹ</span>
        <span>→</span>
      </router-link>
    </div>

    <!-- Active Cart: 2 Column Layout -->
    <div v-else class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
      <!-- Left: Item List (7 cols) -->
      <div class="lg:col-span-7 space-y-4">
        <div
          v-for="item in cartStore.items"
          :key="item.id"
          class="bg-stage-surface p-4 sm:p-5 rounded-2xl flex flex-col sm:flex-row items-start sm:items-center gap-4 transition-colors"
        >
          <!-- Thumbnail -->
          <div class="relative w-24 h-24 rounded-xl bg-stage-bg p-2 flex-shrink-0 flex items-center justify-center overflow-hidden">
            <img
              :src="item.images || 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=400&q=80'"
              :alt="item.name"
              class="max-w-full max-h-full object-contain"
              @error="e => e.target.src = 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=400&q=80'"
            />
            <span class="absolute bottom-1 right-1 text-[9px] font-bold px-1.5 py-0.5 rounded bg-stage-surface text-white">
              {{ item.brand }}
            </span>
          </div>

          <!-- Product Details -->
          <div class="flex-grow min-w-0">
            <router-link
              :to="`/products/${item.slug}`"
              class="font-bold text-white hover:text-stage-accent transition-colors text-sm sm:text-base line-clamp-1"
            >
              {{ item.name }}
            </router-link>

            <p class="text-stage-accent font-bold text-sm sm:text-base mt-1">
              {{ formatCurrency(item.salePrice || item.price) }}
            </p>

            <!-- Quantity Stepper & Remove -->
            <div class="flex items-center gap-4 mt-3">
              <div class="flex items-center bg-stage-bg rounded-lg overflow-hidden">
                <button
                  @click="cartStore.updateQuantity(item.id, item.quantity - 1)"
                  class="w-8 h-7 flex items-center justify-center font-bold text-stage-muted hover:text-white hover:bg-stage-lift transition-colors text-xs"
                  aria-label="Giảm số lượng"
                >
                  -
                </button>
                <span class="w-8 text-center text-xs font-bold text-white">{{ item.quantity }}</span>
                <button
                  @click="cartStore.updateQuantity(item.id, item.quantity + 1)"
                  class="w-8 h-7 flex items-center justify-center font-bold text-stage-muted hover:text-white hover:bg-stage-lift transition-colors text-xs"
                  aria-label="Tăng số lượng"
                >
                  +
                </button>
              </div>

              <button
                @click="cartStore.removeItem(item.id)"
                class="text-xs text-stage-muted hover:text-rose-400 font-medium transition-colors flex items-center gap-1"
              >
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
                <span>Xóa</span>
              </button>
            </div>
          </div>

          <!-- Total price per item -->
          <div class="sm:text-right flex-shrink-0">
            <span class="text-xs text-stage-muted block font-medium">Thành tiền:</span>
            <span class="font-bold text-white text-sm sm:text-base">
              {{ formatCurrency((item.salePrice || item.price) * item.quantity) }}
            </span>
          </div>
        </div>

        <!-- Back to shop link -->
        <div class="pt-2">
          <router-link to="/products" class="inline-flex items-center gap-1.5 text-xs font-bold text-stage-muted hover:text-white transition-colors">
            <span>← Tiếp tục xem thêm mẫu khác</span>
          </router-link>
        </div>
      </div>

      <!-- Right: Checkout Information & Zalo Order Form (5 cols) -->
      <div class="lg:col-span-5">
        <div class="bg-stage-surface p-6 sm:p-7 rounded-2xl lg:sticky lg:top-24 space-y-6">
          <div class="flex items-center justify-between pb-1">
            <h2 class="text-sm font-bold text-white flex items-center gap-2">
              <svg class="w-4 h-4 text-stage-accent" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              <span>Thông tin nhận máy</span>
            </h2>
            <span class="text-xs font-medium text-stage-muted">Giao COD toàn quốc</span>
          </div>

          <form @submit.prevent="handleCheckout" class="space-y-4">
            <div>
              <label class="block text-xs font-semibold text-stage-muted mb-1.5">Họ tên người nhận *</label>
              <input
                v-model="customerForm.fullName"
                type="text"
                required
                minlength="2"
                placeholder="Ví dụ: Nguyễn Văn A"
                class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
              />
            </div>

            <div>
              <label class="block text-xs font-semibold text-stage-muted mb-1.5">Số điện thoại nhận máy *</label>
              <input
                v-model="customerForm.phone"
                type="tel"
                required
                placeholder="Ví dụ: 0912345678 (10 số)"
                class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
              />
              <p v-if="phoneError" class="text-xs text-rose-400 mt-1 font-medium">
                {{ phoneError }}
              </p>
            </div>

            <div>
              <label class="block text-xs font-semibold text-stage-muted mb-1.5">Địa chỉ nhận hàng (Chi tiết) *</label>
              <input
                v-model="customerForm.address"
                type="text"
                required
                minlength="5"
                placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành"
                class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
              />
            </div>

            <div>
              <label class="block text-xs font-semibold text-stage-muted mb-1.5">Ghi chú (Cài sẵn phần mềm, giờ giao...)</label>
              <textarea
                v-model="customerForm.note"
                rows="2"
                placeholder="Cài sẵn Windows, Office hoặc yêu cầu riêng..."
                class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors resize-none"
              ></textarea>
            </div>

            <!-- Order Financial Summary -->
            <div class="bg-stage-bg rounded-xl p-4 space-y-2">
              <div class="flex justify-between text-xs text-stage-muted">
                <span>Số lượng sản phẩm:</span>
                <span class="font-bold text-white">{{ cartStore.totalItems }} máy</span>
              </div>
              <div class="flex justify-between text-xs text-stage-muted">
                <span>Vận chuyển COD:</span>
                <span class="font-bold text-emerald-400">Miễn phí toàn quốc</span>
              </div>
              <div class="flex justify-between items-baseline pt-2">
                <span class="font-bold text-white text-sm">Tổng cộng thanh toán:</span>
                <span class="text-xl sm:text-2xl font-black text-stage-accent">
                  {{ formatCurrency(cartStore.totalPrice) }}
                </span>
              </div>
            </div>

            <!-- Main CTA Submit Button -->
            <button
              type="submit"
              :disabled="submitting"
              class="w-full py-4 bg-stage-accent hover:bg-red-700 text-white font-bold text-sm rounded-xl transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
            >
              <span v-if="submitting" class="animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent"></span>
              <span>{{ submitting ? 'Đang tạo đơn hàng...' : 'Xác nhận & Đặt hàng qua Zalo' }}</span>
            </button>
          </form>

          <!-- Instructions Box -->
          <div class="p-3.5 bg-stage-bg rounded-xl text-xs text-stage-muted space-y-1.5">
            <p class="font-bold text-white flex items-center gap-1.5">
              <span>Quy trình mua hàng:</span>
            </p>
            <p>1. Xác nhận đơn và tự động mở chat Zalo trực tiếp với chủ shop (0778.3333.62).</p>
            <p>2. Shop quay video test thực tế ngoại hình và linh kiện trước khi đóng gói gửi COD.</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Success Modal Popup -->
    <div v-if="orderSuccess" class="fixed inset-0 bg-black/80 z-50 flex items-center justify-center p-4">
      <div class="bg-stage-surface rounded-2xl max-w-md w-full p-6 sm:p-8 text-center space-y-5">
        <div class="w-14 h-14 bg-stage-lift text-emerald-400 rounded-xl flex items-center justify-center mx-auto">
          <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        </div>

        <div class="space-y-1.5">
          <h2 class="text-xl font-bold text-white">Đặt hàng thành công</h2>
          <p class="text-xs sm:text-sm text-stage-muted">
            Mã đơn hàng của bạn là <strong class="text-white">#{{ orderResult?.orderId }}</strong>
          </p>
          <div class="p-3 bg-stage-bg rounded-xl text-xs text-stage-muted">
            Tổng thanh toán COD: <strong class="text-stage-accent text-sm font-bold">{{ formatCurrency(orderResult?.total) }}</strong>
          </div>
        </div>

        <!-- Scan Zalo QR directly -->
        <div class="p-3.5 bg-stage-bg rounded-xl flex items-center gap-3.5 text-left">
          <img
            :src="'https://api.qrserver.com/v1/create-qr-code/?size=120x120&margin=2&data=' + encodeURIComponent(orderResult?.zaloUrl || 'https://zalo.me/0778333362')"
            alt="Quét mã Zalo"
            class="w-16 h-16 rounded-lg bg-white p-1 flex-shrink-0"
          />
          <div class="space-y-0.5">
            <p class="text-xs font-bold text-white">Quét Zalo bằng điện thoại</p>
            <p class="text-[11px] text-stage-muted leading-relaxed">
              Mở camera hoặc Zalo trên điện thoại quét để gửi nội dung đơn hàng ngay cho chủ shop.
            </p>
          </div>
        </div>

        <!-- Actions -->
        <div class="space-y-2.5 pt-1">
          <a
            :href="orderResult?.zaloUrl"
            target="_blank"
            class="block w-full py-3.5 bg-stage-accent hover:bg-red-700 text-white font-bold text-xs rounded-xl transition-colors text-center"
          >
            Mở chat Zalo xác nhận máy ngay
          </a>

          <button
            @click="copyOrderSummary"
            class="block w-full py-2.5 bg-stage-bg hover:bg-stage-lift text-white text-xs font-semibold rounded-xl transition-colors"
          >
            {{ copied ? 'Đã sao chép nội dung đơn hàng!' : 'Sao chép nội dung đơn hàng' }}
          </button>

          <router-link
            :to="`/orders?phone=${customerForm.phone}&orderId=${orderResult?.orderId}`"
            class="block w-full py-2.5 text-sky-400 hover:text-sky-300 text-xs font-semibold transition-colors"
          >
            Xem & theo dõi tiến độ đơn hàng này →
          </router-link>

          <button
            @click="closeModal"
            class="block w-full py-2 text-stage-muted hover:text-white text-xs font-medium transition-colors"
          >
            Đóng & Tiếp tục xem laptop
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCartStore } from '@/stores/cart'
import { useAuthStore } from '@/stores/auth'
import { useToastStore } from '@/stores/toast'
import { orderApi } from '@/api/orders'

const cartStore = useCartStore()
const authStore = useAuthStore()
const toastStore = useToastStore()
const router = useRouter()

const customerForm = reactive({
  fullName: '',
  phone: '',
  address: '',
  note: ''
})

const submitting = ref(false)
const orderSuccess = ref(false)
const orderResult = ref(null)
const phoneError = ref('')
const copied = ref(false)

function formatCurrency(val) {
  if (!val) return '0 ₫'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val)
}

onMounted(() => {
  if (authStore.user) {
    customerForm.fullName = authStore.user.fullName || ''
    customerForm.phone = authStore.user.phone || ''
  }
})

async function copyOrderSummary() {
  if (!orderResult.value?.orderMessage) return
  try {
    await navigator.clipboard.writeText(orderResult.value.orderMessage)
    copied.value = true
    toastStore.success('Đã sao chép nội dung đơn hàng vào bộ nhớ tạm!')
    setTimeout(() => { copied.value = false }, 3000)
  } catch (err) {
    toastStore.info('Không thể tự động chép, bạn có thể bấm Mở chat Zalo trực tiếp.')
  }
}

async function handleCheckout() {
  phoneError.value = ''
  if (cartStore.items.length === 0) return

  // Validate Vietnamese 10-digit phone number
  const cleanPhone = customerForm.phone.replace(/[\s.-]/g, '')
  const phonePattern = /^(0[3|5|7|8|9])[0-9]{8}$/
  if (!phonePattern.test(cleanPhone)) {
    phoneError.value = 'Số điện thoại không đúng định dạng Việt Nam (10 số, ví dụ 0912345678)'
    return
  }

  submitting.value = true
  try {
    const payload = {
      fullName: customerForm.fullName.trim(),
      phone: cleanPhone,
      address: customerForm.address.trim(),
      note: customerForm.note ? customerForm.note.trim() : '',
      items: cartStore.items.map(item => ({
        productId: item.id,
        quantity: item.quantity,
        price: item.salePrice || item.price
      }))
    }

    const res = await orderApi.createOrder(payload)
    orderResult.value = res.data
    orderSuccess.value = true
    cartStore.clearCart()

    // Tu dong mo link Zalo trong tab moi
    if (res.data?.zaloUrl) {
      window.open(res.data.zaloUrl, '_blank')
    }
  } catch (err) {
    alert(err.response?.data?.message || 'Có lỗi khi đặt hàng, vui lòng thử lại!')
  } finally {
    submitting.value = false
  }
}

function closeModal() {
  orderSuccess.value = false
  router.push('/')
}
</script>
