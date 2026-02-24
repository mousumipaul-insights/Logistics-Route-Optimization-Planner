"""
cost_calculator.py
------------------
Calculates last-mile logistics costs for routes.
Applies consolidation savings and load-balancing adjustments.
Author: Mousumi Paul | Jan 2026
"""

import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from config.config import COST_PER_KM, MAX_LOAD_KG


# Consolidation discount applied when multiple stops are merged into one route
CONSOLIDATION_DISCOUNT = 0.12   # 12% savings from combining stops
# Load-balance bonus: if load is between 60-90% of max, apply efficiency bonus
LOAD_EFFICIENCY_BONUS  = 0.06   # 6% savings for optimal load usage


def calculate_base_cost(distance_km: float) -> float:
    """
    Calculate base delivery cost from distance.

    Args:
        distance_km : Total route distance in kilometers

    Returns:
        Base cost in USD
    """
    return round(distance_km * COST_PER_KM, 2)


def apply_consolidation_discount(base_cost: float, num_stops: int) -> float:
    """
    Apply a consolidation discount when multiple stops are grouped.
    
    Discount applies only when 2+ stops are consolidated on one route.

    Args:
        base_cost : Base route cost
        num_stops : Number of delivery stops on this route

    Returns:
        Adjusted cost after consolidation discount
    """
    if num_stops >= 2:
        return round(base_cost * (1 - CONSOLIDATION_DISCOUNT), 2)
    return base_cost


def apply_load_balance_bonus(cost: float, total_load_kg: float) -> float:
    """
    Apply efficiency bonus for optimally loaded vehicles.
    
    A vehicle running at 60–90% capacity gets a cost efficiency bonus,
    representing fuel and operational savings from not running near-empty or overloaded.

    Args:
        cost          : Current route cost
        total_load_kg : Total load for this route in kg

    Returns:
        Adjusted cost after load-balance bonus
    """
    load_pct = total_load_kg / MAX_LOAD_KG
    if 0.60 <= load_pct <= 0.90:
        return round(cost * (1 - LOAD_EFFICIENCY_BONUS), 2)
    return cost


def calculate_route_cost(
    distance_km: float,
    num_stops: int,
    total_load_kg: float,
    is_consolidated: bool = False
) -> dict:
    """
    Full cost calculation pipeline for a single route.

    Args:
        distance_km     : Total route distance
        num_stops       : Number of delivery stops
        total_load_kg   : Total cargo weight
        is_consolidated : Whether route uses stop consolidation

    Returns:
        dict with cost breakdown
    """
    base_cost = calculate_base_cost(distance_km)
    after_consolidation = apply_consolidation_discount(base_cost, num_stops) if is_consolidated else base_cost
    final_cost = apply_load_balance_bonus(after_consolidation, total_load_kg)

    savings = round(base_cost - final_cost, 2)
    savings_pct = round((savings / base_cost) * 100, 1) if base_cost > 0 else 0

    return {
        "base_cost_usd":          base_cost,
        "after_consolidation_usd": after_consolidation,
        "final_cost_usd":         final_cost,
        "total_savings_usd":      savings,
        "savings_pct":            savings_pct,
        "distance_km":            distance_km,
        "num_stops":              num_stops,
        "total_load_kg":          total_load_kg,
        "load_utilization_pct":   round((total_load_kg / MAX_LOAD_KG) * 100, 1),
    }


def summarize_zone_savings(routes: list) -> dict:
    """
    Summarize total cost and savings across all routes in a zone.

    Args:
        routes : List of route cost dicts (output of calculate_route_cost)

    Returns:
        Summary dict with totals and average savings %
    """
    total_base    = sum(r["base_cost_usd"]  for r in routes)
    total_final   = sum(r["final_cost_usd"] for r in routes)
    total_savings = round(total_base - total_final, 2)
    avg_savings_pct = round((total_savings / total_base) * 100, 1) if total_base > 0 else 0

    return {
        "num_routes":           len(routes),
        "total_base_cost_usd":  round(total_base, 2),
        "total_final_cost_usd": round(total_final, 2),
        "total_savings_usd":    total_savings,
        "avg_savings_pct":      avg_savings_pct,
    }


if __name__ == "__main__":
    # Example: 3-stop consolidated route, 118 km, 750 kg load
    result = calculate_route_cost(
        distance_km=118,
        num_stops=3,
        total_load_kg=750,
        is_consolidated=True
    )
    print("[COST CALC] Route cost breakdown:")
    for k, v in result.items():
        print(f"  {k}: {v}")
