package org.opsathlan.spring_advanced_echo.configuration;

import io.micrometer.core.instrument.Gauge;
import io.micrometer.prometheusmetrics.PrometheusConfig;
import io.micrometer.prometheusmetrics.PrometheusMeterRegistry;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;

@Configuration
public class MetricsConfiguration {
    @Bean
    public PrometheusMeterRegistry prometheusMeterRegistry() {
        return new PrometheusMeterRegistry(PrometheusConfig.DEFAULT);
    }

    @Bean
    public Gauge createThreadCountGauge(PrometheusMeterRegistry prometheusMeterRegistry) {
        ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();

        return Gauge.builder("jvm.threads.live.gauge", threadMXBean, ThreadMXBean::getThreadCount)
                .description("The number of live threads in the JVM")
                .register(prometheusMeterRegistry);
    }
}
