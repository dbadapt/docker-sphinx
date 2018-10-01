# NDD Docker Sphinx

<!-- MarkdownTOC -->

1. [Introduction](#introduction)
1. [Installation](#installation)
    1. [From source](#from-source)
    1. [From Docker Hub](#from-docker-hub)
1. [Usage](#usage)
    1. [Initialisation](#initialisation)
    1. [Interactive](#interactive)
    1. [Non interactive](#non-interactive)
1. [Configuration](#configuration)
    1. [Extensions](#extensions)
    1. [Install an extension](#install-an-extension)
1. [Limitations](#limitations)

<!-- /MarkdownTOC -->



<a id="introduction"></a>
## Introduction

A Docker image for the [Sphinx documentation](http://sphinx-doc.org) builder.

The image is based upon the official [python:3.6](https://hub.docker.com/_/python/).

Besides the Sphinx documentation builder ([sphinx-doc](http://sphinx-doc.org)), this image contains:

- [alabaster](https://pypi.python.org/pypi/alabaster)
- [guzzle-sphinx-theme](https://pypi.python.org/pypi/guzzle_sphinx_theme)
- [livereload](https://pypi.python.org/pypi/livereload)
- [sphinx-autobuild](https://pypi.org/project/sphinx-autobuild)
- [sphinx-bootstrap-theme](https://pypi.python.org/pypi/sphinx-bootstrap-theme)
- [sphinx-prompt](https://pypi.python.org/pypi/sphinx-prompt)
- [sphinx-rtd-theme](https://pypi.python.org/pypi/sphinx_rtd_theme)
- [sphinxcontrib-actdiag](https://pypi.python.org/pypi/sphinxcontrib-actdiag)
- [sphinxcontrib-blockdiag](https://pypi.python.org/pypi/sphinxcontrib-blockdiag)
- [sphinxcontrib-excel-table](https://pypi.python.org/pypi/sphinxcontrib-excel-table)
- [sphinxcontrib-fulltoc](https://pypi.org/project/sphinxcontrib-fulltoc)
- [sphinxcontrib-googleanalytics](https://pypi.python.org/pypi/sphinxcontrib-googleanalytics)
- [sphinxcontrib-googlechart](https://pypi.python.org/pypi/sphinxcontrib-googlechart)
- [sphinxcontrib-googlemaps](https://pypi.python.org/pypi/sphinxcontrib-googlemaps)
- [sphinxcontrib-nwdiag](https://pypi.python.org/pypi/sphinxcontrib-nwdiag)
- [sphinxcontrib-plantuml](https://pypi.python.org/pypi/sphinxcontrib-plantuml)
- [sphinxcontrib-seqdiag](https://pypi.python.org/pypi/sphinxcontrib-seqdiag)

The versioning scheme of the Docker image is `<SPHINX_VERSION>-<DOCKER_IMAGE_VERSION>`, e.g. `1.8.1-9` for the 9th version of the Docker image using Sphinx 1.8.1.



<a id="installation"></a>
## Installation

<a id="from-source"></a>
### From source

```shell
git clone git@bitbucket.org:ndd-docker/ndd-docker-sphinx.git
cd ndd-docker-sphinx
docker build -t ddidier/sphinx-doc .
```

<a id="from-docker-hub"></a>
### From Docker Hub

```shell
docker pull ddidier/sphinx-doc
```



<a id="usage"></a>
## Usage

The documentation directory on the host `<HOST_DATA_DIR>` must be mounted as a volume under `/doc` in the container. Use `-v <HOST_DATA_DIR>:/doc` to use a specific documentation directory or `-v $(pwd):/doc` to use the current directory as the documentation directory.

Sphinx will be executed inside the container by the `sphinx-doc` user which is created by the Docker entry point. You **must** pass to the container the environment variable `USER_ID` set to the UID of the user the files will belong to. For example ``-e USER_ID=`id -u $USER` ``.

<a id="initialisation"></a>
### Initialisation

Sphinx provides the [`sphinx-quickstart`](http://sphinx-doc.org/invocation.html) script to create a skeleton of the documentation directory. You should however use the provided `sphinx-init` script which first calls `sphinx-quickstart` then customizes the `Makefile` and the configuration file `conf.py`.

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc sphinx-init
```

All arguments accepted by [`sphinx-quickstart`](http://sphinx-doc.org/invocation.html) are passed to `sphinx-init`. For example:

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc sphinx-init --project my-documentation
```

<a id="interactive"></a>
### Interactive

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc
```

You should now be in the `/doc` directory, otherwise just `cd` to `/doc`.

To create a new Sphinx project, call `sphinx-init`.

To create HTML documents, call `make html`.

To create a PDF document, call `make latexpdf`.

To watch for changes and create HTML documents dynamically, call `make livehtml` with a port binding:

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -p 8000:8000 -e USER_ID=`id -u $USER` ddidier/sphinx-doc make livehtml
```

To trigger a full build while in watch mode, issue from the `<HOST_DATA_DIR>` folder:

```shell
rm -rf build && touch source/conf.py
```

<a id="non-interactive"></a>
### Non interactive

```shell
docker run -i -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc make html
docker run -i -v <HOST_DATA_DIR>:/doc -e USER_ID=`id -u $USER` ddidier/sphinx-doc make latexpdf
```



<a id="configuration"></a>
## Configuration

**Warning: some variables, like the `extensions` variable, are overriden at the end of the `conf.py` file.**

<a id="extensions"></a>
### Extensions

To enable or disable a packaged extension, comment or uncomment the line in your `conf.py`.

<a id="install-an-extension"></a>
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
    ...
    'a.sphinx.extension',
    'another.sphinx.extension',
]
```



<a id="limitations"></a>
## Limitations

- PDF generation does not work when including Markdown file using `recommonmark`.
- PDF generation does not take into account Excel tables.
