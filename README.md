# TI 2026 — Forecast Desk (Phase A + daily Swiss workflow)

Real TI 2026 Swiss-stage schedule (32 matches, from Liquipedia): Rounds 1-3 completed
(24 results), Round 4 in progress (8 matches). Predictions for the OLD fixed bracket are
kept as legacy evidence but are NOT scored.

## Daily cycle
1. Send `DAILY-PREDICT-PROMPT.txt` (with the day's matches filled in, see
   `DAILY-PREDICT-R4-FILLED.txt`) + `TI2026-Complete-NEW.xlsx` to each AI.
2. Paste each AI's JSON output here → store in `site/public/data/daily-predictions.json`
   (matchdays[].models.<model>.predictions.<match_id>).
3. End of day: fetch real results (Liquipedia API or manual) → update
   `site/public/data/results.json` (status completed + winner + score).
4. Run `python backfill/score.py` → regenerates `model-scores.json`
   (winner accuracy + Brier, daily + cumulative).
5. Site shows it live: `#/today` tab + Live Accuracy chart on `#/overview`.

Multi-AI prediction comparison site. Static, hash-routed, EN/FA bilingual (RTL).

## Structure
```
site/
├── public/
│   ├── index.html            ← the app (single shell, hash routes)
│   ├── data/
│   │   ├── schedule.json     ← canonical 32-match bracket (source of truth)
│   │   └── forecast-desk.json ← normalized predictions of all 5 models
│   └── i18n/
│       ├── en.json
│       └── fa.json
├── start.bat / start.sh      ← local server launcher
└── README.md
```

## Routes
- `#/overview` — model cards + status
- `#/model/claude | gemini | gpt-5.6-sol | chatgpt | hermes` — per-model view
- `#/comparison` — side-by-side probabilities, consensus, champion & fantasy

## Run
```
cd site/public
python -m http.server 8901
```
then open http://localhost:8901  (double-click on the folder won't work — fetch() needs http).

## Data pipeline (rebuild after new predictions)
```
python backfill/build_schedule.py     # schedule.json from the workbook
python backfill/normalize_models.py   # forecast-desk.json from the 5 model outputs
```
Rules enforced by the normalizer:
- Schedule-owned team orientation; draws normalized to binary pA/(pA+pB) (source kept for audit)
- Any model fixture not in the canonical schedule is dropped + flagged (no invented matches)
- All published probabilities sum to 1; coverage must be 32/32

## Phase B (later)
Live results ingestion (manual-first, then OpenDota), Brier/log-loss + fantasy scoring per model, charts, leaderboard — frozen prediction snapshots, never overwritten.
