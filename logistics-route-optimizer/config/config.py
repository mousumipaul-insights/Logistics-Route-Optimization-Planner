"""
config.py
---------
Loads environment variables for API keys and database configuration.
"""

import os
from dotenv import load_dotenv

load_dotenv()

# Google Maps API
GOOGLE_MAPS_API_KEY = os.getenv("GOOGLE_MAPS_API_KEY")

# MySQL Configuration
DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", 3306)),
    "database": os.getenv("DB_NAME", "logistics_db"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
}

# Distribution Zone IDs
ZONES = {
    "ZONE_A": "North Distribution Zone",
    "ZONE_B": "Central Distribution Zone",
    "ZONE_C": "South Distribution Zone",
}

# Cost per km (USD) - adjustable
COST_PER_KM = 0.85

# Vehicle max load (kg)
MAX_LOAD_KG = 1000

# Vendor scorecard weights (must sum to 1.0)
VENDOR_WEIGHTS = {
    "on_time_delivery": 0.40,
    "cost_efficiency":  0.35,
    "compliance":       0.25,
}
