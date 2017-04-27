# NDD Docker Sphinx

A Docker image for the [Sphinx documentation](http://sphinx-doc.org) builder.

The image is based upon the official [python:2.7](https://hub.docker.com/_/python/).

Besides the Sphinx documentation builder ([sphinx-doc](http://sphinx-doc.org)), this image contains:

- LaTeX to generate PDF documents and math images
- [alabaster](https://pypi.python.org/pypi/alabaster)
- [livereload](https://pypi.python.org/pypi/livereload)
- [recommonmark](https://pypi.python.org/pypi/recommonmark)
- [sphinx-bootstrap-theme](https://pypi.python.org/pypi/sphinx-bootstrap-theme)
- [sphinx-prompt](https://pypi.python.org/pypi/sphinx-prompt)
- [sphinx-rtd-theme](https://pypi.python.org/pypi/sphinx_rtd_theme)
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

```shell
git clone git@bitbucket.org:ndd-docker/ndd-docker-sphinx.git
cd ndd-docker-sphinx
docker build -t ddidier/sphinx-doc .
```

### From Docker Hub

```shell
docker pull ddidier/sphinx-doc
```



## Usage

The documentation directory on the host `<HOST_DATA_DIR>` must be mounted as a volume under `/doc` in the container. Use `-v <HOST_DATA_DIR>:/doc` to use a specific documentation directory or `-v $(pwd):/doc` to use the current directory as the documentation directory.

Sphinx will be executed by the `sphinx-doc` user which is created by the Docker entry point. You **must** pass to the container the environment variable `USER_ID` set to the UID of the user the files will belong to. For example ``-e USER_ID=`id -u $USER` ``.

### Initialisation

Sphinx provides the [`sphinx-quickstart`](http://sphinx-doc.org/invocation.html) script to create a skeleton of the documentation directory. You should however use the provided `sphinx-init` script which first calls `sphinx-quickstart` then configures the provided extensions.

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc sphinx-init
```

All arguments accepted by [`sphinx-quickstart`](http://sphinx-doc.org/invocation.html) are passed to `sphinx-init`. For example:

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc sphinx-init --project my-documentation
```

### Interactive

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc
```

You should now be in the `/doc` directory, otherwise just `cd` to `/doc`.

To create a new Sphinx project, call `sphinx-init`.

To create HTML documents, call `make html`.

To create a PDF document, call `make pdf`.

To watch for changes and create HTML documents dynamically, call `make livehtml` with a port binding:

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -p 8000:8000 -e USER_ID=`id -u $USER` ddidier/sphinx-doc make livehtml
```

To trigger a full build while in watch mode, issue from the `<HOST_DATA_DIR>` folder:

```shell
rm -rf build && touch source/conf.py
```

### Non interactive

```shell
docker run -i -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc make html
docker run -i -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc make pdf
```



## Configuration

### Enable an extension

To enable an already installed extension, uncomment the line in your `conf.py`:

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

### Install an extension

To install a new extension, first extend the `Dockerfile`:

```docker
FROM ddidier/sphinx-doc:latest

RUN pip install 'a-sphinx-extension       == A.B.C' \
                'another-sphinx-extension == X.Y.Z'
```

Then add a line in your `conf.py`:

```python
extensions = [
    'rst2pdf.pdfbuilder',
    ...
    'a.sphinx.extension',
    'another.sphinx.extension',
]
```

### Enable Markdown

To use Markdown inside of Sphinx, add this to your `conf.py`:

```python
from recommonmark.parser import CommonMarkParser

source_parsers = {
    '.md': CommonMarkParser,
}

source_suffix = ['.rst', '.md']
```

This allows you to write both `.md` and `.rst` files inside of the same project.
