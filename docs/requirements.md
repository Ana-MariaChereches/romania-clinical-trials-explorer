# Romania Clinical Trials Feasibility Explorer: Requirements (v1)

Status: draft, updated 2026-10-28. Items marked **[hypothesis]** or **[open]** are to be validated or decided once the data is explored. Decisions taken on 2026-10-28 are written as definitions below; each carries the reason in the "Why" column.

**Target date for v1: 2026-11-20.** Anything not finished by then moves to v2.

## 1. Problem statement

When a sponsor considers running a clinical trial in Romania, a feasibility manager needs a quick, evidence-based view of the existing trial landscape: which therapeutic areas and phases are active, which sponsors and cities are involved, how many studies compete for the same patients, and how often studies stop. Public registry data contains this information, but it is nested, inconsistent and hard to explore directly.

This project builds a cleaned dataset and an interactive dashboard of studies with at least one site in Romania (2015 to present), and explores two questions:

1. Does Romania's participation in clinical trials match the size of its population?
2. Are trials concentrated in a few large cities with university hospitals?

These are exploratory questions: the project describes patterns, it does not claim to explain why sponsors choose Romania.

The project is also a practical exercise in applying Python, pandas, SQL and Power BI to real, messy data.

### Reference scenario for v1

> "I am planning a Phase 3 study in a given therapeutic area. In which cities can I find sites, how many competing studies are active in Romania, and which sponsors are already present?"

Every chart in v1 must help answer this scenario. The country choice itself ("should we include Romania at all?") needs other countries and is part of v2.

## 2. User persona

- **Role:** Feasibility manager at a CRO or pharma company.
- **Typical decision:** Whether to include Romania in a new study (for example a Phase 3 study in a given disease), and roughly how many sites and how competitive recruitment will be.
- **What the role involves** (from job descriptions for feasibility roles): competitive landscape analysis, historical recruitment analysis, country and site analyses, translating evidence into country, site and enrolment recommendations, and stating assumptions and data limitations transparently.
- **Current way of working:** **[hypothesis]** manual searches on ClinicalTrials.gov, with results collected in spreadsheets.
- **Pain points:** **[hypothesis]** assembling a landscape of existing studies by country, disease and phase is manual and time-consuming; registry data is nested and inconsistent. To be validated in a conversation with someone working in feasibility.

## 3. Scope

**In scope (v1):**
- Studies with at least one site in Romania
- Study type INTERVENTIONAL only
- Start year 2015 to present
- Source: ClinicalTrials.gov API v2
- Site-level analysis restricted to sites located in Romania (the API returns all sites of a study, including those in other countries, so sites are filtered by country)
- Dashboard, labels and documentation in English

**Out of scope (v1):**
- Observational and expanded access studies
- Other countries and population-adjusted comparisons (v2), reasons for termination (v2), safety and adverse events (separate project)
- Site questionnaires, investigator outreach, epidemiology data (not available in the registry)
- Contact fields (names, phone numbers, e-mails of people): dropped before any table is saved

## 4. Definitions

| Term | Definition | Why |
|---|---|---|
| "Romanian study" | Study with at least one site whose country is Romania (3,720 studies in the 2026-10-26 extract; NCT00336544 matched only through facility names in the United States and is excluded on purpose) | Most studies are multinational; `query.locn` matches text, not the country of the site |
| "Romanian site" | Site whose country field is "Romania" | The API returns all sites of a matching study |
| Study type | INTERVENTIONAL only. The numbers excluded at each step (country, start year, study type) are reported in the README funnel table | Phases, competition and stop rate make sense mainly for interventional studies; the persona works in pharma/CRO |
| Phase | One row per study, with one ordered label: Early Phase 1, Phase 1, Phase 1/2, Phase 2, Phase 2/3, Phase 3, Phase 4, No phase. "No phase" (device, behavioural, other, or a missing phase field) is shown separately and left out of phase charts | Splitting the list into one row per phase would count a Phase 1/2 study twice |
| Start year | First four characters of the start date, as a number. The per-year chart counts only studies with an actual start date; the current year is labelled "partial (year to date)". Studies with an estimated start date are shown as "planned" and used only for question 2. A study without a date type is treated as actual if its status is COMPLETED or TERMINATED (it must have started), otherwise as unknown and left out of the per-year chart | Estimated dates would mix planned and started studies; the current year is incomplete |
| "Active study" | Study-level overall status RECRUITING, ACTIVE_NOT_RECRUITING or ENROLLING_BY_INVITATION; NOT_YET_RECRUITING is included but labelled separately. Site status is used only as a secondary filter where it exists | Site status is missing for part of the sites; not-yet-recruiting studies compete for patients soon but some never start |
| "Stopped study" | Status TERMINATED or WITHDRAWN. SUSPENDED is left out of the numerator and the denominator, because the study may resume. There are only 2 such studies in the final set (extract of 2026-10-26), so they stay out and the number is stated in the README | "Stopped" must mean the study will not run |
| Stop rate | Stopped studies / studies with a final status (COMPLETED + TERMINATED + WITHDRAWN), by phase, for start years 2015-2021 only. It describes the whole study, not the Romanian sites | Ongoing studies would push the rate down; recent starts have not had time to stop; a study often stops for global reasons |
| Sponsor | Lead sponsor only. Classes grouped as Industry / Academic and other / Networks. A top 10-15 of industry sponsors uses a hand-made alias table (for example "Pfizer" and "Pfizer Inc."). **[open: confirm the meaning of `OTHER` and `NETWORK` in the ClinicalTrials.gov data definitions before naming the "Academic and other" group]** | A feasibility manager needs sponsor names, but only the top ones are worth the cleaning effort |
| Therapeutic area | MeSH terms from `derivedSection.conditionBrowseModule` (`meshes` and `ancestors`); the field `browseBranches` does not exist in the extract. A study belongs to an area if the area's MeSH category appears among its terms. 13 broad areas are used (Oncology, Respiratory, Immune system, Digestive, Skin and connective tissue, Nervous system, Cardiovascular, Metabolic and endocrine, Infections, Blood and lymphatic, Urogenital, Musculoskeletal, Mental health). An area is listed only if it has at least about 30 studies in the final set; smaller categories (for example eye diseases and dental) are left in "Not classified" in v1. The mapping is kept in a separate study-area table (one row per study and area). Counts are distinct studies per area; areas are never added up. Studies without any area are shown as "Not classified" (268 of 1,717: 194 without any MeSH term and 74 whose terms fall outside the listed areas) | Conditions are free text; one study can belong to several areas |
| Competition | For each area and phase: number of active studies, number of distinct Romanian sites, number of distinct sponsors. Cells with fewer than 5 studies are marked "limited data" and shown as counts only | One number hides the difference between a study with 2 sites and one with 40 |
| "Site" (centre) | A pair of (cleaned city, facility name without codes such as "Site 0001"). Counts are approximate. Cities are cleaned with a hand-made mapping table (diacritics and English/Romanian spellings) | The same hospital is written differently in different studies |
| Unknown status | Reported separately as a data limitation (67 studies in the final set) | |

## 5. Business questions (v1)

| # | Question | Decision it supports | Output (dashboard page) |
|---|---|---|---|
| 1 | How has the number of studies with Romanian sites evolved per start year? | Is the country growing as a destination? | Overview: bar chart per start year (actual starts; current year partial) |
| 2 | Which therapeutic areas and phases dominate active studies? | Where does Romania have experience? | Landscape: areas and phases of active studies |
| 3 | Who are the most active sponsors (industry vs academic)? | Who competes for patients and sites? | Overview: class split and top industry sponsors |
| 4 | Which cities and sites appear in the most studies, and what share of studies is concentrated in the largest cities? | Where to look for experienced sites? | Sites: top 10 cities with cumulative share; a map only if at least about 90% of sites have coordinates |
| 5 | How many active studies compete in the same condition and phase? | Will recruitment be hard? | Landscape: area x phase table with the three numbers from section 4 |
| 6 | What share of studies stop, by phase? | How risky is the country? | Landscape: stop rate by phase (start years 2015-2021) |

Each page title is a sentence that states what the page shows, not the name of a chart. Exploratory question 1 from the problem statement (participation relative to population) needs population data and other countries, so it is addressed in v2.

## 6. Acceptance criteria

- A user can filter all pages by therapeutic area, phase, start year and sponsor class.
- Each question has a visual that answers it without further explanation, and the reference scenario in section 1 can be solved with the dashboard.
- Five analyses are written in SQL (`sql/`) and cross-checked against pandas; differences are explained in the README: (1) studies per start year with `GROUP BY`; (2) active studies per area and phase with `JOIN` and `COUNT(DISTINCT)`; (3) stop rate per phase with `CASE`; (4) top 10 cities with cumulative share using `SUM() OVER`; (5) industry sponsor ranking with `RANK()`. Other dashboard numbers are reproducible from the CSV files in `data/clean/` with pandas.
- Data refresh date is visible on the dashboard.
- Deliverables: Power BI file (`.pbix`) in the repository; README with three screenshots; PDF exported from the report.
- At least one feedback round is done and documented (section 9).

## 7. Known data limitations

- ClinicalTrials.gov does not contain all European studies (EU CTIS / EudraCT are separate registries).
- Enrolment numbers refer to the whole study, not to Romania. The enrolment type (actual or estimated) must be taken into account.
- The phase field is a list: a study can have more than one phase; it is combined into one label (section 4).
- Start and end dates are sometimes only month and year; for some studies the date type (actual or estimated) is missing.
- City names are not written uniformly (for example "Bucharest" and Romanian spellings), and site names can contain suffixes such as a site number. The number of distinct sites is therefore approximate.
- Some site fields are missing for part of the sites (for example state, coordinates, status).
- About 16% of studies (268 of 1,717) have no therapeutic area and are shown as "Not classified": 194 have no MeSH term in the registry, 74 have terms outside the listed areas. The area mapping works on MeSH term names and is approximate (for example, the 4 studies tagged only "Depression" were not matched to Mental health).
- Study status is global: "active" and "stopped" do not say anything about the Romanian sites alone.
- Studies that started recently have not had time to stop, so the stop rate is shown only for start years 2015-2021.
- Sponsor class values (`INDUSTRY`, `OTHER`, `NETWORK`, `OTHER_GOV`) come from the registry; the exact meaning of `OTHER` and `NETWORK` is still to be checked.
- Contact fields were dropped; they are not needed for any analysis.
- Costs, approval timelines and patient availability cannot be measured with this data.
- Some estimated start dates are in the past (records that were not updated). These studies are labelled "planned" and kept out of the per-year chart.

## 8. Roadmap

- **v1 (target 2026-11-20):** questions 1-6, Power BI dashboard, README
  - 2026-10-28 to 2026-11-03: study table, year/type/phase filters, areas, cleaning of cities and sites, README update, feedback requests sent
  - 2026-11-04 to 2026-11-10: SQL analyses, dashboard pages 1 and 2, feedback
  - 2026-11-11 to 2026-11-20: page 3, changes from feedback, screenshots, PDF, final README
- **v2:** study duration, comparison with Poland, Hungary, Czechia and Bulgaria, population-adjusted figures, termination reasons
- **v3:** simple recruitment projection (patients per site per month from completed studies), one-page feasibility brief for a sample study

## 9. Validation

Three people: one working in feasibility, clinical operations or at a CRO, and two with data or BI experience. They are asked after dashboard pages 1 and 2 exist, before the fine cleaning. Each person gets the reference scenario (section 1) and solves it alone, while the author stays silent. Success: all three answer the scenario in under 5 minutes without explanation. The author notes what they cannot find, what they read wrongly, and how long it takes.

To be completed after talking to the people: date, person's role, feedback, change made.

## 10. Data handling

- `data/raw/` is not committed (see `.gitignore`); a small sample can be kept as `sample_*.json`.
- Cleaned tables are saved as CSV in `data/clean/` and committed; they contain no contact fields.
- Power BI reads the CSV files. The SQLite database is built locally from the same CSV files and is not committed (`*.sqlite` is in `.gitignore`).
- The README section "Data source" records the extraction date and the counts after each step.
