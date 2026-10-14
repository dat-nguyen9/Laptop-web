<template>
  <div class="space-y-24 pb-24">
    <!-- HERO SECTION: Split Stage / Specimen Lead -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-10 sm:pt-16">
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 items-center">
        <!-- Left: Headline & Actions (7 cols) -->
        <div class="lg:col-span-7 space-y-6">
          <div class="text-xs text-stage-muted font-semibold">
            Hiếu Trần Laptop US • Chuyên hàng nhập Mỹ nguyên bản
          </div>

          <!-- Two-line headline strictly enforced -->
          <h1 class="text-4xl sm:text-5xl lg:text-6xl font-black text-white tracking-tight leading-[1.1]">
            Laptop xách tay Mỹ <br class="hidden sm:inline" />
            tuyển chọn nguyên bản
          </h1>

          <p class="text-base sm:text-lg text-stage-ink leading-relaxed max-w-xl font-normal">
            Chuyên ThinkPad X1, Dell XPS, HP EliteBook và MacBook. Kiểm tra kỹ lưỡng 24 bước phần cứng, bảo hành 12 đến 24 tháng chu đáo, gửi video test máy 1-1 trực tiếp qua Zalo trước khi chốt đơn.
          </p>

          <!-- Quick Search Chips -->
          <div class="flex flex-wrap items-center gap-2 pt-1 text-xs">
            <span class="text-stage-muted">Dòng máy phổ biến:</span>
            <router-link
              v-for="tag in ['ThinkPad X1', 'Dell XPS', 'MacBook LL/A', 'HP EliteBook']"
              :key="tag"
              :to="{ path: '/products', query: { search: tag } }"
              class="px-2.5 py-1 rounded bg-stage-surface hover:bg-stage-lift text-stage-ink transition-colors"
            >
              {{ tag }}
            </router-link>
          </div>

          <!-- Action Buttons (Flat, solid colors) -->
          <div class="flex flex-wrap items-center gap-4 pt-3">
            <router-link
              to="/products"
              class="btn-primary rounded-lg text-sm px-7 py-3.5"
            >
              Xem kho máy nhập Mỹ →
            </router-link>

            <a
              href="https://zalo.me/0778333362"
              target="_blank"
              class="btn-secondary rounded-lg text-sm px-6 py-3.5"
            >
              Chat Zalo: 0778.3333.62
            </a>
          </div>

          <!-- Metrics -->
          <div class="grid grid-cols-3 gap-6 pt-6 max-w-md">
            <div>
              <div class="text-2xl sm:text-3xl font-black text-white">100%</div>
              <div class="text-xs text-stage-muted mt-1">Zin nguyên bản từ Mỹ</div>
            </div>
            <div>
              <div class="text-2xl sm:text-3xl font-black text-white">12-24T</div>
              <div class="text-xs text-stage-muted mt-1">Bảo hành phần cứng</div>
            </div>
            <div>
              <div class="text-2xl sm:text-3xl font-black text-white">1-1</div>
              <div class="text-xs text-stage-muted mt-1">Video test máy trực tiếp</div>
            </div>
          </div>
        </div>

        <!-- Right: Real Machine Photographic Stage (5 cols) -->
        <div class="lg:col-span-5">
          <div class="bg-stage-surface rounded-2xl p-4 sm:p-5 space-y-4">
            <div class="aspect-[4/3] rounded-xl overflow-hidden bg-stage-bg flex items-center justify-center p-3">
              <img
                src="https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=900&q=80"
                alt="Dell XPS 15 nhập Mỹ nguyên bản"
                class="w-full h-full object-cover rounded-lg"
              />
            </div>
            <div class="flex items-center justify-between text-xs px-1">
              <div>
                <p class="font-bold text-white">Dell XPS 15 9520 (US Specification)</p>
                <p class="text-stage-muted">Intel Core i7 12700H • RAM 16GB • SSD 512GB</p>
              </div>
              <span class="px-2 py-1 rounded bg-stage-bg text-emerald-400 font-semibold text-[11px]">
                Sẵn hàng
              </span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- TRUST PILLARS SECTION -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <TrustBadges />
    </section>

    <!-- BRAND SPECIMEN SELECTOR -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-4">
      <div class="flex items-center justify-between">
        <div>
          <h2 class="text-xs text-stage-muted font-bold">Thương hiệu nhập Mỹ</h2>
          <p class="text-lg font-black text-white">Chọn theo dòng máy chuyên dụng</p>
        </div>
        <router-link to="/products" class="text-xs font-semibold text-stage-muted hover:text-white transition-colors">
          Xem toàn bộ →
        </router-link>
      </div>

      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-6 gap-3">
        <router-link
          v-for="brand in brandList"
          :key="brand.name"
          :to="{ path: '/products', query: { brand: brand.name } }"
          class="p-4 rounded-xl bg-stage-surface hover:bg-stage-lift transition-colors flex flex-col items-center justify-center gap-1.5 text-center"
        >
          <span class="text-sm font-black text-white">{{ brand.name }}</span>
          <span class="text-xs text-stage-muted">{{ brand.sub }}</span>
        </router-link>
      </div>
    </section>

    <!-- SPECIMEN CATALOG: PRODUCTS GRID WITH FILTER TABS -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-6">
      <!-- Section Header & Filter Tabs -->
      <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
          <h2 class="text-2xl sm:text-3xl font-black text-white tracking-tight">
            Kho máy sẵn hàng tại shop
          </h2>
          <p class="text-xs sm:text-sm text-stage-muted mt-1">
            Máy được kiểm tra từng linh kiện, bao test đổi mới trong 15 ngày
          </p>
        </div>

        <!-- Filter Tabs -->
        <div class="flex flex-wrap gap-1.5 p-1 bg-stage-surface rounded-lg">
          <button
            v-for="tab in filterTabs"
            :key="tab.value"
            @click="activeTab = tab.value"
            :class="[
              'px-3.5 py-1.5 rounded text-xs font-semibold transition-colors',
              activeTab === tab.value
                ? 'bg-stage-bg text-white font-bold'
                : 'text-stage-muted hover:text-white'
            ]"
          >
            {{ tab.label }}
          </button>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <ProductSkeleton v-for="i in 8" :key="i" />
      </div>

      <!-- Empty State -->
      <div v-else-if="filteredProducts.length === 0" class="text-center py-16 bg-stage-surface rounded-2xl p-8">
        <p class="text-stage-muted text-sm">Hiện chưa có sản phẩm thuộc danh mục này.</p>
        <button @click="activeTab = 'all'" class="mt-4 px-4 py-2 bg-stage-accent text-white text-xs font-semibold rounded">
          Xem tất cả máy
        </button>
      </div>

      <!-- Products Grid -->
      <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <ProductCard
          v-for="product in filteredProducts"
          :key="product.id"
          :product="product"
          @quickView="openQuickView"
        />
      </div>

      <!-- View More Link -->
      <div class="text-center pt-4">
        <router-link
          to="/products"
          class="btn-secondary rounded-lg text-xs sm:text-sm px-8 py-3.5"
        >
          Xem toàn bộ {{ products.length }} laptop nhập Mỹ sẵn hàng →
        </router-link>
      </div>
    </section>

    <!-- HARDWARE INSPECTION MANIFEST (THE IDEA FROM SUBJECT) -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-6">
      <div class="bg-stage-surface rounded-2xl p-6 sm:p-10 space-y-8">
        <div class="space-y-2">
          <span class="text-xs text-stage-muted font-bold">Tiêu chuẩn kiểm định máy</span>
          <h3 class="text-xl sm:text-2xl font-black text-white tracking-tight">
            Quy trình kiểm tra 24 bước trước khi gửi máy cho khách
          </h3>
          <p class="text-xs sm:text-sm text-stage-muted leading-relaxed max-w-2xl">
            Mỗi chiếc laptop xách tay từ Mỹ về đều được mở nắp đáy kiểm tra cấu trúc bo mạch và trải qua các bài kiểm tra thực tế:
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 text-xs text-stage-muted">
          <div class="space-y-2">
            <h4 class="font-bold text-white text-sm">1. Bo mạch và tản nhiệt</h4>
            <p class="leading-relaxed">Kiểm tra tem bảo hành của hãng, linh kiện không có dấu hiệu sửa chữa hay đóng lại chip, keo tản nhiệt được làm sạch cẩn thận.</p>
          </div>
          <div class="space-y-2">
            <h4 class="font-bold text-white text-sm">2. Màn hình hiển thị</h4>
            <p class="leading-relaxed">Kiểm tra 5 màu nền cơ bản phát hiện điểm chết, đo độ sáng tối đa và kiểm tra độ phủ màu theo đúng thông số xuất xưởng.</p>
          </div>
          <div class="space-y-2">
            <h4 class="font-bold text-white text-sm">3. Pin và sạc zin theo máy</h4>
            <p class="leading-relaxed">Đọc số chu kỳ sạc và dung lượng pin khả dụng (Health Battery trên 85-95%), kèm cục sạc zin chính hãng theo máy.</p>
          </div>
          <div class="space-y-2">
            <h4 class="font-bold text-white text-sm">4. Bàn phím và kết nối</h4>
            <p class="leading-relaxed">Test từng phím bấm chuẩn layout US, kiểm tra webcam, micro lọc ồn, cổng Thunderbolt và kết nối Wi-Fi băng tần kép.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- TESTIMONIALS SECTION -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-6">
      <div class="space-y-1">
        <h3 class="text-xl sm:text-2xl font-black text-white tracking-tight">
          Đánh giá từ khách hàng đã mua
        </h3>
        <p class="text-xs text-stage-muted">Khách hàng chia sẻ trải nghiệm nhận máy thực tế</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="p-6 rounded-xl bg-stage-surface space-y-3">
          <p class="text-xs text-stage-ink leading-relaxed">
            "Máy ThinkPad X1 Carbon Gen 9 nhận được rất đẹp, pin còn 98%, bàn phím gõ êm đúng chuẩn hàng Mỹ. Shop quay video test cẩn thận trước khi ship COD, rất an tâm."
          </p>
          <div class="pt-2">
            <p class="font-bold text-xs text-white">Tuấn Anh</p>
            <p class="text-[11px] text-stage-muted">Lập trình viên, Hà Nội</p>
          </div>
        </div>

        <div class="p-6 rounded-xl bg-stage-surface space-y-3">
          <p class="text-xs text-stage-ink leading-relaxed">
            "Mua Dell XPS 15 làm thiết kế đồ họa, màn hình sắc nét không một tì vết. Chủ shop tư vấn qua Zalo nhiệt tình, cài sẵn phần mềm rất chu đáo."
          </p>
          <div class="pt-2">
            <p class="font-bold text-xs text-white">Mai Hương</p>
            <p class="text-[11px] text-stage-muted">Thiết kế đồ họa, TP.HCM</p>
          </div>
        </div>

        <div class="p-6 rounded-xl bg-stage-surface space-y-3">
          <p class="text-xs text-stage-ink leading-relaxed">
            "Đã mua chiếc thứ 2 tại shop. Giá cạnh tranh và chất lượng máy chuẩn US hơn hẳn các nơi khác. Bảo hành rõ ràng, hỗ trợ cài đặt từ xa rất nhanh."
          </p>
          <div class="pt-2">
            <p class="font-bold text-xs text-white">Hoàng Quân</p>
            <p class="text-[11px] text-stage-muted">Quản lý dự án, Đà Nẵng</p>
          </div>
        </div>
      </div>
    </section>

    <!-- ZALO DIRECT CONSULTATION BANNER -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="bg-stage-surface rounded-2xl p-8 sm:p-12 flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6">
        <div class="space-y-2 max-w-xl">
          <div class="text-xs text-stage-muted font-bold">Tư vấn trực tiếp 24/7</div>
          <h3 class="text-2xl sm:text-3xl font-black text-white tracking-tight leading-tight">
            Bạn cần tư vấn cấu hình phù hợp nhu cầu?
          </h3>
          <p class="text-stage-muted text-xs sm:text-sm leading-relaxed">
            Nhắn Zalo ngay để nhận danh sách máy đang có sẵn tại cửa hàng và yêu cầu quay video test máy chi tiết từng góc cạnh.
          </p>
        </div>

        <div class="flex flex-wrap items-center gap-3 flex-shrink-0">
          <a
            href="https://zalo.me/0778333362"
            target="_blank"
            class="btn-primary rounded-lg text-xs sm:text-sm px-6 py-3"
          >
            Mở Zalo: 0778.3333.62
          </a>
          <a
            href="https://www.facebook.com/p/Hi%E1%BA%BFu-Tr%E1%BA%A7n-Laptop-US-61585268909952/"
            target="_blank"
            class="btn-secondary rounded-lg text-xs sm:text-sm px-5 py-3"
          >
            Fanpage Facebook
          </a>
        </div>
      </div>
    </section>

    <!-- Quick View Modal Component -->
    <QuickViewModal
      :isOpen="isQuickViewOpen"
      :product="selectedQuickViewProduct"
      @close="isQuickViewOpen = false"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { productApi } from '@/api/products'
import ProductCard from '@/components/ProductCard.vue'
import TrustBadges from '@/components/TrustBadges.vue'
import ProductSkeleton from '@/components/ProductSkeleton.vue'
import QuickViewModal from '@/components/QuickViewModal.vue'

const products = ref([])
const loading = ref(true)
const activeTab = ref('all')

const isQuickViewOpen = ref(false)
const selectedQuickViewProduct = ref(null)

const brandList = [
  { name: 'Lenovo', sub: 'ThinkPad zin US' },
  { name: 'Dell', sub: 'XPS và Latitude' },
  { name: 'Apple', sub: 'MacBook LL/A' },
  { name: 'HP', sub: 'EliteBook mỏng nhẹ' },
  { name: 'Asus', sub: 'ZenBook và ROG' },
  { name: 'Acer', sub: 'Swift văn phòng' },
]

const filterTabs = [
  { label: 'Tất cả máy', value: 'all' },
  { label: 'ThinkPad', value: 'Lenovo' },
  { label: 'Dell XPS & Latitude', value: 'Dell' },
  { label: 'MacBook', value: 'Apple' },
  { label: 'HP EliteBook', value: 'HP' },
]

const filteredProducts = computed(() => {
  if (activeTab.value === 'all') {
    return products.value
  }
  return products.value.filter(p => p.brand?.toLowerCase() === activeTab.value.toLowerCase())
})

function openQuickView(product) {
  selectedQuickViewProduct.value = product
  isQuickViewOpen.value = true
}

onMounted(async () => {
  try {
    const res = await productApi.getProducts({ size: 12 })
    products.value = res.data.content || []
  } catch (err) {
    console.error('Lỗi tải sản phẩm trang chủ:', err)
  } finally {
    loading.value = false
  }
})
</script>
