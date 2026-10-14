package com.laptopweb.repository;

import com.laptopweb.entity.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<Order> findByPhoneOrderByCreatedAtDesc(String phone);
    Optional<Order> findByIdAndPhone(Long id, String phone);
    Page<Order> findAllByOrderByCreatedAtDesc(Pageable pageable);
}
