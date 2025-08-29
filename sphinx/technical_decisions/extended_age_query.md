# Extended Age Query (EAQ) Design & Implementation

## Overview

The Extended Age Query (EAQ) feature enhances query capabilities for **Collection Objects (COs)** in the Query Builder by enabling filters based on geological age. Available in Geology, Invertebrate Paleontology, and Vertebrate Paleontology disciplines, EAQ supports both named time periods and explicit numerical ranges using start/end values (in Millions of Years Ago, MYA).

## Core Logic & Filtering Criteria

- **Numeric-Based Logic**  
  EAQ exclusively uses numerical start and end values; no names are directly used for computation—names are converted into numeric ranges by the system.

- **Valid Periods Only**  
  Only Chronostratigraphy nodes from the `GeologicTimePeriod` table with valid `StartPeriod` and `EndPeriod` values (where StartPeriod > EndPeriod) are considered for queries.

- **Range Calculation**  
  The query computes its range using:
  - **Lowest** `EndPeriod` across relevant nodes
  - **Highest** `StartPeriod` across relevant nodes  
  Because MYA increases into the past, higher StartPeriod means older boundary.

- **Strictness in Range Calculations**
  - an age query start period `x`
  - an age query end period `y`
  - with constraint that `x >= y`
  - for each collection object, a meta start period `a` is decided, and a meta end period `b` is decided.
  - with constraint that `a >= b`

  Strict Filter: (full overlap, a-b is within x-y)
  `a <= x` and `b >= y`

  Non-Strict Filter: (partial age range overlap, any overlap so x-y can be within a-b or a-b can be within x-y)
  (` a<= x` and `a >= y`) or (`b <= x` and `b >= y`) or (`a >= x` and `b <= y`)

  This is omitting the complication of uncertainty values.
  The meta age range for each collection object should appear in the age column of the query results.
  The "Any" age query bug is being push to a later issue. For now, do a Age Range query from "13800" to "0" to get all COs with age data (query all of time, the age of the universe

## User Interface & Workflow

1. **Add Age Field**  
   In the Query Builder, users select "Age" on their Collection Object query.

2. **Select Query Method**  
   - **Name**: User enters a geological time period name, which the system converts into start/end values and displays the name in the UI.  
   - **Range**: User enters explicit start and end numeric values (e.g., `15` and `5` for 15–5 MYA).

3. **Choose Search Mode**  
   - **Strict**: Returns COs whose entire age range lies within the specified window.  
   - **Non-strict**: Returns COs whose age ranges overlap at all with the specified window.

4. **Execute Query**  
   The system determines the applicable age range using either the named period or numeric values and filters results accordingly.

## Search Scope Across Age Fields

EAQ applies to the following age contexts within Collection Objects:

- **Relative Age**  
  Uses `AgeNameID` (FK to `GeologicTimePeriod`) to establish a chronostratigraphic linkage and then applies the underlying start/end values.

- **Absolute Age**  
  Computes a range using: AbsoluteAge + AgeUncertainty to AbsoluteAge – AgeUncertainty
  
- **Paleo Context**  
Bound by `ChronosStratID` (and optionally `ChronosStratEndID`). The system determines the widest combined range across both IDs using start/end values.

**Table paths from CollectionObject to Absoluteage or GeologicTimePeriod**

| table_path_1     | table_path_2    | table_path_3  | table_path_4    | table_path_5      |
|------------------|-----------------|---------------|-----------------|-------------------|
| collectionobject | absoluteage     |               |                 |                   |
| collectionobject | relativeage     | chronostrat   |                 |                   |
| collectionobject | paleocontext    | chronostrat   |                 |                   |
| collectionobject | collectionevent | paleocontext  | chronostrat     |                   |
| collectionobject | collectionevent | locality      | paleocontext    | chronostrat       |

**Field Paths from CollectionObject to Absoluteage or GeologicTimePeriod**

| field_path_1     | field_path_2    | field_path_3   | field_path_4   | field_path_5     | field_path_6  |
|------------------|-----------------|----------------|----------------|------------------|---------------|
| collectionobject | absoluteage     | absoluteage    |                |                  |               |
| collectionobject | relativeage     | agename        | startperiod    |                  |               |
| collectionobject | relativeage     | agename        | endperiod      |                  |               |
| collectionobject | relativeage     | agenameend     | startperiod    |                  |               |
| collectionobject | relativeage     | agenameend     | endperiod      |                  |               |
| collectionobject | paleocontext    | chronosstrat   | startperiod    |                  |               |
| collectionobject | paleocontext    | chronosstrat   | endperiod      |                  |               |
| collectionobject | paleocontext    | chronosstratend| startperiod    |                  |               |
| collectionobject | paleocontext    | chronosstratend| endperiod      |                  |               |
| collectionobject | collectingevent | paleocontext   | chronosstrat   | startperiod      |               |
| collectionobject | collectingevent | paleocontext   | chronosstrat   | endperiod        |               |
| collectionobject | collectingevent | paleocontext   | chronosstratend| startperiod      |               |
| collectionobject | collectingevent | paleocontext   | chronosstratend| endperiod        |               |
| collectionobject | collectingevent | locality       | paleocontext   | chronosstrat     | startperiod   |
| collectionobject | collectingevent | locality       | paleocontext   | chronosstrat     | endperiod     |
| collectionobject | collectingevent | locality       | paleocontext   | chronosstratend  | startperiod   |
| collectionobject | collectingevent | locality       | paleocontext   | chronosstratend  | endperiod     |

These three contexts are searched independently according to their respective logic.

## MVP Scope

For the Minimum Viable Product (MVP), the EAQ will only operate on **Collection Objects**.

## Summary Table

| Feature                 | Behavior                                                                 |
|------------------------|--------------------------------------------------------------------------|
| Numeric Logic Only     | Only start/end MYA values are used—names are converted internally        |
| Valid Periods Only     | Filters apply only to Chronostrat nodes with valid start/end values      |
| Range Computation      | Uses lowest EndPeriod and highest StartPeriod for range boundaries       |
| Query Methods          | Supports both named period and explicit numeric range input              |
| Strict vs Non-strict   | Determines whether results must fully fall within or just overlap range  |
| Search Contexts        | Applies across Relative Age, Absolute Age, and Paleo Context             |
| Availability           | Limited to Collection Object queries for MVP                            |


