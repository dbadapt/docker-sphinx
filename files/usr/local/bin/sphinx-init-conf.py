




# == NDD DOCKER SPHINX - OVERRIDE ============================================

# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom ones.
extensions = [
    'sphinx.ext.graphviz',
    'sphinx.ext.ifconfig',
    # 'sphinx.ext.imgmath',
    'sphinx.ext.mathjax',
    'sphinx.ext.todo',

    'sphinx-prompt',

    'sphinxcontrib.actdiag',
    'sphinxcontrib.blockdiag',
    'sphinxcontrib.excel_table',
  # 'sphinxcontrib.googleanalytics',
  # 'sphinxcontrib.googlechart',
  # 'sphinxcontrib.googlemaps',
    'sphinxcontrib.nwdiag',
    'sphinxcontrib.packetdiag',
    'sphinxcontrib.plantuml',
    'sphinxcontrib.rackdiag',
    'sphinxcontrib.seqdiag',
]

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
html_theme = 'sphinx_rtd_theme'

# If true, 'todo' and 'todoList' produce output, else they produce nothing.
todo_include_todos = True

# -- Markdown ----------------------------------------------------------------
# http://www.sphinx-doc.org/en/stable/usage/markdown.html

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
source_suffix = ['.rst', '.md']

from recommonmark.parser import CommonMarkParser

source_parsers = {
    '.md': CommonMarkParser,
}
