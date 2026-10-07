# Fortnightly data check — instructions for the update agent

This repository hosts the Data Center Operators Benchmarking dashboard on GitHub Pages.
The page (`index.html`) reads every number from `data.json`. **The agent only ever edits
`data.json`.** It never edits `index.html`, the logos, or this file.

Nothing goes live without the owner's approval: every change is proposed as a pull
request, and the owner (anshulaayush123) reviews and merges it.

## Schedule

Every other Sunday. Each run is independent: read this file and `data.json` fresh.

## Steps for each run

1. Read `data.json`. For each company, note the reporting period in `companies[].period`
   (e.g. `FY2025`, `TTM Jun 2026`).
2. For each of the 10 companies, look for results published **after** that period:
   quarterly, half-year or annual reports, plus investor presentations for capacity
   (MW), customer and headcount figures.
3. If nothing newer exists for any company, stop. Do not open a pull request.
4. If newer figures exist:
   - Create a branch named `data-update/YYYY-MM-DD`.
   - Update the reported metrics in `data.json`, update that company's `period`, and
     recalculate the derived metrics (see below).
   - For every value you change, record the source in `sources[company][metric]` as a
     direct link to the filing or page (not a search result).
   - For every value you change, also record in `methods[company][metric]` one or two
     plain sentences on how you got it: which figures from the document, the arithmetic,
     and any currency conversion. Example: `"TTM Jun 2026 = FY2025 + H1 2026 − H1 2025:
     9,217 + 5,069 − 4,481 = 9,805 (FY25 10-K; Jun-26 10-Q income statement)."` For a
     number copied as-is, say where it appears (e.g. `"Headcount at 31 Dec 2025, FY25
     10-K, Human Capital section."`). These notes fill the Sources tab of the owner's
     Excel file.
   - Open a pull request to `main` titled `Data update — <date> — <companies>`.
5. The pull request description must contain a table with one row per changed value:

   | Company | Metric | Old | New | Source (clickable link) | Confidence |
   |---|---|---|---|---|---|

   Set Confidence to **High** when the number appears verbatim in a filing table.
   Set it to **Low** when it was read from a chart or text, estimated, or uses a
   definition that differs from earlier periods. Explain each Low row in one line under
   the table.
6. Do not merge. The owner reviews and merges.

## Where to look (most reliable first)

1. Company filings:
   - US listings: SEC EDGAR 10-K, 10-Q, 20-F, 6-K.
   - NextDC: ASX announcements.
2. The company's investor-relations results releases and presentations.
3. Reputable financial news only to *find* a release. Always cite the primary document.

## Data rules

- **Units:** money in USD millions.
- **Period:** use the more recent of the latest full fiscal year or the trailing twelve
  months (TTM). Label the period clearly in `companies[].period`, e.g. `"FY2025"` or
  `"TTM Jun 2026"`.
- **EBITDA:** use the company's reported *adjusted* EBITDA, with the same definition per
  company over time.
- **EV/EBITDA:** refresh only when new results come out.
- **Currency:** convert non-USD figures (e.g. NextDC, AUD) to USD at the exchange rate on
  the day of the update. State the rate, date and source in the pull request.
- **Format:** store percentages and multiples as display strings (`"48.7%"`, `"3.2x"`).
  Use `"N/A"` when not disclosed or not meaningful, and `"—"` when not available.

## Derived metrics (recalculate; do not search for these)

| Metric | Formula |
|---|---|
| EBITDA Margin | EBITDA ÷ Revenue |
| PAT Margin | PAT ÷ Revenue |
| Net Debt/EBITDA | Net Debt ÷ EBITDA (`"N/A"` if EBITDA ≤ 0) |
| Live vs pipeline % | Installed MW ÷ Pipeline MW |
| G&A % of Revenue | G&A ÷ Revenue |
| EBITDA/MW, PAT/MW, Net debt/MW | metric ÷ installed MW |
| MW/FTE | installed MW ÷ total employees |
| Revenue ($M)/FTE, EBITDA ($M)/FTE | metric ÷ total employees |

The MW basis has one exception. Fermi has no installed capacity, so its per-MW and
per-FTE figures use its 222 MW contracted capacity.

FCF/MW and Capex/MW follow the owner's original workbook definitions. If the inputs are
unclear, leave them unchanged and mention that in the pull request.

## Never

- Never change `index.html`, logos, layout or anything in `excel-updater/`.
- Never merge your own pull request or push to `main`.
- Never invent a number. If a figure cannot be sourced, leave the old value and say so.
