package com.example.demo.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Unit tests for {@link HelloController}.
 * This class uses {@link WebMvcTest} to perform sliced testing of the web layer,
 * ensuring that the controller correctly handles HTTP requests and returns the expected JSON response.
 */
@WebMvcTest(HelloController.class)
public class HelloControllerTest {

    @Autowired
    private MockMvc mockMvc;

    /**
     * Verifies that the /api/hello endpoint returns a 200 OK status
     * and the expected greeting message in JSON format.
     * 
     * @throws Exception if any error occurs during the request execution.
     */
    @Test
    public void hello_ShouldReturnDefaultMessage() throws Exception {
        this.mockMvc.perform(get("/api/hello"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("Hello from Observability Platform!"))
                .andExpect(jsonPath("$.status").value("UP"));
    }
}
