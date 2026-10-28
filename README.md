# Romania Clinical Trials Feasibility Explorer

> **Status: work in progress (v1).** Requirements are written, the data is extracted and the study table is built (`03_build_tables.ipynb`). Next: therapeutic areas, city and site cleaning, SQL analyses and the dashboard. See the roadmap below.

## Problem statement

When a sponsor considers running a clinical trial in Romania, a feasibility manager needs a quick, evidence-based view of the existing trial landscape: which therapeutic areas and phases are active, which sponsors and cities are involved, how many studies compete for the same patients, and how often studies stop. Public registry data contains this information, but it is nested, inconsistent and hard to explore directly.

This project builds a cleaned dataset and an interactive dashboard of studies with at least one site in Romania (2015 to present), and explores two questions:

1. Does Romania's participation in clinical trials match the size of its population?
2. Are trials concentrated in a few large cities with university hospitals?

These are exploratory questions: the project describes patterns, it does not claim to explain why sponsors choose Romania.

The project is also a practical exercise in applying Python, pandas, SQL and Power BI to real, messy data.

## Reference scenario

> "I am planning a Phase 3 study in a given therapeutic area. In which cities can I find sites, how many competing studies are active in Romania, and which sponsors are already present?"

Every chart in v1 is meant to help answer this scenario. Choosing between countries needs other countries and is planned for v2. Target date for v1: 2026-11-20.

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

**Result:** 3,721 studies retrieved over 4 pages (`02_extract_data.ipynb`), saved as raw JSON (not stored in the repository). After restricting to studies with a start year of 2015 or later, 1,984 studies remain for analysis; 1,717 of them are interventional.

| Step | Studies |
|---|---|
| Retrieved from the API | 3,721 |
| At least one site in Romania | 3,720 |
| Start year 2015 or later | 1,984 |
| Interventional only | 1,717 |

Filters and the study table are built in `03_build_tables.ipynb`; the cleaned study table is saved as `data/clean/studies.csv`.

**Finding:** `query.locn` matches text, not the country of the site. One study (NCT00336544) matched only because "ROMANIA" appears in facility names located in the United States. Site-level analysis therefore filters on the `country` field. 3,720 studies have at least one site in Romania.
The date type (actual or estimated) is missing for some studies. A study without a date type is treated as started if its status is COMPLETED or TERMINATED (it must have started); the remaining 9 studies are labelled "unknown" and left out of the per-year chart. 45 studies have an estimated start date and are labelled "planned"; 23 of them have an estimated start year before 2026, which suggests records that were not updated. One interventional study has no phase field and is labelled "No phase".

## Tools

Python (pandas), SQL (SQLite), Power BI

## Repository structure (planned)

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
- [x] Extract data from the API
- [ ] Clean and model the data (pandas)
- [ ] SQL analysis, cross-checked against pandas results
- [ ] Power BI dashboard (v1: landscape, sponsors, cities, competition, stop rate)
- [ ] Feedback from 2-3 people in the field, documented
- [ ] v2: comparison with other countries and population-adjusted figures, study duration, termination reasons
- [ ] v3: simple recruitment projection and a one-page feasibility brief for a sample study

## Known limitations

- ClinicalTrials.gov does not contain every European trial (EU CTIS / EudraCT are separate registries).
- Enrolment figures refer to the whole study, not to Romania.
- Study status is global: "active" and "stopped" describe the whole study, not the Romanian sites. Studies that started recently have not had time to stop, so the stop rate is shown only for start years 2015-2021.
- Start dates are text with different forms (for example `2008-06` and `2015-12-18`); the year is taken from the first four characters. Some studies have no start date, and the date type (actual or estimated) is missing for part of them. Studies with an estimated start date are kept apart from started studies.
- Expanded access programmes and observational studies are excluded; only interventional studies are analysed.
- Sponsors are grouped by the registry's `class` field (`INDUSTRY`, `OTHER`, `NETWORK`, `OTHER_GOV`). The exact meaning of `OTHER` and `NETWORK` is still to be checked against the registry's data definitions.
- City and site names are not written uniformly; cities are cleaned with a hand-made mapping and the number of distinct sites is approximate.
- A study can belong to several therapeutic areas, so counts per area cannot be added up.
- Contact fields (people's names, phone numbers, e-mails) are dropped before any table is saved.
- Costs, approval timelines and patient availability cannot be measured with this data.
- The phase field is a list; a study with several phases gets one combined label (for example "Phase 1/2"). Studies without a phase are labelled "No phase".
- The current year is incomplete and is labelled as partial.
- Studies with status SUSPENDED (2) are left out of the stop rate; studies with status UNKNOWN (67) are reported separately.
- More limitations will be added as the data is explored.

## How to run

To be added once the extraction script exists.
