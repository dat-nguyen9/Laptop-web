package com.laptopweb.controller;

import com.laptopweb.entity.Product;
import com.laptopweb.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductRepository productRepository;

    @GetMapping
    public ResponseEntity<Page<Product>> getProducts(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String brand,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) String ram,
            @RequestParam(required = false) String cpu,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(defaultValue = "id,desc") String[] sort
    ) {
        String sortField = sort[0];
        Sort.Direction sortDirection = sort.length > 1 && sort[1].equalsIgnoreCase("asc") ?
                Sort.Direction.ASC : Sort.Direction.DESC;

        // Xử lý sort theo giá
        if ("price".equalsIgnoreCase(sortField)) {
            sortField = "price";
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by(sortDirection, sortField));

        Page<Product> productPage = productRepository.searchProducts(
                keyword != null && !keyword.trim().isEmpty() ? keyword.trim() : null,
                brand != null && !brand.trim().isEmpty() ? brand.trim() : null,
                categoryId,
                minPrice,
                maxPrice,
                ram != null && !ram.trim().isEmpty() ? ram.trim() : null,
                cpu != null && !cpu.trim().isEmpty() ? cpu.trim() : null,
                pageable
        );

        return ResponseEntity.ok(productPage);
    }

    @GetMapping("/{slug}")
    public ResponseEntity<Product> getProductBySlug(@PathVariable String slug) {
        Optional<Product> product = productRepository.findBySlug(slug);
        return product.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/id/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Optional<Product> product = productRepository.findById(id);
        return product.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/related")
    public ResponseEntity<List<Product>> getRelatedProducts(@PathVariable Long id) {
        Optional<Product> product = productRepository.findById(id);
        if (product.isEmpty() || product.get().getCategory() == null) {
            return ResponseEntity.ok(Collections.emptyList());
        }
        List<Product> related = productRepository.findTop4ByCategoryIdAndIdNot(
                product.get().getCategory().getId(), id
        );
        return ResponseEntity.ok(related);
    }
}
