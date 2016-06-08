# NDD Docker Sphinx

A Docker image for the [Sphinx documentation](http://sphinx-doc.org) builder.

The image is based upon the official [python:2.7](https://hub.docker.com/_/python/).

The image contains:

- The Sphinx documentation builder ([sphinx-doc](http://sphinx-doc.org))
- The Sphinx documentation watcher ([sphinx-autobuild](https://github.com/GaretJax/sphinx-autobuild))
- The Sphinx documentation themes ([sphinx-themes](http://docs.writethedocs.org/tools/sphinx-themes))
- A reStructuredText to PDF converter ([rst2pdf](https://github.com/rst2pdf/rst2pdf))
- A Markdown to reStructuredText converter ([recommonmark](https://github.com/rtfd/recommonmark))
- The following pluggins:
    - sphinx.ext.graphviz
    - [sphinx-prompt](https://pypi.python.org/pypi/sphinx-prompt)
    - [sphinxcontrib-actdiag](https://pypi.python.org/pypi/sphinxcontrib-actdiag)
    - [sphinxcontrib-blockdiag](https://pypi.python.org/pypi/sphinxcontrib-blockdiag)
    - [sphinxcontrib-exceltable](https://pypi.python.org/pypi/sphinxcontrib-exceltable)
    - [sphinxcontrib-googleanalytics](https://pypi.python.org/pypi/sphinxcontrib-googleanalytics)
    - [sphinxcontrib-googlechart](https://pypi.python.org/pypi/sphinxcontrib-googlechart)
    - [sphinxcontrib-googlemaps](https://pypi.python.org/pypi/sphinxcontrib-googlemaps)
    - [sphinxcontrib-libreoffice](https://pypi.python.org/pypi/sphinxcontrib-libreoffice)
    - [sphinxcontrib-nwdiag](https://pypi.python.org/pypi/sphinxcontrib-nwdiag)
    - [sphinxcontrib-plantuml](https://pypi.python.org/pypi/sphinxcontrib-plantuml)
    - [sphinxcontrib-seqdiag](https://pypi.python.org/pypi/sphinxcontrib-seqdiag)


## Installation

### From source

```
git clone git@bitbucket.org:ndd-docker/sphinx-doc.git
cd sphinx-doc
docker build -t ddidier/sphinx-doc .
```

### From Docker Hub

```
docker pull ddidier/sphinx-doc
```



## Usage

The documentation directory on the host `<HOST_DOC_DIR>` must be mounted as a volume under `/doc` in the container.

Use `-v <HOST_DOC_DIR>:/doc` to use a specific documentation directory or `-v $(spec):/doc` to use the current directory as the documentation directory.

Sphinx is executed by the user `sphinx-doc` belonging to the group of the `<HOST_DOC_DIR>` directory. All new files will thus belong to this group.

### Initialisation

Sphinx provides the [`sphinx-quickstart`](http://sphinx-doc.org/invocation.html) script to create a skeleton of the documentation directory. You should however use the provided `sphinx-init` script which first calls `sphinx-quickstart` then configures the provided extensions.

```
docker run -i -t -v <HOST_DOC_DIR>:/doc ddidier/sphinx-doc sphinx-init
```

All arguments accepted by [`sphinx-quickstart`](http://sphinx-doc.org/invocation.html) are passed to `sphinx-init`. For example:

```
docker run -i -t -v <HOST_DOC_DIR>:/doc ddidier/sphinx-doc sphinx-init --project my-documentation
```

### Interactive

```
docker run -i -t -v <HOST_DOC_DIR>:/doc ddidier/sphinx-doc
```

You should now be in the `/doc` directory, otherwise just `cd` to `/doc`.

To create a new Sphinx project, call `sphinx-init`.

To create HTML documents, call `make html`.

To create a PDF document, call `make pdf`.

To watch for changes and create HTML documents dynamically, call `make livehtml` with a port binding:

```
docker run -i -t -v <HOST_DOC_DIR>:/doc -p 8000:8000 ddidier/sphinx-doc make livehtml
```

To trigger a full build while in watch mode, issue from the `<HOST_DOC_DIR>` folder:

```
rm -rf build && touch source/conf.py
```

### Non interactive

```
docker run -i -v <HOST_DOC_DIR>:/doc ddidier/sphinx-doc make html
docker run -i -v <HOST_DOC_DIR>:/doc ddidier/sphinx-doc make pdf
```



## Configuration

Enable some extensions in your `conf.py`:

```python
extensions = [
    'rst2pdf.pdfbuilder',
    'sphinx.ext.graphviz',
    'sphinx.ext.ifconfig',
    'sphinx.ext.mathjax',
    'sphinx.ext.todo',
    'sphinxcontrib.actdiag',
    'sphinxcontrib.blockdiag',
    'sphinxcontrib.exceltable',
  # 'sphinxcontrib.googleanalytics',
    'sphinxcontrib.googlechart',
    'sphinxcontrib.googlemaps',
  # 'sphinxcontrib.libreoffice',
    'sphinxcontrib.nwdiag',
    'sphinxcontrib.packetdiag',
    'sphinxcontrib.plantuml',
    'sphinxcontrib.rackdiag',
    'sphinxcontrib.seqdiag',
]
```

To use Markdown inside of Sphinx, add this to your `conf.py`:

```python
from recommonmark.parser import CommonMarkParser

source_parsers = {
    '.md': CommonMarkParser,
}

source_suffix = ['.rst', '.md']
```

This allows you to write both `.md` and `.rst` files inside of the same project.
