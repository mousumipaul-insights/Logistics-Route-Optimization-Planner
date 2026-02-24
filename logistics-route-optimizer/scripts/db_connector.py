"""
db_connector.py
---------------
Handles MySQL connection and query execution for the Logistics Route Optimizer.
Author: Mousumi Paul | Jan 2026
"""

import mysql.connector
from mysql.connector import Error
import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from config.config import DB_CONFIG


def get_connection():
    """Create and return a MySQL database connection."""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        if conn.is_connected():
            print(f"[DB] Connected to MySQL database: {DB_CONFIG['database']}")
            return conn
    except Error as e:
        print(f"[DB ERROR] Could not connect to MySQL: {e}")
        return None


def execute_query(query: str, params: tuple = None, fetch: bool = True):
    """
    Execute a SQL query.
    
    Args:
        query  : SQL query string
        params : Optional tuple of parameters for parameterized queries
        fetch  : If True, returns rows; if False, commits and returns row count
    
    Returns:
        list of dicts (fetch=True) or int rows affected (fetch=False)
    """
    conn = get_connection()
    if not conn:
        return None

    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query, params or ())

        if fetch:
            results = cursor.fetchall()
            return results
        else:
            conn.commit()
            return cursor.rowcount

    except Error as e:
        print(f"[QUERY ERROR] {e}")
        return None

    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()


def execute_script(filepath: str):
    """Execute a .sql file against the database."""
    with open(filepath, "r") as f:
        sql_script = f.read()

    conn = get_connection()
    if not conn:
        return

    try:
        cursor = conn.cursor()
        for statement in sql_script.split(";"):
            stmt = statement.strip()
            if stmt:
                cursor.execute(stmt)
        conn.commit()
        print(f"[DB] Script executed: {filepath}")
    except Error as e:
        print(f"[SCRIPT ERROR] {e}")
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()


if __name__ == "__main__":
    # Quick connection test
    conn = get_connection()
    if conn:
        print("[DB] Connection test passed.")
        conn.close()
