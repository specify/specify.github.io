# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'Specify Developer Documentation'
copyright = '2025, Specify Collections Consortium Team'
author = 'Specify Collections Consortium Team'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    # 'sphinx.ext.autodoc',
    # 'sphinx.ext.doctest',
    'sphinx.ext.intersphinx',
    # 'sphinx.ext.todo',
    # 'sphinx.ext.coverage',
    'sphinx.ext.viewcode',
    'sphinx.ext.githubpages',
    # 'sphinx.ext.napoleon',
    'sphinx_rtd_theme',
    # 'autoapi.extension',
    'myst_parser',  # For MD support
    # for internal links
    'sphinx.ext.autosectionlabel',
]


templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
# html_theme = 'alabaster'
html_static_path = ['_static']
master_doc = 'index'