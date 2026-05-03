package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import io.micrometer.core.annotation.Timed;
import java.util.HashMap;
import java.util.Map;

/**
 * REST Controller providing simple endpoints to demonstrate monitoring capabilities.
 * It uses Micrometer's @Timed annotation to capture execution metrics.
 */
@RestController
public class HelloController {

    /**
     * Returns a simple greeting and status message.
     * The execution time of this method is tracked by Prometheus under the 'hello.request' metric.
     * @return a Map containing a welcome message and the application status.
     */
    @GetMapping("/api/hello")
    @Timed(value = "hello.request", description = "Time taken to return hello")
    public Map<String, String> sayHello() {
        Map<String, String> response = new HashMap<>();
        response.put("message", "Hello from Observability Platform!");
        response.put("status", "UP");
        return response;
    }
}
