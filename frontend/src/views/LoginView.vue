<template>
  <div class="min-h-[80svh] flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full bg-stage-surface p-8 sm:p-10 rounded-2xl space-y-6">
      <!-- Shop Logo & Heading -->
      <div class="text-center space-y-2">
        <router-link to="/" class="inline-block">
          <img
            src="/logo.jpg"
            alt="Hiếu Trần Laptop US"
            class="w-14 h-14 rounded-xl mx-auto object-cover"
            onerror="this.src='https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=100&q=80'"
          />
        </router-link>
        <h1 class="text-2xl font-extrabold text-white tracking-tight">Đăng nhập tài khoản</h1>
        <p class="text-xs text-stage-muted">Hiếu Trần Laptop US - Chuyên ThinkPad & Dell XPS nhập Mỹ</p>
      </div>

      <!-- Quick Demo Account Fillers -->
      <div class="p-3.5 bg-stage-bg rounded-xl text-xs space-y-2">
        <p class="font-medium text-stage-muted">
          Tài khoản kiểm thử nhanh:
        </p>
        <div class="flex gap-2">
          <button
            @click="fillAdmin"
            type="button"
            class="flex-1 py-2 px-2 bg-stage-surface hover:bg-stage-lift text-white rounded-lg font-medium transition-colors text-[11px]"
          >
            Quản trị (Admin)
          </button>
          <button
            @click="fillCustomer"
            type="button"
            class="flex-1 py-2 px-2 bg-stage-surface hover:bg-stage-lift text-white rounded-lg font-medium transition-colors text-[11px]"
          >
            Khách hàng
          </button>
        </div>
      </div>

      <div v-if="errorMsg" class="p-3 bg-rose-500/10 text-rose-400 text-xs font-medium rounded-xl">
        {{ errorMsg }}
      </div>

      <form @submit.prevent="handleLogin" class="space-y-4">
        <div>
          <label class="block text-xs font-semibold text-stage-muted mb-1.5">Email tài khoản</label>
          <input
            v-model="form.email"
            type="email"
            required
            placeholder="example@laptopweb.com"
            class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
          />
        </div>

        <div>
          <label class="block text-xs font-semibold text-stage-muted mb-1.5">Mật khẩu</label>
          <input
            v-model="form.password"
            type="password"
            required
            placeholder="••••••••"
            class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
          />
        </div>

        <button
          type="submit"
          :disabled="loading"
          class="w-full py-3.5 px-4 bg-stage-accent hover:bg-red-700 text-white font-bold text-sm rounded-xl transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
        >
          <span v-if="loading" class="animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent"></span>
          <span>{{ loading ? 'Đang xác thực...' : 'Đăng nhập' }}</span>
        </button>
      </form>

      <div class="text-center text-xs text-stage-muted pt-2">
        Chưa có tài khoản?
        <router-link to="/register" class="text-white font-semibold hover:underline ml-1">
          Đăng ký tài khoản mới →
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

const form = reactive({
  email: '',
  password: ''
})

const loading = ref(false)
const errorMsg = ref('')

function fillAdmin() {
  form.email = 'admin@laptopweb.com'
  form.password = 'admin123'
}

function fillCustomer() {
  form.email = 'customer@laptopweb.com'
  form.password = '123456'
}

async function handleLogin() {
  loading.value = true
  errorMsg.value = ''

  try {
    const user = await authStore.login(form.email, form.password)
    const redirect = route.query.redirect
    if (redirect) {
      router.push(redirect)
    } else if (user.role === 'ADMIN' || user.role === 'ROLE_ADMIN') {
      router.push('/admin')
    } else {
      router.push('/')
    }
  } catch (err) {
    errorMsg.value = err.response?.data?.message || 'Email hoặc mật khẩu không chính xác'
  } finally {
    loading.value = false
  }
}
</script>
