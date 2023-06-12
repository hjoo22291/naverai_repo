package com.example.ai;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

import objectdetection.ObjectDetectionController;

@SpringBootApplication
@ComponentScan
@ComponentScan(basePackages = "cfr")
@ComponentScan(basePackages = "objectdetection")
//@ComponentScan(basePackageClasses = ObjectDetectionController.class) // 클래스로도 가능
//@ComponentScan(basePackages = {"cfr", "objectdetection"}) //배열로 한줄 나열도 가능
@ComponentScan(basePackages = "pose")
@ComponentScan(basePackages = "stt_csr")
@ComponentScan(basePackages = "tts_voice")
@ComponentScan(basePackages = "mymapping")
@ComponentScan(basePackages = "ocr")
@ComponentScan(basePackages = "chatbot")
public class NaveraiBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(NaveraiBootApplication.class, args);
	}

}
