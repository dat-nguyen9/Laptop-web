package com.laptopweb.config;

import com.laptopweb.entity.Category;
import com.laptopweb.entity.Product;
import com.laptopweb.entity.Role;
import com.laptopweb.entity.User;
import com.laptopweb.repository.CategoryRepository;
import com.laptopweb.repository.ProductRepository;
import com.laptopweb.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.math.BigDecimal;

@Configuration
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);

    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        initUsers();
        initCategoriesAndProducts();
    }

    private void initUsers() {
        if (!userRepository.existsByEmail("admin@laptopweb.com")) {
            User admin = User.builder()
                    .email("admin@laptopweb.com")
                    .password(passwordEncoder.encode("admin123"))
                    .fullName("Hiếu Trần Laptop US (Admin)")
                    .phone("0778333362")
                    .address("Hà Nội")
                    .role(Role.ROLE_ADMIN)
                    .build();
            userRepository.save(admin);
            logger.info(">>> Khởi tạo tài khoản Admin: admin@laptopweb.com / admin123");
        }

        if (!userRepository.existsByEmail("customer@laptopweb.com")) {
            User customer = User.builder()
                    .email("customer@laptopweb.com")
                    .password(passwordEncoder.encode("123456"))
                    .fullName("Nguyễn Khách Hàng")
                    .phone("0912345678")
                    .address("Hà Nội")
                    .role(Role.ROLE_CUSTOMER)
                    .build();
            userRepository.save(customer);
            logger.info(">>> Khởi tạo tài khoản Khách hàng mẫu: customer@laptopweb.com / 123456");
        }
    }

    private void initCategoriesAndProducts() {
        // Chỉ khởi tạo dữ liệu mẫu nếu cơ sở dữ liệu chưa có sản phẩm
        if (productRepository.count() > 0) {
            logger.info(">>> Cơ sở dữ liệu đã có sản phẩm, bỏ qua bước khởi tạo mẫu.");
            return;
        }

        Category thinkpad = categoryRepository.save(Category.builder()
                .name("ThinkPad X1 & Doanh Nhân")
                .slug("thinkpad-x1-doanh-nhan")
                .description("Dòng laptop gõ phím số 1 thế giới, bền bỉ chuẩn quân đội nhập trực tiếp từ Mỹ")
                .build());

        Category dellXps = categoryRepository.save(Category.builder()
                .name("Dell XPS & Precision Mỹ")
                .slug("dell-xps-precision-my")
                .description("Thiết kế nhôm CNC, màn hình viền siêu mỏng và máy trạm đồ họa cao cấp")
                .build());

        Category dellLatitude = categoryRepository.save(Category.builder()
                .name("Dell Latitude Quốc Dân")
                .slug("dell-latitude-quoc-dan")
                .description("Laptop văn phòng chuẩn Mỹ siêu bền, hiệu năng ổn định mức giá học sinh sinh viên")
                .build());

        Category macbook = categoryRepository.save(Category.builder()
                .name("MacBook Chuẩn Mỹ (LL/A)")
                .slug("macbook-chuan-my-lla")
                .description("MacBook Pro & Air xuất xứ thị trường Mỹ (mã LL/A) nguyên zin tuyển chọn")
                .build());

        Category hpElite = categoryRepository.save(Category.builder()
                .name("HP EliteBook Doanh Nhân")
                .slug("hp-elitebook-doanh-nhan")
                .description("Vỏ nhôm bạc nguyên khối, mỏng nhẹ sang trọng, âm thanh Bang & Olufsen")
                .build());

        // 1. ThinkPad X1 Carbon Gen 10
        productRepository.save(Product.builder()
                .name("ThinkPad X1 Carbon Gen 10 (USA)")
                .slug("thinkpad-x1-carbon-gen-10-usa")
                .brand("Lenovo")
                .category(thinkpad)
                .price(new BigDecimal("24500000"))
                .salePrice(new BigDecimal("22900000"))
                .stock(10)
                .images("https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Intel Core i7-1260P\",\"ram\":\"16GB LPDDR5 5200MHz\",\"storage\":\"512GB PCIe 4.0 NVMe SSD\",\"gpu\":\"Intel Iris Xe Graphics\",\"screen\":\"14 inch 2.2K IPS Anti-Glare 300 nits 100% sRGB\",\"weight\":\"1.12 kg\",\"battery\":\"57Wh (Hỗ trợ sạc nhanh)\"}")
                .description("Dòng máy huyền thoại doanh nhân nhập Mỹ của Hiếu Trần Laptop US. Trọng lượng siêu nhẹ chỉ 1.12kg, bàn phím gõ êm ái hàng đầu, vỏ sợi Carbon cao cấp chuẩn độ bền quân đội Mỹ.")
                .build());

        // 2. ThinkPad X1 Carbon Gen 9
        productRepository.save(Product.builder()
                .name("ThinkPad X1 Carbon Gen 9 (USA)")
                .slug("thinkpad-x1-carbon-gen-9-usa")
                .brand("Lenovo")
                .category(thinkpad)
                .price(new BigDecimal("18500000"))
                .salePrice(new BigDecimal("16900000"))
                .stock(15)
                .images("https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Intel Core i7-1165G7\",\"ram\":\"16GB LPDDR4x\",\"storage\":\"512GB PCIe NVMe SSD\",\"gpu\":\"Intel Iris Xe Graphics\",\"screen\":\"14 inch FHD+ (1920x1200) IPS 16:10 400 nits\",\"weight\":\"1.13 kg\",\"battery\":\"57Wh\"}")
                .description("Mẫu ThinkPad bán chạy nhất tại shop: tỷ lệ màn hình 16:10 làm việc văn phòng cực kỳ rộng rãi, pin trâu và máy nguyên bản xách tay trực tiếp từ Mỹ.")
                .build());

        // 3. ThinkPad T14s Gen 3 AMD
        productRepository.save(Product.builder()
                .name("ThinkPad T14s Gen 3 (AMD Ryzen 7 PRO 6850U)")
                .slug("thinkpad-t14s-gen-3-ryzen-7-pro")
                .brand("Lenovo")
                .category(thinkpad)
                .price(new BigDecimal("21900000"))
                .salePrice(new BigDecimal("19990000"))
                .stock(12)
                .images("https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"AMD Ryzen 7 PRO 6850U 8 nhân 16 luồng\",\"ram\":\"16GB LPDDR5 6400MHz\",\"storage\":\"512GB PCIe Gen4 SSD\",\"gpu\":\"AMD Radeon 680M mạnh mẽ\",\"screen\":\"14 inch WUXGA IPS 16:10 Anti-Glare\",\"weight\":\"1.22 kg\",\"battery\":\"57Wh\"}")
                .description("Bản T14s mỏng nhẹ chạy chip AMD cực mát và tiết kiệm pin, card đồ họa tích hợp Radeon 680M xử lý Photoshop, AutoCAD và game mượt mà.")
                .build());

        // 4. Dell XPS 13 Plus 9320
        productRepository.save(Product.builder()
                .name("Dell XPS 13 Plus 9320 (OLED 3.5K Touch)")
                .slug("dell-xps-13-plus-9320-oled")
                .brand("Dell")
                .category(dellXps)
                .price(new BigDecimal("32500000"))
                .salePrice(new BigDecimal("29900000"))
                .stock(8)
                .images("https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Intel Core i7-1260P\",\"ram\":\"16GB LPDDR5 5200MHz\",\"storage\":\"512GB PCIe 4.0 SSD\",\"gpu\":\"Intel Iris Xe Graphics\",\"screen\":\"13.4 inch 3.5K (3456x2160) OLED Touch 100% DCI-P3\",\"weight\":\"1.24 kg\",\"battery\":\"55Wh\"}")
                .description("Tuyệt tác công nghệ đến từ Mỹ: Touchpad vô hình haptic phản hồi xúc giác, dải phím cảm ứng điện dung và màn hình OLED 3.5K rực rỡ.")
                .build());

        // 5. Dell XPS 15 9520 (RTX 3050Ti)
        productRepository.save(Product.builder()
                .name("Dell XPS 15 9520 (Core i7 12700H / RTX 3050Ti)")
                .slug("dell-xps-15-9520-rtx3050ti")
                .brand("Dell")
                .category(dellXps)
                .price(new BigDecimal("36900000"))
                .salePrice(new BigDecimal("34500000"))
                .stock(6)
                .images("https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Intel Core i7-12700H 14 nhân 20 luồng\",\"ram\":\"32GB DDR5 4800MHz\",\"storage\":\"1TB PCIe NVMe SSD\",\"gpu\":\"NVIDIA GeForce RTX 3050Ti 4GB\",\"screen\":\"15.6 inch 3.5K OLED InfinityEdge 400 nits\",\"weight\":\"1.92 kg\",\"battery\":\"86Wh\"}")
                .description("Cỗ máy làm đồ họa, dựng video chuyên nghiệp với màn hình tràn viền 4 cạnh, loa stereo 4 hướng âm thanh phòng thu studio.")
                .build());

        // 6. Dell Latitude 7420 Carbon
        productRepository.save(Product.builder()
                .name("Dell Latitude 7420 Carbon (USA)")
                .slug("dell-latitude-7420-carbon-usa")
                .brand("Dell")
                .category(dellLatitude)
                .price(new BigDecimal("13500000"))
                .salePrice(new BigDecimal("11900000"))
                .stock(20)
                .images("https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Intel Core i5-1145G7 vPro\",\"ram\":\"16GB LPDDR4x\",\"storage\":\"256GB PCIe NVMe SSD\",\"gpu\":\"Intel Iris Xe Graphics\",\"screen\":\"14 inch FHD IPS Anti-Glare 400 nits\",\"weight\":\"1.22 kg\",\"battery\":\"63Wh (Pin rất trâu)\"}")
                .description("Dòng laptop văn phòng nhập Mỹ 'quốc dân' tại Hiếu Trần Laptop US: giá siêu rẻ nhưng trang bị vỏ carbon sang trọng, pin 63Wh dùng thoải mái cả ngày.")
                .build());

        // 7. Dell Latitude 7430 Gen 12
        productRepository.save(Product.builder()
                .name("Dell Latitude 7430 (Intel Core i5 1245U)")
                .slug("dell-latitude-7430-gen12-usa")
                .brand("Dell")
                .category(dellLatitude)
                .price(new BigDecimal("17500000"))
                .salePrice(new BigDecimal("15800000"))
                .stock(14)
                .images("https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Intel Core i5-1245U vPro 10 nhân 12 luồng\",\"ram\":\"16GB DDR4\",\"storage\":\"512GB PCIe Gen4 NVMe\",\"gpu\":\"Intel Iris Xe Graphics\",\"screen\":\"14 inch FHD IPS chống chói 300 nits\",\"weight\":\"1.24 kg\",\"battery\":\"58Wh\"}")
                .description("Đời 2022 chip Gen 12 vượt trội về hiệu năng đa nhiệm, độ bền bỉ chuẩn quân đội Mỹ, máy đẹp 99% như mới.")
                .build());

        // 8. Dell Precision 5560
        productRepository.save(Product.builder()
                .name("Dell Precision 5560 (Máy trạm mỏng nhẹ đồ họa)")
                .slug("dell-precision-5560-nvidia-t1200")
                .brand("Dell")
                .category(dellXps)
                .price(new BigDecimal("29500000"))
                .salePrice(new BigDecimal("27500000"))
                .stock(7)
                .images("https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Intel Core i7-11850H 8 nhân 16 luồng\",\"ram\":\"32GB DDR4\",\"storage\":\"512GB NVMe SSD\",\"gpu\":\"NVIDIA T1200 4GB chuyên đồ họa\",\"screen\":\"15.6 inch FHD+ InfinityEdge 500 nits\",\"weight\":\"1.84 kg\",\"battery\":\"86Wh\"}")
                .description("Máy trạm di động mỏng nhẹ đẳng cấp mang ngoại hình XPS, trang bị card NVIDIA chuyên biệt tối ưu phần mềm kiến trúc, 3Ds Max, Revit.")
                .build());

        // 9. HP EliteBook 840 G9
        productRepository.save(Product.builder()
                .name("HP EliteBook 840 G9 (Nhôm nguyên khối - USA)")
                .slug("hp-elitebook-840-g9-usa")
                .brand("HP")
                .category(hpElite)
                .price(new BigDecimal("20500000"))
                .salePrice(new BigDecimal("18900000"))
                .stock(12)
                .images("https://images.unsplash.com/photo-1589578228447-e1a4e481c6c8?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Intel Core i7-1260P 12 nhân 16 luồng\",\"ram\":\"16GB DDR5 4800MHz (Nâng cấp được)\",\"storage\":\"512GB PCIe NVMe SSD\",\"gpu\":\"Intel Iris Xe Graphics\",\"screen\":\"14 inch WUXGA 16:10 IPS 400 nits 100% sRGB\",\"weight\":\"1.36 kg\",\"battery\":\"51Wh\"}")
                .description("Vỏ nhôm màu bạc cao cấp chuẩn doanh nhân, màn hình 16:10 sáng đẹp 400 nits, khả năng nâng cấp RAM linh hoạt.")
                .build());

        // 10. HP EliteBook 840 G8
        productRepository.save(Product.builder()
                .name("HP EliteBook 840 G8 (USA)")
                .slug("hp-elitebook-840-g8-usa")
                .brand("HP")
                .category(hpElite)
                .price(new BigDecimal("14200000"))
                .salePrice(new BigDecimal("12800000"))
                .stock(18)
                .images("https://images.unsplash.com/photo-1589578228447-e1a4e481c6c8?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Intel Core i5-1135G7\",\"ram\":\"16GB DDR4 3200MHz\",\"storage\":\"256GB NVMe SSD\",\"gpu\":\"Intel Iris Xe Graphics\",\"screen\":\"14 inch FHD IPS chống chói\",\"weight\":\"1.37 kg\",\"battery\":\"53Wh\"}")
                .description("Dòng máy bán chạy trong phân khúc 12-13 triệu tại Hiếu Trần Laptop US: bền bỉ, gõ phím êm, vỏ kim loại chắc chắn.")
                .build());

        // 11. MacBook Air M2 13.6" LL/A
        productRepository.save(Product.builder()
                .name("MacBook Air M2 13.6 inch (Bản Mỹ LL/A)")
                .slug("macbook-air-m2-13-6-inch-lla")
                .brand("Apple")
                .category(macbook)
                .price(new BigDecimal("24500000"))
                .salePrice(new BigDecimal("22900000"))
                .stock(15)
                .images("https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Apple M2 8-core CPU\",\"ram\":\"8GB Unified Memory\",\"storage\":\"256GB SSD\",\"gpu\":\"8-core GPU\",\"screen\":\"13.6 inch Liquid Retina True Tone\",\"weight\":\"1.24 kg\",\"battery\":\"Pin 18 Giờ liên tục\"}")
                .description("MacBook Air M2 chuẩn Mỹ mã LL/A, mỏng nhẹ chỉ 1.24kg, thời lượng pin 18 giờ dùng cả ngày không cần mang sạc.")
                .build());

        // 12. MacBook Pro 14 M3 Pro LL/A
        productRepository.save(Product.builder()
                .name("MacBook Pro 14 M3 Pro (18GB/512GB - LL/A)")
                .slug("macbook-pro-14-m3-pro-lla")
                .brand("Apple")
                .category(macbook)
                .price(new BigDecimal("48900000"))
                .salePrice(new BigDecimal("46500000"))
                .stock(5)
                .images("https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?auto=format&fit=crop&w=800&q=80")
                .specs("{\"cpu\":\"Apple M3 Pro 11-core CPU\",\"ram\":\"18GB Unified Memory\",\"storage\":\"512GB SSD Siêu Tốc\",\"gpu\":\"14-core GPU\",\"screen\":\"14.2 inch Liquid Retina XDR 120Hz ProMotion\",\"weight\":\"1.61 kg\",\"battery\":\"70Wh\"}")
                .description("Máy nhập Mỹ LL/A nguyên zin, màn hình Mini-LED 120Hz chuẩn màu đỉnh cao nhất thế giới cho dân đồ họa và quay dựng.")
                .build());

        logger.info(">>> Khởi tạo thành công 12 sản phẩm chuyên biệt của Hiếu Trần Laptop US!");
    }
}
