import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '@/api/auth'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || null)
  const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))
  const loading = ref(false)
  const error = ref(null)

  const isAuthenticated = computed(() => !!token.value)
  const isAdmin = computed(() => user.value && (user.value.role === 'ROLE_ADMIN' || user.value.role === 'ADMIN'))

  async function login(credentialsOrEmail, password) {
    loading.value = true
    error.value = null
    const payload = typeof credentialsOrEmail === 'object'
      ? credentialsOrEmail
      : { email: credentialsOrEmail, password }
    try {
      const response = await authApi.login(payload)
      const data = response.data
      token.value = data.token
      user.value = {
        id: data.id,
        email: data.email,
        fullName: data.fullName,
        phone: data.phone,
        role: data.role
      }

      localStorage.setItem('token', data.token)
      localStorage.setItem('user', JSON.stringify(user.value))
      return data
    } catch (err) {
      error.value = err.response?.data?.message || 'Đăng nhập không thành công'
      throw err
    } finally {
      loading.value = false
    }
  }

  async function register(userData) {
    loading.value = true
    error.value = null
    try {
      const response = await authApi.register(userData)
      return response.data
    } catch (err) {
      error.value = err.response?.data?.message || 'Đăng ký không thành công'
      throw err
    } finally {
      loading.value = false
    }
  }

  function logout() {
    token.value = null
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  return {
    token,
    user,
    loading,
    error,
    isAuthenticated,
    isAdmin,
    login,
    register,
    logout
  }
})
