"""
maps_api.py
-----------
Google Maps API integration for fetching distances and travel durations.
Author: Mousumi Paul | Jan 2026
"""

import googlemaps
import os
import sys
from datetime import datetime

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from config.config import GOOGLE_MAPS_API_KEY


def get_gmaps_client():
    """Initialize and return a Google Maps client."""
    if not GOOGLE_MAPS_API_KEY:
        raise ValueError("[MAPS] GOOGLE_MAPS_API_KEY not set in .env")
    return googlemaps.Client(key=GOOGLE_MAPS_API_KEY)


def get_distance_matrix(origins: list, destinations: list, mode: str = "driving") -> dict:
    """
    Fetch distance matrix between multiple origins and destinations.

    Args:
        origins      : List of (lat, lng) tuples or address strings
        destinations : List of (lat, lng) tuples or address strings
        mode         : Travel mode ('driving', 'walking', 'bicycling', 'transit')

    Returns:
        dict with distances (km) and durations (min) between each origin-destination pair
    """
    gmaps = get_gmaps_client()
    result = gmaps.distance_matrix(
        origins=origins,
        destinations=destinations,
        mode=mode,
        units="metric",
        departure_time=datetime.now()
    )

    matrix = []
    for i, row in enumerate(result["rows"]):
        for j, element in enumerate(row["elements"]):
            if element["status"] == "OK":
                matrix.append({
                    "origin_index":       i,
                    "destination_index":  j,
                    "distance_km":        round(element["distance"]["value"] / 1000, 2),
                    "duration_min":       round(element["duration"]["value"] / 60, 1),
                    "distance_text":      element["distance"]["text"],
                    "duration_text":      element["duration"]["text"],
                })
            else:
                matrix.append({
                    "origin_index":      i,
                    "destination_index": j,
                    "error": element["status"]
                })
    return matrix


def get_route_details(origin: tuple, destination: tuple, waypoints: list = None) -> dict:
    """
    Get a detailed route between an origin and destination.

    Args:
        origin      : (lat, lng) tuple
        destination : (lat, lng) tuple
        waypoints   : Optional list of (lat, lng) intermediate stops

    Returns:
        dict with total distance, duration, and step-by-step legs
    """
    gmaps = get_gmaps_client()

    directions = gmaps.directions(
        origin=origin,
        destination=destination,
        waypoints=waypoints or [],
        optimize_waypoints=True,
        mode="driving",
        units="metric"
    )

    if not directions:
        return {"error": "No route found"}

    route = directions[0]
    legs = route["legs"]

    total_distance_km = sum(leg["distance"]["value"] for leg in legs) / 1000
    total_duration_min = sum(leg["duration"]["value"] for leg in legs) / 60

    return {
        "total_distance_km":  round(total_distance_km, 2),
        "total_duration_min": round(total_duration_min, 1),
        "waypoint_order":     route.get("waypoint_order", []),
        "legs":               [
            {
                "start": leg["start_address"],
                "end":   leg["end_address"],
                "distance_km":  round(leg["distance"]["value"] / 1000, 2),
                "duration_min": round(leg["duration"]["value"] / 60, 1),
            }
            for leg in legs
        ],
    }


if __name__ == "__main__":
    # Demo: distance between Chicago and Indianapolis
    result = get_distance_matrix(
        origins=[(41.8781, -87.6298)],
        destinations=[(39.7684, -86.1581)]
    )
    print("[MAPS TEST]", result)
