# Smart Irrigation Expert System 

A **Knowledge Representation & Reasoning (KRR)** project that implements a **Fuzzy Logic Control System** in Prolog. This system determines the optimal irrigation level for crops based on imprecise real-world sensor data (Soil Moisture, Temperature, and Humidity).

## Project Overview

Traditional algorithms require precise, binary inputs (True/False). However, agricultural conditions are often vague (e.g., "It is sort of hot" or "The soil is a bit dry").

This Expert System uses **Fuzzy Logic** principles to:
1.  **Fuzzify** crisp numerical inputs into linguistic categories (e.g., `35°C` → `Hot`).
2.  **Infer** decisions based on a Logic Rule Base.
3.  **Defuzzify** the result into a concrete recommendation (`Low`, `Medium`, or `High` irrigation).

## Features

* **Interactive CLI:** User-friendly command-line interface that prompts for sensor data.
* **Input Validation:** Recursive loops ensure users enter valid ranges (e.g., 0-100% for humidity).
* **Fuzzy Logic Engine:** Handles overlapping boundaries (e.g., a temperature can be both "Warm" and "Hot").
* **Explanation Facility:** The system outputs *why* a specific decision was made (e.g., "Critical: Soil is dry and evaporation rate is high").
* **Defensive Programming:** Handles edge cases like extreme negative temperatures.

## Prerequisites

* **SWI-Prolog** (Version 8.0 or higher recommended)
    * *Arch Linux:* `sudo pacman -S swi-prolog`
    * *Debian/Ubuntu/Kali:* `sudo apt install swi-prolog`
    * *Windows/Mac:* Download from [swi-prolog.org](https://www.swi-prolog.org/Download.html)

## Installation & Usage

1.  **Clone the repository** (or save the code):
    ```bash
    git clone https://github.com/Nathokip/Smart_irrigation.git
    cd Smart_irrigation
    ```

2.  **Run the System:**
    Open your terminal in the project folder and run:
    ```bash
    swipl irrigation.pl
    ```

3.  **Start the Program:**
    Once inside the Prolog shell (`?-`), type:
    ```prolog
    start.
    ```

4.  **Follow the Prompts:**
    Enter numbers followed by a period (`.`).
    
    *Example:*
    ```text
    Soil Moisture (0-100%): 20.
    Temperature (Celsius): 35.
    Humidity (0-100%): 15.
    ```

## System Logic (KRR Concepts)

The logic flow follows the standard Expert System architecture:

### 1. Fuzzification
Raw numbers are mapped to linguistic sets with overlaps:
* **Moisture:** `Dry`, `Moist`, `Wet`
* **Temperature:** `Cool`, `Warm`, `Hot`
* **Humidity:** `Low`, `Medium`, `High`

### 2. Knowledge Base (Rules)
The system uses `IF-THEN` rules with priorities.
* *Critical Rule:* IF `Dry` AND `Hot` THEN `High Water`.
* *Safety Rule:* IF `Wet` OR `High Humidity` THEN `Low Water`.

### 3. Inference Engine
Prolog's backtracking engine finds the first matching rule. The **Cut operator (`!`)** is used to ensure deterministic behavior (stopping at the first valid conclusion).

## File Structure

* `irrigation.pl` - The main source code containing the UI, Rules, and Logic.
* `README.md` - Documentation.

## Example Output

```text
--- SMART IRRIGATION SYSTEM ---
Please enter sensor data below (ends with a period).

Soil Moisture (0-100%): 10.
Temperature (Celsius -10 to 60): 32.
Humidity (0-100%): 20.

--- ANALYSIS ---
Fuzzified State: Moisture=dry, Temp=hot, Humidity=low

RECOMMENDED IRRIGATION: high
REASON: Critical: Soil is dry and evaporation rate is high.
--- END REPORT ---