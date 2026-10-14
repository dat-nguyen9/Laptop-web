<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-8">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
      <div>
        <div class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded bg-stage-surface text-stage-muted text-xs font-medium mb-3">
          <span>Khu vực quản trị hệ thống</span>
        </div>
        <h1 class="text-3xl sm:text-4xl font-extrabold tracking-tight text-white leading-tight">
          Bảng điều khiển quản lý
        </h1>
        <p class="text-sm text-stage-muted mt-1">
          Theo dõi doanh số, cập nhật kho laptop, quản lý đơn hàng và chat Zalo với khách
        </p>
      </div>

      <button
        @click="refreshCurrentTab"
        class="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-stage-surface hover:bg-stage-lift text-white font-medium text-xs transition-colors self-start sm:self-auto"
      >
        <svg class="w-4 h-4 text-stage-muted" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
        </svg>
        <span>Làm mới dữ liệu</span>
      </button>
    </div>

    <!-- Admin Tab Navigation Switcher -->
    <div class="bg-stage-surface p-1.5 rounded-2xl flex flex-wrap gap-1.5 text-xs font-semibold">
      <button
        @click="activeTab = 'overview'"
        :class="[
          'px-4 py-2.5 rounded-xl transition-colors',
          activeTab === 'overview' ? 'bg-stage-bg text-white' : 'text-stage-muted hover:text-white'
        ]"
      >
        Tổng quan & Doanh số
      </button>
      <button
        @click="activeTab = 'products'"
        :class="[
          'px-4 py-2.5 rounded-xl transition-colors',
          activeTab === 'products' ? 'bg-stage-bg text-white' : 'text-stage-muted hover:text-white'
        ]"
      >
        Quản lý sản phẩm ({{ productList.length }})
      </button>
      <button
        @click="activeTab = 'orders'"
        :class="[
          'px-4 py-2.5 rounded-xl transition-colors',
          activeTab === 'orders' ? 'bg-stage-bg text-white' : 'text-stage-muted hover:text-white'
        ]"
      >
        Quản lý đơn hàng ({{ orders.length }})
      </button>
      <button
        @click="activeTab = 'categories'"
        :class="[
          'px-4 py-2.5 rounded-xl transition-colors',
          activeTab === 'categories' ? 'bg-stage-bg text-white' : 'text-stage-muted hover:text-white'
        ]"
      >
        Quản lý danh mục ({{ categories.length }})
      </button>
    </div>

    <!-- TAB 1: OVERVIEW -->
    <div v-if="activeTab === 'overview'" class="space-y-8">
      <!-- Stats Cards (4 cols) -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <!-- Revenue -->
        <div class="bg-stage-surface p-5 rounded-2xl flex items-center justify-between">
          <div>
            <span class="text-xs font-medium text-stage-muted block">Tổng doanh thu</span>
            <p class="text-xl sm:text-2xl font-black text-stage-accent mt-1.5">
              {{ formatCurrency(stats.totalRevenue) }}
            </p>
          </div>
          <div class="w-11 h-11 rounded-xl bg-stage-bg text-stage-muted flex items-center justify-center">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
        </div>

        <!-- Orders -->
        <div class="bg-stage-surface p-5 rounded-2xl flex items-center justify-between">
          <div>
            <span class="text-xs font-medium text-stage-muted block">Tổng đơn hàng</span>
            <p class="text-xl sm:text-2xl font-black text-white mt-1.5">
              {{ stats.totalOrders || 0 }}
            </p>
          </div>
          <div class="w-11 h-11 rounded-xl bg-stage-bg text-stage-muted flex items-center justify-center">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
            </svg>
          </div>
        </div>

        <!-- Products -->
        <div class="bg-stage-surface p-5 rounded-2xl flex items-center justify-between">
          <div>
            <span class="text-xs font-medium text-stage-muted block">Sản phẩm trong kho</span>
            <p class="text-xl sm:text-2xl font-black text-white mt-1.5">
              {{ stats.totalProducts || 0 }}
            </p>
          </div>
          <div class="w-11 h-11 rounded-xl bg-stage-bg text-stage-muted flex items-center justify-center">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
          </div>
        </div>

        <!-- Users -->
        <div class="bg-stage-surface p-5 rounded-2xl flex items-center justify-between">
          <div>
            <span class="text-xs font-medium text-stage-muted block">Khách đăng ký</span>
            <p class="text-xl sm:text-2xl font-black text-white mt-1.5">
              {{ stats.totalUsers || 0 }}
            </p>
          </div>
          <div class="w-11 h-11 rounded-xl bg-stage-bg text-stage-muted flex items-center justify-center">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Quick Recent Orders Table in Overview -->
      <div class="bg-stage-surface rounded-2xl p-6 space-y-4" data-ui>
        <div class="flex items-center justify-between">
          <h2 class="text-base font-bold text-white">Đơn hàng mới nhất</h2>
          <button @click="activeTab = 'orders'" class="text-xs font-semibold text-stage-accent hover:underline">
            Xem tất cả đơn hàng →
          </button>
        </div>

        <div v-if="orders.length === 0" class="py-10 text-center text-stage-muted text-xs">
          Chưa có đơn hàng nào phát sinh.
        </div>
        <div v-else class="overflow-x-auto" data-ui>
          <table class="w-full text-left text-xs" data-ui>
            <thead class="bg-stage-bg text-stage-muted font-semibold text-[11px]" data-ui>
              <tr>
                <th class="py-3 px-4">Mã đơn</th>
                <th class="py-3 px-4">Khách hàng</th>
                <th class="py-3 px-4">Số điện thoại</th>
                <th class="py-3 px-4">Tổng tiền</th>
                <th class="py-3 px-4">Trạng thái</th>
              </tr>
            </thead>
            <tbody data-ui>
              <tr v-for="order in orders.slice(0, 5)" :key="order.id" class="hover:bg-stage-lift/40 transition-colors">
                <td class="py-3 px-4 font-bold text-white">#{{ order.id }}</td>
                <td class="py-3 px-4 font-medium text-white">{{ order.fullName }}</td>
                <td class="py-3 px-4 text-stage-muted">{{ order.phone }}</td>
                <td class="py-3 px-4 font-bold text-stage-accent">{{ formatCurrency(order.total) }}</td>
                <td class="py-3 px-4">
                  <span class="px-2.5 py-1 rounded text-[11px] font-semibold bg-stage-bg text-white">
                    {{ formatStatus(order.status) }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB 2: PRODUCT MANAGEMENT -->
    <div v-if="activeTab === 'products'" class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 class="text-lg font-bold text-white">Quản lý kho sản phẩm</h2>
          <p class="text-xs text-stage-muted">Thêm máy mới, cập nhật giá bán, số lượng tồn kho và thông số kỹ thuật</p>
        </div>
        <button
          @click="openAddProductModal"
          class="px-4 py-2.5 bg-stage-accent hover:bg-red-700 text-white font-bold text-xs rounded-xl transition-colors inline-flex items-center gap-1.5 self-start sm:self-auto"
        >
          <span>+ Thêm sản phẩm mới</span>
        </button>
      </div>

      <div class="bg-stage-surface rounded-2xl overflow-hidden" data-ui>
        <div v-if="loadingProducts" class="py-16 text-center text-stage-muted text-xs">
          Đang tải danh sách sản phẩm...
        </div>
        <div v-else class="overflow-x-auto" data-ui>
          <table class="w-full text-left text-xs" data-ui>
            <thead class="bg-stage-bg text-stage-muted font-semibold text-[11px]" data-ui>
              <tr>
                <th class="py-3 px-4">Ảnh</th>
                <th class="py-3 px-4">Tên máy & Hãng</th>
                <th class="py-3 px-4">Danh mục</th>
                <th class="py-3 px-4">Giá bán / Sale</th>
                <th class="py-3 px-4">Tồn kho</th>
                <th class="py-3 px-4 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody data-ui>
              <tr v-for="p in productList" :key="p.id" class="hover:bg-stage-lift/40 transition-colors">
                <td class="py-3 px-4">
                  <img
                    :src="p.images || 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=100&q=80'"
                    :alt="p.name"
                    class="w-12 h-12 object-contain rounded-lg bg-stage-bg p-1"
                    @error="e => e.target.src = 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=100&q=80'"
                  />
                </td>
                <td class="py-3 px-4">
                  <div class="font-bold text-white max-w-xs truncate" :title="p.name">{{ p.name }}</div>
                  <span class="text-[10px] text-stage-muted bg-stage-bg px-1.5 py-0.5 rounded">{{ p.brand }}</span>
                </td>
                <td class="py-3 px-4 text-stage-muted">{{ p.category?.name || 'Chưa phân loại' }}</td>
                <td class="py-3 px-4">
                  <div class="font-bold text-stage-accent">{{ formatCurrency(p.salePrice || p.price) }}</div>
                  <div v-if="p.salePrice" class="text-[10px] text-stage-muted line-through">{{ formatCurrency(p.price) }}</div>
                </td>
                <td class="py-3 px-4">
                  <span :class="p.stock > 0 ? 'text-emerald-400 font-bold' : 'text-rose-400 font-bold'">
                    {{ p.stock > 0 ? p.stock + ' máy' : 'Hết hàng' }}
                  </span>
                </td>
                <td class="py-3 px-4 text-right space-x-2">
                  <button
                    @click="openEditProductModal(p)"
                    class="px-2.5 py-1 rounded bg-stage-bg hover:bg-stage-lift text-white text-xs font-medium transition-colors"
                  >
                    Sửa
                  </button>
                  <button
                    @click="deleteProduct(p.id)"
                    class="px-2.5 py-1 rounded bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 text-xs font-medium transition-colors"
                  >
                    Xóa
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB 3: ORDER MANAGEMENT -->
    <div v-if="activeTab === 'orders'" class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 class="text-lg font-bold text-white">Quản lý đơn hàng & Điều phối COD</h2>
          <p class="text-xs text-stage-muted">Cập nhật trạng thái kiểm định máy, giao COD và chat trực tiếp với khách qua Zalo</p>
        </div>
      </div>

      <!-- Status Filter Pills -->
      <div class="flex flex-wrap gap-2 text-xs font-semibold">
        <button
          v-for="st in statusFilters"
          :key="st.value"
          @click="selectedOrderStatusFilter = st.value"
          :class="[
            'px-3.5 py-1.5 rounded-lg transition-colors',
            selectedOrderStatusFilter === st.value
              ? 'bg-stage-accent text-white'
              : 'bg-stage-surface text-stage-muted hover:text-white'
          ]"
        >
          {{ st.label }} ({{ countOrdersByStatus(st.value) }})
        </button>
      </div>

      <div class="bg-stage-surface rounded-2xl overflow-hidden" data-ui>
        <div v-if="loadingOrders" class="py-16 text-center text-stage-muted text-xs">
          Đang tải danh sách đơn hàng...
        </div>
        <div v-else-if="filteredOrders.length === 0" class="py-16 text-center text-stage-muted text-xs">
          Không có đơn hàng nào phù hợp với bộ lọc.
        </div>
        <div v-else class="overflow-x-auto" data-ui>
          <table class="w-full text-left text-xs" data-ui>
            <thead class="bg-stage-bg text-stage-muted font-semibold text-[11px]" data-ui>
              <tr>
                <th class="py-3 px-4">Mã đơn</th>
                <th class="py-3 px-4">Khách hàng</th>
                <th class="py-3 px-4">Số điện thoại</th>
                <th class="py-3 px-4">Địa chỉ giao</th>
                <th class="py-3 px-4">Sản phẩm</th>
                <th class="py-3 px-4">Tổng tiền</th>
                <th class="py-3 px-4">Trạng thái</th>
                <th class="py-3 px-4">Zalo</th>
              </tr>
            </thead>
            <tbody data-ui>
              <tr v-for="order in filteredOrders" :key="order.id" class="hover:bg-stage-lift/40 transition-colors">
                <td class="py-3.5 px-4 font-bold text-white">#{{ order.id }}</td>
                <td class="py-3.5 px-4 font-medium text-white">{{ order.fullName }}</td>
                <td class="py-3.5 px-4">
                  <a :href="`https://zalo.me/${order.phone}`" target="_blank" class="text-stage-accent font-semibold hover:underline">
                    {{ order.phone }}
                  </a>
                </td>
                <td class="py-3.5 px-4 text-stage-muted max-w-xs truncate" :title="order.address">
                  {{ order.address }}
                </td>
                <td class="py-3.5 px-4 text-stage-muted max-w-xs">
                  <div v-for="it in order.items" :key="it.id" class="truncate">
                    {{ it.quantity }}x {{ it.product?.name }}
                  </div>
                </td>
                <td class="py-3.5 px-4 font-bold text-stage-accent">
                  {{ formatCurrency(order.total) }}
                </td>
                <td class="py-3.5 px-4">
                  <select
                    v-model="order.status"
                    @change="updateStatus(order)"
                    class="text-xs font-medium py-1.5 px-2 rounded-lg bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent cursor-pointer"
                  >
                    <option value="PENDING">Chờ xác nhận & Test</option>
                    <option value="CONFIRMED">Đã xác nhận</option>
                    <option value="SHIPPING">Đang gửi COD</option>
                    <option value="DELIVERED">Đã giao thành công</option>
                    <option value="CANCELLED">Đã hủy đơn</option>
                  </select>
                </td>
                <td class="py-3.5 px-4">
                  <a
                    :href="`https://zalo.me/${order.phone}?text=${encodeURIComponent('Xin chào ' + order.fullName + ', Hiếu Trần Laptop US liên hệ gửi video test máy đơn hàng #' + order.id + ' của bạn.')}`"
                    target="_blank"
                    class="inline-flex items-center gap-1 px-3 py-1.5 bg-stage-bg hover:bg-stage-lift text-white rounded-lg font-medium text-xs transition-colors"
                  >
                    <span>Nhắn Zalo</span>
                  </a>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- TAB 4: CATEGORY MANAGEMENT -->
    <div v-if="activeTab === 'categories'" class="space-y-6">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 class="text-lg font-bold text-white">Quản lý danh mục sản phẩm</h2>
          <p class="text-xs text-stage-muted">Phân loại các dòng laptop (ThinkPad, Dell XPS, MacBook, HP...)</p>
        </div>
        <button
          @click="openAddCategoryModal"
          class="px-4 py-2.5 bg-stage-accent hover:bg-red-700 text-white font-bold text-xs rounded-xl transition-colors inline-flex items-center gap-1.5 self-start sm:self-auto"
        >
          <span>+ Thêm danh mục mới</span>
        </button>
      </div>

      <div class="bg-stage-surface rounded-2xl overflow-hidden" data-ui>
        <div class="overflow-x-auto" data-ui>
          <table class="w-full text-left text-xs" data-ui>
            <thead class="bg-stage-bg text-stage-muted font-semibold text-[11px]" data-ui>
              <tr>
                <th class="py-3 px-4">ID</th>
                <th class="py-3 px-4">Tên danh mục</th>
                <th class="py-3 px-4">Đường dẫn (Slug)</th>
                <th class="py-3 px-4">Mô tả</th>
                <th class="py-3 px-4 text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody data-ui>
              <tr v-for="cat in categories" :key="cat.id" class="hover:bg-stage-lift/40 transition-colors">
                <td class="py-3 px-4 font-bold text-white">#{{ cat.id }}</td>
                <td class="py-3 px-4 font-bold text-white">{{ cat.name }}</td>
                <td class="py-3 px-4 text-stage-muted text-[11px]">{{ cat.slug }}</td>
                <td class="py-3 px-4 text-stage-muted">{{ cat.description || 'Không có mô tả' }}</td>
                <td class="py-3 px-4 text-right space-x-2">
                  <button
                    @click="openEditCategoryModal(cat)"
                    class="px-2.5 py-1 rounded bg-stage-bg hover:bg-stage-lift text-white text-xs font-medium transition-colors"
                  >
                    Sửa
                  </button>
                  <button
                    @click="deleteCategory(cat.id)"
                    class="px-2.5 py-1 rounded bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 text-xs font-medium transition-colors"
                  >
                    Xóa
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- PRODUCT MODAL (ADD / EDIT) -->
    <div v-if="productModalOpen" class="fixed inset-0 bg-black/80 z-50 flex items-center justify-center p-4 overflow-y-auto">
      <div class="bg-stage-surface rounded-2xl max-w-2xl w-full p-6 sm:p-8 space-y-6 my-8">
        <div class="flex items-center justify-between pb-1">
          <h3 class="text-lg font-bold text-white">
            {{ editingProduct ? 'Cập nhật thông tin sản phẩm' : 'Thêm sản phẩm laptop mới' }}
          </h3>
          <button @click="productModalOpen = false" class="text-stage-muted hover:text-white p-1" aria-label="Đóng">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
          </button>
        </div>

        <form @submit.prevent="saveProduct" class="space-y-4 text-xs">
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label class="block font-semibold text-stage-muted mb-1">Tên máy laptop *</label>
              <input
                v-model="productForm.name"
                @input="autoGenerateSlug"
                type="text"
                required
                placeholder="Ví dụ: ThinkPad T14 Gen 4"
                class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent"
              />
            </div>

            <div>
              <label class="block font-semibold text-stage-muted mb-1">Đường dẫn slug *</label>
              <input
                v-model="productForm.slug"
                type="text"
                required
                placeholder="thinkpad-t14-gen-4"
                class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent text-[11px]"
              />
            </div>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div>
              <label class="block font-semibold text-stage-muted mb-1">Thương hiệu *</label>
              <select
                v-model="productForm.brand"
                required
                class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent cursor-pointer"
              >
                <option value="Lenovo">Lenovo (ThinkPad)</option>
                <option value="Dell">Dell (XPS / Latitude / Precision)</option>
                <option value="Apple">Apple (MacBook)</option>
                <option value="HP">HP (EliteBook)</option>
                <option value="Asus">Asus</option>
              </select>
            </div>

            <div>
              <label class="block font-semibold text-stage-muted mb-1">Danh mục *</label>
              <select
                v-model="productForm.categoryId"
                required
                class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent cursor-pointer"
              >
                <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
              </select>
            </div>

            <div>
              <label class="block font-semibold text-stage-muted mb-1">Số lượng trong kho *</label>
              <input
                v-model.number="productForm.stock"
                type="number"
                min="0"
                required
                class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent"
              />
            </div>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label class="block font-semibold text-stage-muted mb-1">Giá bán gốc (₫) *</label>
              <input
                v-model.number="productForm.price"
                type="number"
                min="0"
                required
                placeholder="15000000"
                class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent"
              />
            </div>

            <div>
              <label class="block font-semibold text-stage-muted mb-1">Giá khuyến mãi (₫) (tùy chọn)</label>
              <input
                v-model.number="productForm.salePrice"
                type="number"
                min="0"
                placeholder="13500000"
                class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent"
              />
            </div>
          </div>

          <!-- Image URL and File Upload -->
          <div class="space-y-2">
            <label class="block font-semibold text-stage-muted">Ảnh sản phẩm</label>
            <div class="flex flex-col sm:flex-row gap-3">
              <input
                v-model="productForm.images"
                type="url"
                placeholder="Dán link ảnh hoặc upload file bên phải"
                class="flex-1 px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent"
              />
              <label class="px-4 py-2.5 bg-stage-bg hover:bg-stage-lift text-white font-semibold rounded-xl cursor-pointer text-center whitespace-nowrap">
                <span>{{ uploadingImage ? 'Đang tải...' : 'Upload ảnh từ máy' }}</span>
                <input type="file" accept="image/*" class="sr-only" @change="handleFileUpload" />
              </label>
            </div>
            <div v-if="productForm.images" class="flex items-center gap-3 pt-1">
              <img :src="productForm.images" alt="Preview" class="w-14 h-14 object-contain rounded-lg bg-stage-bg p-1" />
              <span class="text-[11px] text-stage-muted truncate">{{ productForm.images }}</span>
            </div>
          </div>

          <!-- Specs JSON / Fields -->
          <div class="space-y-2">
            <label class="block font-semibold text-stage-muted">Thông số kỹ thuật chi tiết (JSON hoặc cấu hình)</label>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-2">
              <input v-model="productSpecs.cpu" placeholder="CPU (e.g. i7-1260P)" class="px-3 py-2 rounded-lg bg-stage-bg text-white" />
              <input v-model="productSpecs.ram" placeholder="RAM (e.g. 16GB LPDDR5)" class="px-3 py-2 rounded-lg bg-stage-bg text-white" />
              <input v-model="productSpecs.storage" placeholder="SSD (e.g. 512GB NVMe)" class="px-3 py-2 rounded-lg bg-stage-bg text-white" />
              <input v-model="productSpecs.gpu" placeholder="GPU (e.g. Intel Iris Xe)" class="px-3 py-2 rounded-lg bg-stage-bg text-white" />
              <input v-model="productSpecs.screen" placeholder="Màn hình (e.g. 14 inch 2K)" class="px-3 py-2 rounded-lg bg-stage-bg text-white" />
              <input v-model="productSpecs.weight" placeholder="Trọng lượng (e.g. 1.2kg)" class="px-3 py-2 rounded-lg bg-stage-bg text-white" />
              <input v-model="productSpecs.battery" placeholder="Pin (e.g. 57Wh)" class="px-3 py-2 rounded-lg bg-stage-bg text-white" />
            </div>
          </div>

          <div>
            <label class="block font-semibold text-stage-muted mb-1">Mô tả sản phẩm</label>
            <textarea
              v-model="productForm.description"
              rows="3"
              placeholder="Mô tả tình trạng máy, xuất xứ xách tay Mỹ..."
              class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent resize-none"
            ></textarea>
          </div>

          <div class="flex justify-end gap-3 pt-2">
            <button
              type="button"
              @click="productModalOpen = false"
              class="px-4 py-2.5 rounded-xl bg-stage-bg hover:bg-stage-lift text-stage-muted hover:text-white font-semibold transition-colors"
            >
              Hủy
            </button>
            <button
              type="submit"
              :disabled="savingProduct"
              class="px-6 py-2.5 bg-stage-accent hover:bg-red-700 text-white font-bold rounded-xl transition-colors disabled:opacity-50"
            >
              {{ savingProduct ? 'Đang lưu...' : 'Lưu sản phẩm' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- CATEGORY MODAL (ADD / EDIT) -->
    <div v-if="categoryModalOpen" class="fixed inset-0 bg-black/80 z-50 flex items-center justify-center p-4">
      <div class="bg-stage-surface rounded-2xl max-w-md w-full p-6 sm:p-8 space-y-5">
        <div class="flex items-center justify-between pb-1">
          <h3 class="text-base font-bold text-white">
            {{ editingCategory ? 'Cập nhật danh mục' : 'Thêm danh mục mới' }}
          </h3>
          <button @click="categoryModalOpen = false" class="text-stage-muted hover:text-white p-1" aria-label="Đóng">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
          </button>
        </div>

        <form @submit.prevent="saveCategory" class="space-y-4 text-xs">
          <div>
            <label class="block font-semibold text-stage-muted mb-1">Tên danh mục *</label>
            <input
              v-model="categoryForm.name"
              @input="autoGenerateCategorySlug"
              type="text"
              required
              placeholder="Ví dụ: ThinkPad X1 Series"
              class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent"
            />
          </div>

          <div>
            <label class="block font-semibold text-stage-muted mb-1">Slug *</label>
            <input
              v-model="categoryForm.slug"
              type="text"
              required
              placeholder="thinkpad-x1-series"
              class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent text-[11px]"
            />
          </div>

          <div>
            <label class="block font-semibold text-stage-muted mb-1">Mô tả ngắn</label>
            <textarea
              v-model="categoryForm.description"
              rows="2"
              placeholder="Mô tả tiêu chuẩn dòng máy..."
              class="w-full px-3.5 py-2.5 rounded-xl bg-stage-bg text-white focus:outline-none focus:ring-1 focus:ring-stage-accent resize-none"
            ></textarea>
          </div>

          <div class="flex justify-end gap-3 pt-2">
            <button
              type="button"
              @click="categoryModalOpen = false"
              class="px-4 py-2.5 rounded-xl bg-stage-bg hover:bg-stage-lift text-stage-muted hover:text-white font-semibold transition-colors"
            >
              Hủy
            </button>
            <button
              type="submit"
              :disabled="savingCategory"
              class="px-6 py-2.5 bg-stage-accent hover:bg-red-700 text-white font-bold rounded-xl transition-colors disabled:opacity-50"
            >
              {{ savingCategory ? 'Đang lưu...' : 'Lưu danh mục' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { adminApi } from '@/api/admin'
import { orderApi } from '@/api/orders'
import { productApi } from '@/api/products'
import { useToastStore } from '@/stores/toast'

const toastStore = useToastStore()

const activeTab = ref('overview')
const selectedOrderStatusFilter = ref('ALL')

const stats = ref({
  totalRevenue: 0,
  totalOrders: 0,
  totalProducts: 0,
  totalUsers: 0
})

const orders = ref([])
const productList = ref([])
const categories = ref([])

const loadingOrders = ref(false)
const loadingProducts = ref(false)
const uploadingImage = ref(false)
const savingProduct = ref(false)
const savingCategory = ref(false)

const productModalOpen = ref(false)
const editingProduct = ref(null)

const categoryModalOpen = ref(false)
const editingCategory = ref(null)

const statusFilters = [
  { value: 'ALL', label: 'Tất cả' },
  { value: 'PENDING', label: 'Chờ xác nhận' },
  { value: 'CONFIRMED', label: 'Đã xác nhận' },
  { value: 'SHIPPING', label: 'Đang gửi COD' },
  { value: 'DELIVERED', label: 'Đã giao' },
  { value: 'CANCELLED', label: 'Đã hủy' }
]

const productForm = reactive({
  name: '',
  slug: '',
  brand: 'Lenovo',
  categoryId: null,
  price: 0,
  salePrice: null,
  stock: 1,
  images: '',
  description: ''
})

const productSpecs = reactive({
  cpu: '',
  ram: '',
  storage: '',
  gpu: '',
  screen: '',
  weight: '',
  battery: ''
})

const categoryForm = reactive({
  name: '',
  slug: '',
  description: ''
})

function formatCurrency(val) {
  if (!val) return '0 ₫'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val)
}

function formatStatus(status) {
  const map = {
    PENDING: 'Chờ test & xác nhận',
    CONFIRMED: 'Đã xác nhận',
    SHIPPING: 'Đang gửi COD',
    DELIVERED: 'Đã giao thành công',
    CANCELLED: 'Đã hủy'
  }
  return map[status] || status
}

const filteredOrders = computed(() => {
  if (selectedOrderStatusFilter.value === 'ALL') {
    return orders.value
  }
  return orders.value.filter(o => o.status === selectedOrderStatusFilter.value)
})

function countOrdersByStatus(status) {
  if (status === 'ALL') return orders.value.length
  return orders.value.filter(o => o.status === status).length
}

function slugify(text) {
  return text
    .toString()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[đĐ]/g, 'd')
    .replace(/[^a-z0-9 -]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function autoGenerateSlug() {
  if (!editingProduct.value) {
    productForm.slug = slugify(productForm.name)
  }
}

function autoGenerateCategorySlug() {
  if (!editingCategory.value) {
    categoryForm.slug = slugify(categoryForm.name)
  }
}

async function fetchStats() {
  try {
    const res = await adminApi.getStats()
    stats.value = res.data
  } catch (err) {
    console.error('Lỗi nạp thống kê:', err)
  }
}

async function fetchOrders() {
  loadingOrders.value = true
  try {
    const res = await orderApi.getAllOrders ? await orderApi.getAllOrders() : await adminApi.getAllOrders()
    orders.value = res.data?.content || res.data || []
  } catch (err) {
    console.error('Lỗi nạp đơn hàng:', err)
  } finally {
    loadingOrders.value = false
  }
}

async function fetchProductsList() {
  loadingProducts.value = true
  try {
    const res = await productApi.getProducts({ page: 0, size: 100 })
    productList.value = res.data?.content || res.data || []
  } catch (err) {
    console.error('Lỗi nạp sản phẩm:', err)
  } finally {
    loadingProducts.value = false
  }
}

async function fetchCategoriesList() {
  try {
    const res = await productApi.getCategories()
    categories.value = res.data || []
  } catch (err) {
    console.error('Lỗi nạp danh mục:', err)
  }
}

async function refreshCurrentTab() {
  await Promise.all([
    fetchStats(),
    fetchOrders(),
    fetchProductsList(),
    fetchCategoriesList()
  ])
  toastStore.success('Đã làm mới dữ liệu mới nhất')
}

async function updateStatus(order) {
  try {
    await adminApi.updateStatus(order.id, order.status)
    toastStore.success(`Đã cập nhật trạng thái đơn #${order.id}`)
    fetchStats()
  } catch (err) {
    alert('Cập nhật thất bại: ' + (err.response?.data?.message || err.message))
    fetchOrders()
  }
}

// Product CRUD Modal handlers
function openAddProductModal() {
  editingProduct.value = null
  productForm.name = ''
  productForm.slug = ''
  productForm.brand = 'Lenovo'
  productForm.categoryId = categories.value[0]?.id || null
  productForm.price = 0
  productForm.salePrice = null
  productForm.stock = 5
  productForm.images = ''
  productForm.description = ''

  productSpecs.cpu = ''
  productSpecs.ram = ''
  productSpecs.storage = ''
  productSpecs.gpu = ''
  productSpecs.screen = ''
  productSpecs.weight = ''
  productSpecs.battery = ''

  productModalOpen.value = true
}

function openEditProductModal(prod) {
  editingProduct.value = prod
  productForm.name = prod.name
  productForm.slug = prod.slug
  productForm.brand = prod.brand
  productForm.categoryId = prod.category?.id || null
  productForm.price = prod.price
  productForm.salePrice = prod.salePrice
  productForm.stock = prod.stock
  productForm.images = prod.images
  productForm.description = prod.description || ''

  try {
    const parsed = typeof prod.specs === 'string' ? JSON.parse(prod.specs) : (prod.specs || {})
    productSpecs.cpu = parsed.cpu || ''
    productSpecs.ram = parsed.ram || ''
    productSpecs.storage = parsed.storage || ''
    productSpecs.gpu = parsed.gpu || ''
    productSpecs.screen = parsed.screen || ''
    productSpecs.weight = parsed.weight || ''
    productSpecs.battery = parsed.battery || ''
  } catch {
    // Keep empty
  }

  productModalOpen.value = true
}

async function handleFileUpload(e) {
  const file = e.target.files[0]
  if (!file) return

  uploadingImage.value = true
  const formData = new FormData()
  formData.append('file', file)

  try {
    const res = await adminApi.uploadImage(formData)
    productForm.images = res.data.url
    toastStore.success('Upload ảnh thành công!')
  } catch (err) {
    alert('Upload thất bại: ' + (err.response?.data?.message || err.message))
  } finally {
    uploadingImage.value = false
  }
}

async function saveProduct() {
  savingProduct.value = true
  try {
    const payload = {
      name: productForm.name.trim(),
      slug: productForm.slug.trim(),
      brand: productForm.brand,
      price: productForm.price,
      salePrice: productForm.salePrice || null,
      stock: productForm.stock,
      images: productForm.images,
      description: productForm.description,
      category: categories.value.find(c => c.id === productForm.categoryId) || null,
      specs: JSON.stringify(productSpecs)
    }

    if (editingProduct.value) {
      await adminApi.updateProduct(editingProduct.value.id, payload)
      toastStore.success('Đã cập nhật sản phẩm!')
    } else {
      await adminApi.createProduct(payload)
      toastStore.success('Đã thêm sản phẩm mới thành công!')
    }

    productModalOpen.value = false
    await Promise.all([fetchProductsList(), fetchStats()])
  } catch (err) {
    alert('Lưu sản phẩm thất bại: ' + (err.response?.data?.message || err.message))
  } finally {
    savingProduct.value = false
  }
}

async function deleteProduct(id) {
  if (!confirm(`Bạn có chắc muốn xóa sản phẩm #${id} khỏi hệ thống?`)) return
  try {
    await adminApi.deleteProduct(id)
    toastStore.success('Đã xóa sản phẩm thành công!')
    await Promise.all([fetchProductsList(), fetchStats()])
  } catch (err) {
    alert('Xóa thất bại: ' + (err.response?.data?.message || err.message))
  }
}

// Category CRUD Modal handlers
function openAddCategoryModal() {
  editingCategory.value = null
  categoryForm.name = ''
  categoryForm.slug = ''
  categoryForm.description = ''
  categoryModalOpen.value = true
}

function openEditCategoryModal(cat) {
  editingCategory.value = cat
  categoryForm.name = cat.name
  categoryForm.slug = cat.slug
  categoryForm.description = cat.description || ''
  categoryModalOpen.value = true
}

async function saveCategory() {
  savingCategory.value = true
  try {
    const payload = {
      name: categoryForm.name.trim(),
      slug: categoryForm.slug.trim(),
      description: categoryForm.description.trim()
    }

    if (editingCategory.value) {
      await adminApi.updateCategory(editingCategory.value.id, payload)
      toastStore.success('Đã cập nhật danh mục!')
    } else {
      await adminApi.createCategory(payload)
      toastStore.success('Đã thêm danh mục mới!')
    }

    categoryModalOpen.value = false
    await fetchCategoriesList()
  } catch (err) {
    alert('Lưu danh mục thất bại: ' + (err.response?.data?.message || err.message))
  } finally {
    savingCategory.value = false
  }
}

async function deleteCategory(id) {
  if (!confirm(`Bạn có chắc muốn xóa danh mục #${id}?`)) return
  try {
    await adminApi.deleteCategory(id)
    toastStore.success('Đã xóa danh mục!')
    await fetchCategoriesList()
  } catch (err) {
    alert('Xóa thất bại: ' + (err.response?.data?.message || err.message))
  }
}

onMounted(() => {
  fetchStats()
  fetchOrders()
  fetchProductsList()
  fetchCategoriesList()
})
</script>
