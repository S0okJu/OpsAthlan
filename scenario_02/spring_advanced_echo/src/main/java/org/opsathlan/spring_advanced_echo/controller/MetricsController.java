package org.opsathlan.spring_advanced_echo.controller;

import io.micrometer.prometheusmetrics.PrometheusMeterRegistry;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class MetricsController {

    private final PrometheusMeterRegistry prometheusMeterRegistry;

    // Custom /metrics endpoint for Prometheus to scrape
    @GetMapping("/metrics")
    public ResponseEntity<String> metrics() {
        String scrape = prometheusMeterRegistry.scrape();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.TEXT_PLAIN);

        return new ResponseEntity<>(scrape, headers, HttpStatus.OK);
    }
}