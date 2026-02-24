-- ============================================================
-- schema.sql
-- Logistics Route Optimization Planner - Database Schema
-- Author: Mousumi Paul | Jan 2026
-- ============================================================

CREATE DATABASE IF NOT EXISTS logistics_db;
USE logistics_db;

-- -----------------------------------------------
-- Distribution Zones
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS distribution_zones (
    zone_id       VARCHAR(10)  PRIMARY KEY,
    zone_name     VARCHAR(100) NOT NULL,
    city          VARCHAR(100),
    state         VARCHAR(50),
    base_lat      DECIMAL(9,6),
    base_lng      DECIMAL(9,6),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- Delivery Orders
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS delivery_orders (
    order_id        INT AUTO_INCREMENT PRIMARY KEY,
    zone_id         VARCHAR(10),
    customer_name   VARCHAR(100),
    delivery_address TEXT,
    dest_lat        DECIMAL(9,6),
    dest_lng        DECIMAL(9,6),
    load_kg         DECIMAL(6,2),
    priority        ENUM('LOW','MEDIUM','HIGH') DEFAULT 'MEDIUM',
    delivery_date   DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES distribution_zones(zone_id)
);

-- -----------------------------------------------
-- Routes
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS routes (
    route_id        INT AUTO_INCREMENT PRIMARY KEY,
    zone_id         VARCHAR(10),
    route_name      VARCHAR(100),
    total_distance_km DECIMAL(8,2),
    total_duration_min INT,
    total_load_kg   DECIMAL(8,2),
    estimated_cost  DECIMAL(10,2),
    is_consolidated BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (zone_id) REFERENCES distribution_zones(zone_id)
);

-- -----------------------------------------------
-- Route-Order Mapping
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS route_orders (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    route_id    INT,
    order_id    INT,
    stop_sequence INT,
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (order_id) REFERENCES delivery_orders(order_id)
);

-- -----------------------------------------------
-- Vendors
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS vendors (
    vendor_id           INT AUTO_INCREMENT PRIMARY KEY,
    vendor_name         VARCHAR(100) NOT NULL,
    contact_email       VARCHAR(100),
    on_time_delivery_pct DECIMAL(5,2),  -- % of deliveries on time
    avg_cost_per_unit   DECIMAL(8,2),   -- average cost per delivery unit
    compliance_score    DECIMAL(5,2),   -- score out of 100
    total_deliveries    INT DEFAULT 0,
    active              BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- Vendor Scorecard Results
-- -----------------------------------------------
CREATE TABLE IF NOT EXISTS vendor_scorecard (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id       INT,
    report_date     DATE,
    weighted_score  DECIMAL(5,2),
    risk_category   ENUM('LOW','MEDIUM','HIGH'),
    rank            INT,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);
