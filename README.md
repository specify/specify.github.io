# Specify Internal Documentation

This repository contains our internal documentation for Specify Collections Consortium staff.

This site uses [Sphinx](https://www.sphinx-doc.org/en/master/) as a framework and is built using `github-pages`. You can view the [deployment history here](https://github.com/specify/specify.github.io/deployments/github-pages).

## Contribution Guidelines
- Do **not commit** sensitive information. This is a public repository.
- Docs that are useful or relevant to users of Specify should instead be pushed to the [**Speciforum**](discourse.specifysoftware.org), not this repository.
- Docs added to this repository should be removed from their original location (e.g. Google Drive, ResFS, OneDrive, etc.) after it is committed.
- Be kind, considerate, and thoughtful.

## Setup and Installation

### Install and Configure Sphinx

Create or activate a virtual Python environment for the project:

```bash
python3 -m venv venv
source venv/bin/activate
```

Install the requirements which include Sphinx and myst-parser (for Markdown parsing):

```bash
pip install -r requirements-docs.txt
```

The `requirements-docs.txt` file contains both Sphinx and myst-parser to handle ReStructuredText and Markdown formats.

### Initial Sphinx Setup

If setting up Sphinx for the first time, create a directory to contain documentation (in our case, `sphinx`), cd to that directory, then run `sphinx-quickstart`. This will create the files `conf.py`, `index.rst`, and `make.bat`. It will also create a destination directory (the default is `_build`) for generated HTML:

```bash
cd sphinx
sphinx-quickstart
```

Edit the `conf.py` file similar to our existing [conf.py](sphinx/conf.py).

## Run Locally

To run Sphinx locally and build the documentation:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements-docs.txt
cd sphinx
make html
```

Each time you make a change, you'll need to run `make html` again from the `sphinx` directory. You should see a list of warnings in the terminal each time to indicate potential issues in the repository. Run this prior to pushing to GitHub:

```bash
checking consistency... /Users/g584f396/GitHub/specify.github.io/sphinx/aws/aws_authentication.rst: WARNING: document isn't included in any toctree [toc.not_included]
```

You can access the built documentation by opening the `index.html` file in your browser (e.g. 
`file:///Users/g584f396/GitHub/specify.github.io/sphinx/_build/html/index.html`).

## Writing and Editing Documentation

### Documentation Format

Write all documents in ReStructuredText (.rst) or Markdown (.md) format. The requirements include both Sphinx and myst-parser to handle each format. Organize documents in logical subdirectories within the `sphinx` folder.

### Important Guidelines

- Each document must contain only one top-level title, which will be displayed in the Table of Contents
- Any number of sub-level headings may be included in each document
- Edit the `index.rst` file to include page names under the Table of Contents (toctree)
- Include paths relative to the documentation directory, and filenames without extension
- The `:maxdepth:` parameter indicates how many sublevels will be displayed in the Table of Contents
- Only if there are very few pages should `:maxdepth:` be more than 1

### Building and Testing

In the documentation directory, run the following to build pages locally and check formatting. The command will build documentation and print errors and warnings in the terminal output:

```bash
make html
```

## GitHub Pages Publishing

### Repository Setup

This repository uses GitHub Pages for automatic deployment. The site is published to https://specify.github.io/ using GitHub Actions.

### GitHub Actions Configuration

The repository uses a GitHub Action configured in `.github/workflows/build_sphinx_docs.yml` to automatically build and deploy the documentation when changes are pushed to the main branch.

### Deployment Process

1. When code is pushed to GitHub, the GitHub Action runs automatically
2. Sphinx builds the documentation
3. The built site is deployed to the `gh-pages` branch
4. GitHub Pages serves the content from this branch
5. The site is available at https://specify.github.io/ within minutes


## Contribute

Contribution for this repository is limited only to SCC staff.

### Step-by-Step Contribution Process

1. **Clone the repository**

    ```bash
    gh repo clone specify/specify.github.io
    ```

2. **Create a new document**
   
   Create a new `.md` or `.rst` file under the appropriate directory (e.g. `server_management`, `testing`, `security`, etc.) or create a new directory to begin a new category.

    ```bash
    ├── LICENSE
    ├── README.md
    ├── environment.yml
    ├── requirements-docs.txt
    └── sphinx
        ├── Makefile
        ├── asset_server
        ├── aws
        ├── conf.py
        ├── dev_process
        ├── dwc_alignment
        ├── index.rst
        ├── make.bat
        ├── misc
        ├── processes
        ├── scripts
        ├── security
        ├── server_management
        ├── software_desc
        └── testing
    ```

    For example, to add `reports.md` to the repository under `server_management`:

    ```bash
    └── sphinx
        └── server_management
            ├── check_asset_usage.md
            └── reports.md
    ```

3. **Add to Table of Contents**
   
   Add your document to the sidebar and homepage by editing the `index.rst` file in the `./sphinx/` directory under the appropriate category. Add the path to your file within that directory minus the file extension (no `.md` or `.rst`).

    If the category you want does not yet exist, you can add a new one in the same format and structure as the others.

    ```rst
    .. toctree::
       :maxdepth: 1
       :caption: Server Management:

       server_management/check_asset_usage
       server_management/reports
    ```

4. **Preview and test locally**
   
   Before committing, preview, proofread, and double-check your document for accuracy:

    ```bash
    cd sphinx
    make html
    ```

    Once saved, the file will be available at this URL pattern (after the base domain):

    ```
    /server_management/reports.html
    ```

5. **Commit and deploy**
   
   Save and commit to the `main` branch of this repository on GitHub. GitHub will automatically update the pages site (https://specify.github.io/) within minutes and the document will be available publicly.

### Content Guidelines

- Ensure your documentation follows the contribution guidelines at the top of this README
- Remove documents from their original location (Google Drive, ResFS, OneDrive, etc.) after committing to this repository
- Test your changes locally before pushing to ensure proper formatting and no build errors