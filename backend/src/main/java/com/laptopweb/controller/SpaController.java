package com.laptopweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SpaController {

    @GetMapping(value = {
            "/",
            "/products",
            "/products/**",
            "/cart",
            "/orders",
            "/login",
            "/register",
            "/admin",
            "/admin/**"
    })
    public String forwardSpa() {
        return "forward:/index.html";
    }
}
