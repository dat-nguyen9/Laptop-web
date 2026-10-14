import apiClient from './axios'

export const adminApi = {
  getStats() {
    return apiClient.get('/admin/stats')
  },

  getAllOrders(page = 0, size = 50) {
    return apiClient.get(`/admin/orders?page=${page}&size=${size}`)
  },

  updateStatus(orderId, status) {
    return apiClient.put(`/admin/orders/${orderId}/status?status=${status}`)
  },

  getUsers() {
    return apiClient.get('/admin/users')
  },

  // Product CRUD
  createProduct(data) {
    return apiClient.post('/admin/products', data)
  },

  updateProduct(id, data) {
    return apiClient.put(`/admin/products/${id}`, data)
  },

  deleteProduct(id) {
    return apiClient.delete(`/admin/products/${id}`)
  },

  // Category CRUD
  createCategory(data) {
    return apiClient.post('/admin/categories', data)
  },

  updateCategory(id, data) {
    return apiClient.put(`/admin/categories/${id}`, data)
  },

  deleteCategory(id) {
    return apiClient.delete(`/admin/categories/${id}`)
  },

  // Upload
  uploadImage(formData) {
    return apiClient.post('/admin/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  }
}
