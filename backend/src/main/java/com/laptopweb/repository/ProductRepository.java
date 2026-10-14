package com.laptopweb.repository;

import com.laptopweb.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {
    Optional<Product> findBySlug(String slug);
    Boolean existsBySlug(String slug);

    @Query("SELECT p FROM Product p WHERE " +
           "(:keyword IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(p.brand) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
           "(:brand IS NULL OR LOWER(p.brand) = LOWER(:brand)) AND " +
           "(:categoryId IS NULL OR p.category.id = :categoryId) AND " +
           "(:minPrice IS NULL OR COALESCE(p.salePrice, p.price) >= :minPrice) AND " +
           "(:maxPrice IS NULL OR COALESCE(p.salePrice, p.price) <= :maxPrice) AND " +
           "(:ram IS NULL OR LOWER(p.specs) LIKE LOWER(CONCAT('%', :ram, '%'))) AND " +
           "(:cpu IS NULL OR LOWER(p.specs) LIKE LOWER(CONCAT('%', :cpu, '%')))")
    Page<Product> searchProducts(@Param("keyword") String keyword,
                                 @Param("brand") String brand,
                                 @Param("categoryId") Long categoryId,
                                 @Param("minPrice") BigDecimal minPrice,
                                 @Param("maxPrice") BigDecimal maxPrice,
                                 @Param("ram") String ram,
                                 @Param("cpu") String cpu,
                                 Pageable pageable);

    List<Product> findTop4ByCategoryIdAndIdNot(Long categoryId, Long id);
}
