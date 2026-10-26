# Romania Clinical Trials Feasibility Explorer

> **Status: work in progress (v1).** Requirements are written; data extraction is next. See the roadmap below.

## Problem statement

When a sponsor considers running a clinical trial in Romania, a feasibility manager needs a quick, evidence-based view of the existing trial landscape: which therapeutic areas and phases are active, which sponsors and cities are involved, how many studies compete for the same patients, and how often studies stop. Public registry data contains this information, but it is nested, inconsistent and hard to explore directly.

This project builds a cleaned dataset and an interactive dashboard of studies with at least one site in Romania (2015 to present), and explores two questions:

1. Does Romania's participation in clinical trials match the size of its population?
2. Are trials concentrated in a few large cities with university hospitals?

These are exploratory questions: the project describes patterns, it does not claim to explain why sponsors choose Romania.

The project is also a practical exercise in applying Python, pandas, SQL and Power BI to real, messy data.

## Data source

**Source:** [ClinicalTrials.gov](https://clinicaltrials.gov), the public registry of clinical studies run by the U.S. National Library of Medicine. Official API page: https://clinicaltrials.gov/data-api/api

**Endpoint:** `https://clinicaltrials.gov/api/v2/studies` (API v2, no key required)

**Request parameters used:**

| Parameter | Value | Purpose |
|---|---|---|
| `query.locn` | `Romania` | Studies whose location fields contain "Romania" |
| `pageSize` | `1000` | Studies per page |
| `countTotal` | `true` | Return the total number of matching studies |
| `pageToken` | from `nextPageToken` | Move to the next page |

**How the endpoint and parameters were identified:** from community tutorials, then verified by testing the request (HTTP 200, response structure inspected) and by comparing the returned total with the number of studies retrieved.

**Extraction date:** 2026-10-26. The registry is updated continuously, so the total will change over time.

**Result:** 3,721 studies retrieved over 4 pages (`02_extract_data.ipynb`), saved as raw JSON (not stored in the repository).

**Finding:** `query.locn` matches text, not the country of the site. One study (NCT00336544) matched only because "ROMANIA" appears in facility names located in the United States. Site-level analysis therefore filters on the `country` field. 3,720 studies have at least one site in Romania.

## Tools

Python (pandas), SQL (SQLite), Power BI

## Repository structure

```
data/raw/        raw API responses, never edited
data/clean/      cleaned tables
notebooks/       exploration and analysis
src/             extraction and cleaning scripts
sql/             queries, each documented with the question it answers
docs/            requirements, data decisions, user feedback
```

## Documentation

- [Requirements](docs/requirements.md)
- Data decisions (to be added): every cleaning choice and why it was made

## Roadmap

- [x] Requirements and scope (v1)
- [ ] Extract data from the API
- [ ] Clean and model the data (pandas)
- [ ] SQL analysis, cross-checked against pandas results
- [ ] Power BI dashboard (v1: landscape, sponsors, cities, competition, stop rate)
- [ ] Feedback from 2-3 people in the field, documented
- [ ] v2: comparison with other countries and population-adjusted figures, study duration, termination reasons
- [ ] v3: simple recruitment projection and a one-page feasibility brief for a sample study

## Known limitations

- ClinicalTrials.gov does not contain every European trial (EU CTIS / EudraCT are separate registries).
- Enrolment figures refer to the whole study, not to Romania.
- Costs, approval timelines and patient availability cannot be measured with this data.
- More limitations will be added as the data is explored.

## How to run

To be added once the extraction script exists.
