package com.example;

import java.util.List;
import java.util.ArrayList;

public class Calculator {
    private int result;
    
    public Calculator() {
        this.result = 0;
    }
    
    public int add(int a, int b) {
        return a + b;
    }
    
    public int subtract(int a, int b) {
        return a - b;
    }
    
    public int multiply(int a, int b) {
        return a * b;
    }
    
    public int divide(int a, int b) {
        if (b == 0) {
            throw new IllegalArgumentException("Division by zero");
        }
        return a / b;
    }
    
    public int getResult() {
        return this.result;
    }
    
    public void setResult(int result) {
        this.result = result;
    }
    
    public static void main(String[] args) {
        Calculator calc = new Calculator();
        System.out.println("Calculator created");
        
        int sum = calc.add(5, 3);
        System.out.println("5 + 3 = " + sum);
        
        int diff = calc.subtract(10, 4);
        System.out.println("10 - 4 = " + diff);
    }
}
