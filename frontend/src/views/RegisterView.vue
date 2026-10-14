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
        <h1 class="text-2xl font-extrabold text-white tracking-tight">Tạo tài khoản mới</h1>
        <p class="text-xs text-stage-muted">Gia nhập cộng đồng Hiếu Trần Laptop US</p>
      </div>

      <div v-if="errorMsg" class="p-3 bg-rose-500/10 text-rose-400 text-xs font-medium rounded-xl">
        {{ errorMsg }}
      </div>
      <div v-if="successMsg" class="p-3 bg-emerald-500/10 text-emerald-400 text-xs font-medium rounded-xl">
        {{ successMsg }}
      </div>

      <form @submit.prevent="handleRegister" class="space-y-4">
        <div>
          <label class="block text-xs font-semibold text-stage-muted mb-1.5">Họ và tên *</label>
          <input
            v-model="form.fullName"
            type="text"
            required
            placeholder="Ví dụ: Nguyễn Văn A"
            class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
          />
        </div>

        <div>
          <label class="block text-xs font-semibold text-stage-muted mb-1.5">Email tài khoản *</label>
          <input
            v-model="form.email"
            type="email"
            required
            placeholder="example@gmail.com"
            class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
          />
        </div>

        <div>
          <label class="block text-xs font-semibold text-stage-muted mb-1.5">Mật khẩu (tối thiểu 6 ký tự) *</label>
          <input
            v-model="form.password"
            type="password"
            minlength="6"
            required
            placeholder="••••••••"
            class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
          />
        </div>

        <div>
          <label class="block text-xs font-semibold text-stage-muted mb-1.5">Số điện thoại liên hệ</label>
          <input
            v-model="form.phone"
            type="tel"
            placeholder="0912345678"
            class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
          />
        </div>

        <div>
          <label class="block text-xs font-semibold text-stage-muted mb-1.5">Địa chỉ giao hàng</label>
          <input
            v-model="form.address"
            type="text"
            placeholder="Số nhà, đường, phường/xã, tỉnh/thành"
            class="w-full px-4 py-2.5 rounded-xl bg-stage-bg text-white placeholder-stage-muted text-xs sm:text-sm focus:outline-none focus:ring-1 focus:ring-stage-accent transition-colors"
          />
        </div>

        <button
          type="submit"
          :disabled="loading"
          class="w-full py-3.5 px-4 bg-stage-accent hover:bg-red-700 text-white font-bold text-sm rounded-xl transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
        >
          <span v-if="loading" class="animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent"></span>
          <span>{{ loading ? 'Đang tạo tài khoản...' : 'Đăng ký tài khoản' }}</span>
        </button>
      </form>

      <div class="text-center text-xs text-stage-muted pt-2">
        Đã có tài khoản?
        <router-link to="/login" class="text-white font-semibold hover:underline ml-1">
          Đăng nhập ngay →
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const router = useRouter()

const form = reactive({
  fullName: '',
  email: '',
  password: '',
  phone: '',
  address: ''
})

const loading = ref(false)
const errorMsg = ref('')
const successMsg = ref('')

async function handleRegister() {
  loading.value = true
  errorMsg.value = ''
  successMsg.value = ''

  try {
    await authStore.register(form)
    successMsg.value = 'Đăng ký thành công! Đang chuyển hướng...'
    setTimeout(() => {
      router.push('/')
    }, 1500)
  } catch (err) {
    errorMsg.value = err.response?.data?.message || 'Đăng ký thất bại, vui lòng kiểm tra lại thông tin'
  } finally {
    loading.value = false
  }
}
</script>
