import apiClient from './axios'

export const orderApi = {
  createOrder(orderData) {
    return apiClient.post('/orders', orderData)
  },

  getMyOrders() {
    return apiClient.get('/orders/my')
  },

  trackOrders(params) {
    return apiClient.get('/orders/track', { params })
  }
}

