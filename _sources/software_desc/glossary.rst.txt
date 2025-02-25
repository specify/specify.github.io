Glossary
#############

Specify-defined terms


.. glossary::

  Algorithm
    An algorithm is a procedure or formula for solving a problem.  There are  multiple
    algorithms for computing Species Distribution Models (SDM) which
    define the relationship between a set of points and the environmental values
    at those points.

  Container
    A :term:`Docker` instance which runs as an application on a :term:`Host machine`.
    The Docker container contains all software dependencies required by the programs it
    will run.

  CSV
    CSV (Comma Separated Values) is a file format for records, in which fields are
    separated by a delimiter.  Commas and tabs are common, but other characters may
    be used as delimiters.

  Data Catalog
    The Specify database of tables and fields containing all data related to one or
    more Collections.

  Data Validation
    Testing processes to run on data values ensuring that they meet the conditions
    defined for the field, table, and database.  This could include data type,
    formatting, content restrictions such as a controlled vocabulary, numeric range,
    or existence of an database identifier.

  Docker
    Docker is an application which can run on Linux, MacOSX, or Windows.  With a
    Docker-ized application, such as this tutorial, a user can run the application on
    their local machine in a controlled and sequestered environment, with a set of
    dependencies that may not be easy, allowed, or even available for their local
    machine.

  Docker image
    A Docker-ized application, built into a single package, with all required
    software dependencies and files.

  DwCA
    DwCA (Darwin Core Archive) is a packaged dataset of occurrence records in `Darwin
    Core standard <https://www.tdwg.org/standards/dwc/>`_ format, along with metadata
    about the contents.

  Host machine
    A physical or virtual machine on which Docker can be run.

  Mapped Spreadsheet
    A spreadsheet that has a mapping document that matches spreadsheet columns to
    Specify database fields.

  Mapping Template
    A document that matches terms in a :term:`Mapped Spreadsheet` to fields in the
    Specify database.

  Occurrence
    An occurrence is a record of a specimen occurrence including metadata about the
    specimen and the spatial location where it was found.

  Occurrence Data
    Point data representing specimens collected for a single species or taxon.  Each
    data point
    contains a location, x and y, in some known geographic spatial reference system.

  Tree
    A Tree is a set of hierarchical data.  Several tables in Specify are defined as
    trees:  Taxonomy, Geography, Storage Location.
