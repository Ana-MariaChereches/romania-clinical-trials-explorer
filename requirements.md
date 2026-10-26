# Romania Clinical Trials Feasibility Explorer: Requirements (v1)

Status: draft, updated 2026-10-26. Items marked **[hypothesis]** or **[open]** are to be validated or decided once the data is explored.

## 1. Problem statement

When a sponsor considers running a clinical trial in Romania, a feasibility manager needs a quick, evidence-based view of the existing trial landscape: which therapeutic areas and phases are active, which sponsors and cities are involved, how many studies compete for the same patients, and how often studies stop. Public registry data contains this information, but it is nested, inconsistent and hard to explore directly.

This project builds a cleaned dataset and an interactive dashboard of studies with at least one site in Romania (2015 to present), and explores two questions:

1. Does Romania's participation in clinical trials match the size of its population?
2. Are trials concentrated in a few large cities with university hospitals?

These are exploratory questions: the project describes patterns, it does not claim to explain why sponsors choose Romania.

The project is also a practical exercise in applying Python, pandas, SQL and Power BI to real, messy data.

## 2. User persona

- **Role:** Feasibility manager at a CRO or pharma company.
- **Typical decision:** Whether to include Romania in a new study (for example a Phase 3 study in a given disease), and roughly how many sites and how competitive recruitment will be.
- **What the role involves** (from job descriptions for feasibility roles): competitive landscape analysis, historical recruitment analysis, country and site analyses, translating evidence into country, site and enrolment recommendations, and stating assumptions and data limitations transparently.
- **Current way of working:** **[hypothesis]** manual searches on ClinicalTrials.gov, with results collected in spreadsheets.
- **Pain points:** **[hypothesis]** assembling a landscape of existing studies by country, disease and phase is manual and time-consuming; registry data is nested and inconsistent. To be validated in a conversation with someone working in feasibility.

## 3. Scope

**In scope (v1):**
- Studies with at least one site in Romania
- Start year 2015 to present
- Source: ClinicalTrials.gov API v2
- Site-level analysis restricted to sites located in Romania (the API returns all sites of a study, including those in other countries, so sites are filtered by country)

**Out of scope (v1):**
- Other countries and population-adjusted comparisons (v2), reasons for termination (v2), safety and adverse events (separate project)
- Site questionnaires, investigator outreach, epidemiology data (not available in the registry)

## 4. Definitions

| Term | Definition | Why |
|---|---|---|
| "Romanian study" | Study with at least one site in Romania | Most studies are multinational |
| "Romanian site" | Site whose country field is "Romania" | The API returns all sites of a matching study |
| "Active study" | Status = RECRUITING **[open: decide whether to include not yet recruiting and active not recruiting, after seeing the status values in the data]** | |
| "Stopped study" | Terminated, withdrawn or suspended **[open: confirm exact status values]** | |
| Study type | **[open]** The registry also holds behavioural and non-drug studies (for example an online intervention for unemployed people, phase "NA"). Decide whether to keep them and label them, or exclude them | |
| Therapeutic area | Mapping of conditions to about 8-10 areas **[open: to define]** | Conditions are free text |
| Unknown status | Reported separately as a data limitation | |

## 5. Business questions (v1)

| # | Question | Decision it supports | Output (chart/table) |
|---|---|---|---|
| 1 | How has the number of studies with Romanian sites evolved per start year? | Is the country growing as a destination? | to define |
| 2 | Which therapeutic areas and phases dominate active studies? | Where does Romania have experience? | to define |
| 3 | Who are the most active sponsors (industry vs academic)? | Who competes for patients and sites? | to define |
| 4 | Which cities and sites appear in the most studies, and what share of studies is concentrated in the largest cities? | Where to look for experienced sites? | to define |
| 5 | How many active studies compete in the same condition and phase? | Will recruitment be hard? | to define |
| 6 | What share of studies stop, by phase? | How risky is the country? | to define |

Exploratory question 1 from the problem statement (participation relative to population) needs population data and other countries, so it is addressed in v2.

## 6. Acceptance criteria

- A user can filter all pages by therapeutic area, phase and start year.
- Each question has a visual that answers it without further explanation.
- Every number on the dashboard can be reproduced from the SQL queries in `sql/`.
- Data refresh date is visible on the dashboard.

## 7. Known data limitations

- ClinicalTrials.gov does not contain all European studies (EU CTIS / EudraCT are separate registries).
- Enrolment numbers refer to the whole study, not to Romania. The enrolment type (actual or estimated) must be taken into account.
- The phase field is a list: a study can have more than one phase.
- Start and end dates are sometimes only month and year.
- City names are not written uniformly (for example "Bucharest" and Romanian spellings), and site names can contain suffixes such as a site number.
- Some site fields are missing for part of the sites (for example state, coordinates).
- Therapeutic area mapping is manual and approximate.
- Site status may be outdated.
- Costs, approval timelines and patient availability cannot be measured with this data.

## 8. Roadmap

- **v1:** questions 1-6, Power BI dashboard, README
- **v2:** study duration, comparison with Poland, Hungary, Czechia and Bulgaria, population-adjusted figures, termination reasons
- **v3:** simple recruitment projection (patients per site per month from completed studies), one-page feasibility brief for a sample study

## 9. Validation

To be completed after talking to 2-3 people: date, person's role, feedback, change made.
