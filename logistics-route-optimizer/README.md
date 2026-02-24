# 🚚 Logistics Route Optimization Planner

**Author:** Mousumi Paul  
**Date:** January 2026  

A data-driven route planning tool that integrates **Google Maps API + MySQL** to evaluate and rank delivery paths across 3 distribution zones. The system achieved an **18% reduction in simulated last-mile logistics costs** through route consolidation and load-balancing, and a **25% reduction in simulated procurement risk** via a weighted vendor scorecard.

---

## 📁 Project Structure

```
logistics-route-optimizer/
│
├── README.md
├── requirements.txt
├── .env.example
├── .gitignore
│
├── config/
│   └── config.py                  # API keys, DB config loader
│
├── sql/
│   ├── schema.sql                 # Database schema
│   ├── seed_data.sql              # Sample delivery data
│   └── queries/
│       ├── route_ranking.sql      # Route evaluation queries
│       ├── zone_analysis.sql      # Distribution zone breakdown
│       └── load_balancing.sql     # Load balancing logic
│
├── scripts/
│   ├── route_optimizer.py         # Core route optimization logic
│   ├── maps_api.py                # Google Maps API integration
│   ├── db_connector.py            # MySQL connection handler
│   └── cost_calculator.py         # Last-mile cost calculation
│
├── vendor_scorecard/
│   ├── vendor_scorecard.py        # Vendor scoring logic
│   ├── scorecard_template.xlsx    # Excel scorecard template (open in Excel/Sheets)
│   └── sample_output/
│       └── vendor_report_sample.csv
│
├── data/
│   └── sample/
│       ├── delivery_orders.csv    # Sample delivery orders
│       ├── distribution_zones.csv # Zone definitions
│       └── vendor_data.csv        # Vendor performance data
│
└── docs/
    ├── architecture.md            # System design overview
    └── results_summary.md         # Simulation results & findings
```

---

## 🚀 Features

### Route Optimization
- Integrates with **Google Maps Distance Matrix API** to fetch real-time distances and travel times
- Ranks delivery routes across **3 distribution zones** by cost efficiency
- Applies **route consolidation** (grouping nearby stops) to reduce total distance
- Implements **load-balancing** to distribute deliveries evenly across vehicles/zones

### Vendor Scorecard System
- Evaluates **10+ suppliers** across 3 KPIs: on-time delivery, cost efficiency, compliance
- Generates a **weighted ranking report** from configurable weights
- Outputs results to Excel/CSV for reporting

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| Python 3.x | Core scripting |
| MySQL | Route & delivery data storage |
| Google Maps API | Distance Matrix, route data |
| Excel / Google Sheets | Vendor scorecard & reporting |
| pandas | Data processing |

---

## ⚙️ Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/mousumi-paul/logistics-route-optimizer.git
cd logistics-route-optimizer
```

### 2. Install Python dependencies
```bash
pip install -r requirements.txt
```

### 3. Configure environment variables
```bash
cp .env.example .env
# Edit .env and add your Google Maps API key and MySQL credentials
```

### 4. Set up the MySQL database
```bash
mysql -u your_user -p < sql/schema.sql
mysql -u your_user -p logistics_db < sql/seed_data.sql
```

### 5. Run the route optimizer
```bash
python scripts/route_optimizer.py
```

### 6. Run the vendor scorecard
```bash
python vendor_scorecard/vendor_scorecard.py
```

---

## 📊 Key Results (Simulated)

| Metric | Baseline | Optimized | Improvement |
|--------|----------|-----------|-------------|
| Last-mile delivery cost | $10,000 | $8,200 | **-18%** |
| Procurement risk exposure | 100% | 75% | **-25%** |
| Avg. route distance (per zone) | 142 km | 118 km | -17% |
| Vendor compliance score avg | 71% | 89% | +18 pts |

---

## 📄 License

This project is for portfolio and educational purposes.  
© 2026 Mousumi Paul
