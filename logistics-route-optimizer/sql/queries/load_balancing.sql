-- ============================================================
-- load_balancing.sql
-- Identifies overloaded routes and suggests rebalancing
-- Author: Mousumi Paul | Jan 2026
-- ============================================================

USE logistics_db;

-- Show routes exceeding 80% vehicle capacity (MAX_LOAD = 1000 kg)
SELECT
    r.route_id,
    r.zone_id,
    r.route_name,
    r.total_load_kg,
    ROUND((r.total_load_kg / 1000) * 100, 1) AS load_pct,
    CASE
        WHEN r.total_load_kg > 900 THEN 'OVERLOADED'
        WHEN r.total_load_kg > 700 THEN 'HIGH'
        WHEN r.total_load_kg > 400 THEN 'BALANCED'
        ELSE 'UNDERUTILIZED'
    END AS load_status
FROM routes r
ORDER BY r.total_load_kg DESC;


-- Load balance summary per zone: identify imbalance
SELECT
    r.zone_id,
    COUNT(*) AS num_routes,
    ROUND(AVG(r.total_load_kg), 2) AS avg_load_kg,
    MAX(r.total_load_kg)           AS max_load_kg,
    MIN(r.total_load_kg)           AS min_load_kg,
    ROUND(MAX(r.total_load_kg) - MIN(r.total_load_kg), 2) AS load_variance
FROM routes r
GROUP BY r.zone_id
ORDER BY load_variance DESC;


-- Orders that could be redistributed (HIGH priority, within load limit headroom)
SELECT
    do.order_id,
    do.zone_id,
    do.customer_name,
    do.load_kg,
    do.priority,
    ro.route_id AS current_route,
    r.total_load_kg AS current_route_load
FROM delivery_orders do
JOIN route_orders ro ON do.order_id = ro.order_id
JOIN routes r ON ro.route_id = r.route_id
WHERE r.total_load_kg > 700
  AND do.priority != 'HIGH'
ORDER BY r.total_load_kg DESC;
