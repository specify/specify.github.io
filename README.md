# Specify Internal Documentation

This repository contains our internal documentation for Specify Collections Consortium staff.

This site uses [Sphinx](https://www.sphinx-doc.org/en/master/) as a framework and is built using `github-pages`. You can view the [deployment history here](https://github.com/specify/specify.github.io/deployments/github-pages).



## Contribution Guidelines
- Do **not commit** sensitive information. This is a public repository.
- Docs that are useful or relevant to users of Specify should instead be pushed to the [**Speciforum**](discourse.specifysoftware.org), not this repository.
- Docs added to this repository should be removed from their original location (e.g. Google Drive, ResFS, OneDrive, etc.) after it is committed.
- Be kind, considerate, and thoughtful.

## Contribute

Contribution for this repository is limited only to SCC staff.

1. Clone the repository

    ```bash
    gh repo clone specify/specify.github.io
    ```

2. Create a new `.md` or `.rst` file under the appropriate directory (e.g. `server_management`, `testing`, `security`, etc.) or create a new directory to begin a new category.

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

    For example, I may want to add `reports.md` to the repository under `server_management`, so I would add this below like so:

    ```bash
    └── sphinx
        └── server_management
            ├── check_asset_usage.md
            └── reports.md
    ```

3. Preview, proofread, and double-check your document for accuracy. Once saved, the file will be available at this URL (after the base domain)

    ```
    /server_management/reports.html
    ```

4. You can add this to the sidebar and homepage by adding it to the `index.rst` file in the `./sphinx/` directory under the appropriate category. You just need to add the path to your file within that directory minus the file extension (no `.md` or `.rst`).

    If the category you want does not yet exist, you can add a new one in the same format and structure as the others.

    ```rst
    .. toctree::
    :maxdepth: 1
    :caption: Server Management:

    server_management/check_asset_usage
    server_management/reports
    ```

5. Save and commit to the `main` branch of this repository on GitHub. GitHub will automatically update the pages site (https://specify.github.io/) within minutes and the document will be available publicly.