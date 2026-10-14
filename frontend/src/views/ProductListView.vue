<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
    <!-- Page Header & Breadcrumb -->
    <div>
      <nav class="flex items-center gap-2 text-xs text-stage-muted mb-2 font-medium">
        <router-link to="/" class="hover:text-white transition-colors">Trang chủ</router-link>
        <span>/</span>
        <span class="text-white font-semibold">Kho máy nhập Mỹ</span>
      </nav>
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div>
          <h1 class="text-2xl sm:text-3xl font-black text-white tracking-tight">
            Kho laptop nhập Mỹ chuẩn zin
          </h1>
          <p class="text-xs sm:text-sm text-stage-muted mt-1">
            Có {{ totalElements }} mẫu máy tuyển chọn sẵn sàng giao hàng
          </p>
        </div>

        <!-- Mobile Filter Button Toggle -->
        <button
          @click="showMobileFilter = !showMobileFilter"
          class="lg:hidden inline-flex items-center justify-center gap-2 px-4 py-2 rounded-lg bg-stage-surface text-white font-semibold text-xs transition-colors"
        >
          <span>Bộ lọc ({{ activeFilterCount }})</span>
        </button>
      </div>
    </div>

    <!-- Main Layout: 2 Columns -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
      <!-- LEFT COLUMN: Sticky Filter Sidebar (3 cols) -->
      <aside
        :class="[
          'lg:col-span-3 space-y-6',
          showMobileFilter ? 'block' : 'hidden lg:block'
        ]"
      >
        <div class="bg-stage-surface rounded-2xl p-5 lg:sticky lg:top-24 space-y-6">
          <div class="flex items-center justify-between pb-1">
            <h3 class="font-bold text-white text-xs">
              Bộ lọc tuyển chọn
            </h3>
            <button
              v-if="hasActiveFilter"
              @click="resetFilters"
              class="text-[11px] font-bold text-rose-400 hover:underline"
            >
              Xóa tất cả
            </button>
          </div>

          <!-- 1. Hãng sản xuất (Brand) -->
          <div class="space-y-2">
            <h4 class="text-xs font-semibold text-stage-muted">Thương hiệu</h4>
            <div class="space-y-1">
              <button
                v-for="b in brands"
                :key="b.value"
                @click="selectBrand(b.value)"
                :class="[
                  'w-full flex items-center justify-between px-3 py-1.5 rounded-lg text-xs transition-colors text-left',
                  selectedBrand === b.value
                    ? 'bg-stage-bg text-white font-bold'
                    : 'text-stage-muted hover:text-white hover:bg-stage-bg/50'
                ]"
              >
                <span>{{ b.label }}</span>
                <svg v-if="selectedBrand === b.value" class="w-3.5 h-3.5 text-stage-accent" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>
              </button>
            </div>
          </div>

          <!-- 2. Khoảng Giá -->
          <div class="space-y-2 pt-2">
            <h4 class="text-xs font-semibold text-stage-muted">Khoảng giá</h4>
            <div class="space-y-1">
              <button
                v-for="p in priceRanges"
                :key="p.label"
                @click="selectPriceRange(p)"
                :class="[
                  'w-full flex items-center justify-between px-3 py-1.5 rounded-lg text-xs transition-colors text-left',
                  selectedPriceRange.label === p.label
                    ? 'bg-stage-bg text-white font-bold'
                    : 'text-stage-muted hover:text-white hover:bg-stage-bg/50'
                ]"
              >
                <span>{{ p.label }}</span>
                <svg v-if="selectedPriceRange.label === p.label" class="w-3.5 h-3.5 text-stage-accent" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>
              </button>
            </div>
          </div>

          <!-- 3. RAM -->
          <div class="space-y-2 pt-2">
            <h4 class="text-xs font-semibold text-stage-muted">Dung lượng RAM</h4>
            <div class="grid grid-cols-2 gap-1.5">
              <button
                v-for="r in ramOptions"
                :key="r"
                @click="selectRam(r)"
                :class="[
                  'px-3 py-1.5 rounded-lg text-xs font-semibold transition-colors text-center',
                  selectedRam === r
                    ? 'bg-stage-accent text-white'
                    : 'bg-stage-bg text-stage-muted hover:text-white'
                ]"
              >
                {{ r || 'Tất cả' }}
              </button>
            </div>
          </div>

          <!-- 4. CPU Chipset -->
          <div class="space-y-2 pt-2">
            <h4 class="text-xs font-semibold text-stage-muted">Dòng chip CPU</h4>
            <div class="space-y-1">
              <button
                v-for="c in cpuOptions"
                :key="c.label"
                @click="selectCpu(c.value)"
                :class="[
                  'w-full flex items-center justify-between px-3 py-1.5 rounded-lg text-xs transition-colors text-left',
                  selectedCpu === c.value
                    ? 'bg-stage-bg text-white font-bold'
                    : 'text-stage-muted hover:text-white hover:bg-stage-bg/50'
                ]"
              >
                <span>{{ c.label }}</span>
                <svg v-if="selectedCpu === c.value" class="w-3.5 h-3.5 text-stage-accent" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>
              </button>
            </div>
          </div>

          <!-- Quick Zalo assistance block in sidebar -->
          <div class="pt-2">
            <div class="p-3.5 rounded-xl bg-stage-bg text-xs space-y-2">
              <p class="font-bold text-white">Chưa rõ chọn máy nào?</p>
              <p class="text-stage-muted leading-relaxed">
                Nhắn số Zalo để nhận video test trực tiếp và báo giá chốt đơn nhanh nhất.
              </p>
              <a
                href="https://zalo.me/0778333362"
                target="_blank"
                class="block text-center py-2 px-3 rounded bg-stage-surface hover:bg-stage-lift text-sky-400 font-bold transition-colors"
              >
                Chat Zalo 0778.3333.62
              </a>
            </div>
          </div>
        </div>
      </aside>

      <!-- RIGHT COLUMN: Products Showcase (9 cols) -->
      <main class="lg:col-span-9 space-y-6">
        <!-- Top Toolbar: Search keyword input + Sort select -->
        <div class="bg-stage-surface rounded-2xl p-4 flex flex-col sm:flex-row items-center justify-between gap-4">
          <!-- Active filter pills & search box -->
          <div class="flex flex-wrap items-center gap-2 w-full sm:w-auto">
            <div class="relative flex-1 sm:w-64">
              <input
                v-model="keyword"
                @keyup.enter="handleSearch"
                type="text"
                placeholder="Tìm tên máy, chip, ram..."
                class="w-full bg-stage-bg text-white placeholder-stage-muted pl-8 pr-3 py-2 rounded-lg text-xs outline-none focus:bg-stage-lift transition-colors"
              />
              <svg class="w-3.5 h-3.5 text-stage-muted absolute left-2.5 top-1/2 -translate-y-1/2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            <button
              @click="handleSearch"
              class="px-3.5 py-2 bg-stage-accent text-white text-xs font-semibold rounded hover:opacity-90 transition-opacity"
            >
              Tìm
            </button>
          </div>

          <!-- Sort dropdown -->
          <div class="flex items-center gap-2 w-full sm:w-auto justify-end">
            <span class="text-xs text-stage-muted">Sắp xếp:</span>
            <select
              v-model="selectedSort"
              @change="fetchProducts(0)"
              class="bg-stage-bg rounded-lg px-3 py-2 text-xs font-semibold text-white outline-none cursor-pointer"
            >
              <option value="id,desc">Mới nhất</option>
              <option value="price,asc">Giá: Thấp đến Cao</option>
              <option value="price,desc">Giá: Cao đến Thấp</option>
            </select>
          </div>
        </div>

        <!-- Filter tag indicators -->
        <div v-if="hasActiveFilter" class="flex flex-wrap items-center gap-2 pt-1 text-xs">
          <span class="text-stage-muted">Đang lọc:</span>
          <span v-if="selectedBrand" class="px-2.5 py-1 bg-stage-surface text-white rounded font-medium">
            Hãng: {{ selectedBrand }}
            <button @click="selectBrand('')" class="hover:text-rose-400 ml-1">×</button>
          </span>
          <span v-if="selectedPriceRange.label !== 'Tất cả mức giá'" class="px-2.5 py-1 bg-stage-surface text-white rounded font-medium">
            Giá: {{ selectedPriceRange.label }}
            <button @click="selectPriceRange(priceRanges[0])" class="hover:text-rose-400 ml-1">×</button>
          </span>
          <span v-if="selectedRam" class="px-2.5 py-1 bg-stage-surface text-white rounded font-medium">
            RAM: {{ selectedRam }}
            <button @click="selectRam('')" class="hover:text-rose-400 ml-1">×</button>
          </span>
          <span v-if="selectedCpu" class="px-2.5 py-1 bg-stage-surface text-white rounded font-medium">
            CPU: {{ selectedCpu }}
            <button @click="selectCpu('')" class="hover:text-rose-400 ml-1">×</button>
          </span>
          <button @click="resetFilters" class="text-rose-400 font-bold hover:underline ml-2">
            Xóa hết
          </button>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          <ProductSkeleton v-for="i in 6" :key="i" />
        </div>

        <!-- Empty State -->
        <div v-else-if="products.length === 0" class="text-center py-20 bg-stage-surface rounded-2xl p-8">
          <h3 class="text-base font-bold text-white">Không tìm thấy máy phù hợp bộ lọc</h3>
          <p class="text-xs text-stage-muted mt-1 max-w-sm mx-auto">
            Bạn có thể thử nới lỏng mức giá hoặc chọn thương hiệu khác để xem thêm sản phẩm.
          </p>
          <button
            @click="resetFilters"
            class="mt-4 px-5 py-2.5 bg-stage-accent text-white font-bold text-xs rounded hover:opacity-90 transition-opacity"
          >
            Xóa bộ lọc & Xem tất cả
          </button>
        </div>

        <!-- Products Grid (3 cols on desktop) -->
        <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          <ProductCard
            v-for="product in products"
            :key="product.id"
            :product="product"
            @quickView="openQuickView"
          />
        </div>

        <!-- Pagination Controls -->
        <div v-if="totalPages > 1" class="pt-8 flex justify-center items-center gap-2">
          <button
            @click="fetchProducts(currentPage - 1)"
            :disabled="currentPage === 0"
            class="px-4 py-2 rounded-lg bg-stage-surface text-xs font-semibold text-stage-ink hover:bg-stage-lift disabled:opacity-40 transition-colors"
          >
            ← Trước
          </button>

          <button
            v-for="p in totalPages"
            :key="p"
            @click="fetchProducts(p - 1)"
            :class="[
              'w-8 h-8 rounded-lg text-xs font-bold transition-colors',
              currentPage === p - 1
                ? 'bg-stage-accent text-white'
                : 'bg-stage-surface text-stage-muted hover:text-white'
            ]"
          >
            {{ p }}
          </button>

          <button
            @click="fetchProducts(currentPage + 1)"
            :disabled="currentPage >= totalPages - 1"
            class="px-4 py-2 rounded-lg bg-stage-surface text-xs font-semibold text-stage-ink hover:bg-stage-lift disabled:opacity-40 transition-colors"
          >
            Sau →
          </button>
        </div>
      </main>
    </div>

    <!-- Quick View Modal Component -->
    <QuickViewModal
      :isOpen="isQuickViewOpen"
      :product="selectedQuickViewProduct"
      @close="isQuickViewOpen = false"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { productApi } from '@/api/products'
import ProductCard from '@/components/ProductCard.vue'
import ProductSkeleton from '@/components/ProductSkeleton.vue'
import QuickViewModal from '@/components/QuickViewModal.vue'

const route = useRoute()

const products = ref([])
const loading = ref(false)
const totalElements = ref(0)
const totalPages = ref(0)
const currentPage = ref(0)
const showMobileFilter = ref(false)

const keyword = ref('')
const selectedSort = ref('id,desc')

const isQuickViewOpen = ref(false)
const selectedQuickViewProduct = ref(null)

const brands = [
  { label: 'Tất cả hãng', value: '' },
  { label: 'Lenovo (ThinkPad)', value: 'Lenovo' },
  { label: 'Dell (XPS, Latitude)', value: 'Dell' },
  { label: 'Apple (MacBook LL/A)', value: 'Apple' },
  { label: 'HP (EliteBook)', value: 'HP' },
  { label: 'Asus (ROG, ZenBook)', value: 'Asus' },
  { label: 'Acer', value: 'Acer' }
]
const selectedBrand = ref('')

const priceRanges = [
  { label: 'Tất cả mức giá', min: null, max: null },
  { label: 'Dưới 15 triệu', min: null, max: 15000000 },
  { label: '15 - 25 triệu', min: 15000000, max: 25000000 },
  { label: '25 - 35 triệu', min: 25000000, max: 35000000 },
  { label: 'Trên 35 triệu', min: 35000000, max: null }
]
const selectedPriceRange = ref(priceRanges[0])

const ramOptions = ['', '8GB', '16GB', '32GB']
const selectedRam = ref('')

const cpuOptions = [
  { label: 'Tất cả CPU', value: '' },
  { label: 'Intel Core i5', value: 'i5' },
  { label: 'Intel Core i7', value: 'i7' },
  { label: 'Intel Core Ultra', value: 'Ultra' },
  { label: 'AMD Ryzen', value: 'Ryzen' },
  { label: 'Apple M-Series', value: 'M2' }
]
const selectedCpu = ref('')

const hasActiveFilter = computed(() => {
  return selectedBrand.value ||
    selectedPriceRange.value.label !== 'Tất cả mức giá' ||
    selectedRam.value ||
    selectedCpu.value ||
    keyword.value
})

const activeFilterCount = computed(() => {
  let count = 0
  if (selectedBrand.value) count++
  if (selectedPriceRange.value.label !== 'Tất cả mức giá') count++
  if (selectedRam.value) count++
  if (selectedCpu.value) count++
  return count
})

function openQuickView(product) {
  selectedQuickViewProduct.value = product
  isQuickViewOpen.value = true
}

function selectBrand(b) {
  selectedBrand.value = b
  fetchProducts(0)
}

function selectPriceRange(p) {
  selectedPriceRange.value = p
  fetchProducts(0)
}

function selectRam(r) {
  selectedRam.value = r
  fetchProducts(0)
}

function selectCpu(c) {
  selectedCpu.value = c
  fetchProducts(0)
}

function handleSearch() {
  fetchProducts(0)
}

function resetFilters() {
  keyword.value = ''
  selectedBrand.value = ''
  selectedPriceRange.value = priceRanges[0]
  selectedRam.value = ''
  selectedCpu.value = ''
  fetchProducts(0)
}

async function fetchProducts(page = 0) {
  loading.value = true
  currentPage.value = page
  try {
    const params = {
      keyword: keyword.value || undefined,
      brand: selectedBrand.value || undefined,
      categoryId: route.query.categoryId || undefined,
      minPrice: selectedPriceRange.value.min || undefined,
      maxPrice: selectedPriceRange.value.max || undefined,
      ram: selectedRam.value || undefined,
      cpu: selectedCpu.value || undefined,
      page: page,
      size: 12,
      sort: selectedSort.value
    }
    const res = await productApi.getProducts(params)
    products.value = res.data.content || []
    totalElements.value = res.data.totalElements || 0
    totalPages.value = res.data.totalPages || 0
  } catch (err) {
    console.error('Lỗi nạp danh sách sản phẩm:', err)
  } finally {
    loading.value = false
  }
}

watch(() => route.query, (newQuery) => {
  if (newQuery.brand !== undefined) {
    selectedBrand.value = newQuery.brand
  }
  if (newQuery.search !== undefined) {
    keyword.value = newQuery.search
  }
  fetchProducts(0)
})

onMounted(() => {
  if (route.query.brand) {
    selectedBrand.value = route.query.brand
  }
  if (route.query.search) {
    keyword.value = route.query.search
  }
  fetchProducts(0)
})
</script>
