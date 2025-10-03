package com.example.demo;

public class ControlFlowDemo {
    
    public static void demonstrateIfElse(int number) {
        if (number > 0) {
            System.out.println("Number is positive");
        } else if (number < 0) {
            System.out.println("Number is negative");
        } else {
            System.out.println("Number is zero");
        }
    }
    
    public static void demonstrateForLoop(int limit) {
        System.out.println("Counting from 1 to " + limit + ":");
        for (int i = 1; i <= limit; i++) {
            System.out.println("Count: " + i);
        }
    }
    
    public static void demonstrateWhileLoop(int start, int end) {
        System.out.println("While loop from " + start + " to " + end + ":");
        int current = start;
        while (current <= end) {
            System.out.println("Current: " + current);
            current++;
        }
    }
    
    public static void demonstrateSwitch(int day) {
        String dayName;
        switch (day) {
            case 1:
                dayName = "Monday";
                break;
            case 2:
                dayName = "Tuesday";
                break;
            case 3:
                dayName = "Wednesday";
                break;
            case 4:
                dayName = "Thursday";
                break;
            case 5:
                dayName = "Friday";
                break;
            case 6:
                dayName = "Saturday";
                break;
            case 7:
                dayName = "Sunday";
                break;
            default:
                dayName = "Invalid day";
                break;
        }
        System.out.println("Day " + day + " is " + dayName);
    }
    
    public static void main(String[] args) {
        demonstrateIfElse(5);
        demonstrateIfElse(-3);
        demonstrateIfElse(0);
        
        demonstrateForLoop(5);
        
        demonstrateWhileLoop(1, 3);
        
        demonstrateSwitch(3);
        demonstrateSwitch(8);
    }
}
