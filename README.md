# NDD Docker Sphinx

1. [Introduction](#markdown-header-introduction)
1. [Installation](#markdown-header-installation)
    1. [From source](#markdown-header-from-source)
    1. [From Docker Hub](#markdown-header-from-docker-hub)
1. [Usage](#markdown-header-usage)
    1. [Initialisation](#markdown-header-initialisation)
    1. [Interactive](#markdown-header-interactive)
    1. [Non interactive](#markdown-header-non-interactive)
1. [Configuration](#markdown-header-configuration)
    1. [Extensions](#markdown-header-extensions)
    1. [Install an extension](#markdown-header-install-an-extension)
1. [Custom "extensions"](#custom-extensions)
    1. [Git extension"](#git-extension)
1. [Limitations](#markdown-header-limitations)



## Introduction

A Docker image for the [Sphinx documentation](http://sphinx-doc.org) builder.

The image is based upon the official [python:3.6](https://hub.docker.com/_/python/).

Besides the Sphinx documentation builder ([sphinx-doc](http://sphinx-doc.org)), this image contains:

- [alabaster](https://pypi.python.org/pypi/alabaster)
- [gitpython](https://pypi.python.org/pypi/gitpython)
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

Sphinx will be executed inside the container by the `sphinx-doc` user which is created by the Docker entry point. You **must** pass to the container the environment variable `USER_ID` set to the UID of the user the files will belong to. For example ``-e USER_ID=$(id -u $USER) ``.

### Initialisation

Sphinx provides the [`sphinx-quickstart`](http://sphinx-doc.org/invocation.html) script to create a skeleton of the documentation directory. You should however use the provided `sphinx-init` script which first calls `sphinx-quickstart` then customizes the `Makefile` and the configuration file `conf.py`.

**The directory `<HOST_DATA_DIR>` must already exist, otherwise the script will fail!**

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -e USER_ID=$(id -u $USER) ddidier/sphinx-doc sphinx-init
```

All arguments accepted by [`sphinx-quickstart`](http://sphinx-doc.org/invocation.html) are passed to `sphinx-init`. For example:

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -e USER_ID=$(id -u $USER) ddidier/sphinx-doc sphinx-init --project my-documentation
```

### Interactive

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -e USER_ID=$(id -u $USER) ddidier/sphinx-doc
```

You should now be in the `/doc` directory, otherwise just `cd` to `/doc`.

To create a new Sphinx project, call `sphinx-init`.

To create HTML documents, call `make html`.

To create a PDF document, call `make latexpdf`.

To watch for changes and create HTML documents dynamically, call `make livehtml` with a port binding:

```shell
docker run -it -v <HOST_DATA_DIR>:/doc -p 8000:8000 -e USER_ID=$(id -u $USER) ddidier/sphinx-doc make livehtml
```

To trigger a full build while in watch mode, issue from the `<HOST_DATA_DIR>` folder:

```shell
rm -rf build && touch source/conf.py
```

### Non interactive

```shell
docker run -i -v <HOST_DATA_DIR>:/doc -e USER_ID=$(id -u $USER) ddidier/sphinx-doc make html
docker run -i -v <HOST_DATA_DIR>:/doc -e USER_ID=$(id -u $USER) ddidier/sphinx-doc make latexpdf
```



## Configuration

**Warning: some variables, like the `extensions` variable, are overriden at the end of the `conf.py` file.**

### Extensions

To enable or disable a packaged extension, comment or uncomment the line in your `conf.py`.

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



## Custom "extensions"

This should be extracted in actual Sphinx extensions...

For now, the Python code is stored in the subdirectory `/_python` and is copied when calling `sphinx-init`.

### Git extension

This pseudo extension reads the properties of a Git repository to display in the left navigation panel and in the footer:

- the current time of the build if any file is not committed or untracked, or
- the name of the tag associated with the last commit if it exists, or
- the hash of the last commit

Enable it by uncommenting in the file `conf.py`:

```python
# Must be defined somewhere
html_context = {}

import os.path
source_directory = os.path.dirname(os.path.realpath(__file__))
python_directory = os.path.join(source_directory, '_python')
exec(open(os.path.join(python_directory, 'sphinx-git.py'), 'rb').read())
```

You now have two options depending on your setup:

- the directory `<HOST_DATA_DIR>` mounted in `/doc` must be a Git repository, or
- the directory `<HOST_GIT_DIR>` mounted in `/doc-git` must be a Git repository

```shell
docker run -i -v <HOST_DATA_DIR>:/doc -e USER_ID=$(id -u $USER) ddidier/sphinx-doc make html
docker run -i -v <HOST_DATA_DIR>:/doc -v <HOST_GIT_DIR>:/doc-git -e USER_ID=$(id -u $USER) ddidier/sphinx-doc make html
```



## Limitations

- PDF generation does not work when including Markdown file using `recommonmark`.
- PDF generation does not take into account Excel tables.
