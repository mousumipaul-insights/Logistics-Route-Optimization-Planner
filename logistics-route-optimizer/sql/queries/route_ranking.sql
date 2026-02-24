-- ============================================================
-- route_ranking.sql
-- Ranks all routes by estimated cost (ascending)
-- Author: Mousumi Paul | Jan 2026
-- ============================================================

USE logistics_db;

-- Rank routes by total estimated cost within each zone
SELECT
    r.route_id,
    r.zone_id,
    dz.zone_name,
    r.route_name,
    r.total_distance_km,
    r.total_duration_min,
    r.total_load_kg,
    r.estimated_cost,
    r.is_consolidated,
    RANK() OVER (PARTITION BY r.zone_id ORDER BY r.estimated_cost ASC) AS cost_rank,
    RANK() OVER (PARTITION BY r.zone_id ORDER BY r.total_distance_km ASC) AS distance_rank
FROM routes r
JOIN distribution_zones dz ON r.zone_id = dz.zone_id
ORDER BY r.zone_id, cost_rank;


-- Summary: average cost per zone, consolidated vs non-consolidated
SELECT
    r.zone_id,
    dz.zone_name,
    r.is_consolidated,
    COUNT(*) AS route_count,
    ROUND(AVG(r.estimated_cost), 2) AS avg_cost,
    ROUND(AVG(r.total_distance_km), 2) AS avg_distance_km,
    ROUND(SUM(r.estimated_cost), 2) AS total_cost
FROM routes r
JOIN distribution_zones dz ON r.zone_id = dz.zone_id
GROUP BY r.zone_id, dz.zone_name, r.is_consolidated
ORDER BY r.zone_id, r.is_consolidated;
