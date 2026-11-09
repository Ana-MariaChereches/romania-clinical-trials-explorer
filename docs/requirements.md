# Romania Clinical Trials Feasibility Explorer: Requirements (v1)

Status: v1 final, updated 2026-11-09. Items marked **[hypothesis]** were not validated in v1 (see section 9). The definitions below record the decisions taken while building the dashboard; each carries the reason in the "Why" column.

**Target date for v1: 2026-11-20.** Anything not finished by then moves to v2.

## 1. Problem statement

When a sponsor considers running a clinical trial in Romania, a feasibility manager needs a quick, evidence-based view of the existing trial landscape: which therapeutic areas and phases are active, which sponsors and cities are involved, how many studies compete for the same patients, and how often studies stop. Public registry data contains this information, but it is nested, inconsistent and hard to explore directly.

This project builds a cleaned dataset and an interactive dashboard of studies with at least one site in Romania (2015 to present), and explores two questions:

1. Does Romania's participation in clinical trials match the size of its population? (needs population data and other countries, so it is addressed in v2)
2. Are trials concentrated in a few large cities with university hospitals? (answered in v1, Sites page)

These are exploratory questions: the project describes patterns, it does not claim to explain why sponsors choose Romania.

The project is also a practical exercise in applying Python, pandas, SQL and Power BI to real, messy data.

### Reference scenario for v1

> "I am planning a Phase 3 study in a given therapeutic area. In which cities can I find sites, how many competing studies are active in Romania, and which sponsors are already present?"

Every chart in v1 must help answer this scenario. The country choice itself ("should we include Romania at all?") needs other countries and is part of v2.

## 2. User persona

- **Role:** Feasibility manager at a CRO or pharma company.
- **Typical decision:** Whether to include Romania in a new study (for example a Phase 3 study in a given disease), and roughly how many sites and how competitive recruitment will be.
- **What the role involves** (from job descriptions for feasibility roles): competitive landscape analysis, historical recruitment analysis, country and site analyses, translating evidence into country, site and enrolment recommendations, and stating assumptions and data limitations transparently.
- **Current way of working:** **[hypothesis, not validated in v1]** manual searches on ClinicalTrials.gov, with results collected in spreadsheets.
- **Pain points:** **[hypothesis, not validated in v1]** assembling a landscape of existing studies by country, disease and phase is manual and time-consuming; registry data is nested and inconsistent. To be validated in a conversation with someone working in feasibility.

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
| Phase | One row per study, with one ordered label: Early Phase 1, Phase 1, Phase 1/2, Phase 2, Phase 2/3, Phase 3, Phase 4, No phase. "No phase" (mostly device, behavioural, procedure, dietary supplement or other interventions, or a missing phase field) is shown separately and left out of phase charts | Splitting the list into one row per phase would count a Phase 1/2 study twice |
| Start year | First four characters of the start date, as a number. The per-year chart counts only studies with an actual start date; the current year is labelled "partial (year to date)". Studies with an estimated start date are shown as "planned" and used only for question 2. A study without a date type is treated as actual if its status is COMPLETED or TERMINATED (it must have started), otherwise as unknown and left out of the per-year chart | Estimated dates would mix planned and started studies; the current year is incomplete |
| "Active study" | Study-level overall status RECRUITING, ACTIVE_NOT_RECRUITING or ENROLLING_BY_INVITATION; NOT_YET_RECRUITING is included but counted separately. Site status is not used (it is missing for part of the sites). Studies with status UNKNOWN are not active | Not-yet-recruiting studies compete for patients soon but some never start; active-not-recruiting studies still occupy sites |
| "Stopped study" | Status TERMINATED or WITHDRAWN. SUSPENDED is left out of the numerator and the denominator, because the study may resume. There are only 2 such studies in the final set (extract of 2026-10-26), so they stay out and the number is stated in the README | "Stopped" must mean the study will not run |
| Stop rate | Stopped studies / studies with a final status (COMPLETED + TERMINATED + WITHDRAWN), by phase, for start years 2015-2021 only. It describes the whole study, not the Romanian sites. Phases with fewer than 30 studies are shown in grey | Ongoing studies would push the rate down; recent starts have not had time to stop; a study often stops for global reasons; small groups give unstable rates |
| Sponsor | Lead sponsor only. Classes grouped as Industry (class INDUSTRY) / Academic and other (OTHER, NETWORK and OTHER_GOV together). Checked on the data: OTHER is mostly universities, hospitals, foundations and societies, but also a few small companies and individual investigators; NETWORK has only 13 studies, 11 of them from one company, so it is not shown separately. A top 10-15 of industry sponsors uses a hand-made alias table (for example "Pfizer" and "Pfizer Inc.") | A feasibility manager needs sponsor names, but only the top ones are worth the cleaning effort |
| Therapeutic area | MeSH terms from `derivedSection.conditionBrowseModule` (`meshes` and `ancestors`); the field `browseBranches` does not exist in the extract. A study belongs to an area if the area's MeSH category appears among its terms. 13 broad areas are used (Oncology, Respiratory, Immune system, Digestive, Skin and connective tissue, Nervous system, Cardiovascular, Metabolic and endocrine, Infections, Blood and lymphatic, Urogenital, Musculoskeletal, Mental health). An area is listed only if it has at least about 30 studies in the final set; smaller categories (for example eye diseases and dental) are left in "Not classified" in v1. The mapping is kept in a separate study-area table (one row per study and area). Counts are distinct studies per area; areas are never added up. Studies without any area are shown as "Not classified" (268 of 1,717: 194 without any MeSH term and 74 whose terms fall outside the listed areas) | Conditions are free text; one study can belong to several areas |
| Competition | For each area and phase: number of active studies, and (in the detail table) number of distinct sponsors, number of cities and number of named centres. Named centres exclude sites without a real name, so they are a minimum. Cells with fewer than 5 studies are shown in grey as limited data | One number hides the difference between a study with 2 sites and one with 40; about 38% of sites have no real name |
| "Site" (centre) | One Romanian location listed for a study (7,524 site rows for the 1,717 studies). A centre is a pair of (cleaned city, cleaned facility name). Sites with no real name (placeholders such as "Site 1901" or "Research Site", or no name at all: 2,841 rows, 37.8%) are labelled "Generic site": they count in city totals but never as centres. Counts are approximate. Cities are cleaned with a hand-made mapping table (diacritics, English/Romanian spellings; 21 rows stay "Unknown city"); facility names with an automatic key plus a hand-made alias table for the largest centres | The same hospital is written differently in different studies; about 38% of sites have no real name |
| Private practice | Practices named after a physician (CMI, SCM, "Dr ..." clinics; 160 site rows) are shown as "Private practice", so no personal names are kept. All private practices in a city count as one centre and are left out of the centre ranking | Understates the real number of centres a little |
| Unknown status | Studies with status UNKNOWN (67 in the final set) are left out of the active studies and of the stop rate, and stated as a data limitation | The registry has not updated them, so it is not known whether they are running |

## 5. Business questions (v1)

| # | Question | Decision it supports | Output (dashboard page) |
|---|---|---|---|
| 1 | How has the number of studies with Romanian sites evolved per start year? | Is the country growing as a destination? | Overview: bar chart per start year (actual starts; current year partial) |
| 2 | Which therapeutic areas and phases dominate active studies? | Where does Romania have experience? | Landscape: areas and phases of active studies |
| 3 | Who are the most active sponsors (industry vs academic)? | Who competes for patients and sites? | Overview: class split and top industry sponsors |
| 4 | Which cities and sites appear in the most studies, and what share of studies is concentrated in the largest cities? | Where to look for experienced sites? | Sites: top 10 cities with cumulative share; top named centres (about 38% of sites have no real name, so centre counts are partial); a map at city level (one bubble per city, size = number of studies), because registry coordinates are unreliable for some sites |
| 5 | How many active studies compete in the same condition and phase? | Will recruitment be hard? | Landscape: area x phase matrix of active studies, plus a detail table with sponsors, cities and named centres for each cell |
| 6 | What share of studies stop, by phase? | How risky is the country? | Landscape: stop rate by phase (start years 2015-2021) |

Each page title is a sentence that states what the page shows, not the name of a chart. Exploratory question 1 from the problem statement (participation relative to population) needs population data and other countries, so it is addressed in v2.

## 6. Acceptance criteria

- On the Landscape page, clicking a cell of the area x phase matrix filters the detail table. Global filters (therapeutic area, phase, start year, sponsor class) are planned for v2.
- Each question has a visual that answers it without further explanation, and the reference scenario in section 1 can be solved with the dashboard.
- Seven queries are written in SQL (`sql/`); the five main ones are: (1) studies per start year with `GROUP BY`; (2) active studies per area and phase with `JOIN` and `COUNT(DISTINCT)`; (3) stop rate per phase with `CASE`; (4) cumulative share of the largest cities with `SUM() OVER`; (5) industry sponsor ranking with `RANK()`. Table sizes and key totals (1,717 studies, 1,663 actual starts, 7,524 site rows) were checked against the pandas tables, and the numbers on the dashboard against the query results.
- Data refresh date is visible on the dashboard.
- Deliverables: Power BI file (`.pbix`) and three screenshots in `powerbi/`; README with the screenshots; PDF exported from the report (`powerbi/`).
- No external feedback round was done in v1 (see section 9).

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
- Sponsor class values (`INDUSTRY`, `OTHER`, `NETWORK`, `OTHER_GOV`) come from the registry. `OTHER` is mostly universities, hospitals, foundations and societies, but also contains a few small companies and individual investigators; `NETWORK` is almost entirely one company. They are therefore shown together as "Academic and other".
- Contact fields were dropped; they are not needed for any analysis.
- Costs, approval timelines and patient availability cannot be measured with this data.
- Some estimated start dates are in the past (records that were not updated). These studies are labelled "planned" and kept out of the per-year chart.
- About 38% of sites have no real facility name, so centre-level numbers cover only the named ~62%. City-level numbers are not affected.
- Facility names are unified by an automatic key plus a hand-made alias table for the largest centres only. The number of centres (about 1,830) is therefore approximate: smaller centres may still appear under two spellings.
- Registry coordinates are geocoded from text and are unreliable for some sites (142 missing, 34 far from their city; “Florești” was placed in Prahova instead of Cluj). Site-level coordinates are not used. The map uses one median point per city, with Florești set manually to Florești (Cluj).
- Industry sponsors are grouped with their parent company only when the registry name says so (for example "a Sanofi company") in a hand-made alias table for the largest sponsors; other relations (for example Celgene and Bristol-Myers Squibb) are not merged.
- Sponsor names are kept as in the registry; a few are individual investigators and are not shown in the dashboard.
- The stop rate for phases with few studies (2/3 with 18 studies, 1/2 with 12) is unstable and shown in grey.

## 8. Roadmap

- **v1 (target 2026-11-20):** questions 1-6, Power BI dashboard, README
  - Done by 2026-11-09: study table, year/type/phase filters, areas, cleaning of cities and sites, SQL analyses, three dashboard pages, README
  - 2026-11-10 to 2026-11-20: final checks, notebooks rerun, final documentation
- **v2:** global filters on the dashboard, a validation round with people from the field, study duration, comparison with Poland, Hungary, Czechia and Bulgaria, population-adjusted figures, termination reasons
- **v3:** simple recruitment projection (patients per site per month from completed studies), one-page feasibility brief for a sample study

## 9. Validation

No validation round with people from the field was done in v1. The plan (three people: one working in feasibility or at a CRO and two with data or BI experience, each solving the reference scenario in section 1 alone, in under 5 minutes) moves to v2. In v1 the numbers were cross-checked between the pandas tables, the SQL queries and the dashboard (section 6).

To be completed after talking to the people: date, person's role, feedback, change made.

## 10. Data handling

- Power BI reads the CSV files in `data/powerbi/` (results of the SQL queries) and `data/clean/city_coords.csv`. The SQLite database is built locally from the CSV files in `data/clean/` and is not committed (`*.db` and `*.sqlite` are in `.gitignore`).
- Cleaned tables are saved as CSV in `data/clean/` and committed; they contain no contact fields.
- Power BI reads the CSV files. The SQLite database is built locally from the same CSV files and is not committed (`*.sqlite` is in `.gitignore`).
- The README section "Data source" records the extraction date and the counts after each step.
