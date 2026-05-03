package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main entry point for the Spring Boot Demo Application.
 * This application demonstrates integration with Prometheus monitoring via Micrometer.
 */
@SpringBootApplication
public class DemoApplication {

	/**
	 * Starts the Spring Boot application.
	 * @param args command line arguments
	 */
	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

}
