import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCartStore = defineStore('cart', () => {
  const items = ref(JSON.parse(localStorage.getItem('cart_items') || '[]'))

  const totalItems = computed(() => {
    return items.value.reduce((total, item) => total + item.quantity, 0)
  })

  const totalPrice = computed(() => {
    return items.value.reduce((total, item) => {
      const price = item.salePrice ? item.salePrice : item.price
      return total + price * item.quantity
    }, 0)
  })

  function saveToStorage() {
    localStorage.setItem('cart_items', JSON.stringify(items.value))
  }

  function addItem(product, quantity = 1) {
    const existingIndex = items.value.findIndex(i => i.id === product.id)
    if (existingIndex > -1) {
      items.value[existingIndex].quantity += quantity
    } else {
      items.value.push({
        id: product.id,
        name: product.name,
        slug: product.slug,
        price: product.price,
        salePrice: product.salePrice,
        brand: product.brand,
        images: product.images,
        quantity: quantity
      })
    }
    saveToStorage()
  }

  function updateQuantity(productId, quantity) {
    const item = items.value.find(i => i.id === productId)
    if (item) {
      if (quantity <= 0) {
        removeItem(productId)
      } else {
        item.quantity = quantity
        saveToStorage()
      }
    }
  }

  function removeItem(productId) {
    items.value = items.value.filter(i => i.id !== productId)
    saveToStorage()
  }

  function clearCart() {
    items.value = []
    saveToStorage()
  }

  return {
    items,
    totalItems,
    totalPrice,
    addItem,
    updateQuantity,
    removeItem,
    clearCart
  }
})
