package org.opsathlan.spring_advanced_echo.controller;

import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.CompletableFuture;

@RestController
public class EchoController {

    @GetMapping("/echo")
    public CompletableFuture<String> echo() {
        return asyncTask();
    }

    @Async
    public CompletableFuture<String> asyncTask() {
        return CompletableFuture.supplyAsync(() -> {
            try {
                Thread.sleep(1000);  // 1초 동안 지연 (비동기 처리 예시)
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return "Async Hello, World!";
        });
    }
}