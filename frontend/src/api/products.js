import apiClient from './axios'

export const productApi = {
  getProducts(params) {
    return apiClient.get('/products', { params })
  },

  getProductBySlug(slug) {
    return apiClient.get(`/products/${slug}`)
  },

  getProductById(id) {
    return apiClient.get(`/products/id/${id}`)
  },

  getRelatedProducts(id) {
    return apiClient.get(`/products/${id}/related`)
  },

  getCategories() {
    return apiClient.get('/categories')
  }
}
