# Technical Justification: Collection Object Groups (COG) Design & Implementation

## Purpose and Context

In Specify, individual specimens and samples are stored as **Collection Objects (COs)**, each with a unique GUID and catalog record. However, when COs share a physical or contextual connection—such as being part of the same organism, mounted on a common medium, or co-located they can be grouped logically using **Collection Object Groups (COGs)**.  
See [Collection Object Groups Discourse Post](https://discourse.specifysoftware.org/t/collection-object-groups/2226) for background.

## Flexibility in Abstraction

COGs allow collections to balance granularity versus simplicity. Collections may choose not to designate separate COs for closely related specimens, instead grouping them in a single record to reflect resource constraints or specific cataloging protocols. Conversely, COGs become essential when multi-component relationships are meaningful—for example, minerals embedded in a slab or multiple specimens on a herbarium sheet—improving efficiency in cataloging, querying, data exports, and managing loans or transactions.

## Types of COGs and Business Logic

COGs can be categorized into three **super types**, each with distinct behaviors:

| Super Type      | Description                                                                                           | Key Behavior                                                                 |
|------------------|-------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------|
| **Consolidated** | Physically joined objects (e.g., a rock slab, microscope slide)                                       | Requires a **primary CO**; transactions treat group as a unit               |
| **Discrete**     | Related but separate objects (e.g., multiple plant species collected together)                        | No primary CO required; each CO remains equally independent                  |
| **Drill Core**   | Segmented cores ordered by depth/age                                                                  | Linear grouping with no primary CO required                                  |

## Implementation Details

- COGs are defined via a *COG Type* record, setting both a user-friendly name and the super type.
- Relationships are managed in the `collectionobjectgroupjoin` (COJO) table, which stores the children (COs or other COGs); primary and substrate roles are also supported.
- For **Consolidated** COGs, marking a CO as **primary** ensures proper handling in reporting and transactional processes—such as loans, where including a preparation of a CO within a COG triggers inclusion of all related COG components.

---
