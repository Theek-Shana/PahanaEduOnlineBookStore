package com.bookshop.model;

import java.util.List;

public class ReportModel {

    private List<SalesReport> salesReports;
    private List<OrderSummary> orderSummaries;
    private List<TopSellingItem> topSellingItems;
    private List<StaffPerformance> staffPerformances;
    private List<UserOrderCount> userOrderCounts; // New field for user order counts

    // Getters and Setters

    public List<SalesReport> getSalesReports() {
        return salesReports;
    }
    public void setSalesReports(List<SalesReport> salesReports) {
        this.salesReports = salesReports;
    }

    public List<OrderSummary> getOrderSummaries() {
        return orderSummaries;
    }
    public void setOrderSummaries(List<OrderSummary> orderSummaries) {
        this.orderSummaries = orderSummaries;
    }

    public List<TopSellingItem> getTopSellingItems() {
        return topSellingItems;
    }
    public void setTopSellingItems(List<TopSellingItem> topSellingItems) {
        this.topSellingItems = topSellingItems;
    }

    public List<StaffPerformance> getStaffPerformances() {
        return staffPerformances;
    }
    public void setStaffPerformances(List<StaffPerformance> staffPerformances) {
        this.staffPerformances = staffPerformances;
    }

    public List<UserOrderCount> getUserOrderCounts() {
        return userOrderCounts;
    }
    public void setUserOrderCounts(List<UserOrderCount> userOrderCounts) {
        this.userOrderCounts = userOrderCounts;
    }

    // Inner classes or import the same separate classes for each report type:
    public static class SalesReport {
        private String period;
        private double totalSales;
        public SalesReport() {}
        public SalesReport(String period, double totalSales) {
            this.period = period; this.totalSales = totalSales;
        }
        public String getPeriod() { return period; }
        public void setPeriod(String period) { this.period = period; }
        public double getTotalSales() { return totalSales; }
        public void setTotalSales(double totalSales) { this.totalSales = totalSales; }
    }

    public static class OrderSummary {
        private String status;
        private int count;
        public OrderSummary() {}
        public OrderSummary(String status, int count) {
            this.status = status; this.count = count;
        }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public int getCount() { return count; }
        public void setCount(int count) { this.count = count; }
    }

    public static class TopSellingItem {
        private int itemId;
        private String title;
        private int totalQuantitySold;
        public TopSellingItem() {}
        public TopSellingItem(int itemId, String title, int totalQuantitySold) {
            this.itemId = itemId; this.title = title; this.totalQuantitySold = totalQuantitySold;
        }
        public int getItemId() { return itemId; }
        public void setItemId(int itemId) { this.itemId = itemId; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public int getTotalQuantitySold() { return totalQuantitySold; }
        public void setTotalQuantitySold(int totalQuantitySold) { this.totalQuantitySold = totalQuantitySold; }
    }

    public static class StaffPerformance {
        private int staffId;
        private String staffName;
        private int ordersHandled;
        public StaffPerformance() {}
        public StaffPerformance(int staffId, String staffName, int ordersHandled) {
            this.staffId = staffId; this.staffName = staffName; this.ordersHandled = ordersHandled;
        }
        public int getStaffId() { return staffId; }
        public void setStaffId(int staffId) { this.staffId = staffId; }
        public String getStaffName() { return staffName; }
        public void setStaffName(String staffName) { this.staffName = staffName; }
        public int getOrdersHandled() { return ordersHandled; }
        public void setOrdersHandled(int ordersHandled) { this.ordersHandled = ordersHandled; }
    }

    // New inner class for User Order Counts
    public static class UserOrderCount {
        private int userId;
        private String userName;
        private int totalOrders;
        private double totalSpent;
        
        public UserOrderCount() {}
        
        public UserOrderCount(int userId, String userName, int totalOrders, double totalSpent) {
            this.userId = userId;
            this.userName = userName;
            this.totalOrders = totalOrders;
            this.totalSpent = totalSpent;
        }
        
        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }
        
        public String getUserName() { return userName; }
        public void setUserName(String userName) { this.userName = userName; }
        
        public int getTotalOrders() { return totalOrders; }
        public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
        
        public double getTotalSpent() { return totalSpent; }
        public void setTotalSpent(double totalSpent) { this.totalSpent = totalSpent; }
    }
}