package com.laptopweb.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.PathResourceResolver;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Uploads static handler
        Path uploadDir = Paths.get("./uploads");
        String uploadPath = uploadDir.toFile().getAbsolutePath().replace("\\", "/");
        if (!uploadPath.endsWith("/")) {
            uploadPath += "/";
        }
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadPath);

        // Dist static handler if frontend/dist exists
        File distDir = new File("./frontend/dist");
        if (!distDir.exists()) {
            distDir = new File("./dist");
        }
        if (!distDir.exists()) {
            distDir = new File("../frontend/dist");
        }

        if (distDir.exists()) {
            String distPath = distDir.getAbsolutePath().replace("\\", "/");
            if (!distPath.endsWith("/")) {
                distPath += "/";
            }
            registry.addResourceHandler("/**")
                    .addResourceLocations("file:" + distPath);
        }

    }
}

