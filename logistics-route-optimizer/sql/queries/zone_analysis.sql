-- ============================================================
-- zone_analysis.sql
-- Breakdown of delivery demand and cost per distribution zone
-- Author: Mousumi Paul | Jan 2026
-- ============================================================

USE logistics_db;

-- Orders per zone with total load
SELECT
    dz.zone_id,
    dz.zone_name,
    COUNT(do.order_id)              AS total_orders,
    ROUND(SUM(do.load_kg), 2)       AS total_load_kg,
    ROUND(AVG(do.load_kg), 2)       AS avg_load_kg,
    SUM(CASE WHEN do.priority = 'HIGH'   THEN 1 ELSE 0 END) AS high_priority,
    SUM(CASE WHEN do.priority = 'MEDIUM' THEN 1 ELSE 0 END) AS medium_priority,
    SUM(CASE WHEN do.priority = 'LOW'    THEN 1 ELSE 0 END) AS low_priority
FROM distribution_zones dz
LEFT JOIN delivery_orders do ON dz.zone_id = do.zone_id
GROUP BY dz.zone_id, dz.zone_name
ORDER BY total_orders DESC;


-- Cost concentration: which zone has the highest logistics cost?
SELECT
    dz.zone_id,
    dz.zone_name,
    ROUND(SUM(r.estimated_cost), 2)                            AS total_zone_cost,
    ROUND(SUM(r.estimated_cost) / SUM(SUM(r.estimated_cost))
          OVER () * 100, 1)                                    AS pct_of_total_cost,
    ROUND(AVG(r.estimated_cost), 2)                            AS avg_route_cost
FROM routes r
JOIN distribution_zones dz ON r.zone_id = dz.zone_id
GROUP BY dz.zone_id, dz.zone_name
ORDER BY total_zone_cost DESC;
