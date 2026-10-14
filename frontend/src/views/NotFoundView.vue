<template>
  <div class="min-h-[70svh] flex items-center justify-center py-16 px-4">
    <div class="max-w-md w-full bg-stage-surface p-8 sm:p-10 rounded-2xl text-center space-y-6">
      <div class="w-16 h-16 bg-stage-bg text-stage-accent rounded-2xl flex items-center justify-center mx-auto">
        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>
      </div>

      <div class="space-y-2">
        <h1 class="text-3xl font-extrabold text-white tracking-tight">
          404 - Trang không tồn tại
        </h1>
        <p class="text-xs sm:text-sm text-stage-muted leading-relaxed">
          Đường dẫn bạn đang tìm kiếm không tồn tại hoặc đã được chuyển sang vị trí khác trên hệ thống.
        </p>
      </div>

      <div class="flex flex-col sm:flex-row gap-3 justify-center">
        <router-link
          to="/"
          class="px-5 py-3 bg-stage-accent hover:bg-red-700 text-white font-bold text-xs rounded-xl transition-colors text-center"
        >
          Về trang chủ
        </router-link>
        <router-link
          to="/products"
          class="px-5 py-3 bg-stage-bg hover:bg-stage-lift text-white font-bold text-xs rounded-xl transition-colors text-center"
        >
          Xem kho laptop nhập Mỹ
        </router-link>
      </div>
    </div>
  </div>
</template>
