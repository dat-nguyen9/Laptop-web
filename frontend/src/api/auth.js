import apiClient from './axios'

export const authApi = {
  login(credentials) {
    return apiClient.post('/auth/login', credentials)
  },

  register(userData) {
    return apiClient.post('/auth/register', userData)
  },

  getProfile() {
    return apiClient.get('/auth/me')
  }
}
