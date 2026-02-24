-- ============================================================
-- seed_data.sql
-- Sample data for Logistics Route Optimization Planner
-- Author: Mousumi Paul | Jan 2026
-- ============================================================

USE logistics_db;

-- Distribution Zones
INSERT INTO distribution_zones (zone_id, zone_name, city, state, base_lat, base_lng) VALUES
('ZONE_A', 'North Distribution Zone', 'Chicago',     'IL', 41.8781, -87.6298),
('ZONE_B', 'Central Distribution Zone', 'Indianapolis', 'IN', 39.7684, -86.1581),
('ZONE_C', 'South Distribution Zone', 'Louisville',  'KY', 38.2527, -85.7585);

-- Delivery Orders (sample - 15 orders across 3 zones)
INSERT INTO delivery_orders (zone_id, customer_name, delivery_address, dest_lat, dest_lng, load_kg, priority, delivery_date) VALUES
('ZONE_A', 'Acme Corp',         '123 N Michigan Ave, Chicago, IL',        41.8858, -87.6237, 120.50, 'HIGH',   '2026-01-15'),
('ZONE_A', 'TechParts Inc',     '456 W Wacker Dr, Chicago, IL',           41.8868, -87.6386, 85.00,  'MEDIUM', '2026-01-15'),
('ZONE_A', 'BlueStar Retail',   '789 N Clark St, Chicago, IL',            41.9019, -87.6310, 200.00, 'HIGH',   '2026-01-15'),
('ZONE_A', 'Greenfield Co',     '321 S State St, Chicago, IL',            41.8757, -87.6280, 60.00,  'LOW',    '2026-01-16'),
('ZONE_A', 'Lakeside Goods',    '654 E Randolph St, Chicago, IL',         41.8851, -87.6205, 145.75, 'MEDIUM', '2026-01-16'),
('ZONE_B', 'Midwest Supply',    '100 Monument Circle, Indianapolis, IN',  39.7686, -86.1581, 300.00, 'HIGH',   '2026-01-15'),
('ZONE_B', 'Hoosier Hardware',  '250 S Meridian St, Indianapolis, IN',    39.7612, -86.1570, 175.50, 'MEDIUM', '2026-01-15'),
('ZONE_B', 'Central Packers',   '400 N Pennsylvania St, Indianapolis, IN',39.7726, -86.1558, 90.00,  'LOW',    '2026-01-16'),
('ZONE_B', 'IndianaFresh',      '500 Mass Ave, Indianapolis, IN',         39.7747, -86.1461, 210.00, 'HIGH',   '2026-01-16'),
('ZONE_B', 'Eagle Logistics',   '750 Virginia Ave, Indianapolis, IN',     39.7559, -86.1418, 130.00, 'MEDIUM', '2026-01-17'),
('ZONE_C', 'Derby Distributors','500 W Main St, Louisville, KY',          38.2575, -85.7680, 180.00, 'HIGH',   '2026-01-15'),
('ZONE_C', 'SouthEnd Traders',  '200 S 4th St, Louisville, KY',           38.2490, -85.7541, 95.00,  'MEDIUM', '2026-01-15'),
('ZONE_C', 'Bluegrass Parts',   '1000 E Broadway, Louisville, KY',        38.2535, -85.7360, 250.00, 'HIGH',   '2026-01-16'),
('ZONE_C', 'Riverbend Retail',  '300 W Jefferson St, Louisville, KY',     38.2524, -85.7607, 70.00,  'LOW',    '2026-01-16'),
('ZONE_C', 'Cardinal Goods',    '800 Barret Ave, Louisville, KY',         38.2436, -85.7285, 155.00, 'MEDIUM', '2026-01-17');

-- Vendors (10 suppliers)
INSERT INTO vendors (vendor_name, contact_email, on_time_delivery_pct, avg_cost_per_unit, compliance_score, total_deliveries) VALUES
('SwiftTrans LLC',        'contact@swifttrans.com',    94.5, 12.50, 91.0, 850),
('RegionHaul Co',         'ops@regionhaul.com',        87.2, 10.80, 78.0, 620),
('MidWest Freight',       'info@mwfreight.com',        91.0, 13.20, 85.0, 740),
('FastLane Delivery',     'hello@fastlane.com',        78.5, 9.90,  70.0, 510),
('PrimeRoute Inc',        'prime@primeroute.com',      96.0, 14.00, 95.0, 1020),
('CentralLink Logistics', 'cl@centrallink.com',        82.3, 11.40, 74.0, 430),
('NorthStar Carriers',    'ns@northstar.com',          89.7, 12.80, 88.0, 680),
('QuickDrop Solutions',   'qd@quickdrop.com',          73.1, 8.75,  62.0, 390),
('BlueLine Freight',      'bl@bluelinefreight.com',    93.2, 13.50, 90.0, 810),
('TerraFreight Partners', 'tf@terrafreight.com',       85.6, 11.10, 80.0, 570);
