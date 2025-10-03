package com.example.model;

public class Person {
    private String name;
    private int age;
    private String email;
    
    public Person(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
    }
    
    public String getName() {
        return this.name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public int getAge() {
        return this.age;
    }
    
    public void setAge(int age) {
        if (age < 0) {
            throw new IllegalArgumentException("Age cannot be negative");
        }
        this.age = age;
    }
    
    public String getEmail() {
        return this.email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public boolean isAdult() {
        return this.age >= 18;
    }
    
    public String toString() {
        return "Person{name='" + this.name + "', age=" + this.age + ", email='" + this.email + "'}";
    }
    
    public static void main(String[] args) {
        Person person = new Person("John Doe", 25, "john@example.com");
        System.out.println(person.toString());
        System.out.println("Is adult: " + person.isAdult());
    }
}
