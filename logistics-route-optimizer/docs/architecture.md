# System Architecture

**Project:** Logistics Route Optimization Planner  
**Author:** Mousumi Paul | Jan 2026

---

## Overview

The system follows a 3-layer pipeline:

```
[MySQL Database]  →  [Python Scripts]  →  [Excel / CSV Reports]
        ↑                   ↑
  Delivery Orders    Google Maps API
  Vendor Data        (Distance Matrix)
```

---

## Components

### 1. Data Layer (MySQL)
- Stores delivery orders, distribution zones, route results, and vendor records
- Schema defined in `sql/schema.sql`
- Sample data in `sql/seed_data.sql`

### 2. Processing Layer (Python)

| Script | Responsibility |
|--------|---------------|
| `db_connector.py` | MySQL connection and query execution |
| `maps_api.py` | Google Maps Distance Matrix + Directions API |
| `cost_calculator.py` | Base cost, consolidation discount, load-balance bonus |
| `route_optimizer.py` | End-to-end orchestration across 3 zones |
| `vendor_scorecard.py` | Weighted vendor KPI scoring + report export |

### 3. Reporting Layer (Excel / CSV)
- Vendor scorecard exported to `.xlsx` and `.csv`
- Route results printed to console with tabular formatting

---

## Route Optimization Logic

```
For each zone:
  1. Fetch orders from MySQL (sorted by priority + load)
  2. Group orders into vehicle routes (greedy, respects MAX_LOAD)
  3. Fetch distances via Google Maps Distance Matrix API
  4. Calculate base cost: distance_km × $0.85/km
  5. Apply consolidation discount (−12%) for multi-stop routes
  6. Apply load-balance bonus (−6%) for 60–90% load utilization
  7. Rank routes by final cost (ascending)
  8. Store results back to MySQL routes table
```

---

## Vendor Scoring Formula

```
Weighted Score = 
    (0.40 × normalized_on_time_delivery) +
    (0.35 × normalized_cost_efficiency_inverted) +
    (0.25 × normalized_compliance_score)

Risk Category:
    Score ≥ 75 → LOW risk
    Score 55–74 → MEDIUM risk
    Score < 55 → HIGH risk
```

---

## Key Design Decisions

- **Greedy route grouping** was chosen for simplicity; a TSP solver could improve results further
- **Min-max normalization** ensures fair comparison across KPIs with different units
- **Configurable weights** in `config.py` allow supply chain managers to adjust priorities
- **Simulation mode** in `route_optimizer.py` allows running without a live Maps API key
