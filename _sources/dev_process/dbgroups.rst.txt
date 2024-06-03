Databases with Specific Features
###################################

All DB’s for testing should be on version `6.8.03.`


**Commonly used databases:**
    It’s alright to use these databases for testing, just know that they are very likely to have been tested on previously and to check if it’s already been tested on.

- Any KU databases.

**Databases with known issues:**

* fwri
* geology
* kuvertpaleo1_11_23

**DO NOT MODIFY:**

* all_discipline_defaults (use as reference for default disciplines)
* geology
* geneva_confidential

Databases on the test panel with…
=====================================

Multiple Collections
-----------------------
* All eurl databases (2).
* All KU_Fish/kufish databases (4).
* All nbm databases (2).
* All ohio databases (3).
* aafc2_22 (4)
* aafc_aac_3_8_23 (4)
* balearicls (3)
* botany_demo (2)
* bulgaria_iber_4_11_24 (7)
* bulgaria_nmnhs_4_11_24
* calvertmarinemuseum (5)
* ciscollections_2_15_2024 (10)
* east_london_museum_2_9_24 (2)
* Fitz_NHMA_Oct_2023 (6)
* Fitz_NHMD_Oct_2023 (18)
* fwri_1_9_2024 (2)
* hujinnhc_9_6_23 (25)
* jerusalem_with_changes_2_19 (15)
* KUHerps_8_17_23 (3)
* kumam_barcodes (2)
* KUVertPaleo_5_16_2024 (3)
* ojsmnh_1_10_24 (9)
* SAIAB_11_24_23 (14)
* sdnhm_herps_2_8_24 (5)
* sp7demofish_2_9_24 (3)
* UFRGS_2_1_24 (8)

Default Forms
-----------------
    Note: GEOLocate Plugin is on every default locality form. Collection Object Attribute is on all non-paleontology default forms.

* Balearicls
    * DNA&Tissue
    * Invertebrates
* bulgaria_iber_4_11_24
    * All collections except for Invertebrate and Mycology
* bulgaria_nmnhs_4_11_24
    * All collections except for Vascular plant collection and Ichthyology
* eurl_2_27_24
    * Host Plants
* KUHerps_8_17_23
    * Digital Archive
    * Observation
* KUPaleoBot_8_31_2023
* UFRGS_2_1_24
    * All except for Ichthyology and Ichthyology photos

Collection Object Attribute
------------------------------
* All KU_Fish/kufish databases.
* aafc2_22
* aafc _aac_3_8_23
* Balearicls
* botany_demo
    * Vascular Plants
* bulgaria_iber_4_11_24
    * Invertebrate
    * Vertebrate
* bulgaria_nmnhs_4_11_24
    * All except for Lichen, Paleobotany, Paleozoology, and Vascular plant
* CollegeofIdaho
* east_london_museum_2_9_24
* Fitz_NHMA_Oct_2023
* Fitz_NHMD_Oct_2023
    * All except for paleontology and botany collections
* fwri_1_9_2024
* herb_rgbe_2_5_2024
* hujinnhc_9_6_23
    * All except for CryoBank, Lichens, Phytopathogenic and Vascular Plants
* jerusalem_with_changes_2_19
    * All except for botany collections, CryoBank and Osteology
* KUBirds_8_25_23
* KUHerps_8_17_23
* kumam_barcodes
* KUVascularPlants_4_16_24
* lsumz_mammals_4_25_24
* mcnb_6_29_23_202307082235
* montreal_canadian_cloud_backup
* nbm_08_post_most_changes
* ojsmnh_1_10_24
* PriPaleo_SchemaUpdated_CM_202304211540
    * Invertebrate Paleontology
* SAIAB_11_24_23
* sdnhm_herps_2_8_24
* sp7demofish_2_9_24
* UFRGS_2_1_24
    * All except for Hemiptera, Ichthyology and Ichthyology photos
* umherb_1_10_24

Shared Collecting Events
----------------------------
    Note: Since embedded event is default for all forms except Ichthyology, if the DB/Collection is not on this list, it’s most likely embedded.

* All KU_Fish/kufish databases.
* All ohio databases.
* bulgaria_nmnhs_4_11_24
    * Ichthyology
* east_london_museum_2_9_24
    * Malacology
* Fitz_NHMA_Oct_2023
    * Fresh water
    * Monitoring
* Fitz_NHMD_Oct_2023
    * Ichthyology
* fwri_1_9_2024
* hujinnhc_9_6_23
* jerusalem_with_changes_2_19
    * KUVascularPlants_4_16_24
* nbm_08_post_most_changes
    * Fish Voucher Collection
* ojsmnh_1_10_24
* SAIAB_11_24_23
* sp7demofish_2_9_24
    * KUFishVoucher
* UFRGS_2_1_24
    * Ichthyology

Embedded Paleo Context
-------------------------
* ChadronTest (Locality)
* ciscollections_2_15_2024 (Collection Object)
    * Anthro
        * Note: Anthro does not have Paleo Context in its forms.
    * Fossils
    * Rocks
* Fitz_NHMD_Oct_2023 (Collection Object)
    * Danekrae
    * Quaternary Zoology
    * Vertebrate Paleontology
* KUVertPaleo_5_16_2024 (Collection Object)

Shared Paleo Context
------------------------
* bulgaria_iber_4_11_24 (Collecting Event)
    * Fossil Mammal
    * Palaeobotany
* bulgaria_nmnhs_4_11_24 (Collecting Event)
    * Paleobotany
    * Paleozoology
* ChadronTest2 (Locality)
* calvertmarinemuseum (Collection Object)
    * Casts
    * Invertebrates
    * Vertebrates
* Fitz_NHMD_Oct_2023 (Collecting Event)
    * Invertebrate Paleontology
    * Micropaleontology
* hujinnhc_9_6_23 (Collecting Event)
    * Cryobank
* jerusalem_with_changes_2_19 (Collecting Event)
    * Cryobank
    * Osteology
* KUPaleoBot_8_31_2023 (Collecting Event)
* ojsmnh_1_10_24 (Locality)
    * Fossil Invertebrates
    * Fossil Plants
    * Fossil Vertebrates
* PriPaleo_SchemaUpdated_CM_202304211540 (Collecting Event)

CollectionRelOneToMany Plugin
--------------------------------
* All KU_Fish/kufish databases.
    * KU Fish Voucher Collection
* KUFish_5_16_23 (in addition to above)
    * KU Fish Observation Collection
* SAIAB_11_24_23
    * All except for BRUV Fish, Invertebrate Imagery, Non-fish Illustrations, and Tissue Collection
    * In the National Fish Collection, ofer and roger accounts have 2.
    * Known issue: Trying to add a record to the Collection Relationship plugin results in a ProgrammingError.
* sp7demofish_2_9_24
* KUFishVoucher

HostTaxon Plugin
-------------------
    Note: Most HostTaxon plugins are on the Collecting Information/Event form.

* All eurl databases.
* jerusalem_with_changes_2_19
    * Fungi
    * Lichens
* KUFish_5_16_23
    * KU Fish Observation Collection
* ojsmnh_1_10_24
    * Fossil Invertebrates
    * Fossil Plants
    * Note: Plugin is in the Collecting Event Attribute form for both Fossil Invertebrates and Fossil Plants, but only Fossil Invertebrates has CeA on a reachable form.
* SAIAB_11_24_23
* BRUV Fish
    * Invertebrate Imagery

Paleomap Plugin
--------------------
    Notes: Use the PaleoMapTest query to find Collection Objects it can be used with in these collections. This section only lists collections that are ready to be tested. Some collections may be missing some data for PaleoMap to work, so while it is in the forms, they are not listed.

    Additionally, PaleoMap is currently broken, but not on our end. Just make sure it brings up a dialog named PaleoMap that has nothing except a close button.

* bulgaria_iber_4_11_24
    * Fossil Mammal
    * Palaeobotany
* bulgaria_nmnhs_4_11_24
    * Paleozoology
* calvertmarinemuseum
    * Invertebrates
    * Vertebrates
* ChadronTest
* KUPaleoBot_8_31_2023
* PriPaleo_SchemaUpdated_CM_202304211540

RSS Feed
----------
    Note: Many of these have not been tested.

* All KU_Fish/kufish databases.
* bulgaria_nmnhs_4_11_24
* Fitz_NHMA_Oct_2023
* Fitz_NHMD_Oct_2023
* fwri_1_9_2024
* KUBirds_8_25_23
* KUVascularPlants_4_16_24
* lsumz_mammals_9_8_2023
* montreal_canadian_cloud_backup
* SAIAB_11_24_23
    * Known Issue: Currently has an issue where the feed does not export.
* sdnhm_herps_2_8_24
