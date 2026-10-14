<template>
  <footer class="bg-stage-bg text-stage-muted pt-20 pb-12">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
      <!-- 4 Columns Grid -->
      <div class="grid grid-cols-1 md:grid-cols-12 gap-10">
        <!-- Col 1: Shop Brand (4 cols) -->
        <div class="md:col-span-4 space-y-4">
          <div class="flex items-center gap-3">
            <img
              src="/logo.jpg"
              alt="Hiếu Trần Laptop US"
              class="w-10 h-10 rounded-lg object-cover bg-stage-surface"
              onerror="this.src='https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=100&q=80'"
            />
            <div>
              <div class="text-white font-extrabold text-base tracking-tight leading-none">
                Hiếu Trần Laptop US
              </div>
              <p class="text-xs text-stage-muted mt-1">Chuyên máy nhập Mỹ nguyên bản</p>
            </div>
          </div>

          <p class="text-xs text-stage-muted leading-relaxed">
            Chuyên cung cấp laptop doanh nhân và đồ họa xách tay Mỹ nguyên bản: ThinkPad, Dell XPS, HP EliteBook, MacBook LL/A. Cam kết mainboard zin 100%, bảo hành 12 đến 24 tháng.
          </p>

          <div class="flex flex-wrap items-center gap-3 pt-1">
            <a
              href="https://zalo.me/0778333362"
              target="_blank"
              class="px-3 py-1.5 rounded bg-stage-surface text-sky-400 text-xs font-semibold hover:bg-stage-lift transition-colors"
            >
              Zalo: 0778.3333.62
            </a>
            <a
              href="https://www.facebook.com/p/Hi%E1%BA%BFu-Tr%E1%BA%A7n-Laptop-US-61585268909952/"
              target="_blank"
              class="px-3 py-1.5 rounded bg-stage-surface text-stage-ink text-xs font-semibold hover:bg-stage-lift transition-colors"
            >
              Fanpage Facebook
            </a>
          </div>
        </div>

        <!-- Col 2: Categories (3 cols) -->
        <div class="md:col-span-3 space-y-3">
          <h4 class="text-white font-bold text-xs">Dòng máy xách tay</h4>
          <ul class="space-y-2 text-xs text-stage-muted">
            <li><router-link to="/products?brand=Lenovo" class="hover:text-white transition-colors">ThinkPad X1 Carbon và T-Series</router-link></li>
            <li><router-link to="/products?brand=Dell" class="hover:text-white transition-colors">Dell XPS và Precision</router-link></li>
            <li><router-link to="/products?brand=Dell" class="hover:text-white transition-colors">Dell Latitude doanh nhân</router-link></li>
            <li><router-link to="/products?brand=HP" class="hover:text-white transition-colors">HP EliteBook mỏng nhẹ</router-link></li>
            <li><router-link to="/products?brand=Apple" class="hover:text-white transition-colors">MacBook Pro và Air LL/A</router-link></li>
          </ul>
        </div>

        <!-- Col 3: Quality Commitments (3 cols) -->
        <div class="md:col-span-3 space-y-3">
          <h4 class="text-white font-bold text-xs">Cam kết chất lượng</h4>
          <ul class="space-y-2 text-xs text-stage-muted">
            <li class="text-stage-ink">Máy nguyên bản zin 100% từ Mỹ</li>
            <li class="text-stage-ink">Bảo hành 12 đến 24 tháng chu đáo</li>
            <li class="text-stage-ink">Đổi mới trong 15 ngày nếu có lỗi</li>
            <li class="text-stage-ink">Gửi video test máy chi tiết qua Zalo</li>
            <li class="text-stage-ink">Kiểm tra máy trước khi thanh toán COD</li>
          </ul>
        </div>

        <!-- Col 4: Contact & Hotline (2 cols) -->
        <div class="md:col-span-2 space-y-3">
          <h4 class="text-white font-bold text-xs">Liên hệ trực tiếp</h4>
          <div class="space-y-2 text-xs text-stage-muted">
            <p>Hotline: <strong class="text-white">0778.3333.62</strong></p>
            <p>Zalo: <strong class="text-sky-400">0778.3333.62</strong></p>
            <p>Địa chỉ: Hà Nội và giao toàn quốc</p>
          </div>
        </div>
      </div>

      <!-- Large Monumental Wordmark Close -->
      <div class="pt-8 space-y-4">
        <div class="w-full overflow-hidden text-center select-none">
          <div class="text-[clamp(2.5rem,7vw,7rem)] font-black text-stage-surface tracking-tighter uppercase leading-none whitespace-nowrap">
            Hiếu Trần Laptop US
          </div>
        </div>

        <div class="flex flex-col sm:flex-row items-center justify-between text-xs text-stage-muted pt-4">
          <p>© 2026 Hiếu Trần Laptop US. Chuyên laptop nhập Mỹ chính hãng tại Việt Nam.</p>
          <p>Bản quyền thuộc về cửa hàng Hiếu Trần.</p>
        </div>
      </div>
    </div>
  </footer>
</template>
