<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-12">
    <!-- Breadcrumb -->
    <nav class="flex items-center gap-2 text-xs text-stage-muted font-medium">
      <router-link to="/" class="hover:text-white transition-colors">Trang chủ</router-link>
      <span>/</span>
      <router-link to="/products" class="hover:text-white transition-colors">Kho máy Mỹ</router-link>
      <span v-if="product">/</span>
      <span v-if="product" class="text-white font-semibold truncate max-w-xs">{{ product.name }}</span>
    </nav>

    <!-- Loading Skeleton -->
    <div v-if="loading" class="bg-stage-surface rounded-2xl p-8 grid grid-cols-1 lg:grid-cols-12 gap-10">
      <div class="lg:col-span-6 aspect-[4/3] bg-stage-bg rounded-xl"></div>
      <div class="lg:col-span-6 space-y-4">
        <div class="h-6 bg-stage-bg rounded w-1/3"></div>
        <div class="h-10 bg-stage-bg rounded w-3/4"></div>
        <div class="h-12 bg-stage-bg rounded w-1/2"></div>
        <div class="h-24 bg-stage-bg rounded"></div>
      </div>
    </div>

    <!-- Product Not Found -->
    <div v-else-if="!product" class="text-center py-24 bg-stage-surface rounded-2xl p-8">
      <h2 class="text-xl font-bold text-white">Không tìm thấy sản phẩm</h2>
      <p class="text-xs text-stage-muted mt-2 max-w-sm mx-auto">
        Máy có thể đã hết hàng hoặc liên kết đã thay đổi. Vui lòng quay lại danh sách để xem các mẫu laptop khác.
      </p>
      <router-link
        to="/products"
        class="mt-6 inline-block px-6 py-2.5 bg-stage-accent text-white font-bold rounded text-xs hover:opacity-90 transition-opacity"
      >
        Xem kho máy nhập Mỹ →
      </router-link>
    </div>

    <!-- Product Details Main Section -->
    <div v-else class="space-y-12">
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 bg-stage-surface p-6 sm:p-10 rounded-2xl">
        <!-- Left: Image Gallery (6 cols) -->
        <div class="lg:col-span-6 space-y-5">
          <!-- Main Image -->
          <div
            @click="imageZoomOpen = true"
            class="relative overflow-hidden rounded-xl bg-stage-bg aspect-[4/3] flex items-center justify-center p-6 cursor-zoom-in"
          >
            <div class="absolute top-3 left-3 flex items-center gap-2">
              <span class="px-2.5 py-1 rounded bg-stage-surface text-xs font-bold text-white">
                {{ product.brand }} • Chuẩn Zin US
              </span>
              <span v-if="product.salePrice" class="px-2 py-0.5 rounded bg-stage-accent text-white text-xs font-bold">
                Tiết kiệm {{ formatCurrency(product.price - product.salePrice) }}
              </span>
            </div>

            <img
              :src="currentImage || product.images || 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80'"
              :alt="product.name"
              class="max-w-full max-h-full object-contain"
              @error="handleImageError"
            />

            <div class="absolute bottom-3 right-3 bg-stage-surface px-2.5 py-1 rounded text-[11px] font-semibold text-stage-muted">
              Phóng to ảnh
            </div>
          </div>

          <!-- Commitments Icons -->
          <div class="grid grid-cols-2 gap-3 text-xs">
            <div class="p-3 bg-stage-bg rounded-lg">
              <p class="font-bold text-white">Bảo hành 12 đến 24 tháng</p>
              <p class="text-stage-muted mt-0.5">Phần cứng chu đáo</p>
            </div>
            <div class="p-3 bg-stage-bg rounded-lg">
              <p class="font-bold text-white">Bao test 15 ngày</p>
              <p class="text-stage-muted mt-0.5">1 đổi 1 nếu có lỗi</p>
            </div>
            <div class="p-3 bg-stage-bg rounded-lg">
              <p class="font-bold text-white">Video test máy</p>
              <p class="text-stage-muted mt-0.5">Gửi qua Zalo trước ship</p>
            </div>
            <div class="p-3 bg-stage-bg rounded-lg">
              <p class="font-bold text-white">Giao hàng đồng kiểm</p>
              <p class="text-stage-muted mt-0.5">Mở hộp kiểm tra trước</p>
            </div>
          </div>
        </div>

        <!-- Right: Info, Price, Specs, CTA (6 cols) -->
        <div class="lg:col-span-6 flex flex-col justify-between space-y-6">
          <div class="space-y-4">
            <div class="flex items-center gap-2">
              <span class="px-2.5 py-1 bg-stage-bg text-stage-muted text-xs font-semibold rounded">
                {{ product.category?.name || 'Doanh nhân' }}
              </span>
              <span class="text-xs text-emerald-400 font-semibold px-2 py-0.5 rounded bg-stage-bg">
                Sẵn hàng tại shop ({{ product.stock }})
              </span>
            </div>

            <!-- Two line headline -->
            <h1 class="text-2xl sm:text-3xl font-black text-white leading-tight tracking-tight">
              {{ product.name }}
            </h1>

            <!-- Price Highlight Box -->
            <div class="p-4 bg-stage-bg rounded-xl flex items-baseline gap-4">
              <span class="text-3xl sm:text-4xl font-black text-white">
                {{ formatCurrency(product.salePrice || product.price) }}
              </span>
              <span v-if="product.salePrice" class="text-sm text-stage-muted line-through">
                {{ formatCurrency(product.price) }}
              </span>
            </div>

            <p class="text-xs sm:text-sm text-stage-muted leading-relaxed">
              {{ product.description }}
            </p>

            <!-- Specifications Table -->
            <div v-if="parsedSpecs" class="space-y-2 pt-1">
              <h3 class="text-xs font-bold text-stage-muted">
                Thông số kỹ thuật chi tiết
              </h3>
              <div class="bg-stage-bg rounded-xl p-2 space-y-1 text-xs">
                <div v-for="(val, key) in parsedSpecs" :key="key" class="grid grid-cols-3 p-2 rounded-lg bg-stage-surface/50">
                  <span class="text-stage-muted font-medium">{{ formatSpecKey(key) }}</span>
                  <span class="col-span-2 text-white font-semibold">{{ val }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Quantity & Purchase Actions -->
          <div class="space-y-4 pt-4">
            <div class="flex items-center gap-4">
              <span class="text-xs font-semibold text-stage-muted">Số lượng:</span>
              <div class="flex items-center bg-stage-bg rounded-lg overflow-hidden">
                <button
                  @click="quantity = Math.max(1, quantity - 1)"
                  class="w-8 h-8 flex items-center justify-center font-bold text-white hover:bg-stage-lift transition-colors"
                >
                  -
                </button>
                <span class="w-10 text-center text-xs font-bold text-white">{{ quantity }}</span>
                <button
                  @click="quantity++"
                  class="w-8 h-8 flex items-center justify-center font-bold text-white hover:bg-stage-lift transition-colors"
                >
                  +
                </button>
              </div>
            </div>

            <!-- Main CTA Buttons -->
            <div class="space-y-2.5">
              <div class="flex flex-col sm:flex-row gap-3">
                <button
                  @click="handleBuyNow"
                  class="flex-1 py-3.5 px-6 bg-stage-accent hover:bg-red-700 text-white font-bold text-sm rounded-xl transition-colors flex items-center justify-center gap-2"
                >
                  Mua ngay ({{ formatCurrency((product.salePrice || product.price) * quantity) }})
                </button>

                <button
                  @click="handleAddToCart"
                  class="py-3.5 px-6 bg-stage-bg hover:bg-stage-lift text-white font-bold text-sm rounded-xl transition-colors flex items-center justify-center gap-2"
                >
                  Thêm vào giỏ
                </button>
              </div>

              <a
                :href="zaloChatLink"
                target="_blank"
                class="w-full py-3 px-6 bg-stage-bg hover:bg-stage-lift text-sky-400 font-bold text-xs rounded-xl transition-colors flex items-center justify-center gap-2"
              >
                Nhắn Zalo nhận video test thực tế (0778.3333.62)
              </a>
            </div>
          </div>
        </div>
      </div>

      <!-- Tabbed Information -->
      <div class="bg-stage-surface rounded-2xl p-6 sm:p-8 space-y-4">
        <div class="bg-stage-bg p-1 rounded-xl inline-flex gap-1 text-xs font-semibold">
          <button
            @click="activeDetailTab = 'warranty'"
            :class="[
              'px-4 py-2 rounded-lg transition-colors',
              activeDetailTab === 'warranty' ? 'bg-stage-surface text-white' : 'text-stage-muted hover:text-white'
            ]"
          >
            Chính sách bảo hành và đổi mới
          </button>
          <button
            @click="activeDetailTab = 'howToBuy'"
            :class="[
              'px-4 py-2 rounded-lg transition-colors',
              activeDetailTab === 'howToBuy' ? 'bg-stage-surface text-white' : 'text-stage-muted hover:text-white'
            ]"
          >
            Quy trình mua và nhận video test
          </button>
        </div>

        <div v-if="activeDetailTab === 'warranty'" class="space-y-3 text-xs text-stage-muted leading-relaxed">
          <p>• <strong class="text-white">Cam kết zin 100%:</strong> Toàn bộ máy được tuyển chọn từ Mỹ. Tuyệt đối không qua sửa chữa hay thay thế linh kiện kém chất lượng.</p>
          <p>• <strong class="text-white">15 ngày trải nghiệm:</strong> Nếu máy có bất kỳ lỗi phần cứng nào từ nhà sản xuất, khách hàng được đổi máy khác tương đương.</p>
          <p>• <strong class="text-white">Bảo hành 12 đến 24 tháng:</strong> Bảo hành bo mạch, màn hình, bàn phím, pin và sạc zin theo máy.</p>
        </div>

        <div v-else class="space-y-3 text-xs text-stage-muted leading-relaxed">
          <p>• <strong class="text-white">Bước 1:</strong> Bạn bấm Thêm vào giỏ hoặc nhắn Zalo: 0778.3333.62.</p>
          <p>• <strong class="text-white">Bước 2:</strong> Shop phản hồi và gửi video chi tiết quay từng góc cạnh máy thật kèm kết quả đo pin, màn hình.</p>
          <p>• <strong class="text-white">Bước 3:</strong> Shop đóng thùng xốp chống sốc và gửi chuyển phát nhanh COD toàn quốc.</p>
          <p>• <strong class="text-white">Bước 4:</strong> Bạn bóc hộp kiểm tra máy đúng như video mới thanh toán tiền cho bên vận chuyển.</p>
        </div>
      </div>

      <!-- Related Products Section -->
      <div v-if="relatedProducts.length > 0" class="space-y-4 pt-4">
        <h2 class="text-xl font-bold text-white tracking-tight">Sản phẩm cùng phân khúc</h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <ProductCard
            v-for="rel in relatedProducts"
            :key="rel.id"
            :product="rel"
          />
        </div>
      </div>
    </div>

    <!-- Image Zoom Lightbox -->
    <div
      v-if="imageZoomOpen"
      class="fixed inset-0 z-50 bg-black/90 flex items-center justify-center p-4"
      @click="imageZoomOpen = false"
    >
      <div class="relative max-w-4xl max-h-[85vh] w-full flex items-center justify-center">
        <button
          @click="imageZoomOpen = false"
          class="absolute -top-10 right-0 text-white font-bold text-xs bg-stage-surface hover:bg-stage-lift px-3 py-1 rounded transition-colors"
        >
          Đóng
        </button>
        <img
          :src="currentImage || product?.images || 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=1200&q=90'"
          :alt="product?.name"
          class="max-w-full max-h-[80vh] object-contain rounded-xl"
        />
      </div>
    </div>

    <!-- Sticky Mobile Purchase Bar -->
    <div
      v-if="product"
      class="lg:hidden fixed bottom-0 left-0 right-0 z-30 bg-stage-surface p-3 flex items-center justify-between gap-3"
    >
      <div class="min-w-0">
        <p class="text-[10px] text-stage-muted truncate">{{ product.name }}</p>
        <p class="text-base font-black text-white">
          {{ formatCurrency(product.salePrice || product.price) }}
        </p>
      </div>

      <div class="flex items-center gap-2 flex-shrink-0">
        <a
          :href="zaloChatLink"
          target="_blank"
          class="p-2 bg-stage-bg text-sky-400 rounded text-xs font-semibold"
        >
          Zalo
        </a>
        <button
          @click="handleAddToCart"
          class="px-4 py-2 bg-stage-accent text-white rounded font-bold text-xs"
        >
          Thêm giỏ
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { productApi } from '@/api/products'
import { useCartStore } from '@/stores/cart'
import { useToastStore } from '@/stores/toast'
import ProductCard from '@/components/ProductCard.vue'

const route = useRoute()
const router = useRouter()
const cartStore = useCartStore()
const toastStore = useToastStore()

const product = ref(null)
const relatedProducts = ref([])
const loading = ref(true)
const quantity = ref(1)
const currentImage = ref(null)
const imageZoomOpen = ref(false)
const activeDetailTab = ref('warranty')

function formatCurrency(val) {
  if (!val) return '0 ₫'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val)
}

function handleImageError(e) {
  e.target.src = 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80'
}

function formatSpecKey(key) {
  const map = {
    cpu: 'Vi xử lý (CPU)',
    ram: 'Bộ nhớ RAM',
    storage: 'Ổ cứng SSD',
    gpu: 'Card đồ họa (GPU)',
    screen: 'Màn hình',
    display: 'Màn hình hiển thị',
    weight: 'Trọng lượng',
    battery: 'Dung lượng pin'
  }
  return map[key.toLowerCase()] || key
}

const parsedSpecs = computed(() => {
  if (!product.value?.specs) return null
  try {
    return typeof product.value.specs === 'string'
      ? JSON.parse(product.value.specs)
      : product.value.specs
  } catch {
    return null
  }
})

const zaloChatLink = computed(() => {
  if (!product.value) return 'https://zalo.me/0778333362'
  const text = encodeURIComponent(`Xin chào Hiếu Trần Laptop US, tôi muốn tư vấn & xem video test máy: "${product.value.name}" (giá: ${formatCurrency(product.value.salePrice || product.value.price)}). Shop hỗ trợ giúp tôi nhé!`)
  return `https://zalo.me/0778333362?text=${text}`
})

function handleAddToCart() {
  if (product.value) {
    cartStore.addItem(product.value, quantity.value)
    toastStore.success(`Đã thêm ${quantity.value} máy "${product.value.name}" vào giỏ hàng`, {
      to: '/cart',
      label: 'Xem giỏ hàng'
    })
  }
}

function handleBuyNow() {
  if (product.value) {
    cartStore.addItem(product.value, quantity.value)
    router.push('/cart')
  }
}

async function loadProductData(slug) {
  loading.value = true
  quantity.value = 1
  try {
    const res = await productApi.getProductBySlug(slug)
    product.value = res.data
    currentImage.value = res.data.images

    if (res.data?.id) {
      const relRes = await productApi.getRelatedProducts(res.data.id).catch(() => ({ data: [] }))
      relatedProducts.value = relRes.data || []
    }
  } catch (err) {
    console.error('Lỗi nạp chi tiết sản phẩm:', err)
    product.value = null
  } finally {
    loading.value = false
  }
}

watch(() => route.params.slug, (newSlug) => {
  if (newSlug) {
    loadProductData(newSlug)
  }
})

onMounted(() => {
  loadProductData(route.params.slug)
})
</script>
