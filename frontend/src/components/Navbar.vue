<template>
  <header class="sticky top-0 z-40 bg-stage-bg text-stage-ink">
    <!-- Top Announcement Bar -->
    <div class="bg-stage-surface text-stage-muted text-xs py-2 px-4 hidden sm:block">
      <div class="max-w-7xl mx-auto flex items-center justify-between">
        <div class="flex items-center gap-4">
          <span class="text-stage-ink font-semibold">
            Hiếu Trần Laptop US: Chuyên máy nhập Mỹ nguyên bản
          </span>
          <span class="text-stage-muted">Video test máy trực tiếp qua Zalo</span>
        </div>
        <div class="flex items-center gap-4">
          <a
            href="https://zalo.me/0778333362"
            target="_blank"
            class="text-stage-ink hover:text-white font-semibold transition"
          >
            Hotline và Zalo: 0778.3333.62
          </a>
          <a
            href="https://www.facebook.com/p/Hi%E1%BA%BFu-Tr%E1%BA%A7n-Laptop-US-61585268909952/"
            target="_blank"
            class="hover:text-white transition"
          >
            Fanpage Facebook
          </a>
        </div>
      </div>
    </div>

    <!-- Main Navigation Bar -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-20 gap-6">
        <!-- Brand Wordmark -->
        <router-link to="/" class="flex items-center gap-3">
          <img
            src="/logo.jpg"
            alt="Hiếu Trần Laptop US"
            class="w-11 h-11 rounded-lg object-cover bg-stage-surface"
            onerror="this.src='https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=100&q=80'"
          />
          <div class="flex flex-col">
            <span class="text-white font-extrabold text-lg tracking-tight leading-tight">
              Hiếu Trần Laptop US
            </span>
            <span class="text-xs text-stage-muted font-normal">
              Laptop xách tay Mỹ
            </span>
          </div>
        </router-link>

        <!-- Search Bar (Desktop) -->
        <div class="hidden lg:flex flex-1 max-w-sm mx-4">
          <form @submit.prevent="handleSearch" class="relative w-full">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Tìm ThinkPad, XPS, MacBook..."
              class="w-full bg-stage-surface text-white placeholder-stage-muted text-xs rounded-lg pl-9 pr-16 py-2.5 outline-none focus:bg-stage-lift transition"
            />
            <div class="absolute left-3 top-1/2 -translate-y-1/2 text-stage-muted pointer-events-none">
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            <button
              type="submit"
              class="absolute right-1 top-1/2 -translate-y-1/2 px-3 py-1 bg-stage-accent text-white text-xs font-semibold rounded"
            >
              Tìm
            </button>
          </form>
        </div>

        <!-- Navigation Links -->
        <nav class="hidden md:flex items-center space-x-6 text-sm font-semibold text-stage-muted">
          <router-link
            to="/"
            class="hover:text-white transition"
            active-class="text-white font-bold"
          >
            Trang chủ
          </router-link>

          <router-link
            to="/products"
            class="hover:text-white transition"
            active-class="text-white font-bold"
          >
            Kho máy Mỹ
          </router-link>

          <router-link
            to="/orders"
            class="hover:text-white transition"
            active-class="text-white font-bold"
          >
            Tra cứu đơn hàng
          </router-link>

          <router-link
            v-if="authStore.isAdmin"
            to="/admin"
            class="text-amber-400 hover:text-amber-300 transition"
          >
            Quản trị
          </router-link>
        </nav>

        <!-- Right Side: Cart & Account -->
        <div class="flex items-center space-x-3">
          <!-- Cart Icon Button -->
          <router-link
            to="/cart"
            class="relative p-2.5 rounded-lg bg-stage-surface hover:bg-stage-lift text-stage-ink transition"
            title="Giỏ hàng"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
            </svg>
            <span
              v-if="cartStore.totalItems > 0"
              class="absolute -top-1 -right-1 bg-stage-accent text-white text-[10px] font-bold rounded-full h-4 w-4 flex items-center justify-center"
            >
              {{ cartStore.totalItems }}
            </span>
          </router-link>

          <!-- User State -->
          <div v-if="authStore.isAuthenticated" class="flex items-center gap-2">
            <router-link
              to="/orders"
              class="hidden sm:inline-flex text-xs font-semibold px-3 py-2 rounded-lg bg-stage-surface hover:bg-stage-lift text-stage-ink transition"
            >
              Đơn hàng
            </router-link>
            <button
              @click="handleLogout"
              class="text-xs font-semibold text-rose-400 hover:text-rose-300 px-3 py-2 rounded-lg bg-stage-surface hover:bg-stage-lift transition"
            >
              Đăng xuất
            </button>
          </div>

          <div v-else class="flex items-center gap-2">
            <router-link
              to="/login"
              class="text-xs font-semibold text-stage-muted hover:text-white px-3 py-2 transition"
            >
              Đăng nhập
            </router-link>
            <router-link
              to="/register"
              class="text-xs font-bold text-white bg-stage-surface hover:bg-stage-lift px-3.5 py-2 rounded-lg transition"
            >
              Đăng ký
            </router-link>
          </div>

          <!-- Mobile Menu Button -->
          <button
            @click="mobileMenuOpen = !mobileMenuOpen"
            class="md:hidden p-2 rounded-lg bg-stage-surface text-stage-ink"
            aria-label="Menu"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path v-if="!mobileMenuOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>

      <!-- Mobile Dropdown Menu -->
      <div v-if="mobileMenuOpen" class="md:hidden py-4 space-y-2 bg-stage-surface p-4 rounded-xl mb-4">
        <router-link
          to="/"
          @click="mobileMenuOpen = false"
          class="block py-2 text-stage-ink font-semibold"
        >
          Trang chủ
        </router-link>
        <router-link
          to="/products"
          @click="mobileMenuOpen = false"
          class="block py-2 text-stage-ink font-semibold"
        >
          Kho máy nhập Mỹ
        </router-link>
        <router-link
          to="/orders"
          @click="mobileMenuOpen = false"
          class="block py-2 text-stage-ink font-semibold"
        >
          Tra cứu đơn hàng
        </router-link>
        <router-link
          v-if="authStore.isAdmin"
          to="/admin"
          @click="mobileMenuOpen = false"
          class="block py-2 text-amber-400 font-semibold"
        >
          Quản trị
        </router-link>
        <a
          href="https://zalo.me/0778333362"
          target="_blank"
          class="block py-2 text-sky-400 font-semibold"
        >
          Zalo: 0778.3333.62
        </a>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'

const router = useRouter()
const authStore = useAuthStore()
const cartStore = useCartStore()

const searchQuery = ref('')
const mobileMenuOpen = ref(false)

function handleSearch() {
  if (searchQuery.value.trim()) {
    router.push({ path: '/products', query: { search: searchQuery.value.trim() } })
  }
}

function handleLogout() {
  authStore.logout()
  router.push('/')
}
</script>
