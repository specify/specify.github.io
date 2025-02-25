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

SCC recommends sending researchers out into the field with a spreadsheet that has a
"Mapping Template" that matches spreadsheet columns to Specify database fields.  The
spreadsheet for data entry is referred to as a "Mapped Spreadsheet".
Mapped Spreadsheets can be created for
research expeditions, focusing on data collection specific to that field trip.
Researchers can easily use the spreadsheet in the field to record information about
specimens, collecting event(s), locality, and more.

Data entered into a Mapped Spreadsheet can be imported via the Specify Workbench, a
spreadsheet-based application. In this workflow, the user chooses the correct Mapping
Template, the uploads the Mapped Spreadsheet to the Workbench. At this stage, the
Workbench is completely external to the data catalog.  The Workbench contains
extensive matching and editing features that can be edited to fit user needs.
The Workbench then performs Data Validation on spreadsheet contents before submitting
the data for upload to the Data Catalog. 

It allows the user to bring in bulk
data, match columns to fields in Specify, and perform basic data integrity checks to
ensure the data matches database requirements (data validity, controlled vocabulary
matching, and linked record matching, such as Agent or Taxon records).

Alternatively, a researcher could create a custom spreadsheet and simply create a mapping template before importing data to Specify.

Users first validate the spreadsheet data within the Workbench, then upload the verified data to the database.  Users may be assigned different levels of access to the Workbench functionality, such as permission to validate a dataset with the Workbench, or perform the upload, so different people may verify that the data is sound.

Because Specify 7 is an online software, if there is internet access there is the option to create a dataset directly in the Specify Workbench from the field.  This workflow allows researchers to verify data against database requirements on entry.

More information on our Workbench application is available here: https://discourse.specifysoftware.org/t/the-specify-7-workbench/540

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

Location and movement control
******************************************

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

