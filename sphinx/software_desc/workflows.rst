Common Workflows
##################

Field collection of specimens
******************************************

Specify contains a table for Permits, which can be configured at the Institution level
to be associated with **Accession**, **Collecting Event**, or **Collecting Trip**
("Permit Associated Record") allowing the user to document permits
acquired for collecting and cataloging specimens.  Either the Permit or the
Permit Associated Record can be created first, and either can be linked to an
existing record.

:ref:`WB field collection`<Using the Specify Workbench for Field Collection>

More information on our Workbench application is available here:
https://discourse.specifysoftware.org/t/the-specify-7-workbench/540

Object entry
******************************************
The user has three ways to document information pre-cataloging: 1) record the data in the Specify Workbench, 2) enter it into the database and mark it as different from cataloged data, or 3) put the data into a separate collection and bring the data back over once it is ready to be cataloged.
If the data is in the Workbench, it is segregated from queries and exports, search boxes which search for existing records to match (such as Agent or Taxon records) do not find this information.  However, that means it may not be linked to Loans or any other interactions.
A user can have multiple active, not uploaded datasets, but datasets are uploaded as a file, meaning all items in a dataset are uploaded at the same time.  If you have cataloged only a portion of the items in the dataset, you will either have to wait for the rest to be cataloged before uploading or move the uncataloged records to another dataset.
If the data is added to the database but marked as separate, the data would be included in any search box searches and could be included in Loans or other Interactions.  The data could be excluded from queries or data exports by adding the field used to mark it as separate.  The user could have a checkbox field to indicate if it is cataloged, or use the lack of a catalog number as an indicator.
If the data is added to a separate collection in the same database, the data would be completely separate from the cataloged data, but could be treated as a collection object, meaning all database and curatorial treatments could be documented.  A script could be set to run automatically to bring the data over from the separate collection to the cataloged collection, ideally using the Specify API, each night for records that meet a requirement, such as a catalog number has been added, indicating it has been cataloged.
Each of these approaches to pre-cataloged data has been successfully used by existing SCC members.

Acquisition and accessioning
******************************************
Specify contains an Accession table for documenting the accession of
objects and groups of objects.  The Accession table links to the Collection Object
table and Permit table allowing the user to document metadata about the accession such
as date, agents involved, and permits included, as well as the objects brought in under
that Accession.

The Specify Workbench can ingest a large dataset at one time, and can accepted
pre-assigned Catalog Numbers or automatically assign them.

A status field can be added (Under Registration, Awaiting proof-reading, etc.).
Users can create an unlimited number of unique label templates for individual or bulk
printing, then print one or more labels for one or more objects.

With the introduction of our Batch Edit tool, due in the second quarter of 2025, users
may change the status of many records at a time.

One or more Preparation objects can be assigned to a Collection Objects and Storage
Location information may be documented for each Preparation.  For example, the Ethanol
preparation of a specimen may be kept in a different facility than the tissue(s) or
the skeleton.



Location and movement control
******************************************
Storage location information is a tree, which is a hierarchical relationship between
storage values.  Default levels are Building, Collection, Room, Aisle, Cabinet, Shelf,
Box, Rack, Vial, but users can define what levels they want in their Storage tree.  An
entire section of the storage location tree may be moved to a different parent location
(for example, a box may be moved to another shelf) to reduce the possibility of errors.
Storage locations have names and unique identifiers.

Storage Locations are associated with Preparations.  Each preparation may have a
different storage location.  A preparation may have a temporary storage location in
addition to its standard storage location.

The SCC is currently gathering requirements for documenting the cold-chain, including
the history of where an object has been stored, at what temperature, start and end times, moved-by, and approved-by.


Cataloguing
******************************************

Loans in (borrowing objects)
******************************************

Loans out (lending objects)
******************************************

Use of collections
******************************************

Condition checking and improvement
******************************************

Deaccessioning and disposal
******************************************

