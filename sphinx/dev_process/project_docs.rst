Project (Github pages) documentation
############################################

Install Configure Sphinx
=============================

Create or activate a virtual python environment for the project::

  python3 -m venv venv
  ./venv/bin/activate

Create a requirements-doc.txt file with sphinx and myst-parser (for Markdown parsing)
like `requirements-docs.txt <../../requirements-docs.txt>`_, then install the
requirements::

  pip install -r requirements-docs.txt

Create a directory to contain documentation (in our example, **sphinx**), cd to that directory,
then run sphinx-quickstart.  This will create the files conf.py, index.rst, and make.bat.
It will also create a destination directory (the default is **_build**) for generated
html::

  cd sphinx
  sphinx-quickstart

Edit the conf.py file similar to
`conf.py <../conf.py>`_


Edit Documentation and View
=============================

Add documentation in the documentation directory.

Write all documents in ReStructured
Text or Markdown (The requirements-docs.txt should contain both sphinx and myst-parser
to handle each format.  Organize in logical subdirectories.

Each document must contain only one top-level title, which will be displayed in the
Table of Contents.  Any number of sub-level headings may be included in each document.

Edit the index.rst file to include page names under the Table of Contents (toctree).
These should include paths relative to the documentation directory, and filenames
without extension, similar to `index.rst <../index.rst>`_.  The :maxdepth parameter
indicates how many sublevels will be displayed in the Table of Contents.  Only if there
are very few pages should :maxdepth be more than 1.

In the documentation directory, run the following to build pages locally and check
formatting.  The command will build documentation and print errors and warnings
in the terminal output.  Run this prior to pushing to Github::

  make html

Publish as Github Pages Site
================================

On Github, Create Repository for Pages site
-----------------------------------------------

https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site

Create a new or use an existing github.io repository for the user/organization
containing this repository to be publicly documented.

<organization>.github.io

If the organization site already exists, you can publish github pages to a subdirectory
under the existing site, i.e. <organization>.github.io/<project>

Go to settings of the new repository, under Code and Automation, select Pages

For Github Action, add YAML configuration files
----------------------------------------------------

Create a yaml file to initiate a github action with a file in ./.github/workflows, like
`build_sphinx_docs.yml <../../.github/workflows/build_sphinx_docs.yml>`_.

TODO: test this after setup branch to publish from
------------------------------------------------------

Add `<.readthedocs.yaml <../../.readthedocs.yaml>`_ and
`environment.yml <../../environment.yml>`_ for the build.  This will ensure that the
dependencies are installed and that index.html page will be the landing site.

Set Pages Site to branch created by Github action
--------------------------------------------------------

After the code is pushed to github, and the action completes successfully, a branch will
be created.  In the example build_sphinx_docs.yml, it is named gh-pages.  Under the
Settings/Code and Automation/Pages form, choose the new branch (in our example,
**gh-pages**)

