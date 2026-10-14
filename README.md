# 💻 HIẾU TRẦN LAPTOP US - WEBSITE THƯƠNG MẠI ĐIỆN TỬ BÁN LAPTOP XÁCH TAY MỸ

Hệ thống website thương mại điện tử chuyên cung cấp **laptop nhập Mỹ chuẩn zin tuyển chọn** (ThinkPad, Dell XPS, Dell Precision, Dell Latitude, MacBook Pro/Air, HP EliteBook). Kiến trúc Fullstack hiện đại tách biệt **Spring Boot 3 + Vue.js 3 + MySQL 8**, áp dụng chuẩn giao diện cao cấp **Design Taste Frontend (anti-slop, 0 emoji, 0 gradients, 0 rest shadows)** và tích hợp luồng chốt đơn **Zalo 1 chạm kèm mã QR Code quét nhanh**.

---

## 📌 THÔNG TIN CỬA HÀNG & LIÊN HỆ

- **Tên shop**: Hiếu Trần Laptop US
- **Định vị**: Chuyên laptop xách tay Mỹ nguyên bản, hỗ trợ video test thực tế qua Zalo trước khi giao máy, bảo hành 12 - 24 tháng, bao test 15 ngày 1 đổi 1, ship COD đồng kiểm mở hộp toàn quốc.
- **Hotline & Zalo chủ shop**: **`0778.3333.62`**
- **Link Zalo chat**: [https://zalo.me/0778333362](https://zalo.me/0778333362)
- **Fanpage Facebook**: [Hiếu Trần Laptop US](https://www.facebook.com/p/Hi%E1%BA%BFu-Tr%E1%BA%A7n-Laptop-US-61585268909952/)

---

## 🛠️ TECH STACK TOÀN DIỆN

### Backend
- **Ngôn ngữ & Framework**: Java 21 LTS + Spring Boot 3.2.5
- **Bảo mật**: Spring Security 6 + JSON Web Token (JWT `io.jsonwebtoken 0.11.5`)
- **Dữ liệu**: Spring Data JPA + Hibernate ORM (tự động migration bảng và index)
- **Cơ sở dữ liệu**: MySQL 8.x
- **Build tool**: Apache Maven 3.9.6
- **Xử lý file**: Lưu trữ ảnh tải lên local tại `./uploads` và ánh xạ static resource handler `http://localhost:8080/uploads/**`

### Frontend
- **Framework**: Vue.js 3 (Composition API với `<script setup>`)
- **Build Tool**: Vite 5
- **Styling**: Tailwind CSS + Custom Design System (`@/assets/main.css`)
- **State Management**: Pinia (Auth Store, Cart Store đồng bộ `localStorage`, Toast Notification Store)
- **Routing**: Vue Router 4 (Navigation Guards kiểm tra Role `ROLE_ADMIN`, bảo vệ route khách, 404 catch-all)
- **HTTP Client**: Axios (Request interceptor đính kèm JWT Bearer token, Response interceptor xử lý 401/403)
- **Chuẩn thẩm mỹ**: `design-taste-frontend` (tasteskill v2) - Đạt chuẩn **0 FAIL, 0 WARN**:
  - 0 emoji trong giao diện
  - 0 CSS gradients rẻ tiền
  - 0 rest box-shadows mờ ảo
  - 0 hairlines (phân tầng bề mặt bằng tone bước `#141517` ground, `#1E2024` surface, `#282B31` lift, `#D72626` accent)
  - Typography: `Schibsted Grotesk` chuẩn phong cách editorial hiện đại

---

## 🗂️ CẤU TRÚC DỰ ÁN

```text
LaptopWeb/
├── backend/
│   ├── src/main/java/com/laptopweb/
│   │   ├── config/
│   │   │   ├── DataInitializer.java        # Khởi tạo Admin, Khách hàng & 12 laptop mẫu
│   │   │   └── WebMvcConfig.java           # Cấu hình Static Resource Handler /uploads/**
│   │   ├── controller/
│   │   │   ├── AdminController.java        # CRUD laptop, upload ảnh, quản lý danh mục, đơn hàng
│   │   │   ├── AuthController.java         # Đăng ký & Đăng nhập (JWT)
│   │   │   ├── CategoryController.java     # Lấy danh mục sản phẩm
│   │   │   ├── OrderController.java        # Đặt hàng, Zalo message generator, tra cứu đơn
│   │   │   └── ProductController.java      # Danh sách, bộ lọc đa chiều, tìm kiếm, chi tiết
│   │   ├── dto/                            # DTOs: Auth, OrderRequest, Product, MessageResponse
│   │   ├── entity/                         # JPA Entities: User, Product, Category, Order, OrderItem
│   │   ├── repository/                     # JPA Repositories
│   │   ├── security/                       # JWT AuthTokenFilter, JwtUtils, WebSecurityConfig
│   │   └── LaptopWebApplication.java
│   ├── src/main/resources/
│   │   └── application.properties          # Cấu hình DB, JWT, seller Zalo, upload dir
│   ├── uploads/                            # Thư mục lưu trữ hình ảnh tải lên từ Admin
│   └── pom.xml
│
├── frontend/
│   ├── src/
│   │   ├── api/
│   │   │   ├── admin.js                    # Gọi API quản trị (CRUD sản phẩm, danh mục, upload)
│   │   │   ├── auth.js                     # Login, Register
│   │   │   ├── axios.js                    # Axios instance + Interceptors
│   │   │   ├── orders.js                   # Đặt hàng, tra cứu đơn bằng SĐT
│   │   │   └── products.js                 # Lọc laptop, tìm kiếm, chi tiết
│   │   ├── components/
│   │   │   ├── Navbar.vue                  # Header responsive + Menu mobile + Tra cứu nhanh
│   │   │   ├── Footer.vue                  # Chân trang cam kết, hotline Zalo, fanpage
│   │   │   ├── ProductCard.vue             # Card laptop chuẩn tone-step US
│   │   │   ├── ProductSkeleton.vue         # Skeleton loading trạng thái tải dữ liệu
│   │   │   ├── QuickViewModal.vue          # Xem nhanh thông số máy
│   │   │   ├── ToastNotification.vue       # Thông báo toast phản hồi người dùng
│   │   │   └── FloatingContact.vue         # Nút Zalo + Hotline nổi góc màn hình
│   │   ├── stores/                         # Pinia stores: auth.js, cart.js, toast.js
│   │   ├── router/index.js                 # Navigation guard Admin, public routes, 404
│   │   ├── views/
│   │   │   ├── HomeView.vue                # Trang chủ: Hero banner, thương hiệu, cam kết, máy hot
│   │   │   ├── ProductListView.vue         # Danh sách laptop, filter đa chiều, phân trang
│   │   │   ├── ProductDetailView.vue       # Chi tiết máy, bảng specs, phóng to ảnh, cam kết
│   │   │   ├── CartView.vue                # Giỏ hàng, form ship COD, popup Zalo + QR Code
│   │   │   ├── OrdersView.vue              # Lịch sử đơn của tôi & Tra cứu công khai bằng SĐT
│   │   │   ├── LoginView.vue               # Đăng nhập (có nút 1-click điền tài khoản mẫu)
│   │   │   ├── RegisterView.vue            # Đăng ký tài khoản khách hàng
│   │   │   ├── NotFoundView.vue            # Trang 404 chống cụt đường dẫn
│   │   │   └── admin/
│   │   │       └── DashboardView.vue       # Bảng điều khiển quản trị 4 tab toàn diện
│   │   └── main.js
│   ├── package.json
│   ├── vite.config.js
│   └── tailwind.config.js
│
├── plan.txt                                # Lộ trình 6 tuần (Phase 1 -> Phase 5)
└── README.md                               # Hướng dẫn chi tiết chạy dự án
```

---

## ⚙️ HƯỚNG DẪN KHỞI CHẠY DỰ ÁN LOCAL

### 1. Chuẩn Bị Cơ Sở Dữ Liệu MySQL
1. Mở MySQL Service (qua XAMPP, Laragon hoặc MySQL Community Server trên cổng `3306`).
2. Kiểm tra thông tin kết nối trong file [backend/src/main/resources/application.properties](file:///C:/project/LaptopWeb/backend/src/main/resources/application.properties):
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/laptopweb?createDatabaseIfNotExist=true&useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Ho_Chi_Minh
   spring.datasource.username=root
   spring.datasource.password=123456   # <-- Thay đổi nếu mật khẩu MySQL của bạn khác
   ```
   *(Cơ sở dữ liệu `laptopweb` và toàn bộ các bảng sẽ tự động được tạo khi khởi động).*

### 2. Khởi Động Backend (Spring Boot)
Mở cửa sổ Command Prompt / PowerShell tại thư mục `backend`:
```powershell
cd C:\project\LaptopWeb\backend
..\apache-maven-3.9.6\bin\mvn.cmd spring-boot:run
```
- **Backend API chạy tại**: [http://localhost:8080](http://localhost:8080)
- **Khởi tạo dữ liệu tự động**: `DataInitializer` sẽ tự động tạo tài khoản Admin, Khách hàng mẫu và 12 sản phẩm laptop Mỹ tuyển chọn nếu database trống.

### 3. Khởi Động Frontend (Vue 3 + Vite)
Mở một cửa sổ Terminal khác tại thư mục `frontend`:
```powershell
cd C:\project\LaptopWeb\frontend
npm install
npm run dev
```
- **Frontend chạy tại**: [http://localhost:5173](http://localhost:5173)

---

## 🔑 TÀI KHOẢN MẪU ĐỂ TEST HỆ THỐNG

| Vai trò | Email | Mật khẩu | Quyền hạn & Chức năng |
|---|---|---|---|
| **Quản trị viên (Admin)** | `admin@laptopweb.com` | `admin123` | Truy cập `/admin`, xem doanh thu, CRUD kho laptop, upload ảnh, quản lý danh mục, cập nhật trạng thái đơn hàng |
| **Khách hàng thân thiết** | `customer@laptopweb.com` | `123456` | Mua sắm, quản lý giỏ hàng, xem tab Đơn hàng của tôi (`/orders`) |
| **Khách vãng lai (Guest)** | Không cần đăng nhập | Không cần | Tự do xem máy, đặt hàng COD, tra cứu đơn công khai bằng Số điện thoại + Mã đơn |

*(Tại màn hình Đăng nhập `/login`, hệ thống có sẵn 2 nút 1-click để tự động điền thông tin Admin hoặc Khách hàng).*

---

## 📦 QUY TRÌNH ĐẶT HÀNG & CHỐT ĐƠN QUA ZALO

```
Khách chọn máy -> Thêm vào giỏ hàng -> Điền tên, SĐT 10 số, địa chỉ nhận
                                  ↓
Backend tính giá server-side, trừ tồn kho tự động, lưu đơn PENDING
                                  ↓
Hiển thị Popup Thành Công với 3 lựa chọn chốt đơn:
  1. Quét mã QR Code Zalo trực tiếp trên điện thoại
  2. Bấm nút "Mở Zalo ngay" (tự động điền đầy đủ cấu hình máy, COD, ghi chú)
  3. Bấm "Sao chép tin nhắn" để gửi cho shop nếu dùng Zalo PC
                                  ↓
Admin vào /admin -> Tab "Quản lý đơn hàng" -> Xem chi tiết máy khách chọn
                                  ↓
Bấm nút "Chat Zalo với khách" để gửi video test máy -> Chuyển trạng thái:
CONFIRMED -> SHIPPING -> DELIVERED (hoặc CANCELLED)
```

---

## 🧪 KIỂM THỬ HỆ THỐNG (TESTING & VERIFICATION)

### 1. Kiểm tra Linter Thẩm Mỹ Anti-Slop
```powershell
node .agents/skills/taste-skill/scripts/lint.mjs frontend/src
```
- Kết quả: **`RESULT: 0 FAIL, 0 WARN`** (Toàn bộ 29 file Vue/JS tuân thủ nghiêm ngặt quy chuẩn).

### 2. Kiểm tra Build Production
```powershell
cd frontend
npm run build
```
- Kết quả: **`✓ built in ~4.5s`** không có bất kỳ cảnh báo hay lỗi cú pháp nào.

### 3. Chạy Kịch Bản Test Tự Động End-To-End (E2E)
Tại thư mục gốc, chạy script kiểm thử luồng nghiệp vụ:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Admin\.gemini\antigravity\brain\e58a87d8-20a8-4eb8-bbb1-55b1e61e8208\scratch\test_e2e.ps1"
```
Kịch bản tự động thực thi 10 bước:
1. Đăng ký tài khoản khách mới
2. Đăng nhập JWT nhận diện `ROLE_CUSTOMER`
3. Lấy kho máy và kiểm tra số lượng tồn
4. Đặt hàng xác thực và sinh link Zalo chi tiết
5. Kiểm tra tự động trừ kho sản phẩm
6. Kiểm tra xem lịch sử đơn hàng cá nhân
7. Kiểm tra tra cứu đơn công khai bằng Số điện thoại + Mã đơn
8. Admin đăng nhập cập nhật trạng thái đơn thành `CONFIRMED`
9. Admin cập nhật trạng thái đơn thành `SHIPPING`
10. Kiểm tra báo cáo thống kê doanh thu và đơn hàng tại Dashboard Admin

---

## 📄 BẢN QUYỀN & GHI CHÚ
- Dự án được phát triển riêng cho thương hiệu **Hiếu Trần Laptop US**.
- Toàn bộ sản phẩm mẫu, danh mục, hình ảnh và cấu hình mô phỏng chân thực các dòng laptop xách tay Mỹ nguyên bản đang được kinh doanh trên thị trường Việt Nam.
