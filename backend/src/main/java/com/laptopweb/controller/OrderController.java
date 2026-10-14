package com.laptopweb.controller;

import com.laptopweb.dto.MessageResponse;
import com.laptopweb.dto.OrderRequest;
import com.laptopweb.entity.*;
import com.laptopweb.repository.OrderRepository;
import com.laptopweb.repository.ProductRepository;
import com.laptopweb.repository.UserRepository;
import com.laptopweb.security.UserDetailsImpl;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;

    @Value("${app.seller.zalo-phone:0988888888}")
    private String sellerZaloPhone;

    @PostMapping
    @Transactional
    public ResponseEntity<?> createOrder(@Valid @RequestBody OrderRequest request) {
        User currentUser = null;
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            UserDetailsImpl userDetails = (UserDetailsImpl) auth.getPrincipal();
            currentUser = userRepository.findById(userDetails.getId()).orElse(null);
        }

        BigDecimal calculatedTotal = BigDecimal.ZERO;
        List<OrderItem> items = new ArrayList<>();

        Order order = Order.builder()
                .user(currentUser)
                .fullName(request.getFullName())
                .phone(request.getPhone())
                .address(request.getAddress())
                .note(request.getNote())
                .status(OrderStatus.PENDING)
                .total(BigDecimal.ZERO)
                .build();

        for (OrderRequest.OrderItemDto itemDto : request.getItems()) {
            Product product = productRepository.findById(itemDto.getProductId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm id: " + itemDto.getProductId()));

            BigDecimal unitPrice = product.getSalePrice() != null ? product.getSalePrice() : product.getPrice();
            BigDecimal lineTotal = unitPrice.multiply(BigDecimal.valueOf(itemDto.getQuantity()));
            calculatedTotal = calculatedTotal.add(lineTotal);

            // Trừ số lượng tồn kho
            int currentStock = product.getStock() != null ? product.getStock() : 0;
            product.setStock(Math.max(0, currentStock - itemDto.getQuantity()));
            productRepository.save(product);

            OrderItem orderItem = OrderItem.builder()
                    .order(order)
                    .product(product)
                    .quantity(itemDto.getQuantity())
                    .price(unitPrice)
                    .build();

            items.add(orderItem);
        }

        order.setTotal(calculatedTotal);
        order.setItems(items);

        Order savedOrder = orderRepository.save(order);

        // Chuẩn bị nội dung chi tiết đơn hàng gửi qua Zalo người bán
        StringBuilder sb = new StringBuilder();
        sb.append(String.format("[ĐƠN HÀNG #%d - HIẾU TRẦN LAPTOP US]\n", savedOrder.getId()));
        sb.append(String.format("• Khách hàng: %s\n", savedOrder.getFullName()));
        sb.append(String.format("• Số điện thoại: %s\n", savedOrder.getPhone()));
        sb.append(String.format("• Địa chỉ nhận: %s\n", savedOrder.getAddress()));
        sb.append("• Sản phẩm đã chọn:\n");
        for (OrderItem oi : items) {
            sb.append(String.format("   - %dx %s (%,.0f đ)\n",
                    oi.getQuantity(),
                    oi.getProduct().getName(),
                    oi.getPrice().doubleValue()));
        }
        sb.append(String.format("• Tổng thanh toán: %,.0f đ (Ship COD đồng kiểm)\n", savedOrder.getTotal().doubleValue()));
        if (savedOrder.getNote() != null && !savedOrder.getNote().trim().isEmpty()) {
            sb.append(String.format("• Ghi chú: %s\n", savedOrder.getNote().trim()));
        }
        sb.append("👉 Shop kiểm tra máy, gửi video test thực tế và xác nhận đơn giúp mình nhé!");

        String message = sb.toString();
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8);
        String zaloUrl = "https://zalo.me/" + sellerZaloPhone + "?text=" + encodedMessage;

        Map<String, Object> response = new HashMap<>();
        response.put("orderId", savedOrder.getId());
        response.put("total", savedOrder.getTotal());
        response.put("status", savedOrder.getStatus());
        response.put("zaloUrl", zaloUrl);
        response.put("orderMessage", message);
        response.put("sellerPhone", sellerZaloPhone);
        response.put("customerName", savedOrder.getFullName());
        response.put("phone", savedOrder.getPhone());
        response.put("message", "Đặt hàng thành công! Vui lòng liên hệ Zalo để shop gửi video test máy.");

        return ResponseEntity.ok(response);
    }

    @GetMapping("/my")
    public ResponseEntity<?> getMyOrders() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || auth.getPrincipal().equals("anonymousUser")) {
            return ResponseEntity.status(401).body(new MessageResponse("Vui lòng đăng nhập để xem đơn hàng"));
        }

        UserDetailsImpl userDetails = (UserDetailsImpl) auth.getPrincipal();
        List<Order> orders = orderRepository.findByUserIdOrderByCreatedAtDesc(userDetails.getId());
        return ResponseEntity.ok(orders);
    }

    @GetMapping("/track")
    public ResponseEntity<?> trackOrders(
            @RequestParam(required = false) Long orderId,
            @RequestParam(required = false) String phone
    ) {
        if (orderId != null && phone != null && !phone.trim().isEmpty()) {
            return orderRepository.findByIdAndPhone(orderId, phone.trim())
                    .map(order -> ResponseEntity.ok(List.of(order)))
                    .orElse(ResponseEntity.ok(List.of()));
        }

        if (phone != null && !phone.trim().isEmpty()) {
            List<Order> orders = orderRepository.findByPhoneOrderByCreatedAtDesc(phone.trim());
            return ResponseEntity.ok(orders);
        }

        return ResponseEntity.badRequest().body(new MessageResponse("Vui lòng cung cấp số điện thoại hoặc mã đơn hàng để tra cứu!"));
    }
}
