# Data Center Operators Benchmarking

This is an interactive dashboard benchmarking 10 data-center operators on commercial,
financial and headcount metrics.

- `index.html` is the dashboard page.
- `data.json` holds all the numbers. This is the only file that changes when new results
  come out.
- `logos/` holds the company logos.
- `AGENT_INSTRUCTIONS.md` has the rules for the fortnightly update agent.

## How updates work

1. Every other Sunday an agent checks for newly published company results.
2. If anything changed, it opens a pull request listing old vs. new values with source
   links.
3. The owner reviews the pull request and merges it.
4. GitHub Pages republishes the site automatically.
5. A scheduled task on the owner's laptop (`excel-updater/`) notices the merged update and
   saves a new Excel version, `DC_benchmarking_Claude_DDMMYYYY_vX.xlsx`, with the changed
   cells highlighted and a Sources tab showing each value's source link and calculation.
