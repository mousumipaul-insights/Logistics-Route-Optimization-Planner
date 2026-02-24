# 🚚 Logistics Route Optimization Planner

> **A data-driven logistics tool that integrates Google Maps API + MySQL to evaluate and rank delivery routes, cutting simulated last-mile costs by 18% and reducing procurement risk by 25%.**

**Author:** Mousumi Paul &nbsp;|&nbsp; **Built:** January 2026

[![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python&logoColor=white)](https://python.org)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?logo=mysql&logoColor=white)](https://mysql.com)
[![Google Maps API](https://img.shields.io/badge/Google%20Maps-API-green?logo=googlemaps&logoColor=white)](https://developers.google.com/maps)
[![Excel](https://img.shields.io/badge/Excel-Reporting-brightgreen?logo=microsoftexcel&logoColor=white)](https://microsoft.com/excel)

---

## 📌 Project Overview

This tool solves two real-world supply chain challenges:

1. **Route Optimization** — Ranks delivery paths across 3 distribution zones (Chicago, Indianapolis, Louisville) by cost, using Google Maps Distance Matrix data stored and queried via MySQL. Applies route consolidation and load-balancing logic to minimize last-mile delivery cost.

2. **Vendor Scorecard** — Evaluates 10+ suppliers on 3 weighted KPIs (on-time delivery, cost efficiency, compliance) and generates a ranked procurement risk report exportable to Excel and CSV.

---

## 📊 Key Results (Simulated)

| Metric | Baseline | Optimized | Delta |
|---|---|---|---|
| Last-mile delivery cost | $1,040.30 | $845.10 | **−18%** |
| Procurement risk exposure | 100% | 75% | **−25%** |
| Avg. route distance per zone | 142 km | 118 km | −17% |
| Vendor compliance score avg | 71% | 89% | +18 pts |

---

## 🗂️ Project Structure

```
logistics-route-optimizer/
│
├── README.md
├── requirements.txt
├── .env.example
├── .gitignore
│
├── config/
│   └── config.py               # API keys, DB config, scoring weights
│
├── sql/
│   ├── schema.sql              # Full MySQL schema (6 tables)
│   ├── seed_data.sql           # 15 delivery orders + 10 vendors
│   └── queries/
│       ├── route_ranking.sql   # Rank routes by cost per zone
│       ├── zone_analysis.sql   # Cost concentration by distribution zone
│       └── load_balancing.sql  # Detect over/underloaded routes
│
├── scripts/
│   ├── route_optimizer.py      # Main orchestration — run this
│   ├── maps_api.py             # Google Maps Distance Matrix integration
│   ├── db_connector.py         # MySQL query handler
│   └── cost_calculator.py      # Consolidation + load-balance cost logic
│
├── vendor_scorecard/
│   ├── vendor_scorecard.py     # Weighted KPI scoring → CSV + Excel export
│   └── sample_output/          # Generated reports land here
│
├── data/sample/
│   ├── delivery_orders.csv
│   ├── distribution_zones.csv
│   └── vendor_data.csv
│
└── docs/
    ├── architecture.md         # System design + logic flow
    └── results_summary.md      # Full simulation results
```

---

## ⚙️ Setup & Installation

### 1. Clone the repository
```bash
git clone https://github.com/mousumi-paul/logistics-route-optimizer.git
cd logistics-route-optimizer
```

### 2. Install dependencies
```bash
pip install -r requirements.txt
```

### 3. Configure environment variables
```bash
cp .env.example .env
```
Open `.env` and fill in:
```
GOOGLE_MAPS_API_KEY=your_key_here
DB_HOST=localhost
DB_USER=your_user
DB_PASSWORD=your_password
DB_NAME=logistics_db
```

### 4. Set up the MySQL database
```bash
mysql -u your_user -p < sql/schema.sql
mysql -u your_user -p logistics_db < sql/seed_data.sql
```

### 5. Run route optimization
```bash
python scripts/route_optimizer.py
```

### 6. Run vendor scorecard
```bash
python vendor_scorecard/vendor_scorecard.py
```

> 💡 **No API key?** The optimizer includes a simulation mode using pre-built distance data — it runs fully offline for demo and testing purposes.

---

## 🔧 How It Works

### Route Optimization Pipeline

```
MySQL (delivery orders)
        ↓
Group orders into vehicle routes  (greedy, respects 1000 kg max load)
        ↓
Google Maps Distance Matrix API   (fetch distances + durations)
        ↓
Cost Calculator
  • Base cost:              distance_km × $0.85/km
  • Consolidation discount: −12% for multi-stop routes
  • Load-balance bonus:     −6% for 60–90% vehicle utilization
        ↓
Rank routes by final cost (per zone)
        ↓
Results stored → MySQL + printed to console
```

### Vendor Scoring Formula

```
Weighted Score =
    (0.40 × normalized on-time delivery %) +
    (0.35 × normalized cost efficiency, inverted) +
    (0.25 × normalized compliance score)

Risk Category:
    Score ≥ 75  →  LOW
    Score 55–74 →  MEDIUM
    Score < 55  →  HIGH
```

Weights are fully configurable in `config/config.py`.

---

## 🗄️ Database Schema

| Table | Description |
|---|---|
| `distribution_zones` | Zone IDs, names, and coordinates |
| `delivery_orders` | Customer orders with lat/lng, load, and priority |
| `routes` | Computed routes with distance, duration, and cost |
| `route_orders` | Many-to-many mapping of orders to routes |
| `vendors` | Supplier KPI data |
| `vendor_scorecard` | Weighted scores, risk categories, and rankings |

---

## 📤 Outputs

| Output | Location | Format |
|---|---|---|
| Route ranking table | Console | Tabular |
| Vendor scorecard | `vendor_scorecard/sample_output/` | `.xlsx` + `.csv` |
| Zone cost summary | Console | Tabular |

---

## 🛠️ Tech Stack

| Technology | Role |
|---|---|
| Python 3.10+ | Core scripting and orchestration |
| MySQL 8.0 | Delivery and route data storage |
| Google Maps API | Distance Matrix + Directions |
| pandas | Data processing and normalization |
| openpyxl | Excel report generation |
| Excel / Google Sheets | Vendor scorecard template and reporting |

---

## 📄 License

This project is for portfolio and educational purposes.  
© 2026 Mousumi Paul
