Specify Cloud Hosting
#######################

Database
************
Collection databases within each institution may be organized in different ways
relative to each other. Research and planning are required to decide on an
institutional database configuration, and SCC staff will advise on the differences
between various options. Institutions may choose to combine data from multiple
collections into a single Specify database, where they can share some data elements. Or
they may choose to isolate the data of individual collections into discrete databases
with no data sharing between them. Institutional requirements and preferences inform
such decisions and affect pricing, data reuse and standardization, data backup regimes,
user roles and permissions, and more.

SCC members choose whether to host databases in the SCC Cloud service, or on local
servers. The Specify Cloud hosting service includes automatic updates of Specify and
constituent software, daily database backup, and 24/7 server status monitoring.

As specified in the Specify Consortium Member Agreement, SCC has no legal interest in
members' data and abides by any member restrictions on our access for technical support
purposes.

SCC will provide full, root, access to the Buyer databases for Buyer member staff.

Specify Cloud uses Amazon Web Services (AWS) to host databases.

The Buyer cost for Specify Cloud database hosting will depend on the number of
independent Specify databases needed. (A single database may include data from one or
more collections.) SCC currently charges $275 USD/year/database with a $300 one-time
setup fee. We project cloud hosting costs will increase over the next five years due to
expected increases in hosting provider (AWS) pricing. Including estimated average
annual increases in AWS pricing, SCC annual database hosting fees would be as shown.

.. csv-table:: Specify Cloud Database Hosting
   :file: hosting_db.csv
   :widths: 30, 20
   :header-rows: 1

*Numbers beyond Year 1 are estimates

For a nominal cost, the SCC can set up “sandbox” Specify database instances for member
staff to test migrations, updates, and to practice workflows before opening user access
to a production database.

Digital Assets
****************

Members may choose Specify Cloud to host their digital assets (files linked to database
records), or if they would prefer to host them themselves. Even if a member chooses
Specify Cloud hosting for their database, they may self-host collection-linked digital
assets.

Amazon’s Simple Storage Service (S3) Standard is used for asset hosting and the S3
Glacier Deep Archive is employed for asset backups. AWS pricing varies widely based on
usage, including adding, listing, viewing, querying, and downloading assets.  With very
large quantities of data, SCC is unable to provide definitive quote for the cost per
year without information about asset usage levels and desired backup strategy.
Our cost structure for asset hosting is to pass-through actual AWS S3 charges adding
7.5% for Specify management and maintenance.

